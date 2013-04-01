Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3DAGpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:45:04 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:45963 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab3DAGpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:45:02 -0400
Date: Sun, 31 Mar 2013 23:41:03 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Andrei Epure <epure.andrei@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: resource_size() instead of computation
Message-ID: <20130401064103.GD13441@lizard>
References: <1364421227-11178-1-git-send-email-epure.andrei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364421227-11178-1-git-send-email-epure.andrei@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 11:53:47PM +0200, Andrei Epure wrote:
> Patch found using coccinelle.
> 
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---

Silviu-Mihai Popescu sent a similar patch ealier, but I added your
Signed-off-by to the commit.

>  drivers/power/goldfish_battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/goldfish_battery.c b/drivers/power/goldfish_battery.c
> index c10f460..29eba88 100644
> --- a/drivers/power/goldfish_battery.c
> +++ b/drivers/power/goldfish_battery.c
> @@ -178,7 +178,7 @@ static int goldfish_battery_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	data->reg_base = devm_ioremap(&pdev->dev, r->start, r->end - r->start + 1);
> +	data->reg_base = devm_ioremap(&pdev->dev, r->start, resource_size(r));
>  	if (data->reg_base == NULL) {
>  		dev_err(&pdev->dev, "unable to remap MMIO\n");
>  		return -ENOMEM;
> -- 
> 1.7.9.5
