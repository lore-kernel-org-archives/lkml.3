Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbaGIPAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:00:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35266 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaGIPAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:00:49 -0400
Date: Wed, 9 Jul 2014 17:00:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Elder <elder@linaro.org>
Cc: akpm@linux-foundation.org, ak@linux.intel.com, bp@suse.de, jack@suse.cz,
        john.stultz@linaro.org, pmladek@suse.cz, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] printk: rename DEFAULT_MESSAGE_LOGLEVEL
Message-ID: <20140709150043.GB5254@pd.tnic>
References: <1404911056-29064-1-git-send-email-elder@linaro.org>
 <1404911056-29064-2-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404911056-29064-2-git-send-email-elder@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 08:04:13AM -0500, Alex Elder wrote:
> This commit:
>     a8fe19eb kernel/printk: use symbolic defines for console loglevels
> makes consistent use of symbolic values for printk() log levels.
> 
> The naming scheme used is different from the one used for
> DEFAULT_MESSAGE_LOGLEVEL though.  Change that symbol name to be
> MESSAGE_LOGLEVEL_DEFAULT for consistency.
> 
> Note that we don't rename CONFIG_DEFAULT_MESSAGE_LOGLEVEL (to avoid
> breaking existing config files that might reference it).
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  include/linux/printk.h | 2 +-
>  kernel/printk/printk.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 319ff7e..3d1ccad 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -31,7 +31,7 @@ static inline const char *printk_skip_level(const char *buffer)
>  }
>  
>  /* printk's without a loglevel use this.. */
> -#define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL
> +#define MESSAGE_LOGLEVEL_DEFAULT CONFIG_DEFAULT_MESSAGE_LOGLEVEL

Well, I can't say I like it - we have the config item
CONFIG_DEFAULT_MESSAGE_LOGLEVEL and DEFAULT_MESSAGE_LOGLEVEL resembles
it for a reason - it is the corresponding define coming from .config.

With this change you have:

CONFIG_DEFAULT_MESSAGE_LOGLEVEL
       MESSAGE_LOGLEVEL_DEFAULT

which is more confusing. To me at least. I can't see the resemblance at
a quick glance anymore.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
