Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaFJRrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:47:03 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56931 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbaFJRrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:47:01 -0400
Date: Tue, 10 Jun 2014 10:46:20 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kent Overstreet <kmo@daterainc.com>, Tejun Heo <tj@kernel.org>,
        Geoff Levand <geoff@infradead.org>, Stefan Weinhuber <wein@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH] s390: avoid format strings leaking into names
Message-ID: <20140610174620.GA30139@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure format strings can't accidentally leak into kernel
interface names.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/s390/block/dcssblk.c     |    2 +-
 drivers/s390/char/vmlogrdr.c     |    2 +-
 drivers/s390/crypto/zcrypt_api.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index ee0e85abe1fd..0f471750327e 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -593,7 +593,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->start = dcssblk_find_lowest_addr(dev_info);
 	dev_info->end = dcssblk_find_highest_addr(dev_info);
 
-	dev_set_name(&dev_info->dev, dev_info->segment_name);
+	dev_set_name(&dev_info->dev, "%s", dev_info->segment_name);
 	dev_info->dev.release = dcssblk_release_segment;
 	dev_info->dev.groups = dcssblk_dev_attr_groups;
 	INIT_LIST_HEAD(&dev_info->lh);
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index cf31d3321dab..a8848db7b09d 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -761,7 +761,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 
 	dev = kzalloc(sizeof(struct device), GFP_KERNEL);
 	if (dev) {
-		dev_set_name(dev, priv->internal_name);
+		dev_set_name(dev, "%s", priv->internal_name);
 		dev->bus = &iucv_bus;
 		dev->parent = iucv_root;
 		dev->driver = &vmlogrdr_driver;
diff --git a/drivers/s390/crypto/zcrypt_api.c b/drivers/s390/crypto/zcrypt_api.c
index 5222ebe15705..0e18c5dcd91f 100644
--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -356,7 +356,7 @@ struct zcrypt_ops *zcrypt_msgtype_request(unsigned char *name, int variant)
 
 	zops = __ops_lookup(name, variant);
 	if (!zops) {
-		request_module(name);
+		request_module("%s", name);
 		zops = __ops_lookup(name, variant);
 	}
 	if ((!zops) || (!try_module_get(zops->owner)))
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
