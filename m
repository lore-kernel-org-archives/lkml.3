Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3LQH3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:29:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23026 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab3LQH3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:29:04 -0500
Date: Tue, 17 Dec 2013 10:28:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, devel@linuxdriverproject.org,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v3 1/2] mfd: rtsx: reduce code duplication in rtl8411
Message-ID: <20131217072842.GZ28413@mwanda>
References: <cover.1387246693.git.micky_ching@realsil.com.cn>
 <4dbd7d35c3e2201a77357155f6610abda69a3139.1387246693.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dbd7d35c3e2201a77357155f6610abda69a3139.1387246693.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:36:58AM +0800, micky_ching@realsil.com.cn wrote:
> diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
> index 947e79b..26b52ec 100644
> --- a/drivers/mfd/rtsx_pcr.h
> +++ b/drivers/mfd/rtsx_pcr.h
> @@ -63,4 +63,12 @@ static inline u8 map_sd_drive(int idx)
>  #define rtl8411_reg_to_sd30_drive_sel_3v3(reg)	(((reg) >> 5) & 0x07)
>  #define rtl8411b_reg_to_sd30_drive_sel_3v3(reg)	((reg) & 0x03)
>  
> +#define set_pull_ctrl_tables(__device)				\
> +do {								\
> +	pcr->sd_pull_ctl_enable_tbl  = __device##_sd_pull_ctl_enable_tbl;  \
> +	pcr->sd_pull_ctl_disable_tbl = __device##_sd_pull_ctl_disable_tbl; \
> +	pcr->ms_pull_ctl_enable_tbl  = __device##_ms_pull_ctl_enable_tbl;  \
> +	pcr->ms_pull_ctl_disable_tbl = __device##_ms_pull_ctl_disable_tbl; \
> +} while (0)
> +
>  #endif

This is nasty...  With readable code, you should understand just from
looking at it what the code is doing but this obscures it completely.
It shouldn't reference the "pcr" variable without passing it in as an
argument but even with that cleanup I don't really like it.

To be honest, I don't see the problem with the original code.

regards,
dan carpenter
