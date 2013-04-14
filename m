Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3DNTah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753383Ab3DNTag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:30:36 -0400
Date: Sun, 14 Apr 2013 21:30:21 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130414193021.GA20962@host2.jankratochvil.net>
References: <20130414191205.GA28791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414191205.GA28791@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Apr 2013 21:12:05 +0200, Oleg Nesterov wrote:
> Jan, Frederic, et all. What do you think we should do?
> 
> 	1. Change ptrace_write_dr7() to do register_user_hw_breakpoint()
> 	   if necessary.
> 
> 	   This is what I was going to do, but I am no longer sure
> 	   we want this. For what? Unlikely it is very useful to use
> 	   the "default" addr == 0 for debugging.

I do not understand how these functions map to the PTRACE_* syscall.

But this was a regression from the application point of view as some
application did/do:
	* waitpid - get the process to: t (tracing stop)
	* PTRACE_POKEUSER DR7, enableDR0
	* PTRACE_POKEUSER DR0, address
	* PTRACE_CONT

This was perfectly valid before, there is no "default" addr == 0 used for any
debugging.  Just the applications did not care about PTRACE_POKEUSER ordering.
This is also how the bug was found.


Thanks,
Jan
