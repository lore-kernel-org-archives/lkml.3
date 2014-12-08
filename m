Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaLHItG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:49:06 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35736 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaLHItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:49:04 -0500
Message-ID: <548565FC.1020908@suse.cz>
Date: Mon, 08 Dec 2014 09:49:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: kernel-janitors@vger.kernel.org, linux@rasmusvillemoes.dk, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/20] TTY: fix misspelling of current function in string
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1417980062-25151-7-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2014, 08:20 PM, Julia Lawall wrote:
> Replace the last argument of serial_paranoia_check by the actual function
> name.
> 
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> The semantic patch is difficult to summarize, but is available in the cover
> letter of this patch series.
> 
>  drivers/tty/amiserial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
> index d9f85f9..b2d7600 100644
> --- a/drivers/tty/amiserial.c
> +++ b/drivers/tty/amiserial.c
> @@ -931,7 +931,7 @@ static void rs_send_xchar(struct tty_struct *tty, char ch)
>  	struct serial_state *info = tty->driver_data;
>          unsigned long flags;
>  
> -	if (serial_paranoia_check(info, tty->name, "rs_send_char"))
> +	if (serial_paranoia_check(info, tty->name, "rs_send_xchar"))

I wonder, why not to use __func__ here too?

thanks,
-- 
js
suse labs
