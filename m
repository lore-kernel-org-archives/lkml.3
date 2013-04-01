Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab3DAGEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:04:52 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:53373 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab3DAGEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:04:51 -0400
Date: Sun, 31 Mar 2013 23:00:52 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Evgeny Romanov <romanov@neurosoft.ru>
Subject: Re: [PATCH 1/5] power: ds2782_battery: Use dev_pm_ops
Message-ID: <20130401060052.GA30190@lizard>
References: <1362922449-27531-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362922449-27531-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 02:34:05PM +0100, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the deprecated legacy suspend/resume callbacks.
> 
> Cc: Evgeny Romanov <romanov@neurosoft.ru>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
[...]
> @@ -465,11 +466,10 @@ MODULE_DEVICE_TABLE(i2c, ds278x_id);
>  static struct i2c_driver ds278x_battery_driver = {
>  	.driver 	= {
>  		.name	= "ds2782-battery",
> +		.pm	= DS278X_BATERY_PM_OPS,

Typo: BATTERY.

  CHECK   drivers/power/ds2782_battery.c
drivers/power/ds2782_battery.c:464:27: error: undefined identifier 'DS278X_BATERY_PM_OPS'
  CC      drivers/power/ds2782_battery.o
drivers/power/ds2782_battery.c:464:9: error: ‘DS278X_BATERY_PM_OPS’ undeclared here (not in a function)
make[1]: *** [drivers/power/ds2782_battery.o] Error 1

I fixed it up and applied the patch...

Thanks,

Anton

>  	},
>  	.probe		= ds278x_battery_probe,
>  	.remove		= ds278x_battery_remove,
> -	.suspend	= ds278x_suspend,
> -	.resume		= ds278x_resume,
>  	.id_table	= ds278x_id,
>  };
>  module_i2c_driver(ds278x_battery_driver);
