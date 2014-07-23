Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbaGWXpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:45:54 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57432 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758607AbaGWXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:44:41 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 07/10] of: Make sure attached nodes don't carry along extra children
Date: Wed, 23 Jul 2014 17:44:21 -0600
Message-Id: <1406159064-21366-8-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The child pointer does not get cleared when attaching new nodes which
could cause the tree to be inconsistent. Clear the child pointer in
__of_attach_node() to be absolutely sure that the structure remains in a
consistent layout.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/dynamic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index c875787fa394..b96d83100987 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -98,6 +98,7 @@ int of_property_notify(int action, struct device_node *np,
 
 void __of_attach_node(struct device_node *np)
 {
+	np->child = NULL;
 	np->sibling = np->parent->child;
 	np->allnext = np->parent->allnext;
 	np->parent->allnext = np;
-- 
1.9.1

