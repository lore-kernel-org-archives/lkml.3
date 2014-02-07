Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbaBGLv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42172 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaBGLvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 160/233] s390/uapi: fix struct statfs64 definition
Date: Fri,  7 Feb 2014 11:46:19 +0000
Message-Id: <1391773652-25214-161-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 4e078146dff728f4865270a47710d57797e81eb6 upstream.

With b8668fd0a7e1b59f "s390/uapi: change struct statfs[64] member types
to unsigned values" the size of a couple of struct statfs64 member got
incorrectly changed from 64 to 32 bit for 32 bit builds.

Fix this by changing the type of couple of struct statfs64 members from
unsigned long to unsigned long long.
The definition of struct compat_statfs64 was correct however.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/include/uapi/asm/statfs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/uapi/asm/statfs.h b/arch/s390/include/uapi/asm/statfs.h
index a61d538..471eb09 100644
--- a/arch/s390/include/uapi/asm/statfs.h
+++ b/arch/s390/include/uapi/asm/statfs.h
@@ -35,11 +35,11 @@ struct statfs {
 struct statfs64 {
 	unsigned int	f_type;
 	unsigned int	f_bsize;
-	unsigned long	f_blocks;
-	unsigned long	f_bfree;
-	unsigned long	f_bavail;
-	unsigned long	f_files;
-	unsigned long	f_ffree;
+	unsigned long long f_blocks;
+	unsigned long long f_bfree;
+	unsigned long long f_bavail;
+	unsigned long long f_files;
+	unsigned long long f_ffree;
 	__kernel_fsid_t f_fsid;
 	unsigned int	f_namelen;
 	unsigned int	f_frsize;
-- 
1.8.3.2

