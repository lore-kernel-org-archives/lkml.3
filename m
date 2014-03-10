Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaCJRmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:42:01 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61254 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaCJRl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:41:58 -0400
MIME-Version: 1.0
In-Reply-To: <531d3b0e.4MeVQMzUoamEWeW7%fengguang.wu@intel.com>
References: <531d3b0e.4MeVQMzUoamEWeW7%fengguang.wu@intel.com>
Date: Mon, 10 Mar 2014 10:41:57 -0700
X-Google-Sender-Auth: iqoo9QXz-xLJnua2yj7DDobukUE
Message-ID: <CAGXu5jJsyAHdiMfoAZHS-4w1+rGKGQH9s9FF83Y59VLmczfaXQ@mail.gmail.com>
Subject: Re: [kees:format-security 2/3] arch/sh/kernel/dumpstack.c:118:2:
 error: format not a string literal and no format arguments
From: Kees Cook <keescook@chromium.org>
To: Matt Fleming <matt@console-pimps.org>, Paul Mundt <lethal@linux-sh.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 9:09 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git format-security
> head:   78ac7178787f348d93ac16cda556265af4b8ce17
> commit: 3aac21c82091399e96c528c8ac4f337757d6e81b [2/3] Make all format string problems fail the build
> config: make ARCH=sh allnoconfig
>
> All error/warnings:
>
>    arch/sh/kernel/dumpstack.c: In function 'print_trace_address':
>>> arch/sh/kernel/dumpstack.c:118:2: error: format not a string literal and no format arguments [-Werror=format-security]
>    cc1: all warnings being treated as errors
>
> vim +118 arch/sh/kernel/dumpstack.c
>
> 4e14dfc7 Matt Fleming 2009-08-07  102                                           context, &graph);
> 4e14dfc7 Matt Fleming 2009-08-07  103           }
> 4e14dfc7 Matt Fleming 2009-08-07  104   }
> 4e14dfc7 Matt Fleming 2009-08-07  105  }
> 4e14dfc7 Matt Fleming 2009-08-07  106
> 4e14dfc7 Matt Fleming 2009-08-07  107  static int print_trace_stack(void *data, char *name)
> 4e14dfc7 Matt Fleming 2009-08-07  108  {
> 4e14dfc7 Matt Fleming 2009-08-07  109   printk("%s <%s> ", (char *)data, name);
> 4e14dfc7 Matt Fleming 2009-08-07  110   return 0;
> 4e14dfc7 Matt Fleming 2009-08-07  111  }
> 4e14dfc7 Matt Fleming 2009-08-07  112
> 4e14dfc7 Matt Fleming 2009-08-07  113  /*
> 4e14dfc7 Matt Fleming 2009-08-07  114   * Print one address/symbol entries per line.
> 4e14dfc7 Matt Fleming 2009-08-07  115   */
> 4e14dfc7 Matt Fleming 2009-08-07  116  static void print_trace_address(void *data, unsigned long addr, int reliable)
> 4e14dfc7 Matt Fleming 2009-08-07  117  {
> 4e14dfc7 Matt Fleming 2009-08-07 @118   printk(data);

This needs to be "printk("%s", data);" so there is no chance of having
"data" interpreted as a format string itself.

Thanks!

-Kees

> 4e14dfc7 Matt Fleming 2009-08-07  119   printk_address(addr, reliable);
> 4e14dfc7 Matt Fleming 2009-08-07  120  }
> 4e14dfc7 Matt Fleming 2009-08-07  121
> 4e14dfc7 Matt Fleming 2009-08-07  122  static const struct stacktrace_ops print_trace_ops = {
> 4e14dfc7 Matt Fleming 2009-08-07  123   .stack = print_trace_stack,
> 4e14dfc7 Matt Fleming 2009-08-07  124   .address = print_trace_address,
> 4e14dfc7 Matt Fleming 2009-08-07  125  };
> 4e14dfc7 Matt Fleming 2009-08-07  126
>
> :::::: The code at line 118 was first introduced by commit
> :::::: 4e14dfc722b8e9e07a355f97aa60a3d9f0739071 sh: Use the generalized stacktrace ops
>
> :::::: TO: Matt Fleming <matt@console-pimps.org>
> :::::: CC: Paul Mundt <lethal@linux-sh.org>
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Kees Cook
Chrome OS Security
