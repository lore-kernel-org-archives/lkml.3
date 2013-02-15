Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935789Ab3BOMif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:38:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933028Ab3BOMid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:38:33 -0500
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Glauber Costa <glommer@parallels.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] ia64: rename cache_show to topology_cache_show
Date: Fri, 15 Feb 2013 13:38:24 +0100
Message-Id: <1360931904-5720-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <511e236a.o0ibbB2U8xMoURgd%fengguang.wu@intel.com>
References: <511e236a.o0ibbB2U8xMoURgd%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fenguang Wu has reported the following compile time issue
arch/ia64/kernel/topology.c:278:16: error: conflicting types for 'cache_show'
include/linux/slab.h:224:5: note: previous declaration of 'cache_show' was here

which has been introduced by 749c5415 (memcg: aggregate memcg cache
values in slabinfo). Let's rename ia64 local function to prevent from
the name conflict.

Reported-by: Fenguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 arch/ia64/kernel/topology.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/topology.c b/arch/ia64/kernel/topology.c
index c64460b..d9e2152 100644
--- a/arch/ia64/kernel/topology.c
+++ b/arch/ia64/kernel/topology.c
@@ -275,7 +275,8 @@ static struct attribute * cache_default_attrs[] = {
 #define to_object(k) container_of(k, struct cache_info, kobj)
 #define to_attr(a) container_of(a, struct cache_attr, attr)
 
-static ssize_t cache_show(struct kobject * kobj, struct attribute * attr, char * buf)
+static ssize_t topology_cache_show(struct kobject * kobj,
+		struct attribute * attr, char * buf)
 {
 	struct cache_attr *fattr = to_attr(attr);
 	struct cache_info *this_leaf = to_object(kobj);
@@ -286,7 +287,7 @@ static ssize_t cache_show(struct kobject * kobj, struct attribute * attr, char *
 }
 
 static const struct sysfs_ops cache_sysfs_ops = {
-	.show   = cache_show
+	.show   = topology_cache_show
 };
 
 static struct kobj_type cache_ktype = {
-- 
1.7.10.4

