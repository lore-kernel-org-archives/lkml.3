Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab3FGXK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:10:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3FGXK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:10:56 -0400
Date: Fri, 7 Jun 2013 16:10:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: Re: [PATCH 5/8] device: avoid format string in dev_set_name
Message-ID: <20130607231055.GA23081@kroah.com>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
 <1370551945-8444-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1370551945-8444-6-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:52:22PM -0700, Kees Cook wrote:
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -515,7 +515,6 @@ EXPORT_SYMBOL(bdi_destroy);
>  int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
>  			   unsigned int cap)
>  {
> -	char tmp[32];
>  	int err;
>  
>  	bdi->name = name;
> @@ -524,8 +523,8 @@ int bdi_setup_and_register(struct backing_dev_info *bdi, char *name,
>  	if (err)
>  		return err;
>  
> -	sprintf(tmp, "%.28s%s", name, "-%d");
> -	err = bdi_register(bdi, NULL, tmp, atomic_long_inc_return(&bdi_seq));
> +	err = bdi_register(bdi, NULL, "%.28s-%d", name,
> +			   atomic_long_inc_return(&bdi_seq));
>  	if (err) {
>  		bdi_destroy(bdi);
>  		return err;

This chunk causes the following build warning to now show up:
mm/backing-dev.c: In function ‘bdi_setup_and_register’:
mm/backing-dev.c:527:7: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘long int’ [-Wformat]

Care to fix it up and resend it?

thanks,

greg k-h
