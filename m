Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3KQQ0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:26:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51053 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754417Ab3KQQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 0/10] ACPI: Device objects for all namespace nodes and PCI root hotplug integration
Date: Sun, 17 Nov 2013 17:29:41 +0100
Message-ID: <1421028.Rsfpmhnym3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is 3.14 material, but I'm posting it today to let you know it is coming.
Of course, if you see any immediate problems with the following patches, please
let me know.

Patch [1/10] is a place holder until we get an equivalent from ACPICA upstream,
which should happen early after 3.13-rc1.  The remaining patches are:

 [2/10] ACPI / scan: Define non-empty removal handler to passed to
        acpi_attach_data() for struct acpi_device objects.

 [3/10] ACPI / scan: Create struct acpi_device objects for all device nodes in
        the namespace regardless of the current result of _STA (the reasons are
        explained in the changelog).

 [4/10] ACPI / hotplug: Do not fail bus check and device check notifications
        if hotplug is not enabled for the given group of devices via sysfs
        (failing those notifications only skips device enumeration, but doesn't
         prevent devices from being physically added to the system).

 [5/10] ACPI / hotplug: Introduce common device hotplug function
        acpi_device_hotplug() and reduce some code duplication.

 [6/10] ACPI / hotplug: Make PCI host bridge hotplug use common code (instead
        of defining its own notify handler).

 [7/10] ACPI / hotplug: Move container-specific code out of the common code.

 [8/10] ACPI / hotplug: Rework the common device hotplug code to cover surprise
        removals of devices.

 [9/10] ACPI / hotplug: Drop unfinished global hotplug notification handling
        routines.

[10/10] ACPI: Clean up some revoltingly ugly stuff.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
