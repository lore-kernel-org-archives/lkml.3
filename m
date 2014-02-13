Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaBMCVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:21:36 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64738 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaBMCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:21:34 -0500
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] ext4: address a benign compiler warning
Date: Wed, 12 Feb 2014 21:13:13 -0500
Message-Id: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 1.9.0.rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as an
empty do-while statement so as to suppress the following compiler
warning:

fs/ext4/mballoc.c: In function ‘ext4_mb_cleanup_pa’:
fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
   mb_debug(1, "mballoc: %u PAs left\n", count);

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 fs/ext4/mballoc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 08481ee..92eeb98 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
 		}							\
 	} while (0)
 #else
-#define mb_debug(n, fmt, a...)
+#define mb_debug(n, fmt, a...)		do { } while (0)
 #endif
 
 #define EXT4_MB_HISTORY_ALLOC		1	/* allocation */
-- 
1.9.0.rc3

