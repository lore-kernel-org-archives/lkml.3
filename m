Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaICHce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:32:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64504 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663AbaICHcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:32:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-14-5406c40c1638
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 3/3] integrity: make all integrity components as integrity
 module
Date: Wed, 03 Sep 2014 10:29:29 +0300
Message-id: <7f2ba23fe3156fcb4d71836ec7b0fd12d30c599b.1409728926.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1409728926.git.d.kasatkin@samsung.com>
References: <cover.1409728926.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e/4FV2eI2whBm+7rCxu/d3LbPFlaZ3F
	yxnz2C0u75rDZvGh5xGbxacVk5gd2Dx2zrrL7vHg0GYWj90LPjN59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bOR9vYC5o5K34urGlgvMPexcjJISFgInGk/T6ULSZx4d56ti5GLg4hgaWM
	Ev/XfGWFcDqZJNrPvmcCqWIT0JPY0PwDrENEIEdi0pkLzCA2s0C6xKdJvWBxYYEwiea5X9hA
	bBYBVYnJTctZQWxegTiJD98mMEJsk5M4eWwyWJxTwEpiw+udYLaQgKXEsldrWHCJT2DkX8DI
	sIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJPC+7GBcfMzqEKMAB6MSD2+BGluIEGtiWXFl
	7iFGCQ5mJRFe30SgEG9KYmVValF+fFFpTmrxIUYmDk6pBka/NrU8NrmnxbWXVm4UXpu3UGKC
	NcM6dt3rHfuv7a3iX7tbK0ffjkHdya/VfuOBYFeP8sLrvJtZvs8VfTc/4vGpXBvlW3st9f59
	2aJiUn28Pff0+4C/KdyBL5pPfLpxTO2jj2yzRMSrE6os8RpRDB5K8yP3nimrmRio5/+6uatg
	erFYd41btRJLcUaioRZzUXEiALnqf8IaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel print macros use KBUILD_MODNAME, which is initialized
to module name. Current Makefile puts every file to its own
module. So pr_xxx messages prefixed with file name instead of
module. This patch makes all as a 'integrity' module the same
way as it is done in evm/Makefile and ima/Makefile.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 security/integrity/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/integrity/Makefile b/security/integrity/Makefile
index 0793f48..8d1f4bf 100644
--- a/security/integrity/Makefile
+++ b/security/integrity/Makefile
@@ -3,11 +3,11 @@
 #
 
 obj-$(CONFIG_INTEGRITY) += integrity.o
-obj-$(CONFIG_INTEGRITY_AUDIT) += integrity_audit.o
-obj-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
-obj-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 
 integrity-y := iint.o
+integrity-$(CONFIG_INTEGRITY_AUDIT) += integrity_audit.o
+integrity-$(CONFIG_INTEGRITY_SIGNATURE) += digsig.o
+integrity-$(CONFIG_INTEGRITY_ASYMMETRIC_KEYS) += digsig_asymmetric.o
 
 subdir-$(CONFIG_IMA)			+= ima
 obj-$(CONFIG_IMA)			+= ima/
-- 
1.9.1

