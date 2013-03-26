Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3CZPoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:44:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965181Ab3CZPXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/150] usb: gadget: ffs: fix enable multiple instances
Date: Tue, 26 Mar 2013 15:19:48 +0000
Message-Id: <1364311249-14454-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

commit 3416905ba058e43112ad7b1b4859797f027f5a07 upstream.

This patch fixes an "off-by-one" bug found in
581791f (FunctionFS: enable multiple functions).

During gfs_bind/gfs_unbind the functionfs_bind/functionfs_unbind should be
called for every functionfs instance. With the "i" pre-decremented they
were not called for the zeroth instance.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[ balbi@ti.com : added offending commit's subject ]

Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/g_ffs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index d3ace90..919177b 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -358,7 +358,7 @@ static int gfs_bind(struct usb_composite_dev *cdev)
 	if (unlikely(ret < 0))
 		goto error;
 
-	for (i = func_num; --i; ) {
+	for (i = func_num; i--; ) {
 		ret = functionfs_bind(ffs_tab[i].ffs_data, cdev);
 		if (unlikely(ret < 0)) {
 			while (++i < func_num)
@@ -413,7 +413,7 @@ static int gfs_unbind(struct usb_composite_dev *cdev)
 		gether_cleanup();
 	gfs_ether_setup = false;
 
-	for (i = func_num; --i; )
+	for (i = func_num; i--; )
 		if (ffs_tab[i].ffs_data)
 			functionfs_unbind(ffs_tab[i].ffs_data);
 
-- 
1.8.1.2

