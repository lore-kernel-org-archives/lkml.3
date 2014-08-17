Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbaHQGzk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:55:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:25478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaHQGzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:55:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,878,1400050800"; 
   d="scan'208";a="469526906"
Date: Sun, 17 Aug 2014 09:55:27 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Al Stone <al.stone@linaro.org>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Josh Triplett <josh@joshtriplett.org>, Aaron Lu <aaron.lu@intel.com>,
        Max Eliaser <max.eliaser@intel.com>,
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
Message-ID: <20140817065527.GO2462@lahna.fi.intel.com>
References: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408172039-32513-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
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

For some reason this series never reached the mailing lists intented, so
I re-sent the series with shorter CC list to LKML, linux-acpi and
devicetree lists. 

LKML thread is here:

https://lkml.org/lkml/2014/8/17/10

Sorry for the inconvenience.
