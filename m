Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaLHJ5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:57:54 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:44295 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbaLHJ5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:57:52 -0500
Date: Mon, 8 Dec 2014 09:57:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, chris@printf.net, ulf.hansson@linaro.org,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, rogerable@realtek.com,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH v4 1/6] mfd: rtsx: add func to split u32 into register
Message-ID: <20141208095746.GG3951@x1>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
 <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17ba65f4bdf4707bdf038e407ecf5dc012bca281.1417758564.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Dec 2014, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Add helper function to write u32 to registers, if we want to put u32
> value to 4 continuous register, this can help us reduce tedious work.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/rtsx_pci.h | 9 +++++++++
>  1 file changed, 9 insertions(+)

Applied, thanks.

> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index 74346d5..9234449 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -558,6 +558,7 @@
>  #define SD_SAMPLE_POINT_CTL		0xFDA7
>  #define SD_PUSH_POINT_CTL		0xFDA8
>  #define SD_CMD0				0xFDA9
> +#define   SD_CMD_START			0x40
>  #define SD_CMD1				0xFDAA
>  #define SD_CMD2				0xFDAB
>  #define SD_CMD3				0xFDAC
> @@ -967,4 +968,12 @@ static inline u8 *rtsx_pci_get_cmd_data(struct rtsx_pcr *pcr)
>  	return (u8 *)(pcr->host_cmds_ptr);
>  }
>  
> +static inline void rtsx_pci_write_be32(struct rtsx_pcr *pcr, u16 reg, u32 val)
> +{
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg,     0xFF, val >> 24);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 1, 0xFF, val >> 16);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 2, 0xFF, val >> 8);
> +	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, reg + 3, 0xFF, val);
> +}
> +
>  #endif

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
