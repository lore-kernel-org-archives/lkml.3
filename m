Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab3LXAiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:38:01 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58493 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757890Ab3LXAiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:38:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] driver: Add Legacy PM OPS usage check and warning to driver_register()
Date: Tue, 24 Dec 2013 01:51:27 +0100
Message-ID: <1868309.7dxduFC77U@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <b33c1967bdaed9a36fa5a6d7855310c84cb9b910.1383868060.git.shuah.kh@samsung.com>
References: <cover.1383868060.git.shuah.kh@samsung.com> <b33c1967bdaed9a36fa5a6d7855310c84cb9b910.1383868060.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 07, 2013 05:03:50 PM Shuah Khan wrote:
> Add Legacy PM OPS usage checks to driver_register() function. If Legacy PM OPS
> usage is found, print warning message to indicate the driver code needs
> updating to use Dev PM OPS interfaces. This will help serve as a way to track
> drivers that still use Legacy PM OPS and fix them.
> 
> The Legacy PM OPS check looks for suspend(struct device *, pm_message_t) or
> resume(struct device *) struct device_driver interfaces.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/base/driver.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
> index 9e29943..10ff280 100644
> --- a/drivers/base/driver.c
> +++ b/drivers/base/driver.c
> @@ -157,6 +157,10 @@ int driver_register(struct device_driver *drv)
>  		printk(KERN_WARNING "Driver '%s' needs updating - please use "
>  			"bus_type methods\n", drv->name);
>  
> +	if (drv->suspend || drv->resume)
> +		pr_warn("Please update driver '%s' to use dev pm ops.\n",
> +			drv->name);

What about the following message instead:

		pr_warn("Driver '%s' needs updating - please use the pm pointer.\n",
			drv->name);

And analogously for bus types and classes?

> +
>  	other = driver_find(drv->name, drv->bus);
>  	if (other) {
>  		printk(KERN_ERR "Error: Driver '%s' is already registered, "
> 

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
