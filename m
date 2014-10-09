Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaJIHXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:23:02 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46476 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJIHWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:22:54 -0400
Message-ID: <543637C3.5010009@gmail.com>
Date: Thu, 09 Oct 2014 09:22:43 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] staging: gs_fpgaboot: Fix "out of memory" error handling
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com> <54340568.7090700@gmail.com> <1412695842.2916.49.camel@joe-AO725> <54340C70.9070505@gmail.com> <54340CC8.8070903@gmail.com> <20141008224816.GA3583@kroah.com> <54363737.50700@gmail.com>
In-Reply-To: <54363737.50700@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "out of memory" error handling

Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>

---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index cbf70ce..0c18c4c 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -295,8 +295,8 @@ static int gs_fpgaboot(void)
 	struct fpgaimage	*fimage;
 
 	fimage = kmalloc(sizeof(struct fpgaimage), GFP_KERNEL);
-	if (fimage == NULL)
-		goto err_out;
+	if (!fimage)
+		return -ENOMEM;
 
 	err = gs_load_image(fimage, file);
 	if (err) {
@@ -338,7 +338,6 @@ err_out2:
 err_out1:
 	kfree(fimage);
 
-err_out:
 	return -1;
 
 }
-- 
2.1.2

