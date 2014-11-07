Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKGQ0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:26:40 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48261 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258AbaKGQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:26:39 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will.deacon@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 01/11] of: Add empty of_get_next_parent stub
Date: Fri,  7 Nov 2014 16:25:26 +0000
Message-Id: <1415377536-12841-2-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
References: <1415377536-12841-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no stub version of of_get_next_parent, so use in code compiled
without !CONFIG_OF will cause the kernel build to fail.

This patch adds a stub version of of_get_next_parent as is with other
!CONFIG_OF stub functions, so such code can compile without CONFIG_OF.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <rob.herring@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 include/linux/of.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 6545e7a..2d4b7e0 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -392,6 +392,11 @@ static inline struct device_node *of_get_parent(const struct device_node *node)
 	return NULL;
 }
 
+static inline struct device_node *of_get_next_parent(struct device_node *node)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_get_next_child(
 	const struct device_node *node, struct device_node *prev)
 {
-- 
1.9.1

