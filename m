Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3HOFCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 01:02:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab3HOFCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 01:02:47 -0400
Date: Thu, 15 Aug 2013 08:04:15 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user
 into low level code 64bit
Message-ID: <20130815050415.GA2025@redhat.com>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
 <1376089460-5459-11-git-send-email-andi@firstfloor.org>
 <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 08:42:58AM -0700, Linus Torvalds wrote:
> On Fri, Aug 9, 2013 at 4:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > Move the cond_resched() check for CONFIG_PREEMPT_VOLUNTARY into
> > the low level copy_*_user code. This avoids some code bloat and
> > makes check much more efficient by avoiding unnecessary function calls.
> 
> May I suggest going one step further, and just removing the
> cond_resched() _entirely_, leaving just the debug test?
> 
> There really is zero reason for doing a cond_resched() for user
> accesses. If they take a page fault, then yes, by all means do that
> (and maybe we should add one to the page fault trap if we don't have
> it already), but without a page fault they really aren't that
> expensive.
> 
> We do many more expensive things without any cond_resched(), and doing
> that cond_resched() really doesn't make much sense *unless* there's a
> big expensive loop involved.
> 
> Most of this series looks fine, but I really think that we
> could/should just take that extra step, and say "no, user accesses
> don't imply that we need to check for scheduling".
> 
>                     Linus

In fact we are doing exactly this since 3.11-rc1.

-- 
MST
