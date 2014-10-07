Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaJGPZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:25:11 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:33483 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaJGPZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:25:07 -0400
Message-ID: <543405C9.8090706@gmail.com>
Date: Tue, 07 Oct 2014 17:24:57 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 2/2] staging: gs_fpgaboot: Fix "Possible unnecessary 'out
 of memory' message" checkpatch.pl warning
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com> <54340568.7090700@gmail.com>
In-Reply-To: <54340568.7090700@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Possible unnecessary 'out of memory' message" checkpatch.pl warning

Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>

---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 6129164..cc788f1 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -316,10 +316,8 @@ static int gs_fpgaboot(void)
 	struct fpgaimage	*fimage;
 
 	fimage = kmalloc(sizeof(struct fpgaimage), GFP_KERNEL);
-	if (fimage == NULL) {
-		pr_err("No memory is available\n");
-		goto err_out;
-	}
+	if (!fimage)
+		return -ENOMEM;
 
 	err = gs_load_image(fimage, file);
 	if (err) {
@@ -361,7 +359,6 @@ err_out2:
 err_out1:
 	kfree(fimage);
 
-err_out:
 	return -1;
 
 }
-- 
2.1.2
