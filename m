Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3IXXqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 19:46:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3IXXqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 19:46:48 -0400
Date: Tue, 24 Sep 2013 16:46:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: keescook@chromium.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: add missing destroy_workqueue() on error in
 i2o_driver_register()
Message-Id: <20130924164646.c42172bb0f86e5eec0c16fe5@linux-foundation.org>
In-Reply-To: <CAPgLHd_sVSo04e4Su0sUm7h7wgM6xP=XVb+sWFT-e-VZP7FJXQ@mail.gmail.com>
References: <CAPgLHd_sVSo04e4Su0sUm7h7wgM6xP=XVb+sWFT-e-VZP7FJXQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 17:56:56 +0800 Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Add the missing destroy_workqueue() before return from
> i2o_driver_register() in the error handling case.

yup.

> --- a/drivers/message/i2o/driver.c
> +++ b/drivers/message/i2o/driver.c
> @@ -105,7 +105,8 @@ int i2o_driver_register(struct i2o_driver *drv)
>  			osm_err("too many drivers registered, increase "
>  				"max_drivers\n");
>  			spin_unlock_irqrestore(&i2o_drivers_lock, flags);
> -			return -EFAULT;
> +			rc = -EFAULT;

Why on earth does this function return -EFAULT (twice)?  Imagine the poor
user's confusion if that code gets propagated back to his application
or shell.

