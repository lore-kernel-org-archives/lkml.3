Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaBGVEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:04:51 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:62556 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaBGVEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:04:50 -0500
Date: Fri, 7 Feb 2014 13:04:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rashika Kheria <rashika.kheria@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        josh@joshtriplett.org
Subject: Re: [PATCH 9/9] mm: Remove ifdef condition in include/linux/mm.h
In-Reply-To: <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
Message-ID: <alpine.DEB.2.02.1402071304080.4212@chino.kir.corp.google.com>
References: <a7658fc8f2ab015bffe83de1448cc3db79d2a9fc.1391167128.git.rashika.kheria@gmail.com> <63adb3b97f2869d4c7e76d17ef4aa76b8cf599f3.1391167128.git.rashika.kheria@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Rashika Kheria wrote:

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1cedd00..5f8348f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1589,10 +1589,8 @@ static inline int __early_pfn_to_nid(unsigned long pfn)
>  #else
>  /* please see mm/page_alloc.c */
>  extern int __meminit early_pfn_to_nid(unsigned long pfn);
> -#ifdef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>  /* there is a per-arch backend function. */
>  extern int __meminit __early_pfn_to_nid(unsigned long pfn);
> -#endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
>  #endif
>  
>  extern void set_dma_reserve(unsigned long new_dma_reserve);

Wouldn't it be better to just declare the __early_pfn_to_nid() in 
mm/page_alloc.c to be static?
