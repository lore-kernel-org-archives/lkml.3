Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaE2ANd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 20:13:33 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35179 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaE2ANc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 20:13:32 -0400
Date: Thu, 29 May 2014 09:13:28 +0900
From: Simon Horman <horms@verge.net.au>
To: Liu Hua <sdu.liu@huawei.com>
Cc: ebiederm@xmission.com, wangnan0@huawei.com, peifeiyue@huawei.com,
        liusdu@126.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, hui.geng@huawei.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com
Subject: Re: [RESEND PATCH] kexec : add sparse memory related values to vmcore
Message-ID: <20140529001328.GD22705@verge.net.au>
References: <1401284996-44873-1-git-send-email-sdu.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401284996-44873-1-git-send-email-sdu.liu@huawei.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 09:49:56PM +0800, Liu Hua wrote:
> This patch deales with sparse memory model.
> 
> For ARM32 platforms, different vendors may define different
> SECTION_SIZE_BITS, which we did not write to vmcore.
> 
> For example:
> 
>   1 arch/arm/mach-clps711x/include/mach/memory.h
>     #define SECTION_SIZE_BITS 24
>   2 arch/arm/mach-exynos/include/mach/memory.h
>     #define SECTION_SIZE_BITS 28
>   3 arch/arm/mach-sa1100/include/mach/memory.h
>     #define SECTION_SIZE_BITS 27

I wonder if this problem will eventually go away, or at least only
apply to older platforms, as ARM moves towards multiplatform: a single
kernel for more than one platform.

> It is really a bad news for user space tools such as
> makedumpfile and crash, who have to defines them as
> macros. So for the same architecture, we may need to
> recomile them to parse vmcores with different
> SECTION_SIZE_BITS.
> 
> And if we enable LPAE, MAX_PHYSMEM_SIZE can alse
> be variable.
> 
> This patch adds these SECTION_SIZE_BITS and MAX_PHYSMEM_SIZE
> to vmcore. which makes user space tools more compatible.
> 
> BTW, makedumpfile has queued the related patch.
> 
> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
> ---
>  kernel/kexec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index bf0b929e..8b1a193 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1577,6 +1577,8 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_LENGTH(mem_section, NR_SECTION_ROOTS);
>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
> +	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
> +	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
>  #endif
>  	VMCOREINFO_STRUCT_SIZE(page);
>  	VMCOREINFO_STRUCT_SIZE(pglist_data);
> -- 
> 1.9.0
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
