Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946017AbaGRTV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:21:27 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60603 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422795AbaGRTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:21:26 -0400
Message-ID: <53C973B8.9060900@linaro.org>
Date: Fri, 18 Jul 2014 14:21:28 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] printk: report dropped messages on separate line
References: <1405692859-32500-1-git-send-email-elder@linaro.org> <1405692859-32500-2-git-send-email-elder@linaro.org>
In-Reply-To: <1405692859-32500-2-git-send-email-elder@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 09:14 AM, Alex Elder wrote:
> It is possible for the log to be filled too quickly for the consoles
> to be able to keep up.  This is detected in console_unlock(), and
> when it occurs, a message is printed on the console.  When reviewing
> some nearby code, Petr Mládek suggested it might be nicer if this
> message were placed on a separate line.  This patch implements that
> suggestion.
> 
> Suggested-by: Petr Mládek <pmladek@suse.cz>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 13e839d..bed8f09 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -2142,9 +2142,10 @@ again:
>  		}
>  
>  		if (console_seq < log_first_seq) {
> -			len = sprintf(text, "** %u printk messages dropped ** ",
> +			len = sprintf(text,
> +				      "%s** %llu printk messages dropped **\n",
                                             ^^^
This is wrong, an artifact I didn't clean up.
It should still just be "%u".  Sorry about that.

					-Alex

> +				      (console_prev & LOG_CONT) ? "\n" : "",
>  				      (unsigned)(log_first_seq - console_seq));
> -
>  			/* messages are gone, move to first one */
>  			console_seq = log_first_seq;
>  			console_idx = log_first_idx;
> 

