Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbaJ2Ohb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:37:31 -0400
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:5152
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932834AbaJ2Oh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:37:29 -0400
Date: Wed, 29 Oct 2014 09:30:36 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Mark Brown <broonie@kernel.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <philip@balister.org>,
        <rubini@gnudd.com>, <jason@lakedaemon.net>, <kyle.teske@ni.com>,
        <nico@linaro.org>, <balbi@ti.com>, <m.chehab@samsung.com>,
        <davidb@codeaurora.org>, <rob@landley.net>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, <linus.walleij@linaro.org>,
        <mgerlach@opensource.altera.com>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
In-Reply-To: <20141029103103.GD10262@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1410290929320.6507@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de> <alpine.DEB.2.02.1410281601570.11910@atx-linux-37> <20141029075701.GA10262@pengutronix.de>
 <20141029101632.GU18557@sirena.org.uk> <20141029103103.GD10262@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR00CA0033.namprd00.prod.outlook.com (25.160.243.43) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(51704005)(164054003)(24454002)(86152002)(92566001)(46102003)(4396001)(80022003)(86362001)(76482002)(97736003)(83506001)(15975445006)(85306004)(93886004)(53416004)(122386002)(110136001)(87976001)(54356999)(50986999)(69596002)(120916001)(76176999)(99396003)(101416001)(85852003)(15202345003)(19580405001)(19580395003)(42186005)(20776003)(102836001)(92726001)(47776003)(21056001)(66066001)(106356001)(64706001)(81156004)(46406003)(40100003)(31966008)(77096002)(95666004)(107046002)(33716001)(50466002)(105586002)(23726002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Steffen Trumtrar wrote:

> On Wed, Oct 29, 2014 at 10:16:32AM +0000, Mark Brown wrote:
> > On Wed, Oct 29, 2014 at 08:57:01AM +0100, Steffen Trumtrar wrote:
> > 
> > > So, that shouldn't be a problem though, as I already cooked up a driver for
> > > the L3 with all the ranges specified. The only thing I need to figure out
> > > before I will post it, is how to nicely handle the WO remap register.
> > > I think regmap might be able to handle this itself, but am not sure yet.
> > 
> > It's supposed to be able to, not sure if anyone really tests that or not
> > though so it's possible bugs crept in.  Most write only registers can
> > physically be read so actually come out as volatile rather than write
> > only even if functionally there is no reason to read.
> 
> Ah, I think you might be actually right there. IIRC it IS possible to read
> from that register, but you only get 0s.

Yes, you can read and it will be all 0s.  So read-modify-write is not
something you would want to do for instance.

Alan

> So, I shot myself in the knee with specifying that register as write-only
> in my driver.
> 
> Thanks,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
