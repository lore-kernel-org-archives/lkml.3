Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaG3KmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:42:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46256 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaG3KmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:42:11 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: tklauser@distanz.ch, dan.carpenter@oracle.com, bjorn@mork.no,
        silvio.fricke@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v2 1/1] staging: vt6655: ioctl.c - missing __user annotation
Date: Wed, 30 Jul 2014 16:11:59 +0530
Message-Id: <1406716919-13595-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

v2:
- private_ioctl() internally calls copy_{to,from}_user() and does
  not use '__user' which gives out several sparse warnings
- this patch adds __user annotation to the data member of struct
  tagSCmdRequest as suggested by tklauser@distanz.ch
- sparse warnings fixed:
 drivers/staging/vt6655/ioctl.c:78:51: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:78:51:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:78:51:    got void *data
 drivers/staging/vt6655/ioctl.c:117:55: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:117:55:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:117:55:    got void *data
 drivers/staging/vt6655/ioctl.c:149:46: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:149:46:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:149:46:    got void *data
 drivers/staging/vt6655/ioctl.c:166:51: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:166:51:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:166:51:    got void *data
 drivers/staging/vt6655/ioctl.c:212:50: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:212:50:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:212:50:    got void *data
 drivers/staging/vt6655/ioctl.c:276:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:276:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:276:38:    got void *data
 drivers/staging/vt6655/ioctl.c:292:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:292:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:292:38:    got void *data
 drivers/staging/vt6655/ioctl.c:300:48: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:300:48:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:300:48:    got void *data
 drivers/staging/vt6655/ioctl.c:344:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:344:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:344:38:    got void *data
 drivers/staging/vt6655/ioctl.c:353:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:353:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:353:38:    got void *data
 drivers/staging/vt6655/ioctl.c:360:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:360:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:360:38:    got void *data
 drivers/staging/vt6655/ioctl.c:401:49: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:401:49:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:401:49:    got void *data
 drivers/staging/vt6655/ioctl.c:424:49: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:424:49:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:424:49:    got void *data
 drivers/staging/vt6655/ioctl.c:440:49: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:440:49:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:440:49:    got void *data
 drivers/staging/vt6655/ioctl.c:457:49: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:457:49:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:457:49:    got void *data
 drivers/staging/vt6655/ioctl.c:479:54: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:479:54:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:479:54:    got void *data
 drivers/staging/vt6655/ioctl.c:563:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:563:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:563:38:    got void *data
 drivers/staging/vt6655/ioctl.c:571:52: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:571:52:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:571:52:    got void *data
 drivers/staging/vt6655/ioctl.c:615:38: warning: incorrect type in argument 1 (different address spaces)
 drivers/staging/vt6655/ioctl.c:615:38:    expected void [noderef] asn:1>*to
 drivers/staging/vt6655/ioctl.c:615:38:    got void *data
 drivers/staging/vt6655/ioctl.c:631:53: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:631:53:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:631:53:    got void *data

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/vt6655/iocmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/iocmd.h b/drivers/staging/vt6655/iocmd.h
index e499f1b..dd12498 100644
--- a/drivers/staging/vt6655/iocmd.h
+++ b/drivers/staging/vt6655/iocmd.h
@@ -100,7 +100,7 @@ typedef enum tagWZONETYPE {
 #pragma pack(1)
 typedef struct tagSCmdRequest {
 	u8	    name[16];
-	void	*data;
+	void __user *data;
 	u16	    wResult;
 	u16     wCmdCode;
 } SCmdRequest, *PSCmdRequest;
-- 
1.9.1

