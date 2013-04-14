Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3DNGqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:46:25 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:51215 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3DNGqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:46:23 -0400
Date: Sun, 14 Apr 2013 01:46:18 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] doc: Hold down best practices for pull requests
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
In-Reply-To: <51608BBE.8030703@infradead.org> (from rdunlap@infradead.org on
	Sat Apr  6 15:55:26 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365921978.18069.97@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2013 03:55:26 PM, Randy Dunlap wrote:
> On 03/03/13 04:43, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> >
> > Hold down some important points to pay attention to when preparing a
> > pull request to upper-level maintainers and/or Linus. Based on a  
> couple
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
> > prepping a pull request. I also sampled some more rants from last  
> year
> > to get a couple more recurring issues.
> >
> > I hope I've covered the most important points.
> >
> > Thanks.
> >
> >  Documentation/SubmittingPullRequests | 148  
> +++++++++++++++++++++++++++++++++++
> >  1 file changed, 148 insertions(+)
> >  create mode 100644 Documentation/SubmittingPullRequests
> >
> > diff --git a/Documentation/SubmittingPullRequests  
> b/Documentation/SubmittingPullRequests
> > new file mode 100644
> > index 000000000000..d123745e0cf5
> > --- /dev/null
> > +++ b/Documentation/SubmittingPullRequests
> > @@ -0,0 +1,148 @@
> > +	Trees, merges and other hints for maintainers of all levels
> > +	===========================================================
> > +
> > +... or how do I send my tree to Linus without him biting my head  
> off.
> > +
> > +
> > +This is a collection of hints, notes, suggestions and accepted  
> practices
> > +for sending pull requests to (other maintainers which then forward  
> those
> > +trees to) Linus. It is loosely based on Linus' friendly and polite  
> hints
> > +to maintainers on the Linux Kernel Mailing List and the idea  
> behind it
> > +is to document the most apparent do's and dont's, thus saving time  
> and
> > +money of everyone involved.

"Loosely based on Linus's hints to maintainers on the Linux Kernel  
Mailing List."

The rest is throat clearing.

> > +Basically, pull requests and merge commits adhering to the  
> guidelines
> > +described below should establish certain practices which make
> > +development history as presentable, useful and sensible as  
> possible.
> > +
> > +People staring at it should be able to understand what went where,  
> when
> > +and why, without encountering senseless merge commits and internal
> > +subsystem development state which don't have any bearing on the  
> final,
> > +cast-in-stone history. A second, not less important reason is tree
> > +bisectability.

That can be replaced with:

Pull requests should ensure the upstream tree is bisectable, and  
present development history that clearly shows what went where, when  
and why, without extra merge commits and internal subsystem development.

> > +Here we go:

Ahem.

> > +0.) Before asking any maintainer to pull a pile of patches, make  
> damn
> > +well sure that said pile is stable, works, and has been  
> extensively,
> > +thoroughly and to the best of your abilities, tested. There's  
> absolutely
> > +no reason in rushing half-cooked patches just because your manager  
> says
> > +so. Rule of thumb is: if the patches are so done that they're  
> boringly
> > +missing any issues or regressions and you've almost forgotten them  
> in
> > +linux-next, *then* you can send.

As a developer, this is where I'd stop reading. (Because nobody ever  
has an actual bug that needs to be fixed in a timely manner.)

This says to a maintainer "you are careless and your code sucks". It  
doesn't say "any user interface that goes upstream is cast in stone and  
you'll regret getting it wrong almost immediately but it's too late!"  
Nor "cry wolf and they'll stop paying attention to you". Nor "a  
thousand experienced developers will find bugs you couldn't find, so  
making them find bugs you DIDN'T find but could have makes you look  
like an idiot"...

> > +1.) The patchset going to an upper level maintainer should NOT be  
> based
> > +on some random, potentially completely broken commit in the middle  
> of a
> > +merge window, or some other random point in the tree history.
> > +
> > +Tangential to that, it shouldn't contain back-merges - not to  
> "next"
> > +trees, and not to a "random commit of the day" in Linus' tree.

Could you do positive advice first instead of negative advice? "Base  
your tree on a release version, and never re-pull between releases  
without a damn good reason."

