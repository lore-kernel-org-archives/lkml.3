Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbbAST00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:26:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50530 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbbAST0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:26:23 -0500
Date: Mon, 19 Jan 2015 20:26:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/3 v2] Fix kdump failures with crashkernel=high
Message-ID: <20150119192616.GB4398@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420555874-11506-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some more people to CC.

On Tue, Jan 06, 2015 at 03:51:11PM +0100, Joerg Roedel wrote:
> v1->v2:
> 
> * Updated comments based on feedback from Konrad
> * Added Acked-bys
> * Rebased to v3.19-rc3
> 
> Hi,
> 
> here is a patch-set to fix failed kdump kernel boots when
> the systems was booted with crashkernel=X,high. On those
> systems the kernel allocates only 72MiB of low-memory for
> DMA buffers, which showed to be too low on some systems.
> 
> The problem is that 64MiB of the low-memory is allocated by
> swiotlb, leaving 8MB for the page-allocator. But swiotlb
> tries to allocate DMA memory from the page-allocator first,
> which fails pretty fast in the boot sequence, causing
> warnings. This patch-set removes these warnings.
> 
> But even the 64MiB for swiotlb are eaten up on some systems,
> so that the default of low-memory allocated for the
> crash-kernel is increase from 72MB to 256MB (only changing
> the defaults, can still be overwritten by crashkernel=X,low).
> 
> This number comes from experiments on the affected systems,
> 128MiB low-memory was still not enough there, thus I set the
> value to 256MiB to fix the issues.
> 
> Any feedback appreciated.
> 
> Thanks,
> 
> 	Joerg
> 
> Joerg Roedel (3):
>   swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
>   x86, swiotlb: Try coherent allocations with __GFP_NOWARN
>   x86, crash: Allocate enough low-mem when crashkernel=high
> 
>  arch/x86/kernel/pci-swiotlb.c |  8 ++++++++
>  arch/x86/kernel/setup.c       |  5 ++++-
>  lib/swiotlb.c                 | 11 +++++++++--
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> -- 
> 1.9.1
> 
> Joerg Roedel (3):
>   swiotlb: Warn on allocation failure in swiotlb_alloc_coherent
>   x86, swiotlb: Try coherent allocations with __GFP_NOWARN
>   x86, crash: Allocate enough low-mem when crashkernel=high
> 
>  arch/x86/kernel/pci-swiotlb.c |  8 ++++++++
>  arch/x86/kernel/setup.c       |  5 ++++-
>  lib/swiotlb.c                 | 11 +++++++++--
>  3 files changed, 21 insertions(+), 3 deletions(-)
> 
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
