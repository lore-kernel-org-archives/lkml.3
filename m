Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaJGOX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:23:56 -0400
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:53920
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752846AbaJGOXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:23:55 -0400
Date: Tue, 7 Oct 2014 09:17:34 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <delicious.quinoa@gmail.com>
Subject: Re: [PATCH v2 2/2] socfpga: support suspend to ram
In-Reply-To: <20141007111715.GB6904@amd>
Message-ID: <alpine.DEB.2.02.1410070916590.9610@atx-linux-37>
References: <1412192304-1209-1-git-send-email-atull@opensource.altera.com> <1412192304-1209-3-git-send-email-atull@opensource.altera.com> <20141007111715.GB6904@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0036.namprd02.prod.outlook.com (10.141.56.36) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(24454002)(164054003)(189002)(77096002)(99396003)(23726002)(47776003)(81156004)(106356001)(120916001)(31966008)(105586002)(97736003)(50466002)(15202345003)(21056001)(107046002)(122386002)(46406003)(95666004)(40100002)(33716001)(76482002)(80022003)(64706001)(110136001)(42186005)(46102003)(4396001)(101416001)(20776003)(66066001)(15975445006)(85306004)(85852003)(87976001)(86152002)(102836001)(69596002)(92726001)(83506001)(92566001)(19580405001)(53416004)(50986999)(86362001)(19580395003)(76176999)(54356999);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014, Pavel Machek wrote:

> Hi!
> 
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add code that requests that the sdr controller go into
> > self-refresh mode.  This code is run from ocram.
> > 
> > This patch assumes that u-boot has already configured sdr:
> >   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
> >   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
> >   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> > 
> > How to suspend to ram:
> >  $ echo enabled > \
> > /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> > 
> >  $ echo -n mem > /sys/power/state
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> > +static int __init socfpga_pm_init(void)
> > +{
> > +	if (socfpga_setup_ocram_self_refresh())
> > +		return -EFAULT;
> 
> It would be nice to propagate the error result here.

Hi Pavel,

Yes, good catch.

Thanks,
Alan

> 
> Best regards,
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
