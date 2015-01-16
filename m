Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbbAPPzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbbAPPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:55:51 -0500
Date: Fri, 16 Jan 2015 16:54:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        pbonzini@redhat.com, tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 2/3] x86, fpu: don't abuse ->has_fpu in
	__kernel_fpu_{begin,end}()
Message-ID: <20150116155445.GA7249@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150115192005.GC27332@redhat.com> <54B876FD.3060702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B876FD.3060702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Rik van Riel wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 01/15/2015 02:20 PM, Oleg Nesterov wrote:
> > b/arch/x86/kernel/i387.c @@ -81,9 +81,7 @@ void
> > __kernel_fpu_begin(void) this_cpu_write(in_kernel_fpu, true);
> >
> > if (__thread_has_fpu(me)) { -		__thread_clear_has_fpu(me);
>
> I will put that line back in the patch series that defers the
> loading of FPU state until the switch to user space,

I think this needs more discussion.

Firstly, __thread_clear_has_fpu() should go into __kernel_fpu_end(), it
should replace restore_fpu_checking().

But does your series actually need this change? Correctness-wise this is
not needed (afaics). Performance-wise I am not sure, kernel_fpu_begin()
is unlikely event. Plus I am not sure this is a win (in general), but I
can be easily wrong.

> but I
> guess we can go either way for now...

Yes, this should not really conflict with your changes in any case.

Given that you acked 1/3 and 3/3, perhaps you can ack this one as well?

Oleg.

