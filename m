Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaBTAuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:50:21 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49138 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaBTAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:50:19 -0500
Date: Wed, 19 Feb 2014 19:50:17 -0500 (EST)
Message-Id: <20140219.195017.88959684259741556.davem@davemloft.net>
To: paul.gortmaker@windriver.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: make copy_to/from_user_page() usable from
 modular code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com>
References: <1392326101-20388-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2014 16:50:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 13 Feb 2014 16:15:01 -0500

> While copy_to/from_user_page() users are uncommon, there is one in
> drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c which leads
> to the following:
> 
> ERROR: "sparc32_cachetlb_ops" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!
> 
> during routine allmodconfig build coverage.  The reason this happens
> is as follows:
> 
> In arch/sparc/include/asm/cacheflush_32.h we have:
> 
>  #define flush_cache_page(vma,addr,pfn) \
>         sparc32_cachetlb_ops->cache_page(vma, addr)
> 
>  #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
>         do {                                                    \
>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>                 memcpy(dst, src, len);                          \
>         } while (0)
>  #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
>         do {                                                    \
>                 flush_cache_page(vma, vaddr, page_to_pfn(page));\
>                 memcpy(dst, src, len);                          \
>         } while (0)
> 
> However, sparc32_cachetlb_ops isn't exported and hence the error.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Also applied.
