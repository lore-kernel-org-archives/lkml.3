Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965217Ab3DPS1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:27:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965003Ab3DPS1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 17/28] drm: Constify drm_proc_list[] [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        dri-devel@lists.freedesktop.org
Date: Tue, 16 Apr 2013 19:26:57 +0100
Message-ID: <20130416182657.27773.75870.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Constify drm_proc_list[] and related pointers.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: dri-devel@lists.freedesktop.org
---

 drivers/gpu/drm/drm_proc.c |    6 +++---
 include/drm/drmP.h         |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index e064318..aead653 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -49,7 +49,7 @@
 /**
  * Proc file list.
  */
-static struct drm_info_list drm_proc_list[] = {
+static const struct drm_info_list drm_proc_list[] = {
 	{"name", drm_name_info, 0},
 	{"vm", drm_vm_info, 0},
 	{"clients", drm_clients_info, 0},
@@ -89,7 +89,7 @@ static const struct file_operations drm_proc_fops = {
  * Create a given set of proc files represented by an array of
  * gdm_proc_lists in the given root directory.
  */
-static int drm_proc_create_files(struct drm_info_list *files, int count,
+static int drm_proc_create_files(const struct drm_info_list *files, int count,
 			  struct proc_dir_entry *root, struct drm_minor *minor)
 {
 	struct drm_device *dev = minor->dev;
@@ -172,7 +172,7 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
 	return 0;
 }
 
-static int drm_proc_remove_files(struct drm_info_list *files, int count,
+static int drm_proc_remove_files(const struct drm_info_list *files, int count,
 			  struct drm_minor *minor)
 {
 	struct list_head *pos, *q;
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 2d94d74..af53320 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1022,7 +1022,7 @@ struct drm_info_list {
 struct drm_info_node {
 	struct list_head list;
 	struct drm_minor *minor;
-	struct drm_info_list *info_ent;
+	const struct drm_info_list *info_ent;
 	struct dentry *dent;
 };
 

