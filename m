Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab3G2V7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:59:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:46545 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab3G2V7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:59:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] DT, maintainership, development process
Date: Tue, 30 Jul 2013 00:09:42 +0200
Message-ID: <3402784.vRBPhVDbi3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130729081141.00818596@lwn.net>
References: <20130729102452.GA2682@zurbaran> <7008541.g5m1pJPVp1@vostro.rjw.lan> <20130729081141.00818596@lwn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 29, 2013 08:11:41 AM Jonathan Corbet wrote:
> On Mon, 29 Jul 2013 15:10:33 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > That actually is simple enough.
> > 
> > Check out the Linus' master branch and do
> > 
> > $ git log --ancestry-path --merges <commit>..
> 
> So I picked a recent, single-signoff patch mostly at random:
> 
> 	8ade62857ef77bdf639185410fbcd811aa700cb2
> 
> That "git log" command gives me 156 intervening commits involving at least
> a dozen networking trees, along with virtio, parisc, blackfin, x86, ...
> Even if one stops looking at the first merge performed by Linus, that's 47
> to look at.  Did that patch really pass through all those peoples' hands?
> 
> Plus, of course, this assumes there's no fast-forward merges in the mix.

Well, let's just say that the "git describe --contains" method described by
Paul (http://marc.info/?l=linux-kernel&m=137511549202238&w=4) is better and
using gitk also works, as noted by Jiri
(http://marc.info/?l=linux-kernel&m=137511562702289&w=4), but the point is that
the information is there and the effort needed to extract it is not
overwhelming.

What SOBs are useful for is to track the origins of a given patch before it
enters a git repository, but once that's happened, all of the history is
recorded by git.

> From your other message:
> 
> > And what about trusting maintainers?  If Linus trusts them enough to pull from
> > them, why can't everybody else trust them enough to assume that they don't do
> > bad things on purpose?
> 
> I hope you're not reading such thoughts into what *I* wrote.

No, I'm not.

And in fact this last paragraph of my previous message sounds much stronger
than I wanted it to.  I didn't mean things like adding bad code to the kernel
in a sneaky way, which in my opinion is out of the question.  I meant things
like making changes with the maintainer's own SOB without posting them for
public review beforehand, which would be an abuse of the process even if the
changes themselves were useful and correct.

> But most anybody who works on code occasionally does bad things by mistake,
> that's why we have a review process.

Of course.

But that has nothing to do with how many SOB tags there are in the given
commit log.  There are submitters whose patches already have a couple of them
when they are first posted.

A single SOB tag usually means that the committer himself is the author of
the change set and I don't see why this should be regarded as a bad thing in
principle.  Yes, it is technically possible for maintainers to "cheat", for
example by making unreviewed changes and pushing them upstream with their
own SOBs even without any linux-next testing, but they can do damage in some
other ways too if they are irresponsible.

We generally don't record information about what mailing lists the given patch
was submitted and how much time the maintainer waited for comments before
applying that patch.  I suppose we possibly could record it, but then I'm not
sure how useful that will be in general.  It definitely would mean more work
for maintainers and it's not like they don't have enough of that already.
Moreover, perhaps we can simply expect maintainers not to abuse the process?

I guess my point is that the fact that there are commits with one SOB tag only
doesn't have to mean that we have a problem of any sort and it even doesn't
have to indicate the existence of such a problem.

Commits that have never been in linux-next are much more problematic in my
opinion.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
