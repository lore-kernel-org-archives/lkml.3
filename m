Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935965Ab3DKUto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:49:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935906Ab3DKUte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:34 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=OAOFcGKwT3kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=J-kGdjJJDhsA:10 a=hD80L64hAAAA:8 a=lMwjtec1AAAA:8 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=ayC55rCoAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=v3rLFGiuRE8A:10 a=6gwatna_2BgA:10 a=jeBq3FmKZ4MA:10 a=x2szoZtqnggA:10 a=q9mC2fbAJx8A:10 a=YtYob3NMTz2M2EjU:21 a=4M12i82KA21zWPSy:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202557.208344122@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 067/171 ] usb: gadget: ffs: fix enable multiple instances
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0067-usb-gadget-ffs-fix-enable-multiple-instances.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>

[ Upstream commit 3416905ba058e43112ad7b1b4859797f027f5a07 ]

This patch fixes an "off-by-one" bug found in
581791f (FunctionFS: enable multiple functions).

During gfs_bind/gfs_unbind the functionfs_bind/functionfs_unbind should be
called for every functionfs instance. With the "i" pre-decremented they
were not called for the zeroth instance.

Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

[ balbi@ti.com : added offending commit's subject ]

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/g_ffs.c |    4 ++--
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
1.7.10.4


