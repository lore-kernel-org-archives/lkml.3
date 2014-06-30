Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbaF3Kkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:40:37 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:59429 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbaF3Kju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:39:50 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 30 Jun 2014 12:39:11 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, jkosina@suse.cz, greg@kroah.com, bjorn@mork.no,
        cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] HID: leds: move led_mode attribute to led-class
 devices in MSI GT683R driver
Message-ID: <20140630103911.GA2486@localhost>
References: <20140625174109.GE1409@localhost>
 <1403719989-19989-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403719989-19989-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:13:09PM +0300, Janne Kanniainen wrote:
> Move led_mode attribute from HID device to led-class devices and rename it
> msi_mode. This will also fix race condition by using attribute-groups.
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
> 
> Changes in v3:
> 	- Style fixes
> 	- Rename sysfs-class-hid-driver-gt683r to sysfs-class-leds-driver-gt683r
> 
>  .../ABI/testing/sysfs-class-hid-driver-gt683r      | 14 -----------
>  .../ABI/testing/sysfs-class-leds-driver-gt683r     | 16 +++++++++++++
>  drivers/hid/hid-gt683r.c                           | 28 ++++++++++++----------
>  3 files changed, 32 insertions(+), 26 deletions(-)
>  delete mode 100644 Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
>  create mode 100644 Documentation/ABI/testing/sysfs-class-leds-driver-gt683r
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> deleted file mode 100644
> index 317e9d5..0000000
> --- a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -What:		/sys/class/hidraw/<hidraw>/device/leds_mode
> -Date:		Jun 2014
> -KernelVersion:	3.17
> -Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
> -Description:
> -		Set the mode of LEDs
> -
> -		0 - normal
> -		1 - audio
> -		2 - breathing
> -
> -		Normal: LEDs are fully on when enabled
> -		Audio:  LEDs brightness depends on sound level
> -		Breathing: LEDs brightness varies at human breathing rate
> \ No newline at end of file
> diff --git a/Documentation/ABI/testing/sysfs-class-leds-driver-gt683r b/Documentation/ABI/testing/sysfs-class-leds-driver-gt683r
> new file mode 100644
> index 0000000..29769fb
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-leds-driver-gt683r
> @@ -0,0 +1,16 @@
> +What:		/sys/class/leds/<led>/msi_mode

The ABI-file name now sort of matches the attribute path and there are
examples of attributes being documented in this particular way, but
naming is far from consistent in Documentation/ABI.

Perhaps we should use the name field of the attribute group and kill two
birds with one stone by making the sysfs file name match the attribute
path, while also making it even more obvious that the mode attribute is a
driver specific attribute (and not a common led class one) by placing it
in a subdirectory.

That is, if you set the .name field to "gt683r" (and rename the
attribute and ABI-file again) then the file name and attribute path
could match:

	Documentation/ABI/testing/sysfs-class-leds-gt683r

	What:		/sys/class/leds/<led>/gt683r/mode

Both patches look good otherwise.

Johan
