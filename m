Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3FGAoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:44:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32923 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab3FGAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:44:00 -0400
Date: Thu, 6 Jun 2013 17:39:14 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, stable@vger.kernel.org
Subject: Re: [PATCH 4/8] power: ensure event is not used as format string
Message-ID: <20130607003914.GH7052@lizard.sbx05280.losalca.wayport.net>
References: <1370551945-8444-1-git-send-email-keescook@chromium.org>
 <1370551945-8444-5-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370551945-8444-5-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 01:52:21PM -0700, Kees Cook wrote:
> The exposed interface for cm_notify_event() could result in the event
> msg string being parsed as a format string. Make sure it is only used
> as a literal string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> ---

Thanks a lot, Kees! This is now applied.

>  drivers/power/charger-manager.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index fefc39f..98de1dd 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -450,7 +450,7 @@ static void uevent_notify(struct charger_manager *cm, const char *event)
>  	strncpy(env_str, event, UEVENT_BUF_SIZE);
>  	kobject_uevent(&cm->dev->kobj, KOBJ_CHANGE);
>  
> -	dev_info(cm->dev, event);
> +	dev_info(cm->dev, "%s", event);
>  }
>  
>  /**
> -- 
> 1.7.9.5
