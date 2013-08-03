Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3HCTf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 15:35:26 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:38414 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3HCTfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 15:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130802203457.GR26476@sgi.com>
References: <20130802194659.GP26476@sgi.com>
	<20130802201301.A872BE0090@blue.fi.intel.com>
	<20130802203457.GR26476@sgi.com>
Date: Sat, 3 Aug 2013 12:35:22 -0700
X-Google-Sender-Auth: 9EjTM6t5U5ir587eCrcuP3KBpPo
Message-ID: <CAGXu5j+d3fzKWNtmPF9tyMg7PzHsKWQZkhu5tFaThLTZue=3JQ@mail.gmail.com>
Subject: Re: [PATCH] Add per-process flag to control thp
From: Kees Cook <keescook@chromium.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Robin Holt <holt@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 1:34 PM, Alex Thorlton <athorlton@sgi.com> wrote:
>> What kind of workloads are you talking about?
>
> Our benchmarking team has a list of several of the SPEC OMP benchmarks
> that perform significantly better when THP is disabled. I tried to get
> the list but one of our servers is acting up and I can't get to it
> right now :/
>
>> What's wrong with madvise? Could you elaborate?
>
> The main issue with using madvise is that it's not an option with static
> binaries, but there are also some users who have legacy Fortran code
> that they're not willing/able to change.
>
>> And I think thp_disabled should be reset to 0 on exec.
>
> The main purpose for this getting carried down from the parent process
> is that we'd like to be able to have a userland program set this flag on
> itself, and then spawn off children who will also carry the flag.
> This allows us to set the flag for programs where we're unable to modify
> the code, thus resolving the issues detailed above.

This could be done with LD_PRELOAD for uncontrolled binaries. Though
it does seem sensible to make it act like most personality flags do
(i.e. inherited).

-Kees

-- 
Kees Cook
Chrome OS Security
