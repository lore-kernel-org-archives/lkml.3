Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3AOWgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:36:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:44017 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758171Ab3AOWg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 211/221] rbd: get rid of RBD_MAX_SEG_NAME_LEN
Date: Tue, 15 Jan 2013 10:52:18 -0800
Message-Id: <20130115185013.280584909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit 2fd82b9e92c2a718ae81fc987b4468ceeee6979b)

RBD_MAX_SEG_NAME_LEN represents the maximum length of an rbd object
name (i.e., one of the objects providing storage backing an rbd
image).

Another symbol, MAX_OBJ_NAME_SIZE, is used in the osd client code to
define the maximum length of any object name in an osd request.

Right now they disagree, with RBD_MAX_SEG_NAME_LEN being too big.

There's no real benefit at this point to defining the rbd object
name length limit separate from any other object name, so just
get rid of RBD_MAX_SEG_NAME_LEN and use MAX_OBJ_NAME_SIZE in its
place.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c       |    6 +++---
 drivers/block/rbd_types.h |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -706,13 +706,13 @@ static char *rbd_segment_name(struct rbd
 	u64 segment;
 	int ret;
 
-	name = kmalloc(RBD_MAX_SEG_NAME_LEN + 1, GFP_NOIO);
+	name = kmalloc(MAX_OBJ_NAME_SIZE + 1, GFP_NOIO);
 	if (!name)
 		return NULL;
 	segment = offset >> rbd_dev->header.obj_order;
-	ret = snprintf(name, RBD_MAX_SEG_NAME_LEN, "%s.%012llx",
+	ret = snprintf(name, MAX_OBJ_NAME_SIZE + 1, "%s.%012llx",
 			rbd_dev->header.object_prefix, segment);
-	if (ret < 0 || ret >= RBD_MAX_SEG_NAME_LEN) {
+	if (ret < 0 || ret > MAX_OBJ_NAME_SIZE) {
 		pr_err("error formatting segment name for #%llu (%d)\n",
 			segment, ret);
 		kfree(name);
--- a/drivers/block/rbd_types.h
+++ b/drivers/block/rbd_types.h
@@ -46,8 +46,6 @@
 #define RBD_MIN_OBJ_ORDER       16
 #define RBD_MAX_OBJ_ORDER       30
 
-#define RBD_MAX_SEG_NAME_LEN	128
-
 #define RBD_COMP_NONE		0
 #define RBD_CRYPT_NONE		0
 


