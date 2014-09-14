Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaINQCc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:02:32 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37562 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbaINQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:02:31 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Matt Kurz <matt@ninezulu.com>, Vitaly Osipov <vitaly.osipov@gmail.com>,
        Tugce Sirin <ztugcesirin@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: prism2fw.c:  Cleaning up unnecessary use of memset in conjunction with strncpy
Date: Sun, 14 Sep 2014 18:04:21 +0200
Message-Id: <1410710661-14604-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using memset before strncpy just to ensure a trailing null
character is an unnecessary double writing of a string

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/wlan-ng/prism2fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
index 42c14b0..e66b7d4 100644
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -733,8 +733,8 @@ static int plugimage(struct imgchunk *fchunk, unsigned int nfchunks,
 			 c, chunkoff);
 
 		if (j == -1) {	/* plug the filename */
-			memset(dest, 0, s3plug[i].len);
 			strncpy(dest, PRISM2_USB_FWFILE, s3plug[i].len - 1);
+			dest[s3plug[i].len - 1] = '\0';
 		} else {	/* plug a PDR */
 			memcpy(dest, &(pda->rec[j]->data), s3plug[i].len);
 		}
-- 
1.7.10.4

