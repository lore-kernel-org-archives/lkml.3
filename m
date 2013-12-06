Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062Ab3LFOXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:23:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab3LFM7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 010/272] ioatdma: Fix bug in selftest after removal of DMA_MEMSET.
Date: Fri,  6 Dec 2013 12:54:59 +0000
Message-Id: <1386334761-25517-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit ac7d631f7d9f9e4e6116c4a72b6308067d0a2226 upstream.

Commit 48a9db4 (3.11) removed the memset op in the xor selftest for ioatdma.
The issue is that with the removal of that op, it never replaced the memset
with a CPU memset. The memory being operated on is expected to be zeroes but
was not. This is causing the xor selftest to fail.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/ioat/dma_v3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index b642e03..dc4191c 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1545,6 +1545,8 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 		goto free_resources;
 	}
 
+	memset(page_address(dest), 0, PAGE_SIZE);
+
 	/* test for non-zero parity sum */
 	op = IOAT_OP_XOR_VAL;
 
-- 
1.8.3.2

