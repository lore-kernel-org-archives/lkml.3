Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3LMCax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:30:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3LMCat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:30:49 -0500
Date: Thu, 12 Dec 2013 18:32:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shawn Landden <shawn@churchofgit.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: only print sysrq help for handlers that are enabled
Message-ID: <20131213023239.GA15130@kroah.com>
References: <1386086125-1865-1-git-send-email-shawn@churchofgit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386086125-1865-1-git-send-email-shawn@churchofgit.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 07:55:25AM -0800, Shawn Landden wrote:
> Also print out a notice when sysrq is in selective mode.
> 
> Signed-off-by: Shawn Landden <shawn@churchofgit.com>
> ---
>  drivers/tty/sysrq.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> index ce396ec..4eee0e4 100644
> --- a/drivers/tty/sysrq.c
> +++ b/drivers/tty/sysrq.c
> @@ -548,9 +548,14 @@ void __handle_sysrq(int key, bool check_mask)
>  					;
>  				if (j != i)
>  					continue;
> -				printk("%s ", sysrq_key_table[i]->help_msg);
> +				/* only print if handler is enabled */
> +				if (sysrq_enabled & 1 ||
> +				    sysrq_enabled & sysrq_key_table[i]->enable_mask)
> +					printk("%s ", sysrq_key_table[i]->help_msg);
>  			}
>  		}
> +		if (!(sysrq_enabled & 1))
> +			printk("(some options are disabled)");
>  		printk("\n");
>  		console_loglevel = orig_log_level;
>  	}

What exactly is this fixing?  What is broken here that this change
resolves?  Where is it applicable?  I need a lot more context here
please.

thanks,

greg k-h
