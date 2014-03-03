Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaCCWti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:49:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28108 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755905AbaCCWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:49:36 -0500
Date: Mon, 3 Mar 2014 17:49:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about -rc and stable patches
Message-ID: <20140303174934.7e5971d8@gandalf.local.home>
In-Reply-To: <20140303174532.7cb8f31e@gandalf.local.home>
References: <20140303172806.4486f65a@gandalf.local.home>
	<20140303224104.GA26031@kroah.com>
	<20140303174532.7cb8f31e@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2014 17:45:32 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 8cabf63..9f354e5 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -586,6 +586,9 @@ void ftrace_replace_code(int enable)
>  	for_ftrace_rec_iter(iter) {
>  		rec = ftrace_rec_iter_record(iter);
>  
> +		if (count == 1000)
> +			ret = -EPERM;
> +		else
>  		ret = add_breakpoints(rec, enable);
>  		if (ret)
>  			goto remove_breakpoints;
> 
> 
> Not something that can be done from normal operations.
> 

I'll also add that one reason that this hasn't been an issue before, is
that the code that converts calls to mcount to nops, is done at kernel
boot up. If the above code were to fail, it is highly likely that the
code that converted mcount to nops would fail too. And if that happens,
it completely disables function tracing, preventing this code from
running.

The code that converts mcount to nops, handles the above error properly.

-- Steve
