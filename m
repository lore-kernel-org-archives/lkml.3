Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab3AYRWh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:22:37 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43767 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYRWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:22:33 -0500
Date: Fri, 25 Jan 2013 17:22:24 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        sahara <keun-o.park@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 19/19] [INCOMPLETE] ARM: make return_address available
 for ARM_UNWIND
Message-ID: <20130125172224.GA1961@linaro.org>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359123276-15833-20-git-send-email-arnd@arndb.de>
 <20130125162608.GD2069@linaro.org>
 <1359132254.21576.230.camel@gandalf.local.home>
 <20130125165934.GE2069@linaro.org>
 <1359133703.21576.233.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359133703.21576.233.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:08:23PM -0500, Steven Rostedt wrote:
> On Fri, 2013-01-25 at 16:59 +0000, Dave Martin wrote:
> 
> > Cool.  Are you aware of return_address being used elsewhere?  Currently
> > I'm not aware of anything else which uses it, and grep is not finding
> > any calls outside ftrace.h that I can see.
> 
> softirq.c has a trace_preempt_off() use of CALLER_ADDR1.
> 
> kernel/sched/core.c has CALLER_ADDR1, 2 an 3.

These cases look safe to me ... sched/core.c:get_parent_ip() looks like
it uses notrace purely to avoid the spurious extra frame which it would
otherwise insert, and the code in softirq.c doesn't appear to be in a
notrace context.

Am I being too optimistic, or does that match your understanding?

Cheers
---Dave
