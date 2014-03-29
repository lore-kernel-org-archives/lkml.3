Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaC2SqD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:46:03 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41011 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaC2SqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:46:00 -0400
Date: Sun, 30 Mar 2014 00:16:25 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 50/55] scsi: Mark function and macro definition as static in
 be2iscsi/be_main.c
Message-ID: <c4a13888f1c3462834fd2d015b627230d996bfa3.1396114898.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in be2iscsi/be_main.c because they are not used
outside this file. Also, add static keyword to the macro definition to
ensure prototype of functions as defined.

This eliminates the following warning in be2iscsi/be_main.c:
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype for ‘beiscsi_log_enable_disp’ [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype for ‘beiscsi_log_enable_change’ [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype for ‘beiscsi_log_enable_store’ [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:153:1: warning: no previous prototype for ‘beiscsi_log_enable_init’ [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:4843:5: warning: no previous prototype for ‘beiscsi_iotask_v2’ [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:5181:6: warning: no previous prototype for ‘beiscsi_hba_attrs_init’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/be2iscsi/be_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 1f37505..d9d0087 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(be_max_phys_size,
 		"memory that can be allocated. Range is 16 - 128");
 
 #define beiscsi_disp_param(_name)\
-ssize_t	\
+static ssize_t	\
 beiscsi_##_name##_disp(struct device *dev,\
 			struct device_attribute *attrib, char *buf)	\
 {	\
@@ -74,7 +74,7 @@ beiscsi_##_name##_disp(struct device *dev,\
 }
 
 #define beiscsi_change_param(_name, _minval, _maxval, _defaval)\
-int \
+static int \
 beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
 {\
 	if (val >= _minval && val <= _maxval) {\
@@ -93,7 +93,7 @@ beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
 }
 
 #define beiscsi_store_param(_name)  \
-ssize_t \
+static ssize_t \
 beiscsi_##_name##_store(struct device *dev,\
 			 struct device_attribute *attr, const char *buf,\
 			 size_t count) \
@@ -112,7 +112,7 @@ beiscsi_##_name##_store(struct device *dev,\
 }
 
 #define beiscsi_init_param(_name, _minval, _maxval, _defval) \
-int \
+static int \
 beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val) \
 { \
 	if (val >= _minval && val <= _maxval) {\
@@ -4840,9 +4840,9 @@ free_hndls:
 	io_task->cmd_bhs = NULL;
 	return -ENOMEM;
 }
-int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
-		       unsigned int num_sg, unsigned int xferlen,
-		       unsigned int writedir)
+static int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
+			     unsigned int num_sg, unsigned int xferlen,
+			     unsigned int writedir)
 {
 
 	struct beiscsi_io_task *io_task = task->dd_data;
@@ -5178,7 +5178,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 	return rc;
 }
 
-void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
+static void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
 {
 	/* Set the logging parameter */
 	beiscsi_log_enable_init(phba, beiscsi_log_enable);
-- 
1.7.9.5

