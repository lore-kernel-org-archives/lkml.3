Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaHPS6H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:58:07 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33417 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaHPS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:58:05 -0400
Date: Sun, 17 Aug 2014 00:27:48 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: [PATCH] staging: lustre: lustre: libcfs: do not use assignment in if
 condition
Message-ID: <20140816185748.GA12707@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following error using checkpatch.pl
Error: do not use assignment in if condition

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/libcfs/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 43817be..5a5b7fc 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -314,9 +314,8 @@ libcfs_debug_str2mask(int *mask, const char *str, int is_subsys)
 		if (!isspace(str[n-1]))
 			break;
 	matched = n;
-
-	if ((t = sscanf(str, "%i%n", &m, &matched)) >= 1 &&
-	    matched == n) {
+	t = sscanf(str, "%i%n", &m, &matched);
+	if (t >= 1 && matched == n) {
 		/* don't print warning for lctl set_param debug=0 or -1 */
 		if (m != 0 && m != -1)
 			CWARN("You are trying to use a numerical value for the "
-- 
1.9.1

