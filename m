Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244AbaJDAyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:54:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbaJCVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Cooper <alcooperx@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 3.16 027/357] of: Allow mem_reserve of memory with a base address of zero
Date: Fri,  3 Oct 2014 14:26:53 -0700
Message-Id: <20141003212934.285420425@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Cooper <alcooperx@gmail.com>

commit b5f2a8c02697c3685ccbbb66495465742ffa0dc1 upstream.

__reserved_mem_reserve_reg() won't reserve memory if the base address
is zero. This change removes the check for a base address of zero and
allows it to be reserved.

Allowing the first 4K of memory to be reserved will help solve a
problem on some ARM systems where the the first 16K of memory is
unused and becomes allocable memory. This will prevent this memory
from being used for DMA by drivers like the USB OHCI driver which
consider a physical address of zero to be illegal.

Signed-off-by: Al Cooper <alcooperx@gmail.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/of/fdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -453,7 +453,7 @@ static int __init __reserved_mem_reserve
 		base = dt_mem_next_cell(dt_root_addr_cells, &prop);
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
-		if (base && size &&
+		if (size &&
 		    early_init_dt_reserve_memory_arch(base, size, nomap) == 0)
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %ld MiB\n",
 				uname, &base, (unsigned long)size / SZ_1M);


