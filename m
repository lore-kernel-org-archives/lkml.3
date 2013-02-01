Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3BAQIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:08:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38494 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128Ab3BAQIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:08:30 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 1/2] staging: android: ashmem: fix ashmem pin/unpin interface
Date: Fri,  1 Feb 2013 16:08:00 +0000
Message-Id: <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The values exchanged between kernel and userspace through struct
ashmem_pin should be of type size_t. This change won't affect the
existing interface but will stand as the basis of 64bit compat layer.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/ashmem.c |    2 +-
 drivers/staging/android/ashmem.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 72064fc..aa52646 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -596,7 +596,7 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
 	if (unlikely((pin.offset | pin.len) & ~PAGE_MASK))
 		return -EINVAL;
 
-	if (unlikely(((__u32) -1) - pin.offset < pin.len))
+	if (unlikely(((size_t) -1) - pin.offset < pin.len))
 		return -EINVAL;
 
 	if (unlikely(PAGE_ALIGN(asma->size) < pin.offset + pin.len))
diff --git a/drivers/staging/android/ashmem.h b/drivers/staging/android/ashmem.h
index 1976b10..c9b2eba 100644
--- a/drivers/staging/android/ashmem.h
+++ b/drivers/staging/android/ashmem.h
@@ -28,8 +28,8 @@
 #define ASHMEM_IS_PINNED	1
 
 struct ashmem_pin {
-	__u32 offset;	/* offset into region, in bytes, page-aligned */
-	__u32 len;	/* length forward from offset, in bytes, page-aligned */
+	size_t offset;	/* offset into region, in bytes, page-aligned */
+	size_t len;	/* length forward from offset, in bytes, page-aligned */
 };
 
 #define __ASHMEMIOC		0x77
-- 
1.7.9.5

