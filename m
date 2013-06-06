Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3FFHLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:11:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33694 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3FFHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:11:17 -0400
Message-ID: <51B035C9.1070506@ti.com>
Date: Thu, 6 Jun 2013 12:40:01 +0530
From: Archit Taneja <archit@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: <axel.lin@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        "Valkeinen, Tomi" <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] OMAPDSS: Remove kfree for memory allocated with devm_kzalloc
References: <1370453396-18043-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1370453396-18043-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.145.166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 05 June 2013 10:59 PM, Emil Goode wrote:
> It's not necessary to free memory allocated with devm_kzalloc
> in a remove function and using kfree leads to a double free.

Looks fine to me. Tomi, could you take this for 3.11?

Archit

>
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
>   drivers/video/omap2/displays/panel-picodlp.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/video/omap2/displays/panel-picodlp.c b/drivers/video/omap2/displays/panel-picodlp.c
> index 62f2db0..859e111 100644
> --- a/drivers/video/omap2/displays/panel-picodlp.c
> +++ b/drivers/video/omap2/displays/panel-picodlp.c
> @@ -469,8 +469,6 @@ static void picodlp_panel_remove(struct omap_dss_device *dssdev)
>   	i2c_unregister_device(picod->picodlp_i2c_client);
>   	dev_set_drvdata(&dssdev->dev, NULL);
>   	dev_dbg(&dssdev->dev, "removing picodlp panel\n");
> -
> -	kfree(picod);
>   }
>
>   static int picodlp_panel_enable(struct omap_dss_device *dssdev)
>

