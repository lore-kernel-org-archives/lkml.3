Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaHGUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:54:26 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:49383 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaHGUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <1407444232-4005-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1407444232-4005-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Thu, 7 Aug 2014 13:54:22 -0700
Message-ID: <CAF8JNhJuWMPMQzur2rHOSNVSsa6-sM5kZDA2pBNT5ABws340vg@mail.gmail.com>
Subject: Re: [PATCH v2] Input - wacom: update the ABI doc according to latest changes
From: Ping Cheng <pinglinux@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 1:43 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> Now the devices show up under hid no matter the connection (for USB
> and Bluetooth, not serial nor i2c).
>
> The USB devices can now be easily found under
> /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>
>
> The Bluetooth devices could also be found under this path since their
> inclusion (April 2010), so this patch fixes the unprecise "hidraw*" path
> for them.
>
> The ABI has been unified while setting the LEDs and OLEDs. So Bluetooth
> devices lost their own LED selector but use the USB sysfs attribute.
> For OLEDs, Bluetooth devices handle only 1-bit images instead of 4 for USB.
> The documentation has been updated to match this.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Reviewed-by: Ping Cheng <pingc@wacom.com>

Ping

>  Documentation/ABI/testing/sysfs-driver-wacom | 70 +++++++++++-----------------
>  1 file changed, 27 insertions(+), 43 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
> index 7fc7810..c4f0fed 100644
> --- a/Documentation/ABI/testing/sysfs-driver-wacom
> +++ b/Documentation/ABI/testing/sysfs-driver-wacom
> @@ -1,48 +1,27 @@
> -WWhat:         /sys/class/hidraw/hidraw*/device/oled*_img
> -Date:          June 2012
> -Contact:       linux-bluetooth@vger.kernel.org
> -Description:
> -               The /sys/class/hidraw/hidraw*/device/oled*_img files control
> -               OLED mocro displays on Intuos4 Wireless tablet. Accepted image
> -               has to contain 256 bytes (64x32 px 1 bit colour). The format
> -               is the same as PBM image 62x32px without header (64 bits per
> -               horizontal line, 32 lines). An example of setting OLED No. 0:
> -               dd bs=256 count=1 if=img_file of=[path to oled0_img]/oled0_img
> -               The attribute is read only and no local copy of the image is
> -               stored.
> -
> -What:          /sys/class/hidraw/hidraw*/device/speed
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed
>  Date:          April 2010
>  Kernel Version:        2.6.35
>  Contact:       linux-bluetooth@vger.kernel.org
>  Description:
> -               The /sys/class/hidraw/hidraw*/device/speed file controls
> -               reporting speed of Wacom bluetooth tablet. Reading from
> -               this file returns 1 if tablet reports in high speed mode
> +               The /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed file
> +               controls reporting speed of Wacom bluetooth tablet. Reading
> +               from this file returns 1 if tablet reports in high speed mode
>                 or 0 otherwise. Writing to this file one of these values
>                 switches reporting speed.
>
> -What:          /sys/class/leds/0005\:056A\:00BD.0001\:selector\:*/
> -Date:          May 2012
> -Kernel Version:        3.5
> -Contact:       linux-bluetooth@vger.kernel.org
> -Description:
> -               LED selector for Intuos4 WL. There are 4 leds, but only one LED
> -               can be lit at a time. Max brightness is 127.
> -
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/led
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/led
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Attribute group for control of the status LEDs and the OLEDs.
>                 This attribute group is only available for Intuos 4 M, L,
> -               and XL (with LEDs and OLEDs), Intuos 5 (LEDs only), and Cintiq
> -               21UX2 and Cintiq 24HD (LEDs only). Therefore its presence
> -               implicitly signifies the presence of said LEDs and OLEDs on the
> -               tablet device.
> +               and XL (with LEDs and OLEDs), Intuos 4 WL, Intuos 5 (LEDs only),
> +               Intuos Pro (LEDs only) and Cintiq 21UX2 and Cintiq 24HD
> +               (LEDs only). Therefore its presence implicitly signifies the
> +               presence of said LEDs and OLEDs on the tablet device.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status0_luminance
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status0_luminance
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Writing to this file sets the status LED luminance (1..127)
> @@ -50,16 +29,16 @@ Description:
>                 button is pressed on the stylus. This luminance level is
>                 normally lower than the level when a button is pressed.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status1_luminance
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status1_luminance
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Writing to this file sets the status LED luminance (1..127)
>                 when the stylus touches the tablet surface, or any button is
>                 pressed on the stylus.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status_led0_select
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status_led0_select
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Writing to this file sets which one of the four (for Intuos 4
> @@ -67,23 +46,23 @@ Description:
>                 24HD) status LEDs is active (0..3). The other three LEDs on the
>                 same side are always inactive.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/status_led1_select
> -Date:          September 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/status_led1_select
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Writing to this file sets which one of the left four (for Cintiq 21UX2
>                 and Cintiq 24HD) status LEDs is active (0..3). The other three LEDs on
>                 the left are always inactive.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/buttons_luminance
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/buttons_luminance
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 Writing to this file sets the overall luminance level (0..15)
>                 of all eight button OLED displays.
>
> -What:          /sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/button<n>_rawimg
> -Date:          August 2011
> +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/wacom_led/button<n>_rawimg
> +Date:          August 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:
>                 When writing a 1024 byte raw image in Wacom Intuos 4
> @@ -93,3 +72,8 @@ Description:
>                 byte chunk encodes the image data for two consecutive lines on
>                 the display. The low nibble of each byte contains the first
>                 line, and the high nibble contains the second line.
> +               When the Wacom Intuos 4 is connected over Bluetooth, the
> +               image has to contain 256 bytes (64x32 px 1 bit colour).
> +               The format is also scrambled, like in the USB mode, and it can
> +               be summarized by converting 76543210 into GECA6420.
> +                                           HGFEDCBA      HFDB7531
> --
> 2.0.4
>
