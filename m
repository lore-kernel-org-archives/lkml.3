Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680AbbAVOLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:11:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbbAVOLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:11:53 -0500
Date: Thu, 22 Jan 2015 15:13:09 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Joe Perches <joe@perches.com>,
        Simon =?iso-8859-1?Q?K=E5gstr=F6m?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>, Dan Streetman <ddstreet@ieee.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v2 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
Message-ID: <20150122141309.GA14531@pathway.suse.cz>
References: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421893570-6920-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2015-01-21 21:26:08, Pranith Kumar wrote:
> There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
> for when CONFIG_PRINTK is not set causing build failures.
> 
> This patch adds these dummy routines at the appropriate location.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Makes perfect sense and builds now :-)

Best Regards,
Petr

> CC: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  include/linux/printk.h | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index aeb9d7f..baa3f97 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -10,9 +10,6 @@
>  extern const char linux_banner[];
>  extern const char linux_proc_banner[];
>  
> -extern char *log_buf_addr_get(void);
> -extern u32 log_buf_len_get(void);
> -
>  static inline int printk_get_level(const char *buffer)
>  {
>  	if (buffer[0] == KERN_SOH_ASCII && buffer[1]) {
> @@ -163,6 +160,8 @@ extern int kptr_restrict;
>  
>  extern void wake_up_klogd(void);
>  
> +char *log_buf_addr_get(void);
> +u32 log_buf_len_get(void);
>  void log_buf_kexec_setup(void);
>  void __init setup_log_buf(int early);
>  void dump_stack_set_arch_desc(const char *fmt, ...);
> @@ -198,6 +197,16 @@ static inline void wake_up_klogd(void)
>  {
>  }
>  
> +static inline char *log_buf_addr_get(void)
> +{
> +	return NULL;
> +}
> +
> +static inline u32 log_buf_len_get(void)
> +{
> +	return 0;
> +}
> +
>  static inline void log_buf_kexec_setup(void)
>  {
>  }
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
