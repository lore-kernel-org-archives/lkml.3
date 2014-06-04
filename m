Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaFDShb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:37:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:7046 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750777AbaFDSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:37:30 -0400
Date: Wed, 4 Jun 2014 14:37:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <jbeulich@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] ftrace/x86: Use kernel identity mapping only when
 CONFIG_DEBUG_RODATA enabled
Message-ID: <20140604143728.22e8cbf5@gandalf.local.home>
In-Reply-To: <1401896566-8028-1-git-send-email-pmladek@suse.cz>
References: <1401896566-8028-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Jun 2014 17:42:46 +0200
Petr Mladek <pmladek@suse.cz> wrote:

> This is just a tiny optimization. The remapping is not needed when the
> kernel text mapping is read write all the time.

This is true, but I think I rather have it still do it the same. The
less variables in the code modification the better. The more changes
per config option, the less things tend to get tested.

This is a micro optimization to something that is hardly a fast path.

-- Steve

> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Petr Mladek <pmladek@suse.cz>
> ---
>  arch/x86/kernel/ftrace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index cbc4a91b131e..a7a517bb793e 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -79,6 +79,7 @@ within(unsigned long addr, unsigned long start, unsigned long end)
>  
>  static unsigned long text_ip_addr(unsigned long ip)
>  {
> +#ifdef CONFIG_DEBUG_RODATA
>  	/*
>  	 * On x86_64, kernel text mappings are mapped read-only with
>  	 * CONFIG_DEBUG_RODATA. So we use the kernel identity mapping instead
> @@ -89,7 +90,7 @@ static unsigned long text_ip_addr(unsigned long ip)
>  	 */
>  	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
>  		ip = (unsigned long)__va(__pa_symbol(ip));
> -
> +#endif
>  	return ip;
>  }
>  

