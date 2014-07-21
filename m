Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750862AbaGUWqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:46:19 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42844 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGUWqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:46:17 -0400
Date: Mon, 21 Jul 2014 15:46:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "liwanp@linux.vnet.ibm.com" <liwanp@linux.vnet.ibm.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Wulizhen (Pss)" <pss.wulizhen@huawei.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_mm=EF=BC=9Abugfix=2C_pfn=5Fvalid_sometimes_return_incorrect_when_memmap_parameter_specified?=
In-Reply-To: <615092B2FD0E7648B6E4B43E029BCFB852D66798@SZXEMA503-MBS.china.huawei.com>
Message-ID: <alpine.DEB.2.02.1407211544280.29389@chino.kir.corp.google.com>
References: <615092B2FD0E7648B6E4B43E029BCFB852D66798@SZXEMA503-MBS.china.huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2014, Huangpeng (Peter) wrote:

> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 835aa3d..c54284b 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1199,7 +1199,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
>  #ifndef CONFIG_HAVE_ARCH_PFN_VALID
>  static inline int pfn_valid(unsigned long pfn)
>  {
> - if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
> + if (pfn >= max_pfn || pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
>   return 0;
>   return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
>  }

Why should valid_section() return non-zero for sparsemem if it is above 
max_pfn?  (I think you're modifying the wrong function.)

Your patch is also whitespace damaged and cannot be applied, please see 
Documentation/SubmittingPatches which also references 
Documentation/email-clients.txt.

> diff --git a/mm/nobootmem.c b/mm/nobootmem.c
> index 04a9d94..7eb273e 100644
> --- a/mm/nobootmem.c
> +++ b/mm/nobootmem.c
> @@ -31,7 +31,7 @@ EXPORT_SYMBOL(contig_page_data);
>  unsigned long max_low_pfn;
>  unsigned long min_low_pfn;
>  unsigned long max_pfn;
> -
> +EXPORT_SYMBOL(max_pfn);
>  static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
>   u64 goal, u64 limit)
>  {

This is an unrelated change.
