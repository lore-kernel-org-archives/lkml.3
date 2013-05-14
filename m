Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab3ENM4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:56:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757475Ab3ENM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:56:43 -0400
Date: Tue, 14 May 2013 13:56:40 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Philipp Reisner'" <philipp.reisner@linbit.com>,
        "'Lars Ellenberg'" <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 3.9-stable] drbd: Fix build error when CONFIG_CRYPTO_HMAC
 is not set
Message-ID: <20130514125640.GF5196@hercules>
References: <003701ce4c40$a44a3e30$ecdeba90$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003701ce4c40$a44a3e30$ecdeba90$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 08:06:15AM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

This seems to be applicable to older kernels as well (starting with
3.0 at least).

I'm queuing it for 3.5.

Cheers,
--
Luis


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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
