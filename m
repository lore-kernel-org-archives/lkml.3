Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaGUJjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:39:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199AbaGUJjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:39:33 -0400
Date: Mon, 21 Jul 2014 11:39:29 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, kay@vrfy.org, bp@suse.de,
        john.stultz@linaro.org, jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] printk: report dropped messages on separate line
Message-ID: <20140721093929.GA20751@pathway.suse.cz>
References: <1405718885-11227-1-git-send-email-elder@linaro.org>
 <1405718885-11227-2-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405718885-11227-2-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-07-18 16:27:59, Alex Elder wrote:
> It is possible for the log to be filled too quickly for the consoles
> to be able to keep up.  This is detected in console_unlock(), and when
> it occurs, a message is inserted to note the event.  When reviewing
> some nearby code, Petr Mládek suggested it might be nicer if this
> message were placed on a separate line.  This patch implements that
> suggestion.
> 
> Suggested-by: Petr Mládek <pmladek@suse.cz>
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

> ---
>  kernel/printk/printk.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 13e839d..ffc9928 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2142,9 +2142,10 @@ again:
>  		}
>  
>  		if (console_seq < log_first_seq) {
> -			len = sprintf(text, "** %u printk messages dropped ** ",
> +			len = sprintf(text,
> +				      "%s** %u printk messages dropped **\n",
> +				      (console_prev & LOG_CONT) ? "\n" : "",
>  				      (unsigned)(log_first_seq - console_seq));
> -
>  			/* messages are gone, move to first one */
>  			console_seq = log_first_seq;
>  			console_idx = log_first_idx;
> -- 
> 1.9.1
> 
