Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaETIoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:44:08 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:57241 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaETIoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:44:04 -0400
Date: Tue, 20 May 2014 09:43:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: swarren@nvidia.com, wsa@the-dreams.de, abrestic@chromium.org,
        dgreid@chromium.org, olof@lixom.net, sjg@chromium.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        David Hendricks <dhendrix@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] mfd: cros_ec: spi: calculate delay between
 transfers correctly
Message-ID: <20140520084358.GB24991@lee--X1>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
 <1398879850-9111-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398879850-9111-2-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Hendricks <dhendrix@chromium.org>
> 
> To avoid spamming the EC we calculate the time between the previous
> transfer and the current transfer and force a delay if the time delta
> is too small.
> 
> However, a small miscalculation causes the delay period to be
> far too short. Most noticably this impacts commands with a long
> turnaround time such as EC firmware reads and writes.
> 
> Signed-off-by: David Hendricks <dhendrix@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> Tested-by: Andrew Bresticker <abrestic@chromium.org>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mfd/cros_ec_spi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
> index 84af8d7..c185eb6 100644
> --- a/drivers/mfd/cros_ec_spi.c
> +++ b/drivers/mfd/cros_ec_spi.c
> @@ -219,7 +219,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
>  		ktime_get_ts(&ts);
>  		delay = timespec_to_ns(&ts) - ec_spi->last_transfer_ns;
>  		if (delay < EC_SPI_RECOVERY_TIME_NS)
> -			ndelay(delay);
> +			ndelay(EC_SPI_RECOVERY_TIME_NS - delay);
>  	}
>  
>  	/* Transmit phase - send our message */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
