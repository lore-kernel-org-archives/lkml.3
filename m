Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab3FRInF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:43:05 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:43269 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab3FRInD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:43:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130618154515.828365d615bbe6b93169e706@canb.auug.org.au>
References: <20130618154515.828365d615bbe6b93169e706@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 18 Jun 2013 09:42:42 +0100
X-Google-Sender-Auth: 2aFzzwjBIPgic_rVwOac8Qqx8-o
Message-ID: <CACxGe6soHMDvt+bG=m+_A5qwxqXjcgr8jORoPJwMHeHAr8__ig@mail.gmail.com>
Subject: Re: linux-next: manual merge of the irqdomain tree with the tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 6:45 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> Today's linux-next merge of the irqdomain tree got a conflict in
> kernel/irq/irqdomain.c between commit c5cdc67a58a2 ("irqdomain: Remove
> temporary MIPS workaround code") from the mips tree and commit
> bd4641e31e90 ("irq: fix checkpatch error") from the irqdomain tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks Stephen.

g.

>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc kernel/irq/irqdomain.c
> index a341b3d,13f2654..0000000
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@@ -665,8 -475,20 +475,8 @@@ unsigned int irq_create_of_mapping(stru
>
>         domain = controller ? irq_find_host(controller) : irq_default_domain;
>         if (!domain) {
> -               pr_warning("no irq domain found for %s !\n",
> -                          of_node_full_name(controller));
>  -#ifdef CONFIG_MIPS
>  -              /*
>  -               * Workaround to avoid breaking interrupt controller drivers
>  -               * that don't yet register an irq_domain.  This is temporary
>  -               * code. ~~~gcl, Feb 24, 2012
>  -               *
>  -               * Scheduled for removal in Linux v3.6.  That should be enough
>  -               * time.
>  -               */
>  -              if (intsize > 0)
>  -                      return intspec[0];
>  -#endif
> +               pr_warn("no irq domain found for %s !\n",
> +                       of_node_full_name(controller));
>                 return 0;
>         }
>
