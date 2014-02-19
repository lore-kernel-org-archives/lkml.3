Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaBSBSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:18:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58622 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751694AbaBSBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/9] ACPI / dock / PCI / SATA: Simplify ACPI dock handling
Date: Wed, 19 Feb 2014 02:26:10 +0100
Message-ID: <3011875.q18rCmXyYX@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This series is on top of the current linux-next and it removes one of the
ugliest, in my opinion, things related to ACPI dock support, which is the
registration and unregistration of dock operations that makes it necessary
to register dock devices *twice* with the dock driver.

[1/9] After recent changes ACPIPHP doesn't need to clear the event
      callback (introduced in linux-next) for dock stations.
[2/9] Add .fixup() callback to struct acpi_hotplug_context for PCI devices
      located in dock stations.
[3/9] Store ACPI device object pointers instead of ACPI handles in the internal
      data structures used by the dock driver.
[4/9] Make the dock driver use callback pointers from the hotplug contexts of
      ACPI device objects and modify ACPIPHP to use that mechanism (instead of
      registering a special set of dock operations for each device).
[5/9] Add .uevent() callback to struct acpi_hotplug_context for SATA devices
      located in dock stations.
[6/9] Make SATA ACPI support code use hotplug contexts of ACPI device objects
      (instead of dock operations).
[7/9] Drop struct acpi_dock_ops and all code related to it (no more users).
[8/9] Drop remove_dock_dependent_devices() (this is a cleanup that doesn't
      really depend on the rest of the series).
[9/9] Update the copyright notice in dock.c.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
