Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3JUTPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:15:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:39506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3JUTPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:15:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,541,1378882800"; 
   d="scan'208";a="414681892"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/8] mei: debugfs: validate dev is not null
Date: Mon, 21 Oct 2013 22:05:36 +0300
Message-Id: <1382382343-12066-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
References: <1382382343-12066-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make static analyzer happy and
validate dev argument before dereferencing

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/debugfs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/debugfs.c b/drivers/misc/mei/debugfs.c
index e3870f2..9162491 100644
--- a/drivers/misc/mei/debugfs.c
+++ b/drivers/misc/mei/debugfs.c
@@ -30,11 +30,15 @@ static ssize_t mei_dbgfs_read_meclients(struct file *fp, char __user *ubuf,
 	struct mei_device *dev = fp->private_data;
 	struct mei_me_client *cl;
 	const size_t bufsz = 1024;
-	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	char *buf;
 	int i;
 	int pos = 0;
 	int ret;
 
+	if (!dev)
+		return -ENODEV;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
 	if  (!buf)
 		return -ENOMEM;
 
@@ -80,10 +84,14 @@ static ssize_t mei_dbgfs_read_devstate(struct file *fp, char __user *ubuf,
 {
 	struct mei_device *dev = fp->private_data;
 	const size_t bufsz = 1024;
-	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	char *buf;
 	int pos = 0;
 	int ret;
 
+	if (!dev)
+		return -ENODEV;
+
+	buf = kzalloc(bufsz, GFP_KERNEL);
 	if  (!buf)
 		return -ENOMEM;
 
-- 
1.8.3.1

