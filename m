Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbaJHKpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:45:11 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49980 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571AbaJHKpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:45:08 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 8 Oct 2014 12:42:14 +0200
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org,
        arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 2/4] i2c: add support for Diolan DLN-2 USB-I2C adapter
Message-ID: <20141008104214.GD1990@localhost>
References: <1411661254-5204-1-git-send-email-octavian.purdila@intel.com>
 <1411661254-5204-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411661254-5204-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 07:07:32PM +0300, Octavian Purdila wrote:

> diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-busses-dln2 b/Documentation/ABI/testing/sysfs-bus-i2c-busses-dln2
> new file mode 100644
> index 0000000..ad55af6
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-i2c-busses-dln2

This is a nonstandard path that does not match the attribute path (or
any other convention followed under ABI/).

I suggest you rename it

	sysfs-class-i2c-adapter-dln2

> @@ -0,0 +1,5 @@
> +What:		/sys/bus/i2c/devices/.../dln2_i2c_freq

I think you should rename the attribute "bus_frequency" and name the
attribute group "dln2". That way the attribute will show up as

	.../<device>/dln2/bus_frequency

Then the "What:" field should read

	What:		/sys/class/i2c-adapter/<device>/dln2/bus_frequency

> +Date:		September 2014
> +Contact:	Octavian Purdila <octavian.purdila@intel.com>
> +Description:
> +		This attribute shows/sets the frequency (in Hz) of the I2C bus.

I'd reword this "Set the frequency...".

Please also describe under what circumstances this may fail, that is,
when setting a frequency less than or greater than the min or max
frequencies reported by the device.

Perhaps you should even consider exporting those two values?

Johan
