Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaIERAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:00:11 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60979 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaIERAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <1409926097-2101-5-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
	<1409926097-2101-5-git-send-email-bhe@redhat.com>
Date: Fri, 5 Sep 2014 10:00:08 -0700
X-Google-Sender-Auth: fYaXvto1Qo-b9_ZdnauyPIAY_yg
Message-ID: <CAGXu5jKbsosXC2VRedP4ykezbbDebkEXwaP4Cxxuoev259Bc1g@mail.gmail.com>
Subject: Re: [PATCH 4/4] export the kernel image size KERNEL_IMAGE_SIZE
From: Kees Cook <keescook@chromium.org>
To: Baoquan He <bhe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Chao <chaowang@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 7:08 AM, Baoquan He <bhe@redhat.com> wrote:
> Now kaslr makes kernel image size changable, not the fixed size 512M.
> So KERNEL_IMAGE_SIZE need be exported to VMCOREINFO, otherwise makedumfile
> will crash.

Seems like a good idea, yes.

>
> Signed-off-by: Baoquan He <bhe@redhat.com>
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
>         VMCOREINFO_NUMBER(PG_head_mask);
>         VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
> +#ifdef CONFIG_X86
> +       VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
> +#endif
>  #ifdef CONFIG_HUGETLBFS
>         VMCOREINFO_SYMBOL(free_huge_page);
>  #endif

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
