Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaLDLEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:04:08 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:61904 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaLDLEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <20141204110110.GD22643@mwanda>
References: <CAMuHMdVxCUYkaC5wzHi-o6knD6ugFudTdh3PJz5JCwv-std3GA@mail.gmail.com>
	<20141204110110.GD22643@mwanda>
Date: Thu, 4 Dec 2014 12:04:03 +0100
X-Google-Sender-Auth: oLIvijFvb5z6Imx5C68Mqim21xA
Message-ID: <CAMuHMdUhmx7WYDnTNHSk8uYYOQN+R9rgLHH_Fx_XdSKqOANO=A@mail.gmail.com>
Subject: Re: [patch] sh: off by one BUG_ON() in setup_bootmem_node()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 12:01 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This off by one bug is harmless but it upsets the static checkers and
> the code is obvious so it doesn't hurt to fix it.  The Smatch warning
> is:
>
>         arch/sh/mm/numa.c:47 setup_bootmem_node()
>         error: buffer overflow 'node_data' 1024 <= 1024
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

> diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
> index 3d85225..bce52ba 100644
> --- a/arch/sh/mm/numa.c
> +++ b/arch/sh/mm/numa.c
> @@ -31,7 +31,7 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
>         unsigned long bootmem_paddr;
>
>         /* Don't allow bogus node assignment */
> -       BUG_ON(nid > MAX_NUMNODES || nid <= 0);
> +       BUG_ON(nid >= MAX_NUMNODES || nid <= 0);
>
>         start_pfn = start >> PAGE_SHIFT;
>         end_pfn = end >> PAGE_SHIFT;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
