Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab3KXAXg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:23:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41052 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab3KXAXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:23:31 -0500
Date: Sun, 24 Nov 2013 00:23:24 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 6/7] n_tty: Only perform wakeups for waiters
Message-ID: <20131124002324.2fe609d6@alan.etchedpixels.co.uk>
In-Reply-To: <1385135965-4235-7-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
	<1385135965-4235-7-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 10:59:24 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Only wakeup the _waiting_ reader, polls and/or writer(s).
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/n_tty.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> index 8f2356e..aae28a6 100644
> --- a/drivers/tty/n_tty.c
> +++ b/drivers/tty/n_tty.c
> @@ -275,7 +275,8 @@ static void n_tty_check_unthrottle(struct tty_struct *tty)
>  			return;
>  		n_tty_set_room(tty);
>  		n_tty_write_wakeup(tty->link);
> -		wake_up_interruptible_poll(&tty->link->write_wait, POLLOUT);
> +		if (waitqueue_active(&tty->link->write_wait))
> +			wake_up_interruptible_poll(&tty->link->write_wait, POLLOUT);

Does this actually microbenchmark faster ?

Alan
