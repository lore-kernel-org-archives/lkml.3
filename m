Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbaGWXHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:07:41 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44353 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaGWXHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:07:40 -0400
Date: Wed, 23 Jul 2014 16:07:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nicholas Krause <xerofoify@gmail.com>
cc: gregkh@linuxfoundation.org, john.stultz@linaro.org,
        paul.gortmaker@windriver.com, gang.chen.5i5j@gmail.com,
        yongjun_wei@trendmicro.com.cn, dan.carpenter@oracle.com,
        tomas.winkler@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: Change kzalloc to kcalloc
In-Reply-To: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
Message-ID: <alpine.DEB.2.02.1407231606090.1389@chino.kir.corp.google.com>
References: <1406156581-6052-1-git-send-email-xerofoify@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Nicholas Krause wrote:

> diff --git a/drivers/staging/android/ion/ion_dummy_driver.c b/drivers/staging/android/ion/ion_dummy_driver.c
> index 3a45e79..8883432 100644
> --- a/drivers/staging/android/ion/ion_dummy_driver.c
> +++ b/drivers/staging/android/ion/ion_dummy_driver.c
> @@ -67,9 +67,8 @@ static int __init ion_dummy_init(void)
>  {
>  	int i, err;
>  
> 	idev = ion_device_create(NULL);
> -	heaps = kzalloc(sizeof(struct ion_heap *) * dummy_ion_pdata.nr,
> -			GFP_KERNEL);
> +	heaps = kcalloc(*dummy_ion_pdata.nr , sizeof((struct ion_heap *) *dummy_ion_pdata.nr) , GFP_KERNEL);
>  	if (!heaps)
>  		return -ENOMEM;
>  

Nack, this is not equivalent and would not even compile if tried.
