Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaIHOak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:30:40 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46215 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaIHOai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:30:38 -0400
Message-ID: <540DBD62.5040605@oracle.com>
Date: Mon, 08 Sep 2014 10:29:54 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: "mm: introduce dump_vma fix 2" still broken
References: <2815658.dHHBXc7oHP@wuerfel>
In-Reply-To: <2815658.dHHBXc7oHP@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2014 07:02 AM, Arnd Bergmann wrote:
> 
> I saw this commit today in linux-next, which fixes a build error, but introduces
> a new warning:
> 
> commit a60224c708f880dd937b352b7461cbf14e93012d
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Mon Sep 8 19:41:54 2014 +1000
> 
>     mm: introduce dump_vma fix 2
>     
>     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cb510c08073b..0de60769bcf6 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6739,7 +6739,7 @@ void dump_vma(const struct vm_area_struct *vma)
>                 "prot %lx anon_vma %p vm_ops %p\n"
>                 "pgoff %lx file %p private_data %p\n",
>                 vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_next,
> -               vma->vm_prev, vma->vm_mm, vma->vm_page_prot.pgprot,
> +               vma->vm_prev, vma->vm_mm, pgprot_val(vma->vm_page_prot),
>                 vma->anon_vma, vma->vm_ops, vma->vm_pgoff,
>                 vma->vm_file, vma->vm_private_data);
>         dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
> 
> 
> /git/arm-soc/mm/page_alloc.c: In function 'dump_vma':
> /git/arm-soc/mm/page_alloc.c:6744:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 8 has type 'pgprot_t' [-Wformat=]
>    vma->vm_file, vma->vm_private_data);
>    ^
> 
> This happens on machines that use ARM LPAE, where pgprot_t is in fact
> a 64-bit integer. The simplest fix I see would be add a cast to u64
> and always print this as a 64bit value.

Hi Arnd,

The fix for the original issue would be:

	http://ozlabs.org/~akpm/mmots/broken-out/introduce-dump_vma-fix-2.patch

Which includes the casting that Stephen's patch didn't have.

Stephen, in the future, is there a way to get build fixes faster to you? From
what I understand -mm syncs up only once in a couple of days. It might make
everyone’s life much easier if build errors wouldn't drag over a week.


Thanks,
Sasha
