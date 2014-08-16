Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaHPStD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:49:03 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54289 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaHPSs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:48:59 -0400
X-Originating-IP: 50.43.15.134
Date: Sat, 16 Aug 2014 11:48:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Robert Moore <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Mark Brown <broonie@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] Add ACPI _DSD and unified device properties
 support
Message-ID: <20140816184838.GA12671@thin>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 09:53:50AM +0300, Mika Westerberg wrote:
> The recent publication of the ACPI 5.1 specification [1] adds a reserved name
> for Device Specific Data (_DSD, Section 6.2.5). This mechanism allows for
> passing arbitrary hardware description data to the OS. The exact format of the
> _DSD data is specific to the UUID paired with it [2].   
> 
> An ACPI Device Properties UUID has been defined [3] to provide a format
> compatible with existing device tree schemas. The purpose for this was to allow
> for the reuse of the existing schemas and encourage the development of firmware
> agnostic device drivers.
> 
> This series accomplishes the following (as well as some other dependencies):
> 
>  * Add _DSD support to the ACPI core
>    This simply reads the UUID and the accompanying Package
> 
>  * Add ACPI Device Properties _DSD format support
>    This understands the hierarchical key:value pair structure
>    defined by the Device Properties UUID
> 
>  * Add a unified device properties API with ACPI and OF backends
>    This provides for the firmware agnostic device properties
>    Interface to be used by drivers
> 
>  * Provides 2 example drivers that were previously Device Tree aware that
>    can now be used with either Device Tree or ACPI Device Properties. The
>    both drivers use an arbitrary _HID.
> 
> This has been tested on Minnowboard with relevant parts of the modified
> DSDT at the end of this email.
> 
> This series does not provide for a means to append to a system DSDT. That
> will ultimately be required to make the most effective use of the _DSD
> mechanism. Work is underway on that as a separate effort.
> 
> [1] http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
> [2] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> [3] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> Aaron Lu (3):
>   of: Add property_ops callback for devices with of_node
>   gpiolib: add API to get gpio desc and flags
>   Input: gpio_keys_polled - Make use of device property API
> 
> Max Eliaser (1):
>   leds: leds-gpio: Make use of device property API
> 
> Mika Westerberg (4):
>   ACPI: Add support for device specific properties
>   ACPI: Document ACPI device specific properties
>   mfd: Add ACPI support
>   gpio: sch: Consolidate core and resume banks
> 
> Rafael J. Wysocki (1):
>   Driver core: Unified device properties interface for platform firmware

One issue I noticed with the series: the new read functions, when given
an integer type, don't appear to do any range-checking to make sure the
returned value falls within the range of that type.  They should do so,
and return -EOVERFLOW if so.  And the documentation of the new functions
should note that explicitly as an error case.

With that fixed:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
