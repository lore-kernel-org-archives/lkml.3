Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3AYQ7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:59:44 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:43315 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab3AYQ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:59:43 -0500
Date: Fri, 25 Jan 2013 16:59:34 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
Message-ID: <20130125165934.GE2069@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-20-git-send-email-arnd@arndb.de>
 <20130125162608.GD2069@linaro.org>
 <1359132254.21576.230.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359132254.21576.230.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:44:14AM -0500, Steven Rostedt wrote:
> [ I got an error with linux-arm-kernel@list.infradead.org and had to
> remove from CC ]

Blame Arnd :)

> 
> On Fri, 2013-01-25 at 16:26 +0000, Dave Martin wrote:
> 
> > However, if the purpose if making return_address() notrace is just to
> > prevent infinite recursion, where finite recursion is safe, then it
> > feels fixable as described above.
> > 
> > Steven, do you know whether such an approach might be safe?
> > 
> 
> I rewrote the function trace recursion code (see linux-next). The
> function tracer wont recurse on itself. If the return_address() is only
> used by callbacks and not directly by the mcount(ftrace_caller), then
> after the first trace, ftrace wont let recursion of the callback. IOW,
> callbacks of ftrace don't need to worry about re-entrancy at the same
> context level (but do for different contexts, ie. normal, irq, softirq
> and NMI).
> 
> (commit edc15cafcbfa3d73f819cae99885a2e35e4cbce5 in linux-next and
> friends)

Cool.  Are you aware of return_address being used elsewhere?  Currently
I'm not aware of anything else which uses it, and grep is not finding
any calls outside ftrace.h that I can see.

Cheers
---Dave
