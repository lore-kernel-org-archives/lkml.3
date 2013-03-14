Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab3CNK6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:58:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51826 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab3CNKhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 28/88] sysctl: fix null checking in bin_dn_node_address()
Date: Thu, 14 Mar 2013 10:35:21 +0000
Message-Id: <1363257381-15900-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit df1778be1a33edffa51d094eeda87c858ded6560 upstream.

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sysctl_binary.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index a650694..9f9aa32 100644
--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1194,9 +1194,10 @@ static ssize_t bin_dn_node_address(struct file *file,
 
 		/* Convert the decnet address to binary */
 		result = -EIO;
-		nodep = strchr(buf, '.') + 1;
+		nodep = strchr(buf, '.');
 		if (!nodep)
 			goto out;
+		++nodep;
 
 		area = simple_strtoul(buf, NULL, 10);
 		node = simple_strtoul(nodep, NULL, 10);
-- 
1.8.1.2

