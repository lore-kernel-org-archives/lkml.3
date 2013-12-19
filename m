Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LSJrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:47:47 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:57313 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3LSJrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:47:43 -0500
Date: Thu, 19 Dec 2013 15:17:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 11/13] drivers: block: Mark functions as static in drbd_nl.c
Message-ID: <9f865bdcccb0ff88460787a7a33bdd7faa411d39.1387445397.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions conn_khelper(), nla_put_drbd_cfg_context(),
nla_put_status_info() and get_one_status() as static in drbd/drbd_nl.c
because they are not used outside this file.

This eliminates the following warnings in drbd/drbd_nl.c:
drivers/block/drbd/drbd_nl.c:365:5: warning: no previous prototype for ‘conn_khelper’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_nl.c:2727:5: warning: no previous prototype for ‘nla_put_drbd_cfg_context’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_nl.c:2753:5: warning: no previous prototype for ‘nla_put_status_info’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_nl.c:2895:5: warning: no previous prototype for ‘get_one_status’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_nl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index c706d50..4c00837 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -362,7 +362,7 @@ int drbd_khelper(struct drbd_conf *mdev, char *cmd)
 	return ret;
 }
 
-int conn_khelper(struct drbd_tconn *tconn, char *cmd)
+static int conn_khelper(struct drbd_tconn *tconn, char *cmd)
 {
 	char *envp[] = { "HOME=/",
 			"TERM=linux",
@@ -2724,7 +2724,8 @@ int drbd_adm_outdate(struct sk_buff *skb, struct genl_info *info)
 	return drbd_adm_simple_request_state(skb, info, NS(disk, D_OUTDATED));
 }
 
-int nla_put_drbd_cfg_context(struct sk_buff *skb, struct drbd_tconn *tconn, unsigned vnr)
+static int nla_put_drbd_cfg_context(struct sk_buff *skb,
+		struct drbd_tconn *tconn, unsigned vnr)
 {
 	struct nlattr *nla;
 	nla = nla_nest_start(skb, DRBD_NLA_CFG_CONTEXT);
@@ -2750,7 +2751,7 @@ nla_put_failure:
 	return -EMSGSIZE;
 }
 
-int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
+static int nla_put_status_info(struct sk_buff *skb, struct drbd_conf *mdev,
 		const struct sib_info *sib)
 {
 	struct state_info *si = NULL; /* for sizeof(si->member); */
@@ -2892,7 +2893,7 @@ out:
 	return 0;
 }
 
-int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
+static int get_one_status(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct drbd_conf *mdev;
 	struct drbd_genlmsghdr *dh;
-- 
1.7.9.5

