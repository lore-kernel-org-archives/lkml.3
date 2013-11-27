Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab3K0CJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:09:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab3K0A4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:56:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH 3.4 21/39] Revert "ima: policy for RAMFS"
Date: Tue, 26 Nov 2013 16:56:45 -0800
Message-Id: <20131127005620.507911267@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
References: <20131127005619.011763867@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 08de59eb144d7c41351a467442f898d720f0f15f upstream.

This reverts commit 4c2c392763a682354fac65b6a569adec4e4b5387.

Everything in the initramfs should be measured and appraised,
but until the initramfs has extended attribute support, at
least measured.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/integrity/ima/ima_policy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -62,7 +62,6 @@ static struct ima_measure_rule_entry def
 	{.action = DONT_MEASURE,.fsmagic = SYSFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = DEBUGFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
-	{.action = DONT_MEASURE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SECURITYFS_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = DONT_MEASURE,.fsmagic = SELINUX_MAGIC,.flags = IMA_FSMAGIC},
 	{.action = MEASURE,.func = FILE_MMAP,.mask = MAY_EXEC,


