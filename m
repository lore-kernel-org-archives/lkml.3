Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3FWTOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:14:38 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64812 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab3FWTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:14:37 -0400
MIME-Version: 1.0
In-Reply-To: <1372009427.3137.54.camel@joe-AO722>
References: <20130621153331.2881.35589.stgit@bling.home>
	<20130623114930.GA2557@8bytes.org>
	<1372009427.3137.54.camel@joe-AO722>
Date: Sun, 23 Jun 2013 21:14:36 +0200
X-Google-Sender-Auth: YJ_0CffDbq7FQdkLDAUvIgjTmPc
Message-ID: <CAMuHMdWb4WK9ZuJ-vwdywgDSSbZTnnS1emF02VzrUgrSt5VKsg@mail.gmail.com>
Subject: Re: [PATCH] iommu: Use %zx instead %lx and cast to unsigned long
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 7:43 PM, Joe Perches <joe@perches.com> wrote:
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -807,20 +807,19 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
>          * size of the smallest page supported by the hardware
>          */
>         if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
> -               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%lx min_pagesz "
> -                       "0x%x\n", iova, (unsigned long)paddr,
> -                       (unsigned long)size, min_pagesz);
> +               pr_err("unaligned: iova 0x%lx pa 0x%lx size 0x%zx min_pagesz 0x%x\n",
> +                      iova, (unsigned long)paddr, size, min_pagesz);

While we're at it, paddr is phys_addr_t (which can be 32-bit or 64-bit),
so it should be cast to unsigned long long (instead of unsigned long),
and printed using %llx (instead of %lx).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
