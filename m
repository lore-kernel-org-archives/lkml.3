Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3HTVU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:20:26 -0400
Received: from mout.gmx.net ([212.227.17.21]:59538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab3HTVUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:20:23 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] Remove braces in drivers/scsi/in2000.h to fix build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 23:19:06 +0200
Message-Id: <1377033546-19475-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:gbOPNE93fVkNEZwuTrVUwFAMFGLtJrnJ5XA8E8GjHduXFCQSRDa
 zZ+hhxqhVtpPd0DSsiUUjg4f0aRkKTenhydZb2sdTqxAweLYX98zfVmVaFAMUcoTTDw22HJ
 cnGnU+tgwmph9pxQ8cM1+Pr6msJ774KJKYkRhXZBbI3UtaAvuD9ZlGFaEwbmBMIQW/7YG+y
 e3GgGeV/nxwPz+xBiB56w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "insw (%%dx)" but works for "insw %%dx" (outsw likewise);
  GNU as accepts both forms.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: Jan-Simon Möller <dl9pf@gmx.de>
CC: PaX Team <pageexec@freemail.hu>
CC: Behan Webster <behanw@converseincode.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/in2000.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
index 5821e1f..cd8d852 100644
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -72,7 +72,7 @@ int __dummy_1,__dummy_2; \
    orl %%ecx, %%ecx       \n \
    jz 1f                  \n \
    rep                    \n \
-   insw (%%dx),%%es:(%%edi) \n \
+   insw %%dx,%%es:(%%edi) \n \
 1: "                       \
    : "=D" (sp) ,"=c" (__dummy_1) ,"=d" (__dummy_2)  /* output */   \
    : "2" (f), "0" (sp), "1" (i)  /* input */    \
@@ -87,7 +87,7 @@ int __dummy_1,__dummy_2; \
    orl %%ecx, %%ecx       \n \
    jz 1f                  \n \
    rep                    \n \
-   outsw %%ds:(%%esi),(%%dx) \n \
+   outsw %%ds:(%%esi),%%dx \n \
 1: "                       \
    : "=S" (sp) ,"=c" (__dummy_1) ,"=d" (__dummy_2)/* output */   \
    : "2" (f), "0" (sp), "1" (i)  /* input */    \
-- 
1.8.1.4

