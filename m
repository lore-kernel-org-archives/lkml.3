Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaFYKlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:41:39 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62823 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaFYKld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:41:33 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs: cifs: cifsencrypt.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Wed, 25 Jun 2014 12:42:34 +0200
Message-Id: <1403692954-18881-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the string is zeroed before, it's better to just copy one character less, instead of using strlcpy in this case.

This was found using a static code analysis program called cppcheck.

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

