Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3KLOIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:08:11 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50572 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754727Ab3KLOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:08:09 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] ACPI / driver core: Store a device pointer in struct acpi_dev_node
Date: Tue, 12 Nov 2013 15:20:37 +0100
Message-ID: <3448237.NUtWjlv2Mb@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131112092402.GO22916@intel.com>
References: <3268437.YsusHvklcv@vostro.rjw.lan> <1683079.zjqzsOAjXB@vostro.rjw.lan> <20131112092402.GO22916@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 12, 2013 11:24:02 AM Mika Westerberg wrote:
> On Mon, Nov 11, 2013 at 02:45:39PM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node
> > 
> > Modify struct acpi_dev_node to contain a pointer to struct acpi_device
> > associated with the given device object (that is, its ACPI companion
> > device) instead of an ACPI handle corresponding to it.  Introduce two
> > new macros for manipulating that pointer in a CONFIG_ACPI-safe way,
> > ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
> > ACPI_HANDLE() macro to take the above changes into account.
> > Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
> > use ACPI_COMPANION_SET() instead.  For some of them who used to
> > pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
> > introduce a helper routine acpi_preset_companion() doing an
> > equivalent thing.
> > 
> > The main motivation for doing this is that there are things
> > represented by struct acpi_device objects that don't have valid
> > ACPI handles (so called fixed ACPI hardware features, such as
> > power and sleep buttons) and we would like to create platform
> > device objects for them and "glue" them to their ACPI companions
> > in the usual way (which currently is impossible due to the
> > lack of valid ACPI handles).  However, there are more reasons
> > why it may be useful.
> > 
> > First, struct acpi_device pointers allow of much better type checking
> > than void pointers which are ACPI handles, so it should be more
> > difficult to write buggy code using modified struct acpi_dev_node
> > and the new macros.  Second, the change should help to reduce (over
> > time) the number of places in which the result of ACPI_HANDLE() is
> > passed to acpi_bus_get_device() in order to obtain a pointer to the
> > struct acpi_device associated with the given "physical" device,
> > because now that pointer is returned by ACPI_COMPANION() directly.
> > Finally, the change should make it easier to write generic code that
> > will build both for CONFIG_ACPI set and unset without adding explicit
> > compiler directives to it.
> > 
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> I tested this on Haswell as well and it works fine with ACPI enumerated
> platform, I2C and SPI devices.
> 
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com> (on Haswell)
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
