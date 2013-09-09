Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3IIPzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:55:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44955 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3IIPwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:52:09 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        linux-efi@vger.kernel.org, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 02/12] Enforce module signatures when securelevel is greater than 0
Date: Mon,  9 Sep 2013 11:49:36 -0400
Message-Id: <1378741786-18430-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:5d52:9ee3:3e84:6668
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If securelevel has been set to 1 or greater, require that all modules have
valid signatures.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index dc58274..ab126d7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2487,7 +2487,7 @@ static int module_sig_check(struct load_info *info)
 	if (err < 0 && fips_enabled)
 		panic("Module verification failed with error %d in FIPS mode\n",
 		      err);
-	if (err == -ENOKEY && !sig_enforce)
+	if ((err == -ENOKEY && !sig_enforce) && (get_securelevel() <= 0))
 		err = 0;
 
 	return err;
-- 
1.8.3.1

