Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab3FMQfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:35:17 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39410 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3FMQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:35:15 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
Date: Fri, 14 Jun 2013 00:32:23 +0800
Message-Id: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
four bugs related to Sony VAIO VPCZ23A4R dock support.
1) can't correctly detect hotplug slot for dock state
2) resource leak on undocking
3) resource allocation failure for dock devices
4) one bug in intel_snd_hda driver

The first patch fixes issue 1, and the second patch fixes issue 2.
These two patches, if accepted, should be material for stable branches
too.
Patch 3-9 are code improvement for ACPI and dock driver.

I have found the root cause for issue three, but still working on
solutions, and seems can't be solve in short time. So please help 
to review and test patches for issue 1) and 2) first.

Hi Alexander, could you please help to test the whole patchset?

Jiang Liu (9):
  ACPI, DOCK: initialize dock subsystem before scanning PCI root buses
  ACPIPHP: fix device destroying order issue when handling dock
    notification
  ACPI, DOCK: clean up unused module related code
  ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
  ACPI, DOCK: kill redundant spin lock in dock device object
  ACPI, DOCK: mark initialization functions with __init
  ACPI, DOCK: simplify implementation of dock_create_acpi_device()
  ACPI: introduce several helper functions
  ACPI: use new helper functions to simpilify code

 drivers/acpi/dock.c                | 193 +++++++++----------------------------
 drivers/acpi/internal.h            |   5 +
 drivers/acpi/scan.c                |  54 +++--------
 drivers/acpi/utils.c               |  74 ++++++++++++++
 drivers/pci/hotplug/acpiphp_glue.c |  47 ++++-----
 include/acpi/acpi_bus.h            |   5 +
 6 files changed, 162 insertions(+), 216 deletions(-)

-- 
1.8.1.2

