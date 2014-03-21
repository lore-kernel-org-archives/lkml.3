Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966433AbaCUASh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:18:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:56613 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966411AbaCUAS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:18:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,699,1389772800"; 
   d="scan'208";a="476805946"
Subject: Re: [PATCH] Fix late crypto work queue initialization
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "David S.Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <1395100347.2970.14.camel@schen9-DESK>
References: <1395100347.2970.14.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Mar 2014 17:18:00 -0700
Message-ID: <1395361080.2970.29.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 16:52 -0700, Tim Chen wrote:
> The crypto algorithm modules utilizing the crypto daemon could
> be used early when the system start up.  Using module_init
> does not guarantee that the daemon's work queue is initialized
> when the cypto alorithm depending on crypto_wq starts.  It is necessary
> to initialize the crypto work queue earlier at the subsystem
> init time to make sure that it is initialized
> when used.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  crypto/crypto_wq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
> index adad92a..2f1b8d1 100644
> --- a/crypto/crypto_wq.c
> +++ b/crypto/crypto_wq.c
> @@ -33,7 +33,7 @@ static void __exit crypto_wq_exit(void)
>  	destroy_workqueue(kcrypto_wq);
>  }
>  
> -module_init(crypto_wq_init);
> +subsys_initcall(crypto_wq_init);
>  module_exit(crypto_wq_exit);
>  
>  MODULE_LICENSE("GPL");

Herbert,

Any feedback on this patch?

Thanks.

Tim

