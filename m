Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCEN3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:29:22 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59162 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaCEN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:29:13 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 2/6] staging/lustre/libcfs: remove cfs_strncasecmp
Date: Wed,  5 Mar 2014 21:27:16 +0800
Message-Id: <1394026040-1968-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
References: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only difference against generic strncasecmp() is that
cfs_strncasecmp() check NULL pointers and zero length parameter,
which all callers have already taken care of.

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/router_proc.c     |    4 +-
 .../staging/lustre/lustre/libcfs/libcfs_string.c   |   24 +------------------
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index 20d53e0..0cbd9fc 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -837,8 +837,8 @@ static int __proc_lnet_portal_rotor(void *data, int write,
 	rc = -EINVAL;
 	lnet_res_lock(0);
 	for (i = 0; portal_rotors[i].pr_name != NULL; i++) {
-		if (cfs_strncasecmp(portal_rotors[i].pr_name, tmp,
-				    strlen(portal_rotors[i].pr_name)) == 0) {
+		if (strncasecmp(portal_rotors[i].pr_name, tmp,
+				strlen(portal_rotors[i].pr_name)) == 0) {
 			portal_rotor = portal_rotors[i].pr_value;
 			rc = 0;
 			break;
diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
index 922debd..dc6a59a 100644
--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
@@ -42,26 +42,6 @@
 
 #include <linux/libcfs/libcfs.h>
 
-/* non-0 = don't match */
-int cfs_strncasecmp(const char *s1, const char *s2, size_t n)
-{
-	if (s1 == NULL || s2 == NULL)
-		return 1;
-
-	if (n == 0)
-		return 0;
-
-	while (n-- != 0 && tolower(*s1) == tolower(*s2)) {
-		if (n == 0 || *s1 == '\0' || *s2 == '\0')
-			break;
-		s1++;
-		s2++;
-	}
-
-	return tolower(*(unsigned char *)s1) - tolower(*(unsigned char *)s2);
-}
-EXPORT_SYMBOL(cfs_strncasecmp);
-
 /* Convert a text string to a bitmask */
 int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 		 int *oldmask, int minmask, int allmask)
@@ -101,7 +81,7 @@ int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 			debugstr = bit2str(i);
 			if (debugstr != NULL &&
 			    strlen(debugstr) == len &&
-			    cfs_strncasecmp(str, debugstr, len) == 0) {
+			    strncasecmp(str, debugstr, len) == 0) {
 				if (op == '-')
 					newmask &= ~(1 << i);
 				else
@@ -111,7 +91,7 @@ int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 			}
 		}
 		if (!found && len == 3 &&
-		    (cfs_strncasecmp(str, "ALL", len) == 0)) {
+		    (strncasecmp(str, "ALL", len) == 0)) {
 			if (op == '-')
 				newmask = minmask;
 			else
-- 
1.7.7.6

