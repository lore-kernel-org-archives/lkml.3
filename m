Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbbA2BLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:11:25 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53721 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbA2BLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:11:18 -0500
Date: Thu, 29 Jan 2015 00:43:17 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vitor Braga <vitorpybraga@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Thomas Gummerer <t.gummerer@gmail.com>,
        Brian Vandre <bvandre@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: xgifb: XGI_main_26: Change variables that is
 never used
Message-ID: <20150128224317.GC591@fuloong-minipc.musicnaut.iki.fi>
References: <1422481087-30938-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422481087-30938-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 28, 2015 at 10:38:07PM +0100, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> Instead use the struct variable of the same name.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/xgifb/XGI_main_26.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
> index 709d49e..ecfdf34 100644
> --- a/drivers/staging/xgifb/XGI_main_26.c
> +++ b/drivers/staging/xgifb/XGI_main_26.c
> @@ -1233,7 +1233,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>  	unsigned int vtotal = 0;
>  	unsigned int drate = 0, hrate = 0;
>  	int found_mode = 0;
> -	int refresh_rate, search_idx;
> +	int search_idx;
>  
>  	if ((var->vmode & FB_VMODE_MASK) == FB_VMODE_NONINTERLACED) {
>  		vtotal = var->upper_margin + var->yres + var->lower_margin
> @@ -1271,7 +1271,7 @@ static int XGIfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>  
>  	/* Calculation wrong for 1024x600 - force it to 60Hz */
>  	if ((var->xres == 1024) && (var->yres == 600))
> -		refresh_rate = 60;
> +		xgifb_info->refresh_rate = 60;

You are changing behaviour here. Did you test it, is it fixing something?
Otherwise you could just delete the whole if block...

A.
