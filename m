Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbaJGOjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:39:31 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40776 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJGOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:39:30 -0400
Message-ID: <5433FB18.9000009@gmail.com>
Date: Tue, 07 Oct 2014 16:39:20 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 002/002] staging: gs_fpgaboot: Fix "Possible unnecessary 'out
 of memory' message" checkpatch.pl warning
References: <5433FA93.8000607@gmail.com>
In-Reply-To: <5433FA93.8000607@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Possible unnecessary 'out of memory' message" checkpatch.pl warning

Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>

---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 6129164..b7ca3a3 100644
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
-- 
2.1.2
