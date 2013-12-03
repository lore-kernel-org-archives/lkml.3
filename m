Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3LCKpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 05:45:15 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:49398 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3LCKpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 05:45:12 -0500
Date: Tue, 3 Dec 2013 10:45:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com
Subject: Re: [PATCH v2 2/3] mfd: rtsx: add card reader rtl8402
Message-ID: <20131203104507.GL11828@lee--X1>
References: <cover.1386051860.git.micky_ching@realsil.com.cn>
 <39b168dd315f3b2645d92af29e5ad71789853317.1386051860.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <39b168dd315f3b2645d92af29e5ad71789853317.1386051860.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Add card reader rtl8042, rtl8402 is much like rtl8411, so just add it to
> rtl8411.c
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I have never signed this patch off.

These tags actually 'mean' something. Please don't apply them willy-nilly!

> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/rtl8411.c  |   33 +++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.c |    5 +++++
>  drivers/mfd/rtsx_pcr.h |    1 +
>  3 files changed, 39 insertions(+)
> 
> diff --git a/drivers/mfd/rtl8411.c b/drivers/mfd/rtl8411.c
> index c9eab9d..4b377e3 100644
> --- a/drivers/mfd/rtl8411.c
> +++ b/drivers/mfd/rtl8411.c
> @@ -216,6 +216,31 @@ static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
>  	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
>  }
>  
> +static int rtl8402_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
> +{
> +	u8 mask, val;
> +	int err;
> +
> +	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_MASK;
> +	if (voltage == OUTPUT_3V3) {
> +		err = rtsx_pci_write_register(pcr,
> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
> +		if (err < 0)
> +			return err;
> +		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_3V3;
> +	} else if (voltage == OUTPUT_1V8) {
> +		err = rtsx_pci_write_register(pcr,
> +				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
> +		if (err < 0)
> +			return err;
> +		val = (BPP_ASIC_2V0 << BPP_TUNED18_SHIFT_8402) | BPP_PAD_1V8;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return rtsx_pci_write_register(pcr, LDO_CTL, mask, val);
> +}
> +

I opposed this on last submission.

Please find a better way to do it.

Ideally, I'd like to see one function for this kind of thing. The
information required to ensure this is carried out correctly on each
differing platform can be passed in via a struct instead.

<snip>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
