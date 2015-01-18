Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbbAROJQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:09:16 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:39310 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbbAROIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:08:12 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luca Ceresoli <luca@lucaceresoli.net>, Peng Tao <bergwolf@gmail.com>,
        Jinshan Xiong <jinshan.xiong@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: lustre: fld: declare internal symbols as static
Date: Sun, 18 Jan 2015 15:06:51 +0100
Message-Id: <1421590012-7082-6-git-send-email-luca@lucaceresoli.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
References: <1421590012-7082-1-git-send-email-luca@lucaceresoli.net>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes sparse warnings like:
  warning: symbol '...' was not declared. Should it be static?

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Peng Tao <bergwolf@gmail.com>
Cc: Jinshan Xiong <jinshan.xiong@intel.com>
Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: HPDD-discuss@lists.01.org
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/lustre/lustre/fld/fld_cache.c | 6 +++---
 drivers/staging/lustre/lustre/fld/lproc_fld.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/fld/fld_cache.c b/drivers/staging/lustre/lustre/fld/fld_cache.c
index 5d95d0b..0d0a737 100644
--- a/drivers/staging/lustre/lustre/fld/fld_cache.c
+++ b/drivers/staging/lustre/lustre/fld/fld_cache.c
@@ -257,9 +257,9 @@ void fld_cache_flush(struct fld_cache *cache)
  * entry accordingly.
  */
 
-void fld_cache_punch_hole(struct fld_cache *cache,
-			  struct fld_cache_entry *f_curr,
-			  struct fld_cache_entry *f_new)
+static void fld_cache_punch_hole(struct fld_cache *cache,
+				 struct fld_cache_entry *f_curr,
+				 struct fld_cache_entry *f_new)
 {
 	const struct lu_seq_range *range = &f_new->fce_range;
 	const u64 new_start  = range->lsr_start;
diff --git a/drivers/staging/lustre/lustre/fld/lproc_fld.c b/drivers/staging/lustre/lustre/fld/lproc_fld.c
index 74b4db9..562b991 100644
--- a/drivers/staging/lustre/lustre/fld/lproc_fld.c
+++ b/drivers/staging/lustre/lustre/fld/lproc_fld.c
@@ -159,7 +159,7 @@ static int fld_proc_cache_flush_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-struct file_operations fld_proc_cache_flush_fops = {
+static struct file_operations fld_proc_cache_flush_fops = {
 	.owner		= THIS_MODULE,
 	.open		= fld_proc_cache_flush_open,
 	.write		= fld_proc_cache_flush_write,
-- 
1.9.1

