Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaHRJ1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:27:06 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:25142
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750710AbaHRJ1F (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:27:05 -0400
Date: Mon, 18 Aug 2014 17:26:37 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Peter Chen <peter.chen@freescale.com>
CC: Philippe Reynes <tremyfr@gmail.com>, <Linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <gwenhael.goavec-merou@trabucayre.com>
Subject: Re: [RFC] usb issue on imx27: 3 clocks are needed
Message-ID: <20140818092635.GI2114@dragon>
References: <53EF7AF6.2000405@gmail.com> <20140818090056.GA29393@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140818090056.GA29393@peterchendt>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019005)(6009001)(24454002)(51704005)(53754006)(189002)(45984002)(199003)(79102001)(92726001)(92566001)(50986999)(77982001)(76176999)(83506001)(104016003)(31966008)(110136001)(87936001)(33716001)(68736004)(21056001)(33656002)(107046002)(54356999)(80022001)(47776003)(4396001)(76482001)(99396002)(6806004)(83072002)(85306004)(44976005)(64706001)(83322001)(20776003)(46406003)(23726002)(81342001)(26826002)(102836001)(50466002)(105606002)(86362001)(106466001)(97756001)(81542001)(95666004)(97736001)(46102001)(85852003)(84676001)(57986006)(74502001)(74662001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0784;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 03077579FF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 05:00:59PM +0800, Peter Chen wrote:
> On Sat, Aug 16, 2014 at 05:38:30PM +0200, Philippe Reynes wrote:
> > Hi all,
> > 
> > i.MX27's usb needs three clocks (usb_ipg_gate, usb_ahb_gate and usb_div)
> > but the current chipidea driver implementation, and devicetree, provides
> > only ipg and ahb. Consequently, if the bootloader don't enable the last
> > one, the kernel will crash.
> > 
> > Our approach/idea is to add a second, optionnal, clock in ci_hdrc_imx.c
> > with 'per' name in devicetree  and to add  clock name 'main_clk' for mandatory clock.
> > This approach it correct? Or an other approach seems better?
> > Thank you very much for your point of view.
> > 
> 
> It is ok for me to have ipg, ahb and per clocks at driver, but how can you maintain
> DT consistent?

Adding new clock as optional one will just maintain the DT
compatibility.

> Can you accept open ipg and per always on at clock.c?

No, usb driver should manage its clocks.

Shawn
