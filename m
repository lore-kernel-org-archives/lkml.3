Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3LQIEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:04:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27321 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3LQIEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:04:05 -0500
Date: Tue, 17 Dec 2013 11:02:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, devel@linuxdriverproject.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v3 1/2] mfd: rtsx: reduce code duplication in rtl8411
Message-ID: <20131217080259.GA28413@mwanda>
References: <cover.1387246693.git.micky_ching@realsil.com.cn>
 <4dbd7d35c3e2201a77357155f6610abda69a3139.1387246693.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dbd7d35c3e2201a77357155f6610abda69a3139.1387246693.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:36:58AM +0800, micky_ching@realsil.com.cn wrote:
>  void rtl8411b_init_params(struct rtsx_pcr *pcr)
>  {
> -	pcr->extra_caps = EXTRA_CAPS_SD_SDR50 | EXTRA_CAPS_SD_SDR104;
> -	pcr->num_slots = 2;
> -	pcr->ops = &rtl8411b_pcr_ops;
> -
> -	pcr->flags = 0;
> -	pcr->card_drive_sel = RTL8411_CARD_DRIVE_DEFAULT;
> -	pcr->sd30_drive_sel_1v8 = DRIVER_TYPE_B;
> -	pcr->sd30_drive_sel_3v3 = DRIVER_TYPE_D;
> -	pcr->aspm_en = ASPM_L1_EN;
> -	pcr->tx_initial_phase = SET_CLOCK_PHASE(23, 7, 14);
> -	pcr->rx_initial_phase = SET_CLOCK_PHASE(4, 3, 10);
> +	rtl8411_init_params(pcr);
>  
> -	pcr->ic_version = rtl8411_get_ic_version(pcr);
> +	rtl8411_pcr_ops.fetch_vendor_settings =
> +		rtl8411b_fetch_vendor_settings;
> +	rtl8411_pcr_ops.extra_init_hw = rtl8411b_extra_init_hw;
>  

This is a bug here.  If we have both kinds of devices connected at the
same time then the kernel crashes.

Really structures which hold function pointers should be const.  This
code is not as good as the original.

regards,
dan carpenter

