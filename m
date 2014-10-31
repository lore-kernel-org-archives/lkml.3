Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbaJaRlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:41:00 -0400
Received: from mail-by2on0091.outbound.protection.outlook.com ([207.46.100.91]:23424
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757676AbaJaRk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:40:57 -0400
Date: Fri, 31 Oct 2014 10:40:42 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
 <5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
 <CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
 <030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
 <CACRpkdb9Gg90GwTpUm7S6SFkFjKTRaZLWa2JLnXJK4H-ZMbQ6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb9Gg90GwTpUm7S6SFkFjKTRaZLWa2JLnXJK4H-ZMbQ6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21064.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <4a2cb923ab264d7d99107a450d6ddcba@BN1BFFO11FD057.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(51704005)(377424004)(377454003)(24454002)(189002)(199003)(85202003)(31966008)(6806004)(53416004)(21056001)(106466001)(86362001)(120916001)(95666004)(54356999)(62966003)(85182001)(87936001)(23676002)(50986999)(76176999)(102836001)(99396003)(83506001)(74316001)(64706001)(108616004)(20776003)(107046002)(33646002)(104016003)(110136001)(47776003)(44976005)(19580405001)(93886004)(50466002)(19580395003)(92566001)(4396001)(46102003)(77156002)(77096003)(107986001)(24736002)(23106004)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB018;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB018;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 06:36PM +0100, Linus Walleij wrote:
> On Fri, Oct 31, 2014 at 5:57 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Fri, 2014-10-31 at 09:17AM +0100, Linus Walleij wrote:
> 
> >> Again it seems to be a sequencing problem. And device tree is
> >> not good at sequences, therefore all states should be self-contained.
> >
> > I agree, but how would I define a pin with pull-up enabled and
> > tri-state disabled - assume the pin is currently in a random state that
> > can have those things set/not set arbitrarily.
> 
> I was more thinking as everything you don't enable explicitly
> in a state is per definition disabled.
> 
> So if you are in state A and tri-state is enabled there and you
> move to state B where pull-up is enabled, then tri-state should
> be disabled, since it is not explicitly enabled.
> 
> > I can't put bias-disable in DT since it would potentially disable both
> > and the pull-up enable would have only a transient effect.
> 
> Well look at the callback from the core:
> 
>         int (*pin_config_set) (struct pinctrl_dev *pctldev,
>                                unsigned pin,
>                                unsigned long *configs,
>                                unsigned num_configs);
> 
> You get all configs in an array. The driver can walk over the list and
> make informed decisions on what to do *BEFORE* poking any registers.
> 
> Avoiding transients as you describe is part of why the callback
> looks as it does. This is why every driver has its own for-loop.

Okay, I guess that is possible. I find usage of the arguments more
elegant since it is more explicit and reduces code in the driver, but I
suspect it should work.

	Thanks,
	Sören
