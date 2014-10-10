Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaJJKVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 06:21:16 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37945 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbaJJKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 06:21:10 -0400
Date: Fri, 10 Oct 2014 11:21:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: fix PM suspend for 5227 & 5249
Message-ID: <20141010102104.GK26795@lee--X1>
References: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412920724-27945-1-git-send-email-micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, micky_ching@realsil.com.cn wrote:

> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> Fix rts5227&5249 failed send buffer cmd after suspend,
> PM_CTRL3 should reset before send any buffer cmd after suspend.
> Otherwise, buffer cmd will failed, this will lead resume fail.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mfd/Makefile         |  2 +-
>  drivers/mfd/rts5227.c        |  6 ++++++
>  drivers/mfd/rts5249.c        |  4 ++++
>  drivers/mfd/rtsx_gops.c      | 37 +++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h       |  3 +++
>  include/linux/mfd/rtsx_pci.h | 28 ++++++++++++++++++++++++++++
>  6 files changed, 79 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/rtsx_gops.c

[...]

> +static inline int rtsx_pci_update_cfg_byte(struct rtsx_pcr *pcr, int addr,
> +		u8 mask, u8 append)
> +{
> +	int err;
> +	u8 val;
> +
> +	err = pci_read_config_byte(pcr->pci, addr, &val);
> +	if (err < 0)
> +		return err;
> +	return pci_write_config_byte(pcr->pci, addr, (val & mask) | append);
> +}
> +

Why is this in here?  Why not put it in the generic ops file?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
