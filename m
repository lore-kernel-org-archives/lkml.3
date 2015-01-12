Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbbALIpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:45:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57159 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbbALIpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:45:34 -0500
Date: Mon, 12 Jan 2015 09:45:30 +0100
From: Pavel Machek <pavel@denx.de>
To: atull <atull@opensource.altera.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150112084530.GA28681@amd>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com>
 <20150110151118.GA16036@amd>
 <alpine.DEB.2.10.1501111009180.2556@shineypoop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1501111009180.2556@shineypoop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-11 10:29:00, atull wrote:
> On Sat, 10 Jan 2015, Pavel Machek wrote:
> 
> > On Sat 2015-01-10 10:10:51, Pantelis Antoniou wrote:
> > > Hi Pavel,
> > > 
> > > > On Jan 9, 2015, at 22:56 , Pavel Machek <pavel@denx.de> wrote:
> > > > 
> > > > On Fri 2015-01-09 13:14:24, atull wrote:
> > > >> On Wed, 7 Jan 2015, Pavel Machek wrote:
> > > >> 
> > > >>> On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
> > > >>>> +
> > > >>>> +What:		/sys/class/fpga_manager/<fpga>/firmware
> > > >>>> +Date:		October 2014
> > > >>>> +KernelVersion:	3.18
> > > >>>> +Contact:	Alan Tull <atull@opensource.altera.com>
> > > >>>> +Description:	Name of the FPGA image file to load using firmware
> > > >>>> class.
> > > >>> 
> > > >>> This one is ugly: it unneccessarily passes firmware name through the
> > > >>> kernel. Just make interface and code simpler by always passing
> > > >>> "socfpga-fpga-image" or something like that.
> > > >>> 
> > > >>> Thanks,
> > > >>> 									Pavel
> > > >> 
> > > >> Hi Pavel,
> > > >> 
> > > >> It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
> > > >> switching out the FPGA images dynamically under control of the userspace.
> > > > 
> > > > Then configure udev to load right firmware for you, or ln -s
> > > > image-i-want-now socfpga-fpga-image to select the one to read…?
> > > > 
> > > 
> > > Who said that udev is going to be available in the kind of system this is going to end in?
> > 
> > Noone.
> > 
> > > Doing ln -s tricks to load a different image? Really?
> > 
> > But if you don't have udev, you can do ln -s. It is better than
> > open-coding symlink functionality into
> > /sys/class/fpga_manager/<fpga>/firmware ... cause that's what this is.
> > 
> > Actually, clean implementation of "firmware" would be symlink in
> > sysfs; but I'd say that would be overdoing it.
> > 
> > > I say the interface is fine as it is.
> > 
> > I say it is not.
> > 									Pavel
> 
> Hi Pavel,
> 
> I see that we could do it that way and it would eliminate one of the
> sysfs files (../fpga_manager/<fpga>/firmware).  Either way we are assuming
> that there are fpga images in the filesystem in the firmware search path,
> so I don't see why adding a piece of indirection (symlink) makes things
> better.

Well.. you are basically re-implementing symlink with
../fpga_manager/<fpga>/firmware "file" in sysfs, and doing it
badly. It has no advantages over real symlink.

> We want to be able to switch out the FPGA image
> under control of userspace.  So we don't want an interface that makes
> it more cumbersome or tries to pretend that there's only one image.

What is cumbersome about symlink? Why is "fake" symlink in sysfs better?

> Previous uses of the firmware layer has been to use it to load once after
> bootup; this is different since some use cases will want to switch out
> the FPGA image.  If someone wants there to be only one FPGA image on
> the FGPA forever, they will probably not be using this framework; their
> FPGA will probably be loaded before Linux boots up.

Why? I have just one image on the fpga, and would prefer to load it
from Linux.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
