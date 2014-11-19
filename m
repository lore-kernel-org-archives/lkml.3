Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaKSNN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:13:56 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44295 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaKSNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:13:54 -0500
Date: Wed, 19 Nov 2014 22:14:33 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Mahendran Ganesh <opensource.ganesh@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-mm@kvack.or,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: fix zs_init cpu notifier error handling
Message-ID: <20141119131433.GA1003@swordfish>
References: <1415969826-6416-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20141118141212.07b64fdd2f32e8d3b0f725cb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118141212.07b64fdd2f32e8d3b0f725cb@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/18/14 14:12), Andrew Morton wrote:
> > Mahendran Ganesh reported that zpool-enabled zsmalloc should not
> > call zpool_unregister_driver() from zs_init() if cpu notifier
> > registration has failed, because error handling is performed
> > before we register the driver via zpool_register_driver() call.
> > 
> > Factor out cpu notifier registration and unregistration code and
> > fix zs_init() error handling.
> 
> 
> So we can now do this, yes?

yes, sir.

I didn't do this because I though Mahendran would resend his
patch.

thank you.

	-ss

> 
> --- a/mm/zsmalloc.c~mm-zsmallocc-use-__init-and-__exit
> +++ a/mm/zsmalloc.c
> @@ -911,7 +911,7 @@ static int zs_register_cpu_notifier(void
>  	return notifier_to_errno(ret);
>  }
>  
> -static void zs_exit(void)
> +static void __exit zs_exit(void)
>  {
>  #ifdef CONFIG_ZPOOL
>  	zpool_unregister_driver(&zs_zpool_driver);
> @@ -919,7 +919,7 @@ static void zs_exit(void)
>  	zs_unregister_cpu_notifier();
>  }
>  
> -static int zs_init(void)
> +static int __init zs_init(void)
>  {
>  	int ret = zs_register_cpu_notifier();
>  
> 
