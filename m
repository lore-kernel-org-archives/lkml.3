Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaDDM1B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:27:01 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61211 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaDDM0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:26:38 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 2/5] efi: create memory map iteration helper
Date: Fri,  4 Apr 2014 13:25:47 +0100
Message-Id: <1396614350-20889-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
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
index 6c100ff..82d0abb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -863,6 +863,12 @@ extern int efi_set_rtc_mmss(const struct timespec *now);
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

