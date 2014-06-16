Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaFPO4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:56:34 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:45973
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751313AbaFPO4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:56:32 -0400
Date: Mon, 16 Jun 2014 07:56:27 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Jongsung Kim <neidhard.kim@lge.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hayun Hwang <hwang.hayun@lge.com>,
        Youngkyu Choi <youngkyu7.choi@lge.com>
Subject: Re: [PATCH] net/cadence/macb: clear interrupts simply and correctly
References: <1402563054-8546-1-git-send-email-neidhard.kim@lge.com>
 <9f5be687-d127-49a4-90ea-c1033505452d@BN1BFFO11FD019.protection.gbl>
 <539E79F1.1090006@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <539E79F1.1090006@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ea57b37f-1f1c-40a0-84a6-46b0b78ec6b4@BY2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(199002)(377424004)(24454002)(189002)(377454003)(479174003)(51704005)(79102001)(74502001)(74662001)(31966008)(81342001)(83506001)(76176999)(44976005)(70736001)(81542001)(50986999)(80022001)(77096002)(85306003)(53416004)(6806004)(83322001)(54356999)(21056001)(87936001)(92726001)(4396001)(86362001)(92566001)(50466002)(64706001)(77982001)(74316001)(20776003)(31696002)(1496007)(85182001)(104016001)(46102001)(99396002)(23676002)(102836001)(33646001)(47776003)(83072002)(85852003)(76482001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB054;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 02:00PM +0900, Jongsung Kim wrote:
> On 06/13/2014 12:44 AM, Sören Brinkmann wrote:
> > Hi Jongsung,
> 
> Hi Sören,
> 
> > Does this interrupt need to be enabled? There is nothing checking
> > that bit and handling this IRQ in the handler, AFAICT. And you solve
> > this by simply clearing the bit. So, I wonder whether not enabling this
> > IRQ in the first place would solve things too.
> 
> The driver actually checks the bit, but does not clear it. Disabling the
> "Rx used bit read" interrupt you said may be a solution. However, I think
> it is the better way to clear the exceptional HW-state rather than just to
> mask it.
Hmm, I must have missed that.

> 
> > This is now clearing all IRQ flags which is probably not what we want
> > here. This is handling RX only. We still want the non-RX interrupts to go to
> > the actual interrupt service routing.
> 
> The ISR(Interrupt Status Register) is read only in the interrupt service
> routine, macb_interrupt. But is partially cleared here and there. Further
> handler-functions decide jobs to be done by reading/checking other status
> registers. (e.g., TSR, RSR) So, clearing the ISR after reading looks not
> a bad idea.
But you are clearing _all_ interrupt flags in the RX NAPI handler.
Doesn't that mean we might miss certain events?

	Sören
