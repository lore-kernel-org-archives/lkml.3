Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaETKfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:35:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44499 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaETKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:04 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] staging: ft1000: Remove useless return variables
Date: Tue, 20 May 2014 12:33:44 +0200
Message-Id: <1400582028-24990-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/ft1000/ft1000-usb/ft1000_download.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index cab9cdf..65f9801 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -522,7 +522,6 @@ static void usb_dnld_complete(struct urb *urb)
 static int write_blk_fifo(struct ft1000_usb *ft1000dev, u16 **pUsFile,
 			  u8 **pUcFile, long word_length)
 {
-	int Status = 0;
 	int byte_length;
 
 	byte_length = word_length * 4;
@@ -547,7 +546,7 @@ static int write_blk_fifo(struct ft1000_usb *ft1000dev, u16 **pUsFile,
 	*pUsFile = *pUsFile + (word_length << 1);
 	*pUcFile = *pUcFile + (word_length << 2);
 
-	return Status;
+	return 0;
 }
 
 static int scram_start_dwnld(struct ft1000_usb *ft1000dev, u16 *hshake,

