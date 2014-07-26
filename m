Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaGZW1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 18:27:08 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:53151 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaGZW1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 18:27:06 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cifs: cifsencrypt.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sun, 27 Jul 2014 00:28:31 +0200
Message-Id: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are going to use memset before strncpy you must copy sizeof -1

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/cifs/cifsencrypt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4934347..dcca8b3 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
 
 	memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
 	if (password)
-		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
+		strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
 
 	if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
 		memcpy(lnm_session_key, password_with_pad,
-- 
1.7.10.4

