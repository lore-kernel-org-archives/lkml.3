Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaGGOFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:05:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaGGOFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:05:07 -0400
Date: Mon, 7 Jul 2014 10:04:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: fbdev: aty: atyfb_base.c:  Cleaning up variable
 that is never used
In-Reply-To: <1404671093-17590-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Message-ID: <alpine.LRH.2.02.1407071004060.9534@file01.intranet.prod.int.rdu2.redhat.com>
References: <1404671093-17590-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2014, Rickard Strandqvist wrote:

> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/video/fbdev/aty/atyfb_base.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/video/fbdev/aty/atyfb_base.c b/drivers/video/fbdev/aty/atyfb_base.c
> index c3d0074..46188a4 100644
> --- a/drivers/video/fbdev/aty/atyfb_base.c
> +++ b/drivers/video/fbdev/aty/atyfb_base.c
> @@ -3088,7 +3088,6 @@ static int atyfb_setup_sparc(struct pci_dev *pdev, struct fb_info *info,
>  	if (dp == of_console_device) {
>  		struct fb_var_screeninfo *var = &default_var;
>  		unsigned int N, P, Q, M, T, R;
> -		u32 v_total, h_total;
>  		struct crtc crtc;
>  		u8 pll_regs[16];
>  		u8 clock_cntl;
> @@ -3104,9 +3103,6 @@ static int atyfb_setup_sparc(struct pci_dev *pdev, struct fb_info *info,
>  		crtc.gen_cntl = aty_ld_le32(CRTC_GEN_CNTL, par);
>  		aty_crtc_to_var(&crtc, var);
>  
> -		h_total = var->xres + var->right_margin + var->hsync_len + var->left_margin;
> -		v_total = var->yres + var->lower_margin + var->vsync_len + var->upper_margin;
> -
>  		/*
>  		 * Read the PLL to figure actual Refresh Rate.
>  		 */
> -- 
> 1.7.10.4
> 
