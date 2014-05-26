Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaEZO2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:28:37 -0400
Received: from 1wt.eu ([62.212.114.60]:36007 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaEZO2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:28:35 -0400
Date: Mon, 26 May 2014 16:28:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Dominique van den Broeck <domdevlin@free.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: panel: (coding style) Matching braces
Message-ID: <20140526142827.GG13929@1wt.eu>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400674201-9560-1-git-send-email-domdevlin@free.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dominique,

On Wed, May 21, 2014 at 02:09:59PM +0200, Dominique van den Broeck wrote:
> Style-only modifications to comply with checkpatch.pl --strict --file. 
> . Adds every missing brace in condition statements.
> 
> Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
> ---
> Apply on linux-next tree, above:
> commit 4151fa6adc65da14673ece623bbb2acc6936f8be
> "Add linux-next specific files for 20140516"
> 
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index 136671a..1ac5e25 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -711,10 +711,9 @@ static void pin_to_bits(int pin, unsigned char *d_val, unsigned char *c_val)
>  /* sleeps that many milliseconds with a reschedule */
>  static void long_sleep(int ms)
>  {
> -
> -	if (in_interrupt())
> +	if (in_interrupt()) {
>  		mdelay(ms);
> -	else {
> +	} else {

I don't want to be nit-picking, but since we're talking about style...
for me these "} else {" statements are harder to parse than having them
on two lines this way :

         }
         else {

That's especially more true with "else if" as below :

		} else if (*esc >= 'A' && *esc <= 'Z') {
			value |= (*esc - 'A' + 10) << shift;
		} else if (*esc >= 'a' && *esc <= 'z') {
			value |= (*esc - 'a' + 10) << shift;
		} else {

I believe that most of the kernel code prefers the two-line format resluting
in this instead :

		}
		else if (*esc >= 'A' && *esc <= 'Z') {
			value |= (*esc - 'A' + 10) << shift;
		}
		else if (*esc >= 'a' && *esc <= 'z') {
			value |= (*esc - 'a' + 10) << shift;
		}
		else {

It's just a matter of taste I know, but for me they read easier, probably
because the braces do not affect alignment and the lines appear exactly
similar with or without the braces.

Thanks,
Willy

