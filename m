Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab3FZPAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:00:14 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39271 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3FZPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <1372189326-12230-2-git-send-email-geert@linux-m68k.org>
References: <1372189326-12230-1-git-send-email-geert@linux-m68k.org>
	<1372189326-12230-2-git-send-email-geert@linux-m68k.org>
Date: Wed, 26 Jun 2013 17:00:09 +0200
X-Google-Sender-Auth: wcGn0adwRATq2zM-PzULaF8SCo8
Message-ID: <CAMuHMdUuxvaMJP6rL6HgrPix+asx7acCfA=mZV_CFki5r103hw@mail.gmail.com>
Subject: Re: [PATCH 2/2] m68k/sun3: Dynamically allocate the table to track
 IOMMU use
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Creasey <sammy@sammy.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:42 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> -static unsigned long iommu_use[IOMMU_TOTAL_ENTRIES];
> +static unsigned long *iommu_use;
>
>  #define dvma_index(baddr) ((baddr - DVMA_START) >> DVMA_PAGE_SHIFT)
>
> @@ -266,6 +267,7 @@ void __init dvma_init(void)
>
>         list_add(&(hole->list), &hole_list);
>
> +       iommu_use = alloc_bootmem(IOMMU_TOTAL_ENTRIES * sizeof(unsigned long));
>         memset(iommu_use, 0, sizeof(iommu_use));

Bummer, the sizeof in the above line is no longer valid.
As the bootmem allocator zeroes memory, the line can just be removed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
