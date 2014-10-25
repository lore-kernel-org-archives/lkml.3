Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbaJYTPi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:15:38 -0400
Received: from jambon.ath.cx ([212.129.4.85]:47640 "EHLO debian"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751023AbaJYTPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:15:37 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2014 15:15:36 EDT
From: Junien Fridrick <linux.kernel@junien.fridrick.net>
To: linux-kernel@vger.kernel.org
Cc: Junien Fridrick <linux.kernel@junien.fridrick.net>,
        Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Isaac Huang <he.huang@intel.com>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Doug Oucharek <doug.s.oucharek@intel.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: lustre: fix sparse warning for static declarations
Date: Sat, 25 Oct 2014 19:09:34 +0000
Message-Id: <1414264176-2546-1-git-send-email-linux.kernel@junien.fridrick.net>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings :

drivers/staging/lustre/lnet/lnet/router_proc.c:167:5: warning: symbol 'proc_lnet_routes' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router_proc.c:293:5: warning: symbol 'proc_lnet_routers' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router_proc.c:428:5: warning: symbol 'proc_lnet_peers' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router_proc.c:660:5: warning: symbol 'proc_lnet_nis' was not declared. Should it be static?

Signed-off-by: Junien Fridrick <linux.kernel@junien.fridrick.net>
---
This patch is part of task 16 of the Eudyptula challenge
Applies to next-20141023

 drivers/staging/lustre/lnet/lnet/router_proc.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index 6e8f7e2..b82914f 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -164,8 +164,8 @@ static int proc_lnet_stats(struct ctl_table *table, int write,
 				 __proc_lnet_stats);
 }
 
-int proc_lnet_routes(struct ctl_table *table, int write, void __user *buffer,
-		     size_t *lenp, loff_t *ppos)
+static int proc_lnet_routes(struct ctl_table *table, int write,
+		     void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	const int	tmpsiz = 256;
 	char		*tmpstr;
@@ -290,8 +290,8 @@ int proc_lnet_routes(struct ctl_table *table, int write, void __user *buffer,
 	return rc;
 }
 
-int proc_lnet_routers(struct ctl_table *table, int write, void __user *buffer,
-		      size_t *lenp, loff_t *ppos)
+static int proc_lnet_routers(struct ctl_table *table, int write,
+		      void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int	rc = 0;
 	char      *tmpstr;
@@ -425,8 +425,8 @@ int proc_lnet_routers(struct ctl_table *table, int write, void __user *buffer,
 	return rc;
 }
 
-int proc_lnet_peers(struct ctl_table *table, int write, void __user *buffer,
-		    size_t *lenp, loff_t *ppos)
+static int proc_lnet_peers(struct ctl_table *table, int write,
+		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	const int		tmpsiz  = 256;
 	struct lnet_peer_table	*ptable;
@@ -657,8 +657,8 @@ static int proc_lnet_buffers(struct ctl_table *table, int write,
 				 __proc_lnet_buffers);
 }
 
-int proc_lnet_nis(struct ctl_table *table, int write, void __user *buffer,
-		  size_t *lenp, loff_t *ppos)
+static int proc_lnet_nis(struct ctl_table *table, int write,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int	tmpsiz = 128 * LNET_CPT_NUMBER;
 	int	rc = 0;
-- 
2.0.1

