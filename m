Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbaFQL6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:58:49 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39867 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaFQL6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:58:46 -0400
Date: Tue, 17 Jun 2014 12:58:18 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: Re: [PATCH tty-next 15/22] isdn: tty: Use private flag for
 ASYNC_CLOSING
Message-ID: <20140617125818.4f02a760@alan.etchedpixels.co.uk>
In-Reply-To: <1402924639-5164-16-git-send-email-peter@hurleysoftware.com>
References: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
	<1402924639-5164-16-git-send-email-peter@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 09:17:12 -0400
Peter Hurley <peter@hurleysoftware.com> wrote:

> ASYNC_CLOSING is no longer used in the tty core; use private flag
> info->closing as substitute.
> 
> CC: Karsten Keil <isdn@linux-pingi.de>
> CC: netdev@vger.kernel.org
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/isdn/i4l/isdn_tty.c | 14 +++++++-------
>  include/linux/isdn.h        |  1 +
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
> index 732f68a..5310932 100644
> --- a/drivers/isdn/i4l/isdn_tty.c
> +++ b/drivers/isdn/i4l/isdn_tty.c
> @@ -1577,8 +1577,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
>  #endif
>  		return;
>  	}
> -	port->flags |= ASYNC_CLOSING;
> -
> +	info->closing = 1;

This is not sane C because

> +  int			closing:1;	 /* port count has dropped to 0    */

has the values 0 and -1.

Using a bool would let the compiler figure out what it wanted to do and
do the right thing. It'll probably generate identical code for most
processors but it gives it the freedom to do better.

Alan
