Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbbAURGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:06:13 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63086 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbbAURGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:06:03 -0500
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] of: Empty node & property flag accessors when !OF
Date: Wed, 21 Jan 2015 19:05:57 +0200
Message-Id: <1421859957-24457-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce empty node and property flag accessors when CONFIG_OF is not
defined.
This allows us to use them without ifdef'ing them in places where it
makes sense to do so.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 include/linux/of.h | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index dfde07e..7ede449 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -616,6 +616,38 @@ static inline const char *of_prop_next_string(struct property *prop,
 	return NULL;
 }
 
+static inline int of_node_check_flag(struct device_node *n, unsigned long flag)
+{
+	return 0;
+}
+
+static inline int of_node_test_and_set_flag(struct device_node *n,
+					    unsigned long flag)
+{
+	return 0;
+}
+
+static inline void of_node_set_flag(struct device_node *n, unsigned long flag)
+{
+}
+
+static inline void of_node_clear_flag(struct device_node *n, unsigned long flag)
+{
+}
+
+static inline int of_property_check_flag(struct property *p, unsigned long flag)
+{
+	return 0;
+}
+
+static inline void of_property_set_flag(struct property *p, unsigned long flag)
+{
+}
+
+static inline void of_property_clear_flag(struct property *p, unsigned long flag)
+{
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
-- 
1.7.12

