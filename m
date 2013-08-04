Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab3HDOZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3HDOZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:25:44 -0400
Date: Sun, 4 Aug 2013 16:19:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Alex Thorlton <athorlton@sgi.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
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
        Al Viro <viro@zeniv.linux.org.uk>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130804141928.GA17935@redhat.com>
References: <20130802194659.GP26476@sgi.com> <20130802201301.A872BE0090@blue.fi.intel.com> <20130802203457.GR26476@sgi.com> <CAGXu5j+d3fzKWNtmPF9tyMg7PzHsKWQZkhu5tFaThLTZue=3JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+d3fzKWNtmPF9tyMg7PzHsKWQZkhu5tFaThLTZue=3JQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Kees Cook wrote:
>
> On Fri, Aug 2, 2013 at 1:34 PM, Alex Thorlton <athorlton@sgi.com> wrote:
> >
> >> And I think thp_disabled should be reset to 0 on exec.
> >
> > The main purpose for this getting carried down from the parent process
> > is that we'd like to be able to have a userland program set this flag on
> > itself, and then spawn off children who will also carry the flag.
> > This allows us to set the flag for programs where we're unable to modify
> > the code, thus resolving the issues detailed above.
>
> This could be done with LD_PRELOAD for uncontrolled binaries. Though
> it does seem sensible to make it act like most personality flags do
> (i.e. inherited).

It is only inheritable if the process is single-threaded.

And even if it is single-threaded I can't understand how it can really
help.

OK, transparent_hugepage_enabled() checks ->thp_disabled, but this is
the fault path. But this flag can't hide the task from khugepaged and
collapse_huge_page ?

I still think this should be mm flag. And we have MMF_INIT_MASK, it
can be inheritable.

Oleg.

