Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaFFL5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:57:24 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46599 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaFFL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:57:21 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@linaro.org, Magnus Damm <magnus.damm@gmail.com>,
        robh+dt@kernel.org
Date: Fri, 06 Jun 2014 20:59:25 +0900
Message-Id: <20140606115925.4584.28783.sendpatchset@w520>
In-Reply-To: <20140606115909.4584.28612.sendpatchset@w520>
References: <20140606115909.4584.28612.sendpatchset@w520>
Subject: [PATCH 02/02] of: Add OF=n stub for of_find_all_nodes()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Add a stub for the CONFIG_OF=n case of of_find_all_nodes().
The return value for the stub is NULL which is in sync with
when the full version of the function cannot find any nodes
registered. Added to allow removal of Kconfig dependency
handling for CONFIG_OF.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
---

 include/linux/of.h |    5 +++++
 1 file changed, 5 insertions(+)

--- 0001/include/linux/of.h
+++ work/include/linux/of.h	2014-06-06 19:00:38.000000000 +0900
@@ -349,6 +349,11 @@ int of_device_is_stdout_path(struct devi
 
 #else /* CONFIG_OF */
 
+static inline struct device_node *of_find_all_nodes(struct device_node *prev)
+{
+	return NULL;
+}
+
 static inline const char* of_node_full_name(const struct device_node *np)
 {
 	return "<no-node>";
