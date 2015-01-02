Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbbABEZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 23:25:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbbABEZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 23:25:46 -0500
Date: Thu, 1 Jan 2015 20:25:26 -0800
From: Darren Hart <dvhart@infradead.org>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>, mjg59@srcf.ucam.org,
        linux-api@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        pali.rohar@gmail.com, A.Sloman@cs.bham.ac.uk
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Message-ID: <20150102042525.GC51121@vmdeb7>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com>
 <20141231053149.GA3764@norris-Latitude-E6410>
 <1636595.UbTko9mUNA@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1636595.UbTko9mUNA@xps13>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 12:20:59PM +0100, Gabriele Mazzotta wrote:
> On Tuesday 30 December 2014 21:31:49 Brian Norris wrote:
> > Hi,
> > 
> > On Wed, Dec 03, 2014 at 06:41:33PM +0100, Gabriele Mazzotta wrote:
> > > Add the documentation for the new sysfs interface of dell-laptop
> > > that allows to configure the keyboard illumination on Dell systems.
> > > 
> > > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > ---
> > >  .../ABI/testing/sysfs-platform-dell-laptop         | 60 ++++++++++++++++++++++
> > >  1 file changed, 60 insertions(+)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > 
> > > diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > new file mode 100644
> > > index 0000000..7969443
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > @@ -0,0 +1,60 @@
> > > +What:		/sys/class/leds/dell::kbd_backlight/als_setting
> > > +Date:		December 2014
> > > +KernelVersion:	3.19
> > > +Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
> > > +		Pali Rohár <pali.rohar@gmail.com>
> > > +Description:
> > > +		This file allows to control the automatic keyboard
> > > +		illumination mode on some systems that have an ambient
> > > +		light sensor. Write 1 to this file to enable the auto
> > > +		mode, 0 to disable it.
> > [...]
> > 
> > This entry appears wrong, or at least incomplete. My system boots with a
> > default value of 18, and the 'set' implementation accepts any value from
> > 0 to 255.
> > 
> > According to the comments in dell-laptop.c, the value actually means
> > something different than on/off:
> > 
> >   cbArg3, byte0  Desired setting of ALS value that turns the light on or off.
> > 
> > Admittedly, I'm not clear on what the intended interface is, as I've
> > never had the ALS / keyboard backlight controls all working properly on
> > my laptop in the first place, but I thought this would be the right
> > place to ask about getting the documentation and driver in sync.
> 
> Hi,
> 
> You are perfectly right, the documentation is wrong and I'm sorry for
> that. als_setting should allow you to define when the keyboard
> backlight has to be turned on or off depending on the value reported
> by the ambient light sensor.
> 
> Please note that not everything that is in libsmbios [1] is implemented
> in the kernel driver. Take a look at it, recently there have been few
> changes related to the ALS settings. Probably they are not needed given
> that you are able to set the threshold with the current kernel driver,
> but you might find something interesting.
> 
> I'll submit a patch to correct the documentation, thanks for reporting.

Thanks Gabriele, let's make sure to get this into this rc cycle, sooner the
better.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
