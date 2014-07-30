Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaG3NA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:00:27 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36148 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaG3NA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:00:26 -0400
From: Anil Belur <askb23@gmail.com>
To: tklauser@distanz.ch, dan.carpenter@oracle.com, bjorn@mork.no,
        silvio.fricke@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH v3] staging: vt6655: ioctl.c - missing __user annotation
Date: Wed, 30 Jul 2014 18:29:57 +0530
Message-Id: <1406725197-18530-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- private_ioctl() internally calls copy_{to,from}_user() and does
  not use '__user' which gives out several sparse warnings
- these sparse warnings were fixed by adding __user annotation to
  the data member of struct tagSCmdRequest:

 drivers/staging/vt6655/ioctl.c:78:51: warning: incorrect type in argument 2 (different address spaces)
 drivers/staging/vt6655/ioctl.c:78:51:    expected void const [noderef] asn:1>*from
 drivers/staging/vt6655/ioctl.c:78:51:    got void *data

Signed-off-by: Anil Belur <askb23@gmail.com>
---
v2:
- replaced the 'void __user *' casts by adding '__user' annotation to the data member of struct
  tagSCmdRequest which is much cleaner approach as suggested by tklauser@distanz.ch
v1:
- added 'void __user *' casts to supress the warnings

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

