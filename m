Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3AVO6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 09:58:50 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:55236 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3AVO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 09:58:48 -0500
From: Xi Wang <xi.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Xi Wang <xi.wang@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] sysctl: fix null checking in bin_dn_node_address()
Date: Tue, 22 Jan 2013 09:58:25 -0500
Message-Id: <1358866705-30690-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The null check of `strchr() + 1' is broken, which is always non-null,
leading to OOB read.  Instead, check the result of strchr().

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: stable@vger.kernel.org
---
 kernel/sysctl_binary.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
index 5a63844..0ddf3a0 100644
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
1.7.10.4

