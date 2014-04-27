Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaD0RPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:15:44 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48080 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283AbaD0RIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:21 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 31/47] staging/lustre/libcfs: fix issues found by Klocwork Insight tool
Date: Sun, 27 Apr 2014 13:06:55 -0400
Message-Id: <1398618431-29757-32-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

sscanf format specification '%u' expects type 'unsigned int *'
for 'u', but parameter 3 has a different type 'int*'.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9400
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c |  2 +-
 drivers/staging/lustre/lustre/libcfs/nidstrings.c      | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
index 77b1ef6..d169374 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-cpu.c
@@ -881,7 +881,7 @@ cfs_cpt_table_create_pattern(char *pattern)
 			break;
 		}
 
-		if (sscanf(str, "%u%n", &cpt, &n) < 1) {
+		if (sscanf(str, "%d%n", &cpt, &n) < 1) {
 			CERROR("Invalid cpu pattern %s\n", str);
 			goto failed;
 		}
diff --git a/drivers/staging/lustre/lustre/libcfs/nidstrings.c b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
index cfb274f..87705ae 100644
--- a/drivers/staging/lustre/lustre/libcfs/nidstrings.c
+++ b/drivers/staging/lustre/lustre/libcfs/nidstrings.c
@@ -227,11 +227,11 @@ libcfs_ip_addr2str(__u32 addr, char *str)
 int
 libcfs_ip_str2addr(const char *str, int nob, __u32 *addr)
 {
-	int   a;
-	int   b;
-	int   c;
-	int   d;
-	int   n = nob;			  /* XscanfX */
+	unsigned int	a;
+	unsigned int	b;
+	unsigned int	c;
+	unsigned int	d;
+	int		n = nob; /* XscanfX */
 
 	/* numeric IP? */
 	if (sscanf(str, "%u.%u.%u.%u%n", &a, &b, &c, &d, &n) >= 4 &&
@@ -419,7 +419,7 @@ libcfs_str2net_internal(const char *str, __u32 *net)
 {
 	struct netstrfns *uninitialized_var(nf);
 	int	       nob;
-	int	       netnum;
+	unsigned int   netnum;
 	int	       i;
 
 	for (i = 0; i < libcfs_nnetstrfns; i++) {
-- 
1.8.5.3

