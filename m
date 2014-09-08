Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaIHKnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:43:08 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35734 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbaIHKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:43:07 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: correct of_console_check()'s return value
To: Brian Norris <computersforpeace@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>
In-Reply-To: <1409767603-3290-1-git-send-email-computersforpeace@gmail.com>
References: <1409767603-3290-1-git-send-email-computersforpeace@gmail.com>
Date: Mon, 08 Sep 2014 11:42:38 +0100
Message-Id: <20140908104238.C7B3DC40AB2@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  3 Sep 2014 11:06:43 -0700, Brian Norris <computersforpeace@gmail.com> wrote:
> The comments above of_console_check() say that it will return TRUE if it
> registers a preferred console, but add_preferred_console() uses a
> 0-equals-success convention, so ths leaves of_console_check() with an
> inconsistent policy for its return values.
> 
> Fortunately, nobody was actually checking the return value of
> of_console_check(), so this isn't significant at the moment.
> 
> But let's match the comments, so we're doing what we say.
> 
> Fixes: 3482f2c52b77 ('of: Create of_console_check() for selecting a console specified in /chosen')
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Grant Likely <grant.likely@linaro.org>

Good catch. Applied, thanks.

g.

> ---
> This is one way to fix it. Another possibility includes changing
> of_console_check() to use 0-as-success
> 
>  drivers/of/base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d8574adf0d62..bcfd08c2795c 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1986,7 +1986,7 @@ bool of_console_check(struct device_node *dn, char *name, int index)
>  {
>  	if (!dn || dn != of_stdout || console_set_on_cmdline)
>  		return false;
> -	return add_preferred_console(name, index, NULL);
> +	return !add_preferred_console(name, index, NULL);
>  }
>  EXPORT_SYMBOL_GPL(of_console_check);
>  
> -- 
> 1.9.1
> 

