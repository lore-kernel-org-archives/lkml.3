Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551Ab3CTOvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:51:25 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37858 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab3CTOvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:51:24 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/2] of: Create sysfs view of device tree nodes
Date: Wed, 20 Mar 2013 14:51:12 +0000
Message-Id: <1363791074-16415-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series reworks the device tree userspace view to be exposed via
sysfs. I've been wanting to move to using kobjects to manage the device
tree for a while now. It results in less code overall, and it gives us
the userspace view "for free".

The first patch converts the device_nodes into kobjects and registers
them under /sys/firmware/ofw/device-tree. The second removes the old
/proc/device-tree support code and replaces it with a symlink from
/proc/device-tree to the sysfs view.

I attempted to also remove the virtual /proc/openprom filesystem, but
unfortunately /proc/devicetree and /proc/openprom use different
semantics. In /proc/devicetree the properties are exposed as raw
binaries, but in /proc/openprom the properties are all converted into
ascii string representation first.

I've tested this series on ARM and embedded powerpc. I have build tested
on SPARC and x86. Dave, I'm particularly interested to know how well
this runs on SPARC. I think I've got it right, but I haven't tested the
changes to the driver/of/pdt.c code.

g.

 Documentation/ABI/testing/sysfs-firmware-ofw |   28 ++++++
 drivers/of/Kconfig                           |   10 +-
 drivers/of/base.c                            |  180 +++++++++++++++++++++++-------------
 drivers/of/fdt.c                             |    3 +-
 drivers/of/pdt.c                             |    4 +-
 fs/proc/Makefile                             |    1 -
 fs/proc/proc_devtree.c                       |  243 -------------------------------------------------
 fs/proc/root.c                               |    3 -
 include/linux/of.h                           |   10 +-
 include/linux/proc_fs.h                      |   16 ----
 10 files changed, 156 insertions(+), 342 deletions(-)


[PATCH 1/2] of: Make device nodes kobjects so they show up in sysfs
[PATCH 2/2] of: remove /proc/device-tree
