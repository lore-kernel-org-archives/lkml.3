Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaLKGg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 01:36:29 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34643 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaLKGg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 01:36:27 -0500
Date: Thu, 11 Dec 2014 07:36:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141211063621.GC5059@gmail.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
 <862cbb2ab71a9f71d1123b5512605350a4b61846.1418006970.git.shli@fb.com>
 <CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
 <20141210215713.GA30230@devbig257.prn2.facebook.com>
 <CALCETrUi--fmZLBUB=tjmGt_D3y+HJ+MtJTRZ0=JUKFgAvxyuA@mail.gmail.com>
 <20141210225627.GA11754@devbig257.prn2.facebook.com>
 <CALCETrXpVUVY6paKJq0Uq8VeHG2A0E3qc4b_H+5ZT-QJApkaJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXpVUVY6paKJq0Uq8VeHG2A0E3qc4b_H+5ZT-QJApkaJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Dec 10, 2014 at 2:56 PM, Shaohua Li <shli@fb.com> wrote:
> > On Wed, Dec 10, 2014 at 02:13:23PM -0800, Andy Lutomirski wrote:
> >> On Wed, Dec 10, 2014 at 1:57 PM, Shaohua Li <shli@fb.com> wrote:
> >> > On Wed, Dec 10, 2014 at 11:10:52AM -0800, Andy Lutomirski wrote:
> >> >> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
> >> >> > This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
> >> >> > use the following method to compute the thread cpu time:
> >> >>
> >> >> I like the idea, and I like making this type of profiling fast.  I
> >> >> don't love the implementation because it's an information leak (maybe
> >> >> we don't care) and it's ugly.
> >> >>
> >> >> The info leak could be fixed completely by having a per-process array
> >> >> instead of a global array.  That's currently tricky without wasting
> >> >> memory, but it could be created on demand if we wanted to do that,
> >> >> once my vvar .fault patches go in (assuming they do -- I need to ping
> >> >> the linux-mm people).
> >> >
> >> > those info leak really doesn't matter.
> >>
> >> Why not?
> >
> > Ofcourse I can't make sure completely, but how could this 
> > info be used as attack?
> 
> It may leak interesting timing info, even from cpus that are 
> outside your affinity mask / cpuset.  I don't know how much 
> anyone actually cares.

Finegraned timing information has been successfully used to 
recover secret keys (and sometimes even coarse timing 
information), so it can be a security issue in certain setups.

Thanks,

	Ingo
