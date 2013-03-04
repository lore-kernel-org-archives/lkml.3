Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3CDKqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:46:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:65340 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab3CDKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:46:31 -0500
From: Claudiu Ghioc <claudiughioc@gmail.com>
To: akpm@linux-foundation.org
Cc: mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com, dhillf@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Claudiu Ghioc <claudiu.ghioc@gmail.com>
Subject: [PATCH] hugetlb: fix sparse warning for hugetlb_register_node
Date: Mon,  4 Mar 2013 12:46:15 +0200
Message-Id: <1362393975-22533-1-git-send-email-claudiu.ghioc@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the following sparse warnings:
*  mm/hugetlb.c:1764:6: warning: symbol
    'hugetlb_unregister_node' was not declared.
    Should it be static?
*   mm/hugetlb.c:1808:6: warning: symbol
    'hugetlb_register_node' was not declared.
    Should it be static?

Signed-off-by: Claudiu Ghioc <claudiu.ghioc@gmail.com>
---
 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0a0be33..c65a8a5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1761,7 +1761,7 @@ static struct hstate *kobj_to_node_hstate(struct kobject *kobj, int *nidp)
  * Unregister hstate attributes from a single node device.
  * No-op if no hstate attributes attached.
  */
-void hugetlb_unregister_node(struct node *node)
+static void hugetlb_unregister_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
@@ -1805,7 +1805,7 @@ static void hugetlb_unregister_all_nodes(void)
  * Register hstate attributes for a single node device.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+static void hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->dev.id];
-- 
1.7.9.5

