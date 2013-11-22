Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3KVIJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:09:22 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:14174 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3KVIJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:09:21 -0500
Message-ID: <528F112B.4090404@bfs.de>
Date: Fri, 22 Nov 2013 09:09:15 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Andreas Platschek <andi.platschek@gmail.com>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tty: replace mutex_lock() with tty_write_lock()
References: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
In-Reply-To: <1385061132-7254-1-git-send-email-andi.platschek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 21.11.2013 20:12, schrieb Andreas Platschek:
> Use tty_write_lock()/tty_write_unlock() consistently.
> 
> This takes care of the following sparse warning:
> drivers/tty/tty_io.c:1169:17: warning: context imbalance in 'tty_write_message' - unexpected unlock
> 
> Signed-off-by: Andreas Platschek <andi.platschek@gmail.com>
> ---
>  drivers/tty/tty_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index 3a1a01a..13dca92 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -1165,7 +1165,7 @@ out:
>  void tty_write_message(struct tty_struct *tty, char *msg)
>  {
>  	if (tty) {
> -		mutex_lock(&tty->atomic_write_lock);
> +		tty_write_lock(tty,0);
>  		tty_lock(tty);
>  		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
>  			tty_unlock(tty);

i am not an expert on this but you may need to replace that tty_unlock() with tty_write_unlock().

re,
 wh
