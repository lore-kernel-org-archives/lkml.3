Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbbARMbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:31:24 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:50576 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbARMbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:31:23 -0500
Date: Sun, 18 Jan 2015 12:31:17 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH 04/10] mfd: rtsx: update PETXCFG address
Message-ID: <20150118123117.GN3574@x1>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
 <962a523f7376c5773c73a9c60991e2ebd775ccf2.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <962a523f7376c5773c73a9c60991e2ebd775ccf2.1421320541.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> PETXCFG is defined at 0xFF03, the old 0xFE49 not used any more.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rts5227.c        | 6 ++----
>  drivers/mfd/rts5249.c        | 6 ++----
>  include/linux/mfd/rtsx_pci.h | 2 +-
>  3 files changed, 5 insertions(+), 9 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
> index 3240740..1f387d4 100644
> --- a/drivers/mfd/rts5227.c
> +++ b/drivers/mfd/rts5227.c
> @@ -118,11 +118,9 @@ static int rts5227_extra_init_hw(struct rtsx_pcr *pcr)
>  	rts5227_fill_driving(pcr, OUTPUT_3V3);
>  	/* Configure force_clock_req */
>  	if (pcr->flags & PCR_REVERSE_SOCKET)
> -		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> -				AUTOLOAD_CFG_BASE + 3, 0xB8, 0xB8);
> +		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB8, 0xB8);
>  	else
> -		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> -				AUTOLOAD_CFG_BASE + 3, 0xB8, 0x88);
> +		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB8, 0x88);
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
>  
>  	return rtsx_pci_send_cmd(pcr, 100);
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index cf425cc..225ad55 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c
> @@ -116,11 +116,9 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
>  	/* Configure driving */
>  	rts5249_fill_driving(pcr, OUTPUT_3V3);
>  	if (pcr->flags & PCR_REVERSE_SOCKET)
> -		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> -				AUTOLOAD_CFG_BASE + 3, 0xB0, 0xB0);
> +		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0xB0);
>  	else
> -		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD,
> -				AUTOLOAD_CFG_BASE + 3, 0xB0, 0x80);
> +		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0x80);
>  	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
>  
>  	return rtsx_pci_send_cmd(pcr, 100);
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index a680427..80baa10 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -572,7 +572,6 @@
>  #define MSGTXDATA2			0xFE46
>  #define MSGTXDATA3			0xFE47
>  #define MSGTXCTL			0xFE48
> -#define PETXCFG				0xFE49
>  #define LTR_CTL				0xFE4A
>  #define OBFF_CFG			0xFE4C
>  
> @@ -606,6 +605,7 @@
>  #define DUMMY_REG_RESET_0		0xFE90
>  
>  #define AUTOLOAD_CFG_BASE		0xFF00
> +#define PETXCFG				0xFF03
>  
>  #define PM_CTRL1			0xFF44
>  #define PM_CTRL2			0xFF45

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
