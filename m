Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161237Ab3DFW3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 18:29:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40607 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161168Ab3DFW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 18:29:02 -0400
Date: Sun, 7 Apr 2013 00:28:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] doc: Hold down best practices for pull requests
Message-ID: <20130406222853.GC3612@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
References: <1362314580-25602-1-git-send-email-bp@alien8.de>
 <51608BBE.8030703@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51608BBE.8030703@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 01:55:26PM -0700, Randy Dunlap wrote:
> On 03/03/13 04:43, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Hold down some important points to pay attention to when preparing a
> > pull request to upper-level maintainers and/or Linus. Based on a couple
> > of agitated mails from Linus to maintainers and random crowd sitting
> > around.
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > ---
> > 
> > Ok,
> > 
> > so here's what I have. I took your message from yesterday and
> > morphed/fleshed it out into a set of points to pay attention to when
> > prepping a pull request. I also sampled some more rants from last year
> > to get a couple more recurring issues.
> > 
> > I hope I've covered the most important points.
> > 
> > Thanks.
> > 
> >  Documentation/SubmittingPullRequests | 148 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 148 insertions(+)
> >  create mode 100644 Documentation/SubmittingPullRequests
> > 
> > diff --git a/Documentation/SubmittingPullRequests b/Documentation/SubmittingPullRequests
> > new file mode 100644
> > index 000000000000..d123745e0cf5
> > --- /dev/null
> > +++ b/Documentation/SubmittingPullRequests
> > @@ -0,0 +1,148 @@
> > +	Trees, merges and other hints for maintainers of all levels
> > +	===========================================================
> > +
> > +... or how do I send my tree to Linus without him biting my head off.
> > +
> > +
> > +This is a collection of hints, notes, suggestions and accepted practices
> > +for sending pull requests to (other maintainers which then forward those
> > +trees to) Linus. It is loosely based on Linus' friendly and polite hints
> > +to maintainers on the Linux Kernel Mailing List and the idea behind it
> > +is to document the most apparent do's and dont's, thus saving time and
> > +money of everyone involved.
> > +
> > +Basically, pull requests and merge commits adhering to the guidelines
> > +described below should establish certain practices which make
> > +development history as presentable, useful and sensible as possible.
> > +
> > +People staring at it should be able to understand what went where, when
> > +and why, without encountering senseless merge commits and internal
> > +subsystem development state which don't have any bearing on the final,
> > +cast-in-stone history. A second, not less important reason is tree
> > +bisectability.
> > +
> > +Here we go:
> > +
> > +0.) Before asking any maintainer to pull a pile of patches, make damn
> > +well sure that said pile is stable, works, and has been extensively,
> > +thoroughly and to the best of your abilities, tested. There's absolutely
> > +no reason in rushing half-cooked patches just because your manager says
> > +so. Rule of thumb is: if the patches are so done that they're boringly
> > +missing any issues or regressions and you've almost forgotten them in
> > +linux-next, *then* you can send.
> > +
> > +1.) The patchset going to an upper level maintainer should NOT be based
> > +on some random, potentially completely broken commit in the middle of a
> > +merge window, or some other random point in the tree history.
> > +
> > +Tangential to that, it shouldn't contain back-merges - not to "next"
> > +trees, and not to a "random commit of the day" in Linus' tree.
> > +
> > +Why, you ask?
> > +
> > +Linus: "Basically, I do not want people's development trees to worry
> > +about some random crazy merge-window tree of the day. You should always
> > +pick a good starting point that makes sense (where "makes sense" is very
> > +much about "it's stable and well known" and just do your own thing. What
> > +other people do should simply not concern you over-much. You are the
> > +[ ... ] maintainer, and your job is not integration, it's to make sure
> > +that *your* work is as stable and unsurprising as possible."
> > +
> > +2.) Write a sensible, human-readable mail message explaining in terms
> > +understandable to outsiders what your patchset entails, maybe describe
> > +the high-level big picture of where your patchset fits and why. And
> > +do not use abbreviations - they might be clear to you and the people
> > +working on your subsystem but not necessarily to the rest of the world.
> > +Also, include the diffstat in that mail (git request-pull should take
> > +care of all that nicely).
> > +
> > +3.) GPG-sign your pull request and put the high-level description you've
> > +created into the signed tag. Of course, your key should be signed by
> > +fellow developers who are in the chain of trust of the receiving end of
> > +your pull request.
> > +
> > +4.) The URL of your pull request should contain the signed tag. Make
> > +sure that URL is valid and externally accessible. This is especially
> > +valid for the k.org crowd who get it wrong a *lot*. Also, people tend to
> > +forget to push the signed tag.
> > +
> > +5.) THEN AND ONLY THEN do we start worrying about possible merge issues
> > +your pull request could cause with upstream. It can be very helpful if
> > +you look into and describe them in the pull request mail, maybe even do
> > +an *example* merge. This merge won't normally be used but it is very
> > +helpful to show the person doing the merge how to resolve possible
> > +conflicts.
> > +
> > +Here's Linus counting the ways why you shouldn't make merges yourself:
> > +
> > +" - I'm usually a day or two behind in my merge queue anyway, partly
> > +because I get tons of pull requests in a short while and I just want
> > +to get a feel for what's going on, and partly because I tend to do
> > +pulls in waves of "ok, I'm going filesystems now, then I'll look at
> 
>                               doing ?
> 
> > +drivers".
> > +
> > + - I do a *lot* of merges. I try to make them look good, and have
> > +*explanations* in them. And if a merge conflict happens, I want to
> > +know about them.
> > +
> > + - I want to have a gut feel about what goes into the tree when. I
> > +know, for example, that "oops, we had a bug in ext4 that got
> > +discovered only after the merge, and for a while there it didn't work
> > +well with larger disks". When people complain, my job is often to have
> > +that high-level view of "ok, you're hitting this known bug". If people
> > +do back-merges, that basically pulls in my tree at some random point
> > +that I'm not even aware of, and now you mixed up *other* peoples bugs
> > +into your tree.
> > +
> > + - and somewhat most importantly (for me personally): backmerges make
> > +history messy, and it can be a huge pain for me when I do merge
> > +conflict resolution, or when other people do bisects etc. It's *much*
> > +nicer in many ways (visually, and for bisect reasons) to try to have
> > +as much independent development as possible."
> > +
> > +One more from LKML history: it can happen that your merge *actually*
> > +breaks upstream because it refers to symbols which are being removed by
> > +another, previous merge. So don't merge.
> > +
> > +6.) Avoid an excessive amount of senseless cross-merges. Think of
> > +it this way: a merge appearing in the final git history has to mean
> > +something, it has to say why it is there. So, having too many pointless
> > +merges simply pollutes the history and devalues it. Instead, think of
> > +a good point to do a cross merge, do it and *document* exactly why it is
> > +there.
> > +
> > +7.) And while we're at it, you should *almost* *never* rebase your
> > +tree. More so if it has gone public and people are possibly relying on
> > +it to remain stable and basing their stuff on top - especially then
> > +you're absolutely not allowed to rebase it anymore. But that's not that
> > +problematic if you've adopted the incremental development model and your
> > +tree is at least as well-cooked as in 1) above.
> > +
> > +IOW, "rebasing has other deeper problems too, like the fact that your
> 
> missing ending '"' somewhere.
> 
> > +tree is no longer something that other people can depend on. That's not
> > +a big issue for a new architecture, but it's a big issue going forward.
> > +Which is why rebasing is generally even *worse* than back-merges (but
> > +both are basically big "just don't do that").
> > +
> > +So the rule for both rebasing and back-merging should be:
> > +
> > + - you should have damn good reasons for it, and you should document
> > +them.
> > +
> > + - you should basically *never* rebase or back-merge random commits in
> 
> hm, sometimes it is backmerge and other times it is back-merge.  Please be
> consistent.
> 
> > +the merge window. That's *NEVER* a good idea. If you have a conflict,
> > +ignore it. Explain it to me when you ask me to pull, but it is *my* job
> > +to know "ok, I've pulled fiftynine different trees, and trees X and Y
> 
>                             fifty-nine
> 
> > +end up conflicting, and this is how it got resolved". Seriously.
> > +
> > + - if you have some really long-lived development tree, and you want to
> > +back-merge just to not be *too* far away, back-merge to actual releases.
> > +Don't pull my master branch. Say "git merge v3.8" or something like
> > +that, and then you write a good merge message that talks about *why* you
> > +wanted to update to a new release."
> > +
> > +8.) After the maintainer has pulled, it is always a good idea to take a
> > +look at the merge and verify it has happened as you've expected it to,
> > +maybe even run your tests on it to double-check everything went fine.
> > +
> > +Further reading: Documentation/development-process/*
> > 
> Looks good and useful overall.

Yeah, thanks for looking at this.

Most of those above are Linus quotes so I didn't look at language issues
there - their absolute correctness is not even that important as long as
the message of do's and dont's for maintainers comes across correctly
and people understand the bulk of it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
