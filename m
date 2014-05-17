Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaEQUc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 16:32:57 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43482 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaEQUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 16:32:55 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, jkc@redhat.com, sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: unisys: visorutil: Add a blank line
Date: Sat, 17 May 2014 21:32:53 +0100
Message-Id: <1400358773-21378-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a blank line after declarations to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/unisys/visorutil/charqueue.c      |    2 ++
 drivers/staging/unisys/visorutil/easyproc.c       |    6 ++++++
 drivers/staging/unisys/visorutil/periodic_work.c  |    1 +
 drivers/staging/unisys/visorutil/procobjecttree.c |    6 ++++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/staging/unisys/visorutil/charqueue.c b/drivers/staging/unisys/visorutil/charqueue.c
index 61600e1..22241c7 100644
--- a/drivers/staging/unisys/visorutil/charqueue.c
+++ b/drivers/staging/unisys/visorutil/charqueue.c
@@ -41,6 +41,7 @@ CHARQUEUE *visor_charqueue_create(ulong nslots)
 {
 	int alloc_size = sizeof(CHARQUEUE) + nslots + 1;
 	CHARQUEUE *cq = kmalloc(alloc_size, GFP_KERNEL|__GFP_NORETRY);
+
 	if (cq == NULL) {
 		ERRDRV("visor_charqueue_create allocation failed (alloc_size=%d)",
 		       alloc_size);
@@ -75,6 +76,7 @@ EXPORT_SYMBOL_GPL(visor_charqueue_enqueue);
 BOOL visor_charqueue_is_empty(CHARQUEUE *charqueue)
 {
 	BOOL b;
+
 	spin_lock(&charqueue->lock);
 	b = IS_EMPTY(charqueue);
 	spin_unlock(&charqueue->lock);
diff --git a/drivers/staging/unisys/visorutil/easyproc.c b/drivers/staging/unisys/visorutil/easyproc.c
index 43df598..3b38849 100644
--- a/drivers/staging/unisys/visorutil/easyproc.c
+++ b/drivers/staging/unisys/visorutil/easyproc.c
@@ -61,6 +61,7 @@ static struct proc_dir_entry *
 	createProcDir(char *name, struct proc_dir_entry *parent)
 {
 	struct proc_dir_entry *p = proc_mkdir_mode(name, S_IFDIR, parent);
+
 	if (p == NULL)
 		ERRDRV("failed to create /proc directory %s", name);
 	return p;
@@ -196,6 +197,7 @@ void visor_easyproc_InitDevice(struct easyproc_driver_info *pdriver,
 {
 	if ((pdriver->ProcDeviceDir != NULL) && (p->procDevicexDir == NULL)) {
 		char s[29];
+
 		sprintf(s, "%d", devno);
 		p->procDevicexDir = createProcDir(s, pdriver->ProcDeviceDir);
 		p->devno = devno;
@@ -267,6 +269,7 @@ void visor_easyproc_DeInitDevice(struct easyproc_driver_info *pdriver,
 				 struct easyproc_device_info *p, int devno)
 {
 	size_t i;
+
 	for (i = 0; i < ARRAY_SIZE(p->device_property_info); i++) {
 		if (p->device_property_info[i].procEntry != NULL) {
 			struct easyproc_device_property_info *px =
@@ -281,6 +284,7 @@ void visor_easyproc_DeInitDevice(struct easyproc_driver_info *pdriver,
 	}
 	if (p->procDevicexDir != NULL) {
 		char s[29];
+
 		sprintf(s, "%d", devno);
 		remove_proc_entry(s, pdriver->ProcDeviceDir);
 		p->procDevicexDir = NULL;
@@ -334,6 +338,7 @@ static ssize_t proc_write_driver(struct file *file, const char __user *buffer,
 	struct seq_file *seq = (struct seq_file *)file->private_data;
 	struct easyproc_driver_info *p = NULL;
 	char local_buf[256];
+
 	if (seq == NULL)
 		return 0;
 	p = (struct easyproc_driver_info *)(seq->private);
@@ -356,6 +361,7 @@ static ssize_t proc_write_device(struct file *file, const char __user *buffer,
 	struct seq_file *seq = (struct seq_file *)file->private_data;
 	struct easyproc_device_info *p = NULL;
 	char local_buf[256];
+
 	if (seq == NULL)
 		return 0;
 	p = (struct easyproc_device_info *)(seq->private);
diff --git a/drivers/staging/unisys/visorutil/periodic_work.c b/drivers/staging/unisys/visorutil/periodic_work.c
index 0251b83..38a60ce 100644
--- a/drivers/staging/unisys/visorutil/periodic_work.c
+++ b/drivers/staging/unisys/visorutil/periodic_work.c
@@ -92,6 +92,7 @@ EXPORT_SYMBOL_GPL(visor_periodic_work_destroy);
 BOOL visor_periodic_work_nextperiod(PERIODIC_WORK *periodic_work)
 {
 	BOOL rc = FALSE;
+
 	write_lock(&periodic_work->lock);
 	if (periodic_work->want_to_stop) {
 		periodic_work->is_scheduled = FALSE;
diff --git a/drivers/staging/unisys/visorutil/procobjecttree.c b/drivers/staging/unisys/visorutil/procobjecttree.c
index 2f874e0..5c8c95c 100644
--- a/drivers/staging/unisys/visorutil/procobjecttree.c
+++ b/drivers/staging/unisys/visorutil/procobjecttree.c
@@ -95,6 +95,7 @@ static struct proc_dir_entry *
 createProcDir(const char *name, struct proc_dir_entry *parent)
 {
 	struct proc_dir_entry *p = proc_mkdir_mode(name, S_IFDIR, parent);
+
 	if (p == NULL)
 		ERRDRV("failed to create /proc directory %s", name);
 	return p;
@@ -197,9 +198,11 @@ void visor_proc_DestroyType(MYPROCTYPE *type)
 		return;
 	if (type->procDirs != NULL) {
 		int i = type->nNames-1;
+
 		while (i >= 0) {
 			if (type->procDirs[i] != NULL) {
 				struct proc_dir_entry *parent = NULL;
+
 				if (i == 0)
 					parent = type->procDirRoot;
 				else
@@ -299,6 +302,7 @@ EXPORT_SYMBOL_GPL(visor_proc_CreateObject);
 void visor_proc_DestroyObject(MYPROCOBJECT *obj)
 {
 	MYPROCTYPE *type = NULL;
+
 	if (obj == NULL)
 		return;
 	type = obj->type;
@@ -306,6 +310,7 @@ void visor_proc_DestroyObject(MYPROCOBJECT *obj)
 		return;
 	if (obj->procDirProperties != NULL) {
 		int i = 0;
+
 		for (i = 0; i < type->nProperties; i++) {
 			if (obj->procDirProperties[i] != NULL) {
 				remove_proc_entry(type->propertyNames[i],
@@ -338,6 +343,7 @@ EXPORT_SYMBOL_GPL(visor_proc_DestroyObject);
 static int seq_show(struct seq_file *seq, void *offset)
 {
 	PROCDIRENTRYCONTEXT *ctx = (PROCDIRENTRYCONTEXT *)(seq->private);
+
 	if (ctx == NULL) {
 		ERRDRV("I don't have a freakin' clue...");
 		return 0;
-- 
1.7.9.5

