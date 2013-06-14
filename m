Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3FNTeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 15:34:24 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63596 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3FNTeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 15:34:22 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [BUGFIX v2 0/4] fix bug 56531, 59501 and 59581
Date: Sat, 15 Jun 2013 03:27:57 +0800
Message-Id: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com>
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

Hi Alexander, could you please help to test the whole patchset?
Really get sleepy, it's already 3 oclock now, so please forgive me
if there any stupid mistakes.

Jiang Liu (4):
  ACPI, DOCK: initialize dock subsystem before scanning PCI root buses
  ACPI, DOCK: resolve possible deadlock scenarios
  PCI, ACPI: fix device destroying order issue when handling dock
    notification
  ACPIPHP: fix bug 56531 Sony VAIO VPCZ23A4R: can't assign mem/io
    after docking

 drivers/acpi/dock.c                | 116 +++++++++++++++++++++----------------
 drivers/acpi/internal.h            |   5 ++
 drivers/acpi/scan.c                |   1 +
 drivers/pci/hotplug/acpiphp_glue.c |  54 ++++++++++++-----
 drivers/pci/pci.h                  |   5 ++
 drivers/pci/setup-bus.c            |   8 +--
 include/acpi/acpi_drivers.h        |   2 +
 7 files changed, 121 insertions(+), 70 deletions(-)

-- 
1.8.1.2

