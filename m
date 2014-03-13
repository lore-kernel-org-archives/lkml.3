Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaCMWsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:48:13 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58763 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaCMWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:48:05 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, catalin.marinas@arm.com,
        matt.fleming@intel.com
Cc: msalter@redhat.com, roy.franz@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 03/15] efi: create memory map iteration helper
Date: Thu, 13 Mar 2014 22:46:56 +0000
Message-Id: <1394750828-16351-4-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

There are a lot of places in the kernel which iterate through an
EFI memory map. Most of these places use essentially the same
for-loop code. This patch adds a for_each_efi_memory_desc()
helper to clean up all of the existing duplicate code and avoid
more in the future.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 include/linux/efi.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 64d532c..a3276da 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -622,6 +622,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern struct efi_memory_map memmap;
 
+/* Iterate through an efi_memory_map */
+#define for_each_efi_memory_desc(m, md)					   \
+	for ((md) = (m)->map;						   \
+	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
+	     (md) = (void *)(md) + (m)->desc_size)
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.7.10.4

