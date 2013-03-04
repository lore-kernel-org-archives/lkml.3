Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab3CDVly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:41:54 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45795 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3CDVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:41:52 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jiang.liu@huawei.com,
        isimatu.yasuaki@jp.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/3] ACPI: Provide consistent PNPID match handling
Date: Mon,  4 Mar 2013 14:30:40 -0700
Message-Id: <1362432643-25636-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When installing/removing a notify handler to/from an ACPI device
object, ACPI core tries to match its associated scan handler to
see if it supports hotplug.  However, the matching logic of the
notify handler is different from the matching logic of attaching
a scan handler to an ACPI device object.  This inconsistency can
lead a mismatch and prevents ACPI scan handlers from supporting
non-HID devices, such as processor objects.

This patchset first updates PNPID setup interfaces to be independent
from acpi_device, and then updates the matching logic of the notify
handlers to be consistent with the attach handling.

This patchset is based on linux-pm.git/bleeding-edge.

---
Toshi Kani (3):
  ACPI: Remove acpi_device dependency in acpi_device_set_id()
  ACPI: Update PNPID set/free interfaces
  ACPI: Update PNPID match handling for notify

---
 drivers/acpi/internal.h               |   2 +-
 drivers/acpi/power.c                  |   2 +-
 drivers/acpi/scan.c                   | 203 +++++++++++++++++++---------------
 drivers/acpi/video_detect.c           |  25 ++---
 drivers/gpu/drm/i915/intel_opregion.c |   4 +-
 include/acpi/acpi_bus.h               |  14 ++-
 include/linux/acpi.h                  |   4 +-
 7 files changed, 138 insertions(+), 116 deletions(-)
