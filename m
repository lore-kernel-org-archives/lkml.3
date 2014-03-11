Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589AbaCKUBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 16:01:43 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:53097 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbaCKUBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140311095910.GA5834@console-pimps.org>
References: <531d3b0e.4MeVQMzUoamEWeW7%fengguang.wu@intel.com>
	<CAGXu5jJsyAHdiMfoAZHS-4w1+rGKGQH9s9FF83Y59VLmczfaXQ@mail.gmail.com>
	<20140311095910.GA5834@console-pimps.org>
Date: Tue, 11 Mar 2014 13:01:40 -0700
X-Google-Sender-Auth: dgac-Mqn2LSa4fJdJbHj-2HmPTc
Message-ID: <CAGXu5jLLD7n0gWXUd-ME5iDYh=ywaG9eDjCkkcSY3Rk1pgfJTg@mail.gmail.com>
Subject: Re: [kees:format-security 2/3] arch/sh/kernel/dumpstack.c:118:2:
 error: format not a string literal and no format arguments
From: Kees Cook <keescook@chromium.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 2:59 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 10 Mar, at 10:41:57AM, Kees Cook wrote:
>> > 4e14dfc7 Matt Fleming 2009-08-07  113  /*
>> > 4e14dfc7 Matt Fleming 2009-08-07  114   * Print one address/symbol entries per line.
>> > 4e14dfc7 Matt Fleming 2009-08-07  115   */
>> > 4e14dfc7 Matt Fleming 2009-08-07  116  static void print_trace_address(void *data, unsigned long addr, int reliable)
>> > 4e14dfc7 Matt Fleming 2009-08-07  117  {
>> > 4e14dfc7 Matt Fleming 2009-08-07 @118   printk(data);
>>
>> This needs to be "printk("%s", data);" so there is no chance of having
>> "data" interpreted as a format string itself.
>
> OMG, I suck. Thanks for the report Kees. Have you got a patch for x86?
> I think that's where this code came from.

Your patch looks great, thanks!

-Kees

>
> Including Andrew, because I'm not sure who else is going to take this
> patch.
>
> ---
>
> From 2284f3a27f68cec665aa982c0a226cf3fbf96ddf Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Tue, 11 Mar 2014 09:50:26 +0000
> Subject: [PATCH] sh: Fix format string bug in stack tracer
>
> Kees reported the following error,
>
>    arch/sh/kernel/dumpstack.c: In function 'print_trace_address':
>>> arch/sh/kernel/dumpstack.c:118:2: error: format not a string literal and no format arguments [-Werror=format-security]
>
> Use the "%s" format so that it's impossible to interpret 'data' as a
> format string.
>
> Reported-by: Kees Cook <keescook@chromium.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/sh/kernel/dumpstack.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/sh/kernel/dumpstack.c b/arch/sh/kernel/dumpstack.c
> index b959f5592604..8dfe645bcc4b 100644
> --- a/arch/sh/kernel/dumpstack.c
> +++ b/arch/sh/kernel/dumpstack.c
> @@ -115,7 +115,7 @@ static int print_trace_stack(void *data, char *name)
>   */
>  static void print_trace_address(void *data, unsigned long addr, int reliable)
>  {
> -       printk(data);
> +       printk("%s", (char *)data);
>         printk_address(addr, reliable);
>  }
>
> --
> 1.8.5.3
>
> --
> Matt Fleming, Intel Open Source Technology Center



-- 
Kees Cook
Chrome OS Security
