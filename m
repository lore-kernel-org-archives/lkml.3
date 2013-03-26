Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3CZX3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:29:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3CZWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 87/98] usb: gadget: ffs: fix enable multiple instances
Date: Tue, 26 Mar 2013 15:43:16 -0700
Message-Id: <20130326224251.495059596@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/g_ffs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -357,7 +357,7 @@ static int gfs_bind(struct usb_composite
 		goto error;
 	gfs_dev_desc.iProduct = gfs_strings[USB_GADGET_PRODUCT_IDX].id;
 
-	for (i = func_num; --i; ) {
+	for (i = func_num; i--; ) {
 		ret = functionfs_bind(ffs_tab[i].ffs_data, cdev);
 		if (unlikely(ret < 0)) {
 			while (++i < func_num)
@@ -413,7 +413,7 @@ static int gfs_unbind(struct usb_composi
 		gether_cleanup();
 	gfs_ether_setup = false;
 
-	for (i = func_num; --i; )
+	for (i = func_num; i--; )
 		if (ffs_tab[i].ffs_data)
 			functionfs_unbind(ffs_tab[i].ffs_data);
 


