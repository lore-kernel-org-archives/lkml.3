Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab3LRSgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:36:13 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:32867 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3LRSgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:36:10 -0500
Date: Thu, 19 Dec 2013 00:05:59 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jingoo Han <jg1.han@samsung.com>, Andy Grover <agrover@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 4/4] drivers: target: Mark functions and structures as static
 in tfc_conf.c
Message-ID: <94a49e2b29220b2a3fb93449a7b2c96fb6ea4667.1387390091.git.rashika.kheria@gmail.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions ft_tpg_alloc_fabric_acl(), ft_register_configfs() and
ft_deregister_configfs() as static in tcm_fc/tfc_conf.c because they are
not used outside this file.

This eliminates the following warnings in tcm_fc/tfc_conf.c:
drivers/target/tcm_fc/tfc_conf.c:270:21: warning: no previous prototype for ‘ft_tpg_alloc_fabric_acl’ [-Wmissing-prototypes]
drivers/target/tcm_fc/tfc_conf.c:555:5: warning: no previous prototype for ‘ft_register_configfs’ [-Wmissing-prototypes]
drivers/target/tcm_fc/tfc_conf.c:602:6: warning: no previous prototype for ‘ft_deregister_configfs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/target/tcm_fc/tfc_conf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index c6932fb..e879da8 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -267,7 +267,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	return found;
 }
 
-struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
+static struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 {
 	struct ft_node_acl *acl;
 
@@ -552,7 +552,7 @@ static struct target_core_fabric_ops ft_fabric_ops = {
 	.fabric_drop_nodeacl =		&ft_del_acl,
 };
 
-int ft_register_configfs(void)
+static int ft_register_configfs(void)
 {
 	struct target_fabric_configfs *fabric;
 	int ret;
@@ -599,7 +599,7 @@ int ft_register_configfs(void)
 	return 0;
 }
 
-void ft_deregister_configfs(void)
+static void ft_deregister_configfs(void)
 {
 	if (!ft_configfs)
 		return;
-- 
1.7.9.5

