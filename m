Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3HFD31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:29:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39102 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753665Ab3HFD30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:29:26 -0400
Message-ID: <1375759763.1968.24.camel@joe-AO722>
Subject: Re: [PATCH] printk: Fix return of braille_register_console()
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Ming Lei <ming.lei@canonical.com>
Date: Mon, 05 Aug 2013 20:29:23 -0700
In-Reply-To: <1375757728.25420.14.camel@gandalf.local.home>
References: <1375757728.25420.14.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 22:55 -0400, Steven Rostedt wrote:
> Some of my configs I test with have CONFIG_A11Y_BRAILLE_CONSOLE set.
> When I started testing against v3.11-rc4 my console went bonkers. Using
> ktest to bisect the issue, it came down to:
> 
> commit bbeddf52a "printk: move braille console support into separate
> braille.[ch] files"
> 
> Looking into the patch I found the problem. It's with the return of
> braille_register_console(). As anything other than NULL is considered a
> failure.
> 
> But for those of us that have CONFIG_A11Y_BRAILLE_CONSOLE set but do not
> define a "brl" or "brl=" on the command line, we still may want a
> console that those with sight can still use.
> 
> Return NULL (success) if "brl" or "brl=" is not on the console line.

Thanks Steven.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> diff --git a/kernel/printk/braille.c b/kernel/printk/braille.c
> index b51087f..276762f 100644
> --- a/kernel/printk/braille.c
> +++ b/kernel/printk/braille.c
> @@ -19,7 +19,8 @@ char *_braille_console_setup(char **str, char **brl_options)
>  			pr_err("need port name after brl=\n");
>  		else
>  			*((*str)++) = 0;
> -	}
> +	} else
> +		return NULL;
>  
>  	return *str;
>  }
> 
> 
> 



