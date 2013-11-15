Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3KOC6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 21:58:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36923 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab3KOC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 21:58:27 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAF2vB7s031387, This message is accepted by code: ctloc85258
Message-ID: <52858DF6.7010800@realsil.com.cn>
Date: Fri, 15 Nov 2013 10:59:02 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>
CC: <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/4] mfd: rtsx: Generify the switch voltage routine
References: <1384421355-4434-1-git-send-email-lee.jones@linaro.org> <1384421355-4434-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1384421355-4434-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee

Thank you for your work.

Switch output voltage may have some problem here.
1. modify params of function in pcr_ops may affect other chips, like
rts52xx, and we may add other registers or value in the future, just
add params may not enough to handle this case. So I think different
chip should use a different function here, and modify the function
will not affect others.

2. rtl8402 has another difference with 8411 here, it doesn't use
  BPP_ASIC_1V8, but use BPP_ASIC_2V0.

so, I will send another patch to fix this problem.

> -static int rtl8411_switch_output_voltage(struct rtsx_pcr *pcr, u8 voltage)
> +static int rtl84xx_switch_output_voltage(struct rtsx_pcr *pcr,
> +					 u8 voltage, int shift)
>   {
>   	u8 mask, val;
>   	int err;
>   
> -	mask = (BPP_REG_TUNED18 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_MASK;
> +	mask = (BPP_REG_TUNED18 << shift) | BPP_PAD_MASK;
>   	if (voltage == OUTPUT_3V3) {
>   		err = rtsx_pci_write_register(pcr,
>   				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_3v3);
>   		if (err < 0)
>   			return err;
> -		val = (BPP_ASIC_3V3 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_3V3;
> +		val = (BPP_ASIC_3V3 << shift) | BPP_PAD_3V3;
>   	} else if (voltage == OUTPUT_1V8) {
>   		err = rtsx_pci_write_register(pcr,
>   				SD30_DRIVE_SEL, 0x07, pcr->sd30_drive_sel_1v8);
>   		if (err < 0)
>   			return err;
> -		val = (BPP_ASIC_1V8 << BPP_TUNED18_SHIFT_8411) | BPP_PAD_1V8;
> +		val = (BPP_ASIC_1V8 << shift) | BPP_PAD_1V8;
>   	} else {
>   		return -EINVAL;
>   	}


-- 
Best Regards
Micky.

