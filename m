Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbbAJNIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 08:08:17 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47267 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbbAJNIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 08:08:15 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>, mjg59@srcf.ucam.org,
        linux-api@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, libsmbios-devel@lists.us.dell.com,
        Srinivas_G_Gowda@dell.com, Michael_E_Brown@dell.com,
        pali.rohar@gmail.com, A.Sloman@cs.bham.ac.uk
Subject: Re: [PATCH] Documentation: Add entry for dell-laptop sysfs interface
Date: Sat, 10 Jan 2015 14:08:11 +0100
Message-ID: <2495157.bRb6NIzxPV@xps13>
In-Reply-To: <20150110065714.GB104814@vmdeb7>
References: <1417628493-29323-1-git-send-email-gabriele.mzt@gmail.com> <1636595.UbTko9mUNA@xps13> <20150110065714.GB104814@vmdeb7>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 22:57:14 Darren Hart wrote:
> On Wed, Dec 31, 2014 at 12:20:59PM +0100, Gabriele Mazzotta wrote:
> > On Tuesday 30 December 2014 21:31:49 Brian Norris wrote:
> > > Hi,
> > > 
> > > On Wed, Dec 03, 2014 at 06:41:33PM +0100, Gabriele Mazzotta wrote:
> > > > Add the documentation for the new sysfs interface of dell-laptop
> > > > that allows to configure the keyboard illumination on Dell systems.
> > > > 
> > > > Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> > > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > > ---
> > > >  .../ABI/testing/sysfs-platform-dell-laptop         | 60 ++++++++++++++++++++++
> > > >  1 file changed, 60 insertions(+)
> > > >  create mode 100644 Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > > 
> > > > diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > > new file mode 100644
> > > > index 0000000..7969443
> > > > --- /dev/null
> > > > +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> > > > @@ -0,0 +1,60 @@
> > > > +What:		/sys/class/leds/dell::kbd_backlight/als_setting
> > > > +Date:		December 2014
> > > > +KernelVersion:	3.19
> > > > +Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
> > > > +		Pali Rohár <pali.rohar@gmail.com>
> > > > +Description:
> > > > +		This file allows to control the automatic keyboard
> > > > +		illumination mode on some systems that have an ambient
> > > > +		light sensor. Write 1 to this file to enable the auto
> > > > +		mode, 0 to disable it.
> > > [...]
> > > 
> > > This entry appears wrong, or at least incomplete. My system boots with a
> > > default value of 18, and the 'set' implementation accepts any value from
> > > 0 to 255.
> > > 
> > > According to the comments in dell-laptop.c, the value actually means
> > > something different than on/off:
> > > 
> > >   cbArg3, byte0  Desired setting of ALS value that turns the light on or off.
> > > 
> > > Admittedly, I'm not clear on what the intended interface is, as I've
> > > never had the ALS / keyboard backlight controls all working properly on
> > > my laptop in the first place, but I thought this would be the right
> > > place to ask about getting the documentation and driver in sync.
> > 
> > Hi,
> > 
> > You are perfectly right, the documentation is wrong and I'm sorry for
> > that. als_setting should allow you to define when the keyboard
> > backlight has to be turned on or off depending on the value reported
> > by the ambient light sensor.
> > 
> > Please note that not everything that is in libsmbios [1] is implemented
> > in the kernel driver. Take a look at it, recently there have been few
> > changes related to the ALS settings. Probably they are not needed given
> > that you are able to set the threshold with the current kernel driver,
> > but you might find something interesting.
> > 
> > I'll submit a patch to correct the documentation, thanks for reporting.
> 
> Hi Gabriele,
> 
> Have I missed a patch from you for this? I'd like to see this corrected in the
> 3.19 rc cycle.
> 
> Thanks,

I'm sorry, I must have done something wrong when I sent the patch, the
CC list is not complete.

Thanks for the link Brian.
