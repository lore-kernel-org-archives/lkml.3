Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3DPN2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:28:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab3DPN2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:28:40 -0400
Date: Tue, 16 Apr 2013 15:25:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130416132545.GA9189@redhat.com>
References: <20130414191205.GA28791@redhat.com> <20130415233652.GE17561@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415233652.GE17561@somewhere.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Frederic Weisbecker wrote:
>
> On Sun, Apr 14, 2013 at 09:12:05PM +0200, Oleg Nesterov wrote:
>
> Looking at the bug report, it seems they only reproduced with a homemade
> test. No real app has reported that issue?

iirc (Jan can correct me) gdb hit this problem, but it was already
changed to change DR0 first.

> > Jan, Frederic, et all. What do you think we should do?
> >
> > 	1. Change ptrace_write_dr7() to do register_user_hw_breakpoint()
> > 	   if necessary.
> >
> > 	   This is what I was going to do, but I am no longer sure
> > 	   we want this. For what? Unlikely it is very useful to use
> > 	   the "default" addr == 0 for debugging.
>
> So you mean assume that the addr is 0 in dr[0-3] if we write dr7 before writing
> the addr register?

Yes,

> Yes, I'm convinced that's the right direction!

OK. Thanks Jan and Frederic.

I'll send v2 tomorrow with the 3rd patch which adds _register into
write_dr7. Plus another minor/offtopic fix I forgot to send.

Oleg.

