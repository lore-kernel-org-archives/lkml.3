Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaGFKXH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 06:23:07 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:45809 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaGFKXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 06:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <1404602638-16447-1-git-send-email-emilgoode@gmail.com>
References: <1404602638-16447-1-git-send-email-emilgoode@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 6 Jul 2014 12:22:25 +0200
Message-ID: <CAOiHx==kyY9ce5jjv5m36OXpG9Vk4NsPa9m+nfWuYWjxOnMisA@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Remove incorrect NULL check in local_flush_tlb_page()
To: Emil Goode <emilgoode@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2014 at 1:23 AM, Emil Goode <emilgoode@gmail.com> wrote:
> We check that the struct vm_area_struct pointer vma is NULL and then
> dereference it a few lines below. The intent was to make sure vma is
> not NULL but this is not necessary since the bug pre-dates GIT history
> and seem to never have caused a problem. The tlb-4k and tlb-8k versions
> of local_flush_tlb_page() don't bother checking if vma is NULL, also
> vma is dereferenced before being passed to local_flush_tlb_page(),
> thus it is safe to remove this NULL check.
>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>

Looks good.

Reviewed-by: Jonas Gorski <jogo@openwrt.org>

> ---
>  arch/mips/mm/tlb-r3k.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
> index d657493..4094bbd 100644
> --- a/arch/mips/mm/tlb-r3k.c
> +++ b/arch/mips/mm/tlb-r3k.c
> @@ -158,7 +158,7 @@ void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
>  {
>         int cpu = smp_processor_id();
>
> -       if (!vma || cpu_context(cpu, vma->vm_mm) != 0) {
> +       if (cpu_context(cpu, vma->vm_mm) != 0) {
>                 unsigned long flags;
>                 int oldpid, newpid, idx;
>
> --
> 1.7.10.4
>
>
