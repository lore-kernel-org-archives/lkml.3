Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbaBZULm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:11:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44101 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbaBZULi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:11:38 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 02/12] Enforce module signatures when trusted kernel is enabled
Date: Wed, 26 Feb 2014 15:11:03 -0500
Message-Id: <1393445473-15068-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If trusted_kernel is true, require that all modules have valid signatures.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..e0220db 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2448,7 +2448,7 @@ static int module_sig_check(struct load_info *info)
 	if (err < 0 && fips_enabled)
 		panic("Module verification failed with error %d in FIPS mode\n",
 		      err);
-	if (err == -ENOKEY && !sig_enforce)
+	if ((err == -ENOKEY && !sig_enforce) && !get_trusted_kernel())
 		err = 0;
 
 	return err;
-- 
1.8.5.3

