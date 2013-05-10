Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3EJISg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:18:36 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:54607 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3EJISd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:18:33 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 3.9-stable] drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
Date: Fri, 10 May 2013 10:18:28 +0200
Message-ID: <11603810.uLPA0sT8aW@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-40-lowlatency; KDE/4.8.5; x86_64; ; )
In-Reply-To: <003701ce4c40$a44a3e30$ecdeba90$%choi@samsung.com>
References: <003701ce4c40$a44a3e30$ecdeba90$%choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please.

> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?
> 
> ------------------
> 
> From: "Philipp Reisner <philipp.reisner@linbit.com>"
> 
> commit ef57f9e6bb9278720c8a5278728f252ab85d7ac6 upstream
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/block/drbd/drbd_receiver.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_receiver.c
> b/drivers/block/drbd/drbd_receiver.c
> index 5105f43..2f5fffd 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -4658,8 +4658,8 @@ static int drbd_do_features(struct drbd_tconn *tconn)
>  #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
>  static int drbd_do_auth(struct drbd_tconn *tconn)
>  {
> -	dev_err(DEV, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
> -	dev_err(DEV, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
> +	conn_err(tconn, "This kernel was build without
> CONFIG_CRYPTO_HMAC.\n");
> +	conn_err(tconn, "You need to disable 'cram-hmac-alg' in
> drbd.conf.\n");
>  	return -1;
>  }
>  #else
> --
