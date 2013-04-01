Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3DAGEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:04:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:65425 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3DAGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:03:59 -0400
Date: Sun, 31 Mar 2013 23:00:01 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Minkyu Kang <mk7.kang@samsung.com>
Subject: Re: [PATCH 2/5] power: max17040_battery: Use dev_pm_ops
Message-ID: <20130401060000.GB25376@lizard>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
 <1362922449-27531-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1362922449-27531-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:34:06PM +0100, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.
> 
> Cc: Minkyu Kang <mk7.kang@samsung.com>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Patches 1-3 applied, thanks a lot!

[...]
> @@ -278,14 +281,14 @@ static const struct i2c_device_id max17040_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, max17040_id);
>  
> +

(Stray new line...)

>  static struct i2c_driver max17040_i2c_driver = {
>  	.driver	= {
>  		.name	= "max17040",
> +		.pm	= MAX17040_PM_OPS,
>  	},
>  	.probe		= max17040_probe,
>  	.remove		= max17040_remove,
> -	.suspend	= max17040_suspend,
> -	.resume		= max17040_resume,
>  	.id_table	= max17040_id,
>  };
>  module_i2c_driver(max17040_i2c_driver);
> -- 
> 1.8.0
