Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031519Ab3HIXN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:13:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031447Ab3HIXN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:13:58 -0400
Date: Fri, 9 Aug 2013 16:13:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genalloc: fix overflow of ending address of memory
 chunk
Message-Id: <20130809161357.5a1d5c0ff6f5bedb8a66be86@linux-foundation.org>
In-Reply-To: <1375853178-12046-1-git-send-email-jy0922.shim@samsung.com>
References: <1375853178-12046-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Aug 2013 14:26:18 +0900 Joonyoung Shim <jy0922.shim@samsung.com> wrote:

> In struct gen_pool_chunk, end_addr means ending address of memory chunk,
> but actually it is starting address + size of memory chunk in codes, so
> it points the address increased one instead of correct ending address.
> 
> The ending address of memory chunk increased one will cause overflow on
> the case to use memory chunk including last address of memory map, e.g.
> when starting address is 0xFFF00000 and size is 0x100000 on 32bit
> machine, ending address will be 0x100000000.
> 
> Use correct ending address like starting address + size - 1.

This might help:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix

add comment to struct gen_pool_chunk:end_addr

Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/genalloc.c~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix lib/genalloc.c
diff -puN include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix
+++ a/include/linux/genalloc.h
@@ -66,8 +66,8 @@ struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
 	atomic_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
-	unsigned long start_addr;	/* starting address of memory chunk */
-	unsigned long end_addr;		/* ending address of memory chunk */
+	unsigned long start_addr;	/* start address of memory chunk */
+	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
_

