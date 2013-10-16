Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760937Ab3JPX2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:28:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54791 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab3JPX23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:28:29 -0400
From: Michael Bohan <mbohan@codeaurora.org>
To: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, david.daney@cavium.com
Cc: linux-arm-msm@vger.kernel.org
Subject: [PATCH] of/lib: Export fdt routines to modules
Date: Wed, 16 Oct 2013 16:27:45 -0700
Message-Id: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since the following commit, libfdt has been available for
usage in the kernel:

     commit ab25383983fb8d7786696f5371e75e79c3e9a405
     Author: David Daney <david.daney@cavium.com>
     Date:   Thu Jul 5 18:12:38 2012 +0200

     of/lib: Allow scripts/dtc/libfdt to be used from kernel code

Export these functions to modules so that they may be used
from device drivers.

Change-Id: I7f540b7cf860c4be414e32ce183be5268b2ae6af
Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
---
 lib/fdt.c     |    6 ++++++
 lib/fdt_ro.c  |   28 ++++++++++++++++++++++++++++
 lib/fdt_rw.c  |   13 +++++++++++++
 lib/fdt_sw.c  |    9 +++++++++
 lib/fdt_wip.c |    6 ++++++
 5 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/lib/fdt.c b/lib/fdt.c
index 97f2006..a3fe87b 100644
--- a/lib/fdt.c
+++ b/lib/fdt.c
@@ -1,2 +1,8 @@
 #include <linux/libfdt_env.h>
+#include <linux/module.h>
 #include "../scripts/dtc/libfdt/fdt.c"
+
+EXPORT_SYMBOL_GPL(fdt_next_tag);
+EXPORT_SYMBOL_GPL(fdt_next_node);
+EXPORT_SYMBOL_GPL(fdt_check_header);
+EXPORT_SYMBOL_GPL(fdt_move);
diff --git a/lib/fdt_ro.c b/lib/fdt_ro.c
index f73c04e..97269bc 100644
--- a/lib/fdt_ro.c
+++ b/lib/fdt_ro.c
@@ -1,2 +1,30 @@
 #include <linux/libfdt_env.h>
+#include <linux/module.h>
 #include "../scripts/dtc/libfdt/fdt_ro.c"
+
+EXPORT_SYMBOL_GPL(fdt_string);
+EXPORT_SYMBOL_GPL(fdt_num_mem_rsv);
+EXPORT_SYMBOL_GPL(fdt_get_mem_rsv);
+EXPORT_SYMBOL_GPL(fdt_subnode_offset_namelen);
+EXPORT_SYMBOL_GPL(fdt_subnode_offset);
+EXPORT_SYMBOL_GPL(fdt_path_offset);
+EXPORT_SYMBOL_GPL(fdt_get_name);
+EXPORT_SYMBOL_GPL(fdt_first_property_offset);
+EXPORT_SYMBOL_GPL(fdt_next_property_offset);
+EXPORT_SYMBOL_GPL(fdt_get_property_by_offset);
+EXPORT_SYMBOL_GPL(fdt_get_property_namelen);
+EXPORT_SYMBOL_GPL(fdt_get_property);
+EXPORT_SYMBOL_GPL(fdt_getprop_by_offset);
+EXPORT_SYMBOL_GPL(fdt_getprop_namelen);
+EXPORT_SYMBOL_GPL(fdt_getprop);
+EXPORT_SYMBOL_GPL(fdt_get_phandle);
+EXPORT_SYMBOL_GPL(fdt_get_alias_namelen);
+EXPORT_SYMBOL_GPL(fdt_get_alias);
+EXPORT_SYMBOL_GPL(fdt_get_path);
+EXPORT_SYMBOL_GPL(fdt_supernode_atdepth_offset);
+EXPORT_SYMBOL_GPL(fdt_node_depth);
+EXPORT_SYMBOL_GPL(fdt_parent_offset);
+EXPORT_SYMBOL_GPL(fdt_node_offset_by_prop_value);
+EXPORT_SYMBOL_GPL(fdt_node_offset_by_phandle);
+EXPORT_SYMBOL_GPL(fdt_node_check_compatible);
+EXPORT_SYMBOL_GPL(fdt_node_offset_by_compatible);
diff --git a/lib/fdt_rw.c b/lib/fdt_rw.c
index 0c1f0f4..30de9ec 100644
--- a/lib/fdt_rw.c
+++ b/lib/fdt_rw.c
@@ -1,2 +1,15 @@
 #include <linux/libfdt_env.h>
+#include <linux/module.h>
 #include "../scripts/dtc/libfdt/fdt_rw.c"
+
+EXPORT_SYMBOL_GPL(fdt_open_into);
+EXPORT_SYMBOL_GPL(fdt_pack);
+EXPORT_SYMBOL_GPL(fdt_add_mem_rsv);
+EXPORT_SYMBOL_GPL(fdt_del_mem_rsv);
+EXPORT_SYMBOL_GPL(fdt_set_name);
+EXPORT_SYMBOL_GPL(fdt_setprop);
+EXPORT_SYMBOL_GPL(fdt_appendprop);
+EXPORT_SYMBOL_GPL(fdt_delprop);
+EXPORT_SYMBOL_GPL(fdt_add_subnode_namelen);
+EXPORT_SYMBOL_GPL(fdt_add_subnode);
+EXPORT_SYMBOL_GPL(fdt_del_node);
diff --git a/lib/fdt_sw.c b/lib/fdt_sw.c
index 9ac7e50..17d6ba1 100644
--- a/lib/fdt_sw.c
+++ b/lib/fdt_sw.c
@@ -1,2 +1,11 @@
 #include <linux/libfdt_env.h>
+#include <linux/module.h>
 #include "../scripts/dtc/libfdt/fdt_sw.c"
+
+EXPORT_SYMBOL_GPL(fdt_create);
+EXPORT_SYMBOL_GPL(fdt_add_reservemap_entry);
+EXPORT_SYMBOL_GPL(fdt_finish_reservemap);
+EXPORT_SYMBOL_GPL(fdt_begin_node);
+EXPORT_SYMBOL_GPL(fdt_property);
+EXPORT_SYMBOL_GPL(fdt_end_node);
+EXPORT_SYMBOL_GPL(fdt_finish);
diff --git a/lib/fdt_wip.c b/lib/fdt_wip.c
index 45b3fc3..22b606d 100644
--- a/lib/fdt_wip.c
+++ b/lib/fdt_wip.c
@@ -1,2 +1,8 @@
 #include <linux/libfdt_env.h>
+#include <linux/module.h>
 #include "../scripts/dtc/libfdt/fdt_wip.c"
+
+EXPORT_SYMBOL_GPL(fdt_setprop_inplace);
+EXPORT_SYMBOL_GPL(fdt_setprop_inplace_u32);
+EXPORT_SYMBOL_GPL(fdt_nop_property);
+EXPORT_SYMBOL_GPL(fdt_nop_node);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

