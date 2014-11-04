Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbaKDLkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:40:22 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37874 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaKDLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:40:17 -0500
Message-ID: <1415101213.3701.9.camel@pengutronix.de>
Subject: Re: [PATCHv2] reset: add socfpga_reset_status
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dinguyen@opensource.altera.com
Cc: dinh.linux@gmail.com, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Date: Tue, 04 Nov 2014 12:40:13 +0100
In-Reply-To: <1415053985-10552-1-git-send-email-dinguyen@opensource.altera.com>
References: <1415053985-10552-1-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Am Montag, den 03.11.2014, 16:33 -0600 schrieb
dinguyen@opensource.altera.com:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Populate the reset_status callback for SOCFPGA.
> 
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
> v2: Remove spin_lock around readl
> ---
>  drivers/reset/reset-socfpga.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/reset/reset-socfpga.c b/drivers/reset/reset-socfpga.c
> index 79c32ca..39da5cb 100644
> --- a/drivers/reset/reset-socfpga.c
> +++ b/drivers/reset/reset-socfpga.c
> @@ -76,9 +76,25 @@ static int socfpga_reset_deassert(struct reset_controller_dev *rcdev,
>  	return 0;
>  }
>  
> +static int socfpga_reset_status(struct reset_controller_dev *rcdev,
> +				unsigned long id)
> +{
> +	struct socfpga_reset_data *data = container_of(rcdev,
> +						struct socfpga_reset_data, rcdev);
> +	int bank = id / BITS_PER_LONG;
> +	int offset = id % BITS_PER_LONG;
> +	unsigned long flags;

Now the flags variable is unused.
I'll fix it up and apply it, no need to resend.

> +	u32 reg;
> +
> +	reg = readl(data->membase + OFFSET_MODRST + (bank * NR_BANKS));
> +
> +	return !(reg & BIT(offset));
> +}
> +
>  static struct reset_control_ops socfpga_reset_ops = {
>  	.assert		= socfpga_reset_assert,
>  	.deassert	= socfpga_reset_deassert,
> +	.status		= socfpga_reset_status,
>  };
>  
>  static int socfpga_reset_probe(struct platform_device *pdev)

thanks
Philipp