Not "don't do this, don't do this, don't do this" and make them figure  
out what they _should_ do by process of elimination.

> > +Why, you ask?
> > +
> > +Linus: "Basically, I do not want people's development trees to  
> worry
> > +about some random crazy merge-window tree of the day. You should  
> always
> > +pick a good starting point that makes sense (where "makes sense"  
> is very
> > +much about "it's stable and well known" and just do your own  
> thing. What
> > +other people do should simply not concern you over-much. You are  
> the
> > +[ ... ] maintainer, and your job is not integration, it's to make  
> sure
> > +that *your* work is as stable and unsurprising as possible."
> > +
> > +2.) Write a sensible, human-readable mail message explaining in  
> terms
> > +understandable to outsiders what your patchset entails, maybe  
> describe
> > +the high-level big picture of where your patchset fits and why. And
> > +do not use abbreviations - they might be clear to you and the  
> people
> > +working on your subsystem but not necessarily to the rest of the  
> world.
> > +Also, include the diffstat in that mail (git request-pull should  
> take
> > +care of all that nicely).

I read that and went "surely [PATCH 0/X] is mentioned in  
SubmittingPatches, but apparently that file's been bikeshedded to  
death. ("Include PATCH in the subject" is item 11 in the list. Oy.)

Was this new file created because the old file is considered unfixable?

> > +3.) GPG-sign your pull request and put the high-level description  
> you've
> > +created into the signed tag. Of course, your key should be signed  
> by
> > +fellow developers who are in the chain of trust of the receiving  
> end of
> > +your pull request.

If you haven't got a GPG key signed by the in-crowd of kernel  
developers, we don't want to hear from you because you're not one of us?

> > +4.) The URL of your pull request should contain the signed tag.  
> Make
> > +sure that URL is valid and externally accessible. This is  
> especially
> > +valid for the k.org crowd who get it wrong a *lot*. Also, people  
> tend to
> > +forget to push the signed tag.

Could you provide an example of how to do it right for people who  
aren't already intimately familiar with a tool with a notoriously  
horrible user interface, even in the context of unix?

> > +5.) THEN AND ONLY THEN do we start worrying about possible merge  
> issues
> > +your pull request could cause with upstream. It can be very  
> helpful if
> > +you look into and describe them in the pull request mail, maybe  
> even do
> > +an *example* merge. This merge won't normally be used but it is  
> very
> > +helpful to show the person doing the merge how to resolve possible
> > +conflicts.

What linus basically said is he wants to resolve the merge conflicts  
himself because it's educational for him to know how the systems  
interact. (If the people you ask to pull want you to resolve a  
conflict, they'll tell you.)

I didn't get that from your paragraph.

> > +Here's Linus counting the ways why you shouldn't make merges  
> yourself:
> > +
> > +" - I'm usually a day or two behind in my merge queue anyway,  
> partly
> > +because I get tons of pull requests in a short while and I just  
> want
> > +to get a feel for what's going on, and partly because I tend to do
> > +pulls in waves of "ok, I'm going filesystems now, then I'll look at
> 
>                               doing ?
> 
> > +drivers".

Given that he's quoting linus, it would be "[doing]".

> > +
> > + - I do a *lot* of merges. I try to make them look good, and have
> > +*explanations* in them. And if a merge conflict happens, I want to
> > +know about them.
> > +
> > + - I want to have a gut feel about what goes into the tree when. I
> > +know, for example, that "oops, we had a bug in ext4 that got
> > +discovered only after the merge, and for a while there it didn't  
> work
> > +well with larger disks". When people complain, my job is often to  
> have
> > +that high-level view of "ok, you're hitting this known bug". If  
> people
> > +do back-merges, that basically pulls in my tree at some random  
> point
> > +that I'm not even aware of, and now you mixed up *other* peoples  
> bugs
> > +into your tree.
> > +
> > + - and somewhat most importantly (for me personally): backmerges  
> make
> > +history messy, and it can be a huge pain for me when I do merge
> > +conflict resolution, or when other people do bisects etc. It's  
> *much*
> > +nicer in many ways (visually, and for bisect reasons) to try to  
> have
> > +as much independent development as possible."

For long quoted sections like this, is there a way to indent them or  
something? A quote character at the beginning and another at the end  
isn't much help for 4 paragraphs that internally contain quote  
characters (and the first paragraph of which ends with one).

> > +One more from LKML history: it can happen that your merge  
> *actually*
> > +breaks upstream because it refers to symbols which are being  
> removed by
> > +another, previous merge. So don't merge.

Your branch you submit for pulling should not contain merges. That  
doesn't mean you can't have a _separate_ branch that you merge and  
track upstream development with.

You've never mentioned "git help cherry-pick" so far...

> > +6.) Avoid an excessive amount of senseless cross-merges. Think of
> > +it this way: a merge appearing in the final git history has to mean
> > +something, it has to say why it is there. So, having too many  
> pointless
> > +merges simply pollutes the history and devalues it. Instead, think  
> of
> > +a good point to do a cross merge, do it and *document* exactly why  
> it is
> > +there.

