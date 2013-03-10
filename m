Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab3CJM3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:29:21 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36342 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3CJM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:29:19 -0400
From: Dia Vasile <winged.flamespitter@gmail.com>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        samba-technical@lists.samba.org, Dia Vasile <kill.elohim@hotmail.com>
Subject: [PATCH] cifs: replaced kmalloc + memset with kzalloc
Date: Sun, 10 Mar 2013 14:29:04 +0200
Message-Id: <1362918544-31796-1-git-send-email-winged.flamespitter@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dia Vasile <kill.elohim@hotmail.com>

Signed-off-by: Diana Vasile <kill.elohim@hotmail.com>
---
 fs/cifs/smb2pdu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 41d9d07..83ef66e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -846,12 +846,10 @@ create_lease_buf(u8 *lease_key, u8 oplock)
 {
 	struct create_lease *buf;
 
-	buf = kmalloc(sizeof(struct create_lease), GFP_KERNEL);
+	buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
-	memset(buf, 0, sizeof(struct create_lease));
-
 	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
 	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
-- 
1.7.10.4

