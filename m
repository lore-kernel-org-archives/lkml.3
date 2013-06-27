Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3F0JHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:07:30 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:34164 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab3F0JH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:07:26 -0400
Date: Thu, 27 Jun 2013 11:07:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v5 0/9] liblockdep: userspace lockdep
Message-ID: <20130627090722.GC4398@gmail.com>
References: <1371163284-6346-1-git-send-email-sasha.levin@oracle.com>
 <20130626122408.GJ28407@twins.programming.kicks-ass.net>
 <20130626155325.GB7399@gmail.com>
 <51CB4328.7010006@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB4328.7010006@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> On 06/26/2013 11:53 AM, Ingo Molnar wrote:
> >>Ingo, I don't think I see anything holding this back; however I remember
> >>>reading some email about people not liking stuff like this living in the
> >>>tools/ directory or such.
> >>>
> >>>Will you pick this up?
> >So I'd really be interested in how interesting/useful this is to userspace
> >developers? Does it work for something complex as Firefox, or Apache, to
> >the extent they make use of these locking APIs?
> 
> So far I've tested it on Firefox, Apache, QEMU, LKVM, GCC and random 
> smallish programs. I haven't really done full testing for each of those, 
> but just made sure that liblockdep behaves as it supposed to. I'm 
> guessing that with further work it will dig up actual issues.

The other issue is that with lock classes disabled you have to hit an 
actual deadlock to trigger any output.

I.e. much of the power of lockdep is diminished :-/ When actual deadlocks 
are triggered then it's not particularly complex to debug user-space apps: 
gdb the hung task(s) and look at the backtraces.

Thanks,

	Ingo
