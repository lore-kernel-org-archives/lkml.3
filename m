Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaGIQTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:19:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48526 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaGIQTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:19:49 -0400
Date: Wed, 9 Jul 2014 18:19:46 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz,
        john.stultz@linaro.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] printk: use a clever macro
Message-ID: <20140709161946.GA26508@pathway.suse.cz>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-4-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404911056-29064-4-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-07-09 08:04:15, Alex Elder wrote:
> Use the IS_ENABLED() macro rather than #ifdef blocks to set certain
> global values.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  kernel/printk/printk.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 646146c..6f75e8a 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -453,11 +453,7 @@ static int log_store(int facility, int level,
>  	return msg->text_len;
>  }
>  
> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> -int dmesg_restrict = 1;
> -#else
> -int dmesg_restrict;
> -#endif
> +int dmesg_restrict = IS_ENABLED(CONFIG_SECURITY_DMESG_RESTRICT);

I wondered if IS_ENABLED() is guaranteed to set 1 when enabled. Well, it
does not matter because the variable is used as a boolean.

>  static int syslog_action_restricted(int type)
>  {
> @@ -947,11 +943,7 @@ static inline void boot_delay_msec(int level)
>  }
>  #endif
>  
> -#if defined(CONFIG_PRINTK_TIME)
> -static bool printk_time = 1;
> -#else
> -static bool printk_time;
> -#endif
> +static bool printk_time = IS_ENABLED(CONFIG_PRINTK_TIME);
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
>  
>  static size_t print_time(u64 ts, char *buf)
> -- 
> 1.9.1

Nice clean up.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
