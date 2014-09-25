Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaIYRQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:16:41 -0400
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:48256
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753013AbaIYRQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:16:39 -0400
Date: Thu, 25 Sep 2014 12:10:34 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <delicious.quinoa@gmail.com>
Subject: Re: [PATCH 2/2] socfpga: support suspend to ram
In-Reply-To: <20140925082506.GC26991@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1409251200490.693@atx-linux-37>
References: <1411590449-9794-1-git-send-email-atull@opensource.altera.com> <1411590449-9794-3-git-send-email-atull@opensource.altera.com> <20140925082506.GC26991@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0050.namprd08.prod.outlook.com (10.141.200.30) To
 BL2PR03MB308.namprd03.prod.outlook.com (10.141.68.26)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB308;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(24454002)(51704005)(64706001)(50466002)(53416004)(107046002)(76482002)(15975445006)(83322001)(86362001)(69596002)(81156004)(33716001)(120916001)(86152002)(74502003)(99396003)(92726001)(92566001)(81542003)(79102003)(80022003)(77096002)(87976001)(10300001)(106356001)(46406003)(74662003)(4396001)(81342003)(19580405001)(110136001)(85852003)(77982003)(101416001)(90102001)(31966008)(95666004)(20776003)(42186005)(21056001)(50986999)(85306004)(105586002)(19580395003)(23726002)(66066001)(47776003)(46102003)(83506001)(15202345003)(102836001)(54356999)(76176999)(97736003)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB308;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen,

On Thu, 25 Sep 2014, Steffen Trumtrar wrote:

> Hi!
> 
> On Wed, Sep 24, 2014 at 03:27:29PM -0500, atull@opensource.altera.com wrote:
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
> 
> (...)
> 
> Never looked into that, so maybe a stupid question:
> What happens if the bootloader (u-boot or other) didn't configure the sdr?
> Will it "just" not wake up again?

Waking up won't be the problem.  Linux won't boot.

Alternatively, if this Linux kernel is paired with a version of the
bootloader that does most of the initializion, but not the settings
that we want here, I expect there could be issues.

I don't want to duplicate the u-boot sdr configuration code, instead
I document my assumptions here here.  For future generations who take
this patch.  If they have a problem with s2r, they will look through
the git logs and find this helpful note of what their bootloader
was supposed to do.

Alan

> 
> Regards,
> Steffen
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
