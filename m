Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaHEVfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:35:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753454AbaHEVe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:34:58 -0400
Date: Tue, 5 Aug 2014 17:34:36 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH] Input - wacom: update the ABI doc according to latest
 changes
Message-ID: <20140805213436.GC29591@mail.corp.redhat.com>
References: <1407252899-10293-1-git-send-email-benjamin.tissoires@redhat.com>
 <CAF8JNhKQAZz_a-=5qyqS4rgdv-8Lr=i=uKJMwz_iR4c7cq-cvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF8JNhKQAZz_a-=5qyqS4rgdv-8Lr=i=uKJMwz_iR4c7cq-cvg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ping,

On Aug 05 2014 or thereabouts, Ping Cheng wrote:
> Thank you Benjamin for updating the ABI docs. My comments are inline.
> 
> With those lines updated, this patch is:
> 
> Reviewed-by: Ping Cheng <pingc@wacom.com>

Thanks!

> 
> Cheers,
> 
> Ping
> 
> On Tue, Aug 5, 2014 at 8:34 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> > Now the devices show up under hid no matter the connection. So update the
> > sysfs path to the shortest and common one.
> > The ABI has also been unified regarding the OLEDs, but Bluetooth handle
> > only 1-bit images instead of 4.
> >
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> >
> > Guys,
> >
> > by updating this and working on the g-s-d client side for OLEDs, I think now
> > that we should also keep the oled*_img for Bluetooth and implement this file
> > for USB too. The user space code gets messy quite fast due to the need to
> > support old and new kernels, whereas if we handle the scrambling in the kernel,
> > it should be quite straightforward.
> > Of course, we have to keep the current button<n>_rawimg for backward
> > compatibility.
> >
> > Any thoughts?
> >
> > Cheers,
> > Benjamin
> >
> >  Documentation/ABI/testing/sysfs-driver-wacom | 56 ++++++++++------------------
> >  1 file changed, 20 insertions(+), 36 deletions(-)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
> > index 7fc7810..c75ed4c 100644
> > --- a/Documentation/ABI/testing/sysfs-driver-wacom
> > +++ b/Documentation/ABI/testing/sysfs-driver-wacom
> > @@ -1,47 +1,26 @@
> > -WWhat:         /sys/class/hidraw/hidraw*/device/oled*_img
> > -Date:          June 2012
> > -Contact:       linux-bluetooth@vger.kernel.org
> > -Description:
> > -               The /sys/class/hidraw/hidraw*/device/oled*_img files control
> > -               OLED mocro displays on Intuos4 Wireless tablet. Accepted image
> > -               has to contain 256 bytes (64x32 px 1 bit colour). The format
> > -               is the same as PBM image 62x32px without header (64 bits per
> > -               horizontal line, 32 lines). An example of setting OLED No. 0:
> > -               dd bs=256 count=1 if=img_file of=[path to oled0_img]/oled0_img
> > -               The attribute is read only and no local copy of the image is
> > -               stored.
> > -
> > -What:          /sys/class/hidraw/hidraw*/device/speed
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed
> >  Date:          April 2010
> 
> Should the Date be updated?

I don't think that this one should. The ABI is the same since April
2010, and the "new" path works also for older kernels. So basically,
here, for Bluetooth, there has been no changes.

> 
> >  Kernel Version:        2.6.35
> 
> This patch is planned for 3.16, right?

Same comment than before (about not touching it).
This will be planned for 3.17, 3.16 has been out last Sunday.

> 
> >  Contact:       linux-bluetooth@vger.kernel.org
> >  Description:
> > -               The /sys/class/hidraw/hidraw*/device/speed file controls
> > -               reporting speed of Wacom bluetooth tablet. Reading from
> > -               this file returns 1 if tablet reports in high speed mode
> > +               The /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed file
> > +               controls reporting speed of Wacom bluetooth tablet. Reading
> > +               from this file returns 1 if tablet reports in high speed mode
> >                 or 0 otherwise. Writing to this file one of these values
> >                 switches reporting speed.
> >
> > -What:          /sys/class/leds/0005\:056A\:00BD.0001\:selector\:*/
> > -Date:          May 2012
> > -Kernel Version:        3.5
> > -Contact:       linux-bluetooth@vger.kernel.org
> > -Description:
> > -               LED selector for Intuos4 WL. There are 4 leds, but only one LED
> > -               can be lit at a time. Max brightness is 127.
> > -
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/led
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/led
> >  Date:          August 2011
> 
> Same here and other 6 dates below

We can probably update these dates. I let them untouched because the
ABI did not changed but only the path did.

> 
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> >                 Attribute group for control of the status LEDs and the OLEDs.
> >                 This attribute group is only available for Intuos 4 M, L,
> > -               and XL (with LEDs and OLEDs), Intuos 5 (LEDs only), and Cintiq
> > -               21UX2 and Cintiq 24HD (LEDs only). Therefore its presence
> > -               implicitly signifies the presence of said LEDs and OLEDs on the
> > -               tablet device.
> > +               and XL (with LEDs and OLEDs), Intuos 4 WL, Intuos 5 (LEDs only),
> > +               Intuos Pro (LEDs only) and Cintiq 21UX2 and Cintiq 24HD
> > +               (LEDs only). Therefore its presence implicitly signifies the
> > +               presence of said LEDs and OLEDs on the tablet device.
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status0_luminance
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status0_luminance
> >  Date:          August 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> > @@ -50,7 +29,7 @@ Description:
> >                 button is pressed on the stylus. This luminance level is
> >                 normally lower than the level when a button is pressed.
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status1_luminance
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status1_luminance
> >  Date:          August 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> > @@ -58,7 +37,7 @@ Description:
> >                 when the stylus touches the tablet surface, or any button is
> >                 pressed on the stylus.
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status_led0_select
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status_led0_select
> >  Date:          August 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> > @@ -67,7 +46,7 @@ Description:
> >                 24HD) status LEDs is active (0..3). The other three LEDs on the
> >                 same side are always inactive.
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status_led1_select
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status_led1_select
> >  Date:          September 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> > @@ -75,14 +54,14 @@ Description:
> >                 and Cintiq 24HD) status LEDs is active (0..3). The other three LEDs on
> >                 the left are always inactive.
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/buttons_luminance
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/buttons_luminance
> >  Date:          August 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> >                 Writing to this file sets the overall luminance level (0..15)
> 
> We need to specify that this ABI is only for Intuos 4 (USB and Bluetooth).

Yep. We can carry this fix too in this patch.

Cheers,
Benjamin

> 
> >                 of all eight button OLED displays.)
> >
> > -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/button<n>_rawimg
> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/button<n>_rawimg
> >  Date:          August 2011
> >  Contact:       linux-input@vger.kernel.org
> >  Description:
> > @@ -93,3 +72,8 @@ Description:
> >                 byte chunk encodes the image data for two consecutive lines on
> >                 the display. The low nibble of each byte contains the first
> >                 line, and the high nibble contains the second line.
> > +               When the Wacom Intuos 4 is connected over Bluetooth, the
> > +               image has to contain 256 bytes (64x32 px 1 bit colour).
> > +               The format is also scrambled, like in the USB mode, and it can
> > +               be summarized by converting 76543210 into GECA6420.
> > +                                           HGFEDCBA      HFDB7531
> > --
> > 2.0.4
> >
