Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3IJXwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:52:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IJXwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:52:13 -0400
Date: Tue, 10 Sep 2013 16:52:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/6] tree-sweep: Include linux/sched.h for might_sleep
 users
Message-Id: <20130910165212.b95be29e2816dc69c909c058@linux-foundation.org>
In-Reply-To: <CAMuHMdU-EJdS2epcLUKXThSdGcQd56aXyPH5TyyhGZeiDtZBxQ@mail.gmail.com>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
	<1376687844-19857-4-git-send-email-andi@firstfloor.org>
	<CAMuHMdU-EJdS2epcLUKXThSdGcQd56aXyPH5TyyhGZeiDtZBxQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013 20:22:23 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Fri, Aug 16, 2013 at 11:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > might_sleep is moving from linux/kernel.h to linux/sched.h, so any users
> > need to include linux/sched.h
> 
> Really? <linux/sched.h> is the worst choice w.r.t. include hell.

Yes.  Mechanically adding sched.h inclusions into .h files will cause
problems.

I've had decent success with this sort of thing by adding new,
finer-grained headers.  Maybe include/linux/might_sleep.h would be a
good starting point to fix whatever it was that this fixed.


I think I'll make x86-include-linux-schedh-in-asm-uaccessh.patch,
tree-sweep-include-linux-schedh-for-might_sleep-users.patch and
sched-mark-should_resched-__always_inline.patch go away for now - I
need a mergeable tree, fast.
