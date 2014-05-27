Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaE0TRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:17:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37257 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751991AbaE0TRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:17:31 -0400
Date: Tue, 27 May 2014 15:17:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Kees Cook <keescook@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: Use symbolic defines for console loglevels
Message-ID: <20140527151728.64e8cf59@gandalf.local.home>
In-Reply-To: <1400524052-25625-1-git-send-email-bp@alien8.de>
References: <1400524052-25625-1-git-send-email-bp@alien8.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 20:27:32 +0200
Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
 
> There should be no functionality change resulting from this patch.
> 

> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 068054f4bf20..eda1a865641e 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
>  	 */
>  	load_ucode_bsp();
>  
> -	if (console_loglevel == 10)
> +	if (console_loglevel >= CONSOLE_LOGLEVEL_DEBUG)

This looks like functionality change to me.

Please make the fix of "==" --> ">=" a separate patch.

-- Steve
 
