Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJLCry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:47:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:38367 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaJLCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:47:26 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 2/3] staging/lustre: get rid of deprecaed acl mount option code
Date: Sat, 11 Oct 2014 22:46:53 -0400
Message-Id: <1413082014-10510-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
References: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is long since unused code, so get rid of it.

Signed-off-by: Oleg Drokin <green@linuxhacker.ru>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index a8bcc51..695424b 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -816,25 +816,6 @@ static int ll_options(char *options, int *flags)
 			*flags &= ~tmp;
 			goto next;
 		}
-#if LUSTRE_VERSION_CODE < OBD_OCD_VERSION(2, 5, 50, 0)
-		tmp = ll_set_opt("acl", s1, LL_SBI_ACL);
-		if (tmp) {
-			/* Ignore deprecated mount option.  The client will
-			 * always try to mount with ACL support, whether this
-			 * is used depends on whether server supports it. */
-			LCONSOLE_ERROR_MSG(0x152, "Ignoring deprecated "
-						  "mount option 'acl'.\n");
-			goto next;
-		}
-		tmp = ll_set_opt("noacl", s1, LL_SBI_ACL);
-		if (tmp) {
-			LCONSOLE_ERROR_MSG(0x152, "Ignoring deprecated "
-						  "mount option 'noacl'.\n");
-			goto next;
-		}
-#else
-#warning "{no}acl options have been deprecated since 1.8, please remove them"
-#endif
 		tmp = ll_set_opt("remote_client", s1, LL_SBI_RMT_CLIENT);
 		if (tmp) {
 			*flags |= tmp;
-- 
1.9.3

