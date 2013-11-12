Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3KLJS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:18:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:27740 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab3KLJSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:18:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433755044"
Date: Tue, 12 Nov 2013 11:24:02 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] ACPI / driver core: Store a device pointer in struct
 acpi_dev_node
Message-ID: <20131112092402.GO22916@intel.com>
References: <3268437.YsusHvklcv@vostro.rjw.lan>
 <52803124.7000304@intel.com>
 <1683079.zjqzsOAjXB@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1683079.zjqzsOAjXB@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:45:39PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node
> 
> Modify struct acpi_dev_node to contain a pointer to struct acpi_device
> associated with the given device object (that is, its ACPI companion
> device) instead of an ACPI handle corresponding to it.  Introduce two
> new macros for manipulating that pointer in a CONFIG_ACPI-safe way,
> ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
> ACPI_HANDLE() macro to take the above changes into account.
> Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
> use ACPI_COMPANION_SET() instead.  For some of them who used to
> pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
> introduce a helper routine acpi_preset_companion() doing an
> equivalent thing.
> 
> The main motivation for doing this is that there are things
> represented by struct acpi_device objects that don't have valid
> ACPI handles (so called fixed ACPI hardware features, such as
> power and sleep buttons) and we would like to create platform
> device objects for them and "glue" them to their ACPI companions
> in the usual way (which currently is impossible due to the
> lack of valid ACPI handles).  However, there are more reasons
> why it may be useful.
> 
> First, struct acpi_device pointers allow of much better type checking
> than void pointers which are ACPI handles, so it should be more
> difficult to write buggy code using modified struct acpi_dev_node
> and the new macros.  Second, the change should help to reduce (over
> time) the number of places in which the result of ACPI_HANDLE() is
> passed to acpi_bus_get_device() in order to obtain a pointer to the
> struct acpi_device associated with the given "physical" device,
> because now that pointer is returned by ACPI_COMPANION() directly.
> Finally, the change should make it easier to write generic code that
> will build both for CONFIG_ACPI set and unset without adding explicit
> compiler directives to it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

I tested this on Haswell as well and it works fine with ACPI enumerated
platform, I2C and SPI devices.

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com> (on Haswell)
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
