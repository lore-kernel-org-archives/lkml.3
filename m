Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbaKRVZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:25:30 -0500
Received: from 1wt.eu ([62.212.114.60]:53274 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbaKRVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:25:28 -0500
Date: Tue, 18 Nov 2014 22:25:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mariusz Gorski <marius.gorski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] staging: panel: Remove more magic number comparison
Message-ID: <20141118212523.GK26514@1wt.eu>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com> <1416344174-9155-9-git-send-email-marius.gorski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416344174-9155-9-git-send-email-marius.gorski@gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 09:56:13PM +0100, Mariusz Gorski wrote:
> Use a macro instead of magic number comparison for checking
> whether a module param value has been set.
> 
> Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
> ---
>  drivers/staging/panel/panel.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index ee48bca..268ad2e 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -136,6 +136,7 @@
>  #define NOT_SET			-1
>  
>  #define IS_NOT_SET(x)	(x == NOT_SET)
> +#define IS_SET(x)		(x > NOT_SET)
>  
>  /* macros to simplify use of the parallel port */
>  #define r_ctr(x)        (parport_read_control((x)->port))
> @@ -1496,17 +1497,17 @@ static void lcd_init(void)
>  	}
>  
>  	/* Overwrite with module params set on loading */
> -	if (lcd_height > -1)
> +	if (IS_SET(lcd_height))
>  		lcd.height = lcd_height;
> -	if (lcd_width > -1)
> +	if (IS_SET(lcd_width))
>  		lcd.width = lcd_width;

(...)

Same as for the other patch, better open-code the test for readability :

-	if (lcd_height > -1)
+	if (lcd_height != NOT_SET)
 		lcd.height = lcd_height;

Note that we take the freedom to change the operator since we only want
to check equality and not sign in practice.

Willy

