Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIUAGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 20:06:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51382 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751360AbaIUAGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 20:06:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC PATCH v2 00/16] Add ACPI _DSD and unified device properties support
Date: Sun, 21 Sep 2014 02:26:05 +0200
Message-ID: <1582936.0FiE8Cvqie@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 02:52:31 PM Mika Westerberg wrote:
> This is a second revision of the patches first submitted here [1].
> 
> The recent publication of the ACPI 5.1 specification [2] adds a reserved name
> for Device Specific Data (_DSD, Section 6.2.5). This mechanism allows for
> passing arbitrary hardware description data to the OS. The exact format of the
> _DSD data is specific to the UUID paired with it [3].   
> 
> An ACPI Device Properties UUID has been defined [4] to provide a format
> compatible with existing device tree schemas. The purpose for this was to
> allow for the reuse of the existing schemas and encourage the development
> of firmware agnostic device drivers.
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
>  * Provides 3 example drivers that were previously Device Tree aware that
>    can now be used with either Device Tree or ACPI Device Properties. The
>    drivers use "PRP0001" as their _HID which means that the match should be
>    done using driver's .of_match_table instead.
> 
> The patch series has been tested on Minnoboard and Minnowboard MAX and the
> relevant part of DSDTs are at the end of this cover letter.
> 
> This series does not provide for a means to append to a system DSDT. That
> will ultimately be required to make the most effective use of the _DSD
> mechanism. Work is underway on that as a separate effort.
> 
> Most important changes to the previous RFC version:
> 
>   * Added wrapper functions for most used property types
>   * Return -EOVERFLOW in case integer would not fit to a type
>   * Dropped dev_prop_ops
>   * We now have dev_node_xxx() functions to access firmware node
>     properties without dev pointer
>   * The accessor function names try to be close to their corresponding of_*
>     counterpart
>   * Tried to have a bit better examples in the documentation patch
>   * gpiolib got support for _DSD and also it now understand firmware node
>     properties with dev_node_get_named_gpiod() that requests the GPIO
>     properly.
>   * Support for "PRP0001" _HID/_CID. This means that the match should be
>     done using driver .of_match_table instead.
>   * Add unified property support for at25 SPI eeprom driver as well.
> 
> [1] https://lkml.org/lkml/2014/8/17/10
> [2] http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
> [3] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> [4] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> Aaron Lu (2):
>   input: gpio_keys_polled - Add support for GPIO descriptors
>   input: gpio_keys_polled - Make use of device property API
> 
> Max Eliaser (2):
>   leds: leds-gpio: Make use of device property API
>   leds: leds-gpio: Add ACPI probing support
> 
> Mika Westerberg (11):
>   ACPI: Add support for device specific properties
>   ACPI: Allow drivers to match using Device Tree compatible property
>   ACPI: Document ACPI device specific properties
>   mfd: Add ACPI support
>   gpio / ACPI: Add support for _DSD device properties
>   gpio: Add support for unified device properties interface
>   gpio: sch: Consolidate core and resume banks
>   leds: leds-gpio: Add support for GPIO descriptors
>   input: gpio_keys_polled - Add ACPI probing support
>   misc: at25: Make use of device property API
>   misc: at25: Add ACPI probing support

Given the ACKs that we've got already (the Greg's one in particular) and
the apparent lack of objections (or indeed any comments at all), I'm about
to queue this up for 3.18 next week.

Rafael

