Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbaEPRwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:52:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47874 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaEPRwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:52:09 -0400
Date: Fri, 16 May 2014 19:51:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: lkml <linux-kernel@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Cleanup console loglevels
Message-ID: <20140516175154.GA18834@pd.tnic>
References: <20140516174921.GA18778@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140516174921.GA18778@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 07:49:21PM +0200, Borislav Petkov wrote:
> Hi,
> 
> so I was staring at
> 
> 12544697f12e ("x86_64: be less annoying on boot, v2")
> 
> and how naked numbers mean sh*t and how I have to grep sources to find
> out what this 10 thing means. So how about the following cleanup? We can
> do it this way, we can do accessors and stuff, whatever. But the naked
> numbers are plain misleading.
> 
> So how about it? I'm asking whether it makes sense first before I go
> and replace all tests of console_loglevel with naked numbers around the
> tree.
> 
> Thanks.
> 
> ---
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 068054f4bf20..0029d974e431 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -172,7 +172,7 @@ asmlinkage __visible void __init x86_64_start_kernel(char * real_mode_data)
>  	 */
>  	load_ucode_bsp();
>  
> -	if (console_loglevel == 10)
> +	if (console_loglevel >= CONSOLE_LOGLEVEL_QUIET)

That's CONSOLE_LOGLEVEL_DEBUG, of course.

See, misleading. :-P

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
