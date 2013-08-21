Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3HUAl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:41:26 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:64073 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3HUAlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130820235700.GA7209@kroah.com>
References: <20130820224032.GA20491@kroah.com>
	<CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
	<20130820235700.GA7209@kroah.com>
Date: Tue, 20 Aug 2013 20:41:23 -0400
X-Google-Sender-Auth: QKlIA44JX4SJ2VhEsD1d8fwuPY8
Message-ID: <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
Subject: Re: Proposed stable release changes
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 7:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 20, 2013 at 07:40:49PM -0400, Josh Boyer wrote:
>> On Tue, Aug 20, 2013 at 6:40 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> > Hi all,
>> >
>> > Given that I had to just revert a patch in the recent stable releases
>> > that didn't get enough time to "bake" in Linus's tree (or in -next), I
>> > figured it was worth discussing some possible changes with how "fast" I
>> > pick up patches for stable releases.
>> >
>> > So, how about this proposal:
>> >
>> > - I will wait for a -rc to come out with the patch in it before putting
>> >   it into a stable release, unless:
>> >         - the maintainer ACKs it, or sends it directly (like DaveM does
>> >           for networking patches)
>> >         - I have seen enough discussion about a patch to show that it
>> >           really does fix something / is good / doesn't cause problems.
>> >         - obviously safe, i.e. "add a device id" type thing.
>> >
>> > Given that we have -rc releases every week, except for the initial -rc1
>> > release, I don't think this will really cause any major delays.
>> >
>> > Also, now that we are about to head into my busy "travel season", odds
>> > are, I'll be at least a week behind anyway, so this would probably start
>> > happening without an "official" change.  It's been a boring summer, I've
>> > been able to keep up with the stable stuff really easily, causing
>> > problems like this :)
>> >
>> > Objections?  Comments?
>>
>> I like this overall.  The only thing I might change is "wait for -rc2"
>> for patches tagged with CC: stable that go in during the merge window.
>>  It seems those are the ones that tend to bite us.
>
> Maintainers can always tag their patches to have me hold off until -rc2
> for that.

They can (not immediately sure how though?), but they don't with the
exception of the few that don't tag at all and send you patches in
bundles.  I mean, that's what the huge thread about the stable trees
that hopefully leads to a conversation at KS is about, right?

> And, given the huge number of patches for stable that come in during
> the -rc1 merge window, there's no way I can get to them all before -rc2
> comes out, so this will probably end up being the case for most of them
> anyway.

Sheer numbers forcing some to be pushed out isn't really that great
when the problem is spread across the whole window.  I'm not saying
you aren't correct that a lot of them don't get pushed to stable
releases until post -rc2, but at that point you're playing catch up.
I was suggesting just sitting on them until -rc2 entirely.  Basically,
don't release a stable kernel until the next version is at -rc2.

Let me phrase this as a question instead.  Is there something we can
do to help catch the patches that get sucked into stable during the
merge window and then wind up causing issues and reverted/fixed after
things settle down in the -rc releases?

Reviewing the patches submitted for those stable kernels isn't
necessarily sufficient, since the issues I'm concerned about aren't
spotted until after the release anyway.  It's a two-fold problem.  The
first is one we're never going to fix in that people are human and
make mistakes and sometimes patches don't get tested well enough
before they're tagged for stable.  The second issue is a combination
of timing and volume.  I doubt we're going to fix the volume since we
keep touting the increasing change rate as a sign of success, but
could we fix the timing by forcing things to bake more in the -rc
releases?

I'm offering to help in whatever way you think is best.  It's your
workflow (and sanity) that are the most impacted.  However, I share
the pain whenever something breaks in stable through the wonderful
place that is Fedora bugzilla so I'm looking for ways to reduce that.

josh
