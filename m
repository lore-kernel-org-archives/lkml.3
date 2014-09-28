Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaI1WPo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 18:15:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaI1WPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 18:15:43 -0400
Date: Sun, 28 Sep 2014 18:14:45 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Rost <eric.rost@mybabylon.net>
Cc: jason@lakedaemon.net, jake@lwn.net, antonysaraev@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: skein: Fixed Conditional white space problems
Message-ID: <20140928221445.GA25174@kroah.com>
References: <20140928220828.GA12566@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928220828.GA12566@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 05:08:28PM -0500, Eric Rost wrote:
> This patch fixes the following checkpatch.pl Warnings:
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> +               for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
> [...]
> +               {
> 
> WARNING: suspect code indent for conditional statements (16, 16)
> +               for (r = 1; r <= 2 * RCNT; r += 2 * SKEIN_UNROLL_1024)
> [...]
> +               {
> 
> Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
> ---
>  drivers/staging/skein/skein_block.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/skein/skein_block.c b/drivers/staging/skein/skein_block.c
> index 616364f..bbb5a5b 100644
> --- a/drivers/staging/skein/skein_block.c
> +++ b/drivers/staging/skein/skein_block.c
> @@ -380,7 +380,7 @@ do { \
>  
>  		for (r = 1; r < 2 * RCNT; r += 2 * SKEIN_UNROLL_512)
>  #endif /* end of looped code definitions */
> -		{
> +			{

I'm glad you are trying to fix things, but in looking at this closer,
does it look correct to you?

>  #define R512_8_ROUNDS(R)  /* do 8 full rounds */  \
>  do { \
>  		R512(0, 1, 2, 3, 4, 5, 6, 7, R_512_0, 8 * (R) + 1);   \
> @@ -447,7 +447,7 @@ do { \
>  	#if  (SKEIN_UNROLL_512 > 14)
>  #error  "need more unrolling in skein_512_process_block"
>  	#endif
> -		}
> +			}

same here?

How about working on getting rid of the #if crap in this driver, that
will fix up this { } mess automatically.

thanks,

greg k-h
