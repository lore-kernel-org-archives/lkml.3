Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbAUM6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:58:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbbAUM62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:58:28 -0500
Date: Wed, 21 Jan 2015 13:58:20 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Joe Perches <joe@perches.com>, John Stultz <john.stultz@linaro.org>,
        Dan Streetman <ddstreet@ieee.org>,
        Simon =?iso-8859-1?Q?K=E5gstr=F6m?= 
	<simon.kagstrom@netinsight.net>,
        Borislav Petkov <bp@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 1/2] printk: Add dummy routine for when CONFIG_PRINTK=n
Message-ID: <20150121125820.GA8244@dhcp128.suse.cz>
References: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421797911-23650-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2015-01-20 18:51:49, Pranith Kumar wrote:
> There are missing dummy routines for log_buf_addr_get() and log_buf_len_get()
> for when CONFIG_PRINTK is not set causing build failures.
> 
> This patch adds these dummy routines at the appropriate location.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> CC: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  include/linux/printk.h | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index aeb9d7f..f52f02b 100644
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
> @@ -168,6 +165,8 @@ void __init setup_log_buf(int early);
>  void dump_stack_set_arch_desc(const char *fmt, ...);
>  void dump_stack_print_info(const char *log_lvl);
>  void show_regs_print_info(const char *log_lvl);
> +char *log_buf_addr_get(void);
> +u32 log_buf_len_get(void);
>  #else
>  static inline __printf(1, 0)
>  int vprintk(const char *s, va_list args)
> @@ -217,6 +216,16 @@ static inline void dump_stack_print_info(const char *log_lvl)
>  static inline void show_regs_print_info(const char *log_lvl)
>  {
>  }
> +
> +static inline char *log_buf_addr_get(void)
> +{
> +	return NULL;
> +}
> +
> +static linline u32 log_buf_len_get(void)
          ^
	  typo: linline -> inline

Otherwise, it looks fine to me.

Well, If you send v2, I would move this above log_buf_kexec_setup() in
both #ifdef branches. So that all four log_buf()-related functions
declared/defined together.

Best Regards,
Petr

> +{
> +	return 0;
> +}
>  #endif
>  
>  extern asmlinkage void dump_stack(void) __cold;
> -- 
> 1.9.1
> 
