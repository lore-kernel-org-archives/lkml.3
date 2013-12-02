Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab3LBUGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:06:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3LBTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3.12 090/212] ioatdma: Fix bug in selftest after removal of DMA_MEMSET.
Date: Mon,  2 Dec 2013 11:14:41 -0800
Message-Id: <20131202191257.614474756@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

commit ac7d631f7d9f9e4e6116c4a72b6308067d0a2226 upstream.

Commit 48a9db4 (3.11) removed the memset op in the xor selftest for ioatdma.
The issue is that with the removal of that op, it never replaced the memset
with a CPU memset. The memory being operated on is expected to be zeroes but
was not. This is causing the xor selftest to fail.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/ioat/dma_v3.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1545,6 +1545,8 @@ static int ioat_xor_val_self_test(struct
 		goto free_resources;
 	}
 
+	memset(page_address(dest), 0, PAGE_SIZE);
+
 	/* test for non-zero parity sum */
 	op = IOAT_OP_XOR_VAL;
 


