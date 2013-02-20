Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101Ab3BTHfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:35:19 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:44829 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050Ab3BTHfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:35:17 -0500
Date: Tue, 19 Feb 2013 23:35:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] mfd: tps65010: use devm_request_irq() and
 devm_kzalloc()
Message-ID: <20130220073515.GD2648@core.coreip.homeip.net>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002f01ce0f31$7cb08380$76118a80$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <002f01ce0f31$7cb08380$76118a80$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 03:14:05PM +0900, Jingoo Han wrote:
> Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/tps65010.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
> index da2691f..a5438cc 100644
> --- a/drivers/mfd/tps65010.c
> +++ b/drivers/mfd/tps65010.c
> @@ -525,11 +525,8 @@ static int __exit tps65010_remove(struct i2c_client *client)
>  			dev_dbg(&client->dev, "board %s %s err %d\n",
>  				"teardown", client->name, status);
>  	}
> -	if (client->irq > 0)
> -		free_irq(client->irq, tps);
>  	cancel_delayed_work_sync(&tps->work);
>  	debugfs_remove(tps->file);
> -	kfree(tps);
>  	the_tps = NULL;
>  	return 0;

Nope, again work and IRQ have to be handled in certain order.

Thanks.

-- 
Dmitry