So "don't merge", and here's another "don't merge". (And you don't say  
how a cross-merge differs from any other kind of merge.)

The tree you submit upstream should not include unnecessary merge  
commits. Merging back upstream will usually introduce a merge commit  
where the maintainer gets to summarize and comment on your work. If you  
are not that maintainer, put your summary in your pull request and let  
them make the merge commit.

Is that the point you're trying to make?

> > +7.) And while we're at it,

Throat clearing.

> > +you should *almost* *never* rebase your
> > +tree. More so if it has gone public and people are possibly  
> relying on
> > +it to remain stable and basing their stuff on top - especially then
> > +you're absolutely not allowed to rebase it anymore. But that's not  
> that
> > +problematic if you've adopted the incremental development model  
> and your
> > +tree is at least as well-cooked as in 1) above.

You can always start a new branch and cherry pick clean changes on top  
of it.

> > +IOW, "rebasing has other deeper problems too, like the fact that  
> your
> 
> missing ending '"' somewhere.
> 
> > +tree is no longer something that other people can depend on.  
> That's not
> > +a big issue for a new architecture, but it's a big issue going  
> forward.
> > +Which is why rebasing is generally even *worse* than back-merges  
> (but
> > +both are basically big "just don't do that").

All of this stuff about rebasing boils down to:

If you rewrite published history, you screw up anybody who's pulled  
from you. (Git 101.) Doing that to linux maintainers means they stop  
listening to you. So never rebase published branches, create a new  
branch instead.

> > +So the rule for both rebasing and back-merging should be:
> > +
> > + - you should have damn good reasons for it, and you should  
> document
> > +them.
> > +
> > + - you should basically *never* rebase or back-merge random  
> commits in
> 
> hm, sometimes it is backmerge and other times it is back-merge.   
> Please be
> consistent.
> 
> > +the merge window. That's *NEVER* a good idea. If you have a  
> conflict,
> > +ignore it. Explain it to me when you ask me to pull, but it is  
> *my* job
> > +to know "ok, I've pulled fiftynine different trees, and trees X  
> and Y
> 
>                             fifty-nine
> 
> > +end up conflicting, and this is how it got resolved". Seriously.

I.E. Linus (or the subsystem maintainer) usually want to resolve their  
own conflicts so they can see why it conflicted, and when they want you  
to do it instead they'll let you know.

> > + - if you have some really long-lived development tree, and you  
> want to
> > +back-merge just to not be *too* far away, back-merge to actual  
> releases.
> > +Don't pull my master branch. Say "git merge v3.8" or something like
> > +that, and then you write a good merge message that talks about  
> *why* you
> > +wanted to update to a new release."

Why is "create a new branch instead" (as stated above) wrong here?  
Isn't that what the realtime guys do?

> > +8.) After the maintainer has pulled, it is always a good idea to  
> take a
> > +look at the merge and verify it has happened as you've expected it  
> to,
> > +maybe even run your tests on it to double-check everything went  
> fine.
> > +
> > +Further reading: Documentation/development-process/*
> >
> 
> Looks good and useful overall.

Looks longer than necessary to me, and if we have a  
Documentation/development-process why isn't this going in there instead  
of at the top level? (Although really why isn't it just another couple  
bullet points under submittingpatches?)

Rob