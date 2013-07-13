Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3GMRwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 13:52:34 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42786 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3GMRwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 13:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <1373652854.17876.112.camel@gandalf.local.home>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org>
	<20130712025745.GA24086@tuxdriver.com>
	<20130712033430.GA3798@kroah.com>
	<51E03AEE.5010403@zytor.com>
	<20130712172836.GA7627@kroah.com>
	<1373651458.17876.103.camel@gandalf.local.home>
	<CA+55aFw6_1Lx-vJE=JGXbR_YYhWMqB+w69R1jDAcOrNCQc515Q@mail.gmail.com>
	<1373652854.17876.112.camel@gandalf.local.home>
Date: Sat, 13 Jul 2013 19:52:32 +0200
X-Google-Sender-Auth: VJp6QOhxGxvBr6PuD9YR3wvPvz0
Message-ID: <CAMuHMdXUib7req6ThCJdPy7jgKLODQzva10WQ-2mfkv7R92v1g@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ksummit-2013-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 8:14 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2013-07-12 at 10:59 -0700, Linus Torvalds wrote:
>> On Fri, Jul 12, 2013 at 10:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> > Perhaps just make a separate stable branch, where you cherry-pick the
>> > specific patch using the -x option. Adds a "(cherry picked from
>> > commit ...)". Then you could have some filter that monitors Linus
>> > commits and when a commit matches one of these patches, have it
>> > automatically sent to the stable list.
>>
>> Actually, please don't use -x very much. It doesn't much help, and it
>> can get very confusing before things are merged, and people who are on
>> one branch don't even see the other "identical" commit.
>>
>
> Actually I was trying to answer HPA's question about how to notify
> stable of a patch that wasn't tagged for stable, and one that you need
> to remember when its committed by you.
>
> Say I get a bunch of patches and add them to a branch queued for an -rc
> (all fixes for the current release). Then I notice that one of the
> patches is a fix for older kernels as well, but it has already been made
> public. As to tag it for stable would require a rebase, but its still in
> a queue to be sent to you, and others may have based their work on it.
> The question now is, how do I remember to notify stable of this patch
> when its part of a queue going to you already?
>
> Is it OK to cherry pick the patch separately, and add the stable tag,
> and queue that up to you first? That way the stable automated process
> will trigger when you take it.
>
> Basically, there's been times when branches have been made public before
> it is realized that a commit in that branch should go back to older
> trees, not just a fix for the current -rc release. Thus, this is not a
> question of sending a stable fix to you, but a fix that is already
> queued to go to you and later realize it needs to go to older trees as
> well. Greg likes it when you send that patch after it is in mainline.
> But remembering which patch to send isn't always trivial, and can be
> forgotten about. I was giving an answer to that question.
>
> Having the separate stable branch that will never be pushed to you and
> only used as a database of what needs to go to stable for older kernels
> is what I was going for. It doesn't need to be a git branch at all. It
> could just be a directory of files that was created via a git
> format-patch.

The git branch has the advantage of allowing git power tools for processing.

Say you "cherry-pick -x" all commits for stable to a private branch named
"for-stable".
Then "git cherry -v linus/master for-stable" will prefix all commits that are
already upstream with a minus sign, so you know when to ping stable.
Commits prefixed with a plus sign are still pending (or got applied with some
mutilation, i.e. you want to double-check).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
