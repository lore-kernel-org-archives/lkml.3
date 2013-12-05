Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab3LERvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:51:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38277 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab3LERha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mimi Zohar <zohar@us.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 50/90] Revert "ima: policy for RAMFS"
Date: Thu,  5 Dec 2013 17:35:32 +0000
Message-Id: <1386264972-5399-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 08de59eb144d7c41351a467442f898d720f0f15f upstream.

This reverts commit 4c2c392763a682354fac65b6a569adec4e4b5387.

Everything in the initramfs should be measured and appraised,
but until the initramfs has extended attribute support, at
least measured.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 security/integrity/ima/ima_policy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index d8edff2..d6aab27 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -62,7 +62,6 @@ static struct ima_measure_rule_entry default_rules[] = {
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,
-- 
1.8.3.2

