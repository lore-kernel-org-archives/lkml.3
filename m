Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbaDBMYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:24:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758197AbaDBMYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:24:37 -0400
Subject: Re: [PATCH 1/2] ttyprintk: Fix wrong tty_unregister_driver() call
 in the error path
From: Jean Delvare <jdelvare@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
In-Reply-To: <1396434582-30799-1-git-send-email-tiwai@suse.de>
References: <1396434582-30799-1-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 02 Apr 2014 14:24:33 +0200
Message-ID: <1396441473.10789.23.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 02 April 2014 à 12:29 +0200, Takashi Iwai a écrit :
> ttyprintk driver calls tty_unregister_driver() wrongly in the error
> path of tty_register_driver().  Also, setting ttyprintk_driver to NULL
> is utterly superfluous, so let's get rid of it, too.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/char/ttyprintk.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
> index daea84c41743..2a39c5790364 100644
> --- a/drivers/char/ttyprintk.c
> +++ b/drivers/char/ttyprintk.c
> @@ -210,10 +210,8 @@ static int __init ttyprintk_init(void)
>  	return 0;
>  
>  error:
> -	tty_unregister_driver(ttyprintk_driver);
>  	put_tty_driver(ttyprintk_driver);
>  	tty_port_destroy(&tpk_port.port);
> -	ttyprintk_driver = NULL;
>  	return ret;
>  }
>  device_initcall(ttyprintk_init);

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support

