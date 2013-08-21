Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab3HUBDP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:03:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3HUBDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:03:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130821004924.GA19098@kroah.com>
References: <20130820224032.GA20491@kroah.com>
	<CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
	<20130820235700.GA7209@kroah.com>
	<CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
	<20130821004924.GA19098@kroah.com>
Date: Tue, 20 Aug 2013 21:03:12 -0400
X-Google-Sender-Auth: hxPp_YxK2tD3oshnUQ7ZIDdLvks
Message-ID: <CA+5PVA4Bf7mbB9qFWPfcX-xQDeKPoBKSjW_hF-td9sUUkFRDJQ@mail.gmail.com>
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

On Tue, Aug 20, 2013 at 8:49 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Aug 20, 2013 at 08:41:23PM -0400, Josh Boyer wrote:
>> On Tue, Aug 20, 2013 at 7:57 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> I like this overall.  The only thing I might change is "wait for -rc2"
>> >> for patches tagged with CC: stable that go in during the merge window.
>> >>  It seems those are the ones that tend to bite us.
>> >
>> > Maintainers can always tag their patches to have me hold off until -rc2
>> > for that.
>>
>> They can (not immediately sure how though?)
>
> Some do:
>         Cc: stable <stable@vger.kernel.org> # after -rc5 is out
> or
>         Cc: stable <stable@vger.kernel.org> # wait a -rc cycle
> or
>         Cc: stable <stable@vger.kernel.org> # wait a few weeks to bake
>
>> , but they don't with the
>> exception of the few that don't tag at all and send you patches in
>> bundles.  I mean, that's what the huge thread about the stable trees
>> that hopefully leads to a conversation at KS is about, right?
>
> Hopefully, yes, but I don't know about that yet.
>
>> Let me phrase this as a question instead.  Is there something we can
>> do to help catch the patches that get sucked into stable during the
>> merge window and then wind up causing issues and reverted/fixed after
>> things settle down in the -rc releases?
>
> Test linux-next and Linus's tree-of-the-day better.  If problems happen,
> and a patch has a cc: stable@ on it, let stable@ know about it.

Ah, yes.  I forgot about the "look through linux-next for CC: stable".
 That could probably be automated to a degree even.

We already build a Linus kernel in rawhide at least once a day.  Two
flavors even, once with debug options enabled and once without.  The
three of us run it and have an autotest setup going and being
improved, but there is no substitute for wide-spread user testing.
Unfortunately, we have problems getting that with rawhide for various
reasons.

>> I'm offering to help in whatever way you think is best.  It's your
>> workflow (and sanity) that are the most impacted.  However, I share
>> the pain whenever something breaks in stable through the wonderful
>> place that is Fedora bugzilla so I'm looking for ways to reduce that.
>
> Letting me know when something breaks is always good as well.  Right now
> that doesn't seem to happen much, so either not much is breaking, or I'm
> just not told about it, I don't know which.

There's no need to reply specifically to these, but off the top of my
head just for 3.10.y:

brcmsmac explodes in 3.10.{6,7,8,9}.  I think you know about that one
already and Felix and Arend are working on it.

Suspend/Resume is broken on a variety of Thinkpad T400 and T500
machines in 3.10.  This was true with 3.10.0 afaik.  Current thinking
is that it's related to the Intel mei/mei_me driver(s).  Blacklisting
those seems to fix things for a number of users.  There are patches in
3.11-rcX, but the "fix" highlighted doesn't fix it.

There were various i915 backlight issues reported with 3.10.3/4.  I
believe they were fixed with 3.10.5.

USB storage was broken because of the mishandled VPD stuff.  Fixed in 3.10.7.

I'm aware I'm reporting issues that you either already knew about or
were already fixed.  The problem we have is that we roll out a new
stable release and then we get bug reports for 2 weeks because not
everyone updates as frequently as stable releases, etc.  So something
that may seem to impact a small number of users at the time winds up
actually impacting lots of users once it rolls out in a distro.  As
far as I know, Fedora is possibly the only distro actually pushing
stable release kernels out on a normal basis.  I'd love to be wrong on
that point.

In the future, if we can get the information from the end user in
time, I'll be happy to forward issues that aren't already reported
onwards.  Or if you still want to hear about it, I can chime in on the
existing threads with bugzilla numbers.  I'm also willing to do a
monthly "patches we're carrying not in stable" report if people find
that helpful.  I'll likely be doing that within Fedora already and I'm
happy to send it to stable@, even if those patches aren't exactly
stable-rules matching.  We did that when kernel.org went down and it
helped then, just not sure how much it would help now or if people
care.

josh
