Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab3BZNyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 08:54:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14543 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3BZNyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 08:54:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 26 Feb 2013 05:52:46 -0800
Message-ID: <512CBE50.4050206@nvidia.com>
Date: Tue, 26 Feb 2013 19:23:20 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2 2/2] mfd: palmas add variant and OTP detection
References: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk> <1361637341-22214-2-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361637341-22214-2-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 February 2013 10:05 PM, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>
> Read the chip varient and the OTP information from the chip and display
> this on probe to aid in debugging of issues.
>
> Older palmas chips do not have the USB_ID programmed and will therefore
> return 0x0000 for this field.

> +
>   	/* Change IRQ into clear on read mode for efficiency */
>   	slave = PALMAS_BASE_TO_SLAVE(PALMAS_INTERRUPT_BASE);
> -	addr = PALMAS_BASE_TO_REG(PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL);
>   	reg = PALMAS_INT_CTRL_INT_CLEAR;
>   
> -	regmap_write(palmas->regmap[slave], addr, reg);
> +	ret = palmas_write(palmas, PALMAS_INTERRUPT_BASE, PALMAS_INT_CTRL, reg);
>   

I think this is unrelated change and can be on another patch.

>   	
> -	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
> -	addr = PALMAS_BASE_TO_REG(PALMAS_PU_PD_OD_BASE,
> -			PALMAS_PRIMARY_SECONDARY_PAD1);
> -
>   	if (pdata->mux_from_pdata) {
>   		reg = pdata->pad1;
> -		ret = regmap_write(palmas->regmap[slave], addr, reg);
> +		ret = palmas_write(palmas, PALMAS_PU_PD_OD_BASE,
> +				PALMAS_PRIMARY_SECONDARY_PAD1, reg);

Same, in another patch and elsewhere which was part of cleanups.


otherwise it looks good.

