Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161897Ab3BONBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:01:13 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:38564 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161780Ab3BONBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com>
References: <1360845813-11334-1-git-send-email-ldewangan@nvidia.com>
Date: Fri, 15 Feb 2013 18:31:07 +0530
Message-ID: <CAM=Q2csZyX5PvOPiSJ22u0SCXvh19y1qoC3+qJmmPfTQziM-tg@mail.gmail.com>
Subject: Re: [PATCH] i2c: tegra: remove warning dump if timeout happen in transfer
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: wsa@the-dreams.de, swarren@nvidia.com, khali@linux-fr.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 6:13 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> If timeout error occurs in the i2c transfer then it was dumping warning
> of call stack.
>
> Remove the warning dump as there is may be possibility that some slave
> devices are busy and not responding the i2c communication.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> The patch is generated based on discussion happen between Stephena and
> Wolfram on the patch:
>  i2c: add bcm2835 driver
>
> resending patch as Wolfram's email id has been changed.
>
>  drivers/i2c/busses/i2c-tegra.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index ae2e027..36704e3 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -587,7 +587,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
>         ret = wait_for_completion_timeout(&i2c_dev->msg_complete, TEGRA_I2C_TIMEOUT);
>         tegra_i2c_mask_irq(i2c_dev, int_mask);
>
> -       if (WARN_ON(ret == 0)) {
> +       if (ret == 0) {

I think WARN_ON has a unlikely.

If you could do a profiling and have the unlikely.

BTW thats not an objection to the patch though.

>                 dev_err(i2c_dev->dev, "i2c transfer timed out\n");
>
>                 tegra_i2c_init(i2c_dev);
> --
> 1.7.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
