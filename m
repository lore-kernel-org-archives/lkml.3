Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3K2A12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:27:28 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51528 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752570Ab3K2A0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:26:47 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ide@vger.kernel.org,
        linux-usb@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 0/3] ACPI / bind: Use struct acpi_device pointers instead of ACPI handles
Date: Fri, 29 Nov 2013 01:36:48 +0100
Message-ID: <4501334.ovACrGogrl@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now that we store a pointer to struct acpi_device as the ACPI companion in
struct device, the code making associations between "physical" devices and
ACPI device objects can be modified to work with struct acpi_device pointers
instead of ACPI handles too.  The first two of the following patches make these
changes and the third one is just a related cleanup.

[1/3] ACPI / bind: Replace .find_device in struct acpi_bus_type with .find_companion
[2/3] ACPI / bind: Modify acpi_bind_one() to take a struct acpi_device pointer as
      the second argument.
[3/3] ACPI / bind: Move acpi_get_child() to ide-acpi.c which is the only remaining
      user of that function.

The patches are on top of linux-pm.git/linux-next.  Please let me know if you see
any problems in them.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
