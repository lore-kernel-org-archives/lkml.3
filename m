Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbbARMc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:32:59 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:54002 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbARMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:32:56 -0500
Date: Sun, 18 Jan 2015 12:32:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 05/10] mfd: rtsx: update driving settings
Message-ID: <20150118123251.GO3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <adc95118c4817747ad30383842ff484e67d39651.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adc95118c4817747ad30383842ff484e67d39651.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> update card drive settings, This setting can be used for rts5249
> rts524A and rts525A.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

There is no way for me to know if this is correct or not.

Code looks fine though, so:

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 225ad55..2fe2854 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -36,16 +36,16 @@ static u8 rts5249_get_ic_version(struct rtsx_pcr *pcr)
>  static void rts5249_fill_driving(struct rtsx_pcr *pcr, u8 voltage)
>  {
>  	u8 driving_3v3[4][3] = {
> -		{0x11, 0x11, 0x11},
> +		{0x11, 0x11, 0x18},
>  		{0x55, 0x55, 0x5C},
> -		{0x99, 0x99, 0x92},
> -		{0x99, 0x99, 0x92},
> +		{0xFF, 0xFF, 0xFF},
> +		{0x96, 0x96, 0x96},
>  	};
>  	u8 driving_1v8[4][3] = {
> +		{0xC4, 0xC4, 0xC4},
>  		{0x3C, 0x3C, 0x3C},
> -		{0xB3, 0xB3, 0xB3},
>  		{0xFE, 0xFE, 0xFE},
> -		{0xC4, 0xC4, 0xC4},
> +		{0xB3, 0xB3, 0xB3},
>  	};
>  	u8 (*driving)[3], drive_sel;
>  
> @@ -341,7 +341,7 @@ void rts5249_init_params(struct rtsx_pcr *pcr)
>  
>  	pcr->flags = 0;
>  	pcr->card_drive_sel = RTSX_CARD_DRIVE_DEFAULT;
> -	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_C;
> +	pcr->sd30_drive_sel_1v8 = CFG_DRIVER_TYPE_B;
>  	pcr->sd30_drive_sel_3v3 = CFG_DRIVER_TYPE_B;
>  	pcr->aspm_en = ASPM_L1_EN;
>  	pcr->tx_initial_phase = SET_CLOCK_PHASE(1, 29, 16);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
