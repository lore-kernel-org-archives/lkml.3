Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaIITrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbaIITrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:47:14 -0400
Date: Tue, 9 Sep 2014 15:47:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, mingo@redhat.com,
        whissi@whissi.de, dyoung@redhat.com, tglx@linutronix.de,
        keescook@chromium.org, chaowang@redhat.com,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [PATCH 4/4] export the kernel image size KERNEL_IMAGE_SIZE
Message-ID: <20140909194704.GC20681@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-5-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409926097-2101-5-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 10:08:17PM +0800, Baoquan He wrote:
> Now kaslr makes kernel image size changable, not the fixed size 512M.
> So KERNEL_IMAGE_SIZE need be exported to VMCOREINFO, otherwise makedumfile
> will crash.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>

This one sounds reasonable. CCing Atshushi. 

Thanks
Vivek

> ---
>  kernel/kexec.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2bee072..bd680d3 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -2003,6 +2003,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>  #endif
>  	VMCOREINFO_NUMBER(PG_head_mask);
>  	VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
> +#ifdef CONFIG_X86
> +       VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
> +#endif
>  #ifdef CONFIG_HUGETLBFS
>  	VMCOREINFO_SYMBOL(free_huge_page);
>  #endif
> -- 
> 1.8.5.3
