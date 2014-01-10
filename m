Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaAJMtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:49:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaAJMtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:49:03 -0500
Message-ID: <1389358142.6807.36.camel@linux-fkkt.site>
Subject: Re: [PATCH 2/3] mmc: Add realtek USB sdmmc host driver
From: Oliver Neukum <oneukum@suse.de>
To: rogerable@realtek.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Fri, 10 Jan 2014 13:49:02 +0100
In-Reply-To: <1387792327-2511-3-git-send-email-rogerable@realtek.com>
References: <1387792327-2511-1-git-send-email-rogerable@realtek.com>
	 <1387792327-2511-3-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 17:52 +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> Realtek USB SD/MMC host driver provides mmc host support based on the Realtek
> USB card reader MFD driver.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>

> +#ifdef DEBUG

Dynamic debugging would be nice.

> +static void sd_print_debug_regs(struct rtsx_usb_sdmmc *host)
> +{
> +	struct rtsx_ucr *ucr = host->ucr;
> +	u8 val = 0;
> +
> +	rtsx_usb_ep0_read_register(ucr, SD_STAT1, &val);
> +	dev_dbg(sdmmc_dev(host), "SD_STAT1: 0x%x\n", val);
> +	rtsx_usb_ep0_read_register(ucr, SD_STAT2, &val);
> +	dev_dbg(sdmmc_dev(host), "SD_STAT2: 0x%x\n", val);
> +	rtsx_usb_ep0_read_register(ucr, SD_BUS_STAT, &val);
> +	dev_dbg(sdmmc_dev(host), "SD_BUS_STAT: 0x%x\n", val);
> +}
> +#else
> +#define sd_print_debug_regs(host)
> +#endif /* DEBUG */
> +


	Regards
		Oliver


