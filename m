Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab3EGELi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:11:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5656 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3EGD6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:47 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=g2hrVCTNmYUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=rujq3MB7sFYA:10 a=THCAyMpEAAAA:8 a=VwQbUJbxAAAA:8 a=2LjLHKtCAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=FCIOWvmKq0cA:10 a=C3PaYh0q9tsA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.897473527@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [024/126] remoteproc: fix error path of handle_vdev
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0024-remoteproc-fix-error-path-of-handle_vdev.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>

[ Upstream commit cde42e076c1cdd69a1f955d66ff6596bad3d2105 ]

Remove the vdev entry from the list before freeing it,
otherwise rproc->vdevs will explode.

Cc: stable@vger.kernel.org
Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Acked-by: Ido Yariv <ido@wizery.com>
[edit subject, minor commit log edit, cc stable]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/remoteproc/remoteproc_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 70b296f..cf68afb 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -342,10 +342,12 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* it is now safe to add the virtio device */
 	ret = rproc_add_virtio_dev(rvdev, rsc->id);
 	if (ret)
-		goto free_rvdev;
+		goto remove_rvdev;
 
 	return 0;
 
+remove_rvdev:
+	list_del(&rvdev->node);
 free_rvdev:
 	kfree(rvdev);
 	return ret;
-- 
1.7.10.4


