Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaJGOZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:25:25 -0400
Received: from mail-bl2on0076.outbound.protection.outlook.com ([65.55.169.76]:40480
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752904AbaJGOZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:25:24 -0400
Date: Tue, 7 Oct 2014 09:19:00 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <delicious.quinoa@gmail.com>
Subject: Re: [PATCH v2 1/2] socfpga: hotplug: put cpu1 in wfi
In-Reply-To: <20141007111052.GA6904@amd>
Message-ID: <alpine.DEB.2.02.1410070918000.9610@atx-linux-37>
References: <1412192304-1209-1-git-send-email-atull@opensource.altera.com> <1412192304-1209-2-git-send-email-atull@opensource.altera.com> <20141007111052.GA6904@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0051.namprd08.prod.outlook.com (10.141.200.31) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(377424004)(24454002)(189002)(105586002)(106356001)(21056001)(92566001)(33716001)(81156004)(86362001)(102836001)(23726002)(122386002)(87976001)(85852003)(107046002)(92726001)(97736003)(4396001)(101416001)(40100002)(50466002)(80022003)(86152002)(46102003)(42186005)(120916001)(15975445006)(20776003)(54356999)(83506001)(76176999)(85306004)(15202345003)(50986999)(47776003)(69596002)(64706001)(110136001)(53416004)(99396003)(46406003)(76482002)(77096002)(66066001)(95666004)(31966008)(19580395003)(19580405001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Pavel Machek wrote:

> On Wed 2014-10-01 14:38:23, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Use WFI when putting CPU1 to sleep.  Don't hold CPU1 in reset
> > since that results in increased power consumption.
> > 
> > Reset CPU1 briefly during CPU1 bootup.
> > 
> > This has been tested for hotplug and suspend/resume and results
> > in no increased power consumption.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> It is nice to Cc people who commented ont the patch before.

HI Pavel,

OK, adding you and others who commented.

> 
> >  	if (cpu1start_addr) {
> > +		/* This will put CPU #1 into reset. */
> > +		__raw_writel(RSTMGR_MPUMODRST_CPU1,
> > +			     rst_manager_base_addr + SOCFPGA_RSTMGR_MODMPURST);
> > +
> 
> I thought conclusion was to use writel (not __raw variant) here?

Yes it was.  Fixed in v3, soon.

Alan

> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
