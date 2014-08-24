Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaHXSVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 14:21:50 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33452 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaHXSVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 14:21:48 -0400
MIME-Version: 1.0
In-Reply-To: <1408818808-18850-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
	<1408818808-18850-7-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 24 Aug 2014 20:21:46 +0200
X-Google-Sender-Auth: E-c_EdCK2P_Bx4rzzz6Qtzf_bJ0
Message-ID: <CAMuHMdVERt9XBN5OW8QqT_PvQVHd6xgnCdjRpiSNp7ZSEgXWSg@mail.gmail.com>
Subject: Re: [PATCH 6/7] video: fbdev: sis: delete double assignment
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Thomas Winischhofer <thomas@winischhofer.net>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 8:33 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> ---
> The patches in this series do not depend on each other.
>
> This changes the semantics of the code and is not tested.

Hence I think you should change the subject of the patch, so it's obvious
some bug is fixed, e.g. "video: fbdev: sis: Fix double assignment".

>  drivers/video/fbdev/sis/init301.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
> index a89e3ca..295e0de 100644
> --- a/drivers/video/fbdev/sis/init301.c
> +++ b/drivers/video/fbdev/sis/init301.c
> @@ -1714,7 +1714,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
>                                SiS_Pr->PanelVCLKIdx315 = VCLK81_315; /* ? */
>                             } else {
>                                SiS_Pr->PanelHT   = 1688; SiS_Pr->PanelVT   =  802;
> -                              SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRS  =  112;
> +                              SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRE  =  112;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
