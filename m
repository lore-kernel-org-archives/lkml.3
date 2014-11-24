Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbaKXTHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:07:11 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36256 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbaKXTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:07:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141124184856.GA9349@laptop.dumpdata.com>
References: <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
	<CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
	<CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
	<20141121142301.564f7eb7@gandalf.local.home>
	<CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
	<CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
	<CALCETrX9CNx+Zs3timzxoccrqia1RiaOe5dj7crENnt2W6PGjg@mail.gmail.com>
	<CA+5PVA4mgpAg53bQKnXXgY3N0mkEZrUYf4rgOTHCV-pbK9UF3g@mail.gmail.com>
	<CALCETrUT3Pn0ZCMsgp9dyDvoaiszCrQRc4159Tyggo5wA6Mp7w@mail.gmail.com>
	<CA+5PVA5L1Vcs+nrJWZ+jXgnhQMZ_L22rksopPnO7Wt04jD3kUQ@mail.gmail.com>
	<20141124184856.GA9349@laptop.dumpdata.com>
Date: Mon, 24 Nov 2014 14:07:04 -0500
X-Google-Sender-Auth: cqMGhNndotkAxBhm678MzyR4c6Q
Message-ID: <CA+5PVA5pzWbvfLeu41CxFDGrwRruhx6_fQyR0=+kcbr9C1wuyw@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 1:48 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Nov 21, 2014 at 03:23:13PM -0500, Josh Boyer wrote:
>> On Fri, Nov 21, 2014 at 3:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Fri, Nov 21, 2014 at 12:14 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> >> On Fri, Nov 21, 2014 at 2:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> >>> On Fri, Nov 21, 2014 at 11:46 AM, Linus Torvalds
>> >>> <torvalds@linux-foundation.org> wrote:
>> >>>> On Fri, Nov 21, 2014 at 11:34 AM, Linus Torvalds
>> >>>> <torvalds@linux-foundation.org> wrote:
>> >>>>>
>> >>>>> So I kind of agree, but it wouldn't be my primary worry. My primary
>> >>>>> worry is actually paravirt doing something insane.
>> >>>>
>> >>>> Btw, on that tangent, does anybody actually care about paravirt any more?
>> >>>>
>> >>>
>> >>> Amazon, for better or for worse.
>
> And distros: Oracle and Novell.
>
>> >>>
>> >>>> I'd love to start moving away from it. It makes a lot of the low-level
>> >>>> code completely impossible to follow due to the random indirection
>> >>>> through "native" vs "paravirt op table". Not just the page table
>> >>>> handling, it's all over.
>> >>>>
>> >>>> Anybody who seriously does virtualization uses hw virtualization that
>> >>>> is much better than it used to be. And the non-serious users aren't
>> >>>> that performance-sensitive by definition.
>
> I would point out that the PV paravirt spinlock gives an huge boost
> for virtualization guests (this is for both KVM and Xen).
>> >>>>
>> >>>> I note that the Fedora kernel config seems to include paravirt by
>> >>>> default, so you get a lot of the crazy overheads..
>
> Not that much. We ran benchmarks and it was in i-cache overhead - and
> the numbers came out to be sub-1% percent.
>> >>>
>> >>> I think that there is a move toward deprecating Xen PV in favor of
>> >>> PVH, but we're not there yet.
>> >>
>> >> A move where?  The Xen stuff in Fedora is ... not paid attention to
>> >> very much.  If there's something we should be looking at turning off
>> >> (or on), we're happy to take suggestions.
>> >
>> > A move in the Xen project.  As I understand it, Xen wants to deprecate
>> > PV in favor of PVH, but PVH is still experimental.
>>
>> OK.
>>
>> > I think that dropping PARAVIRT in Fedora might be a bad idea for
>> > several more releases, since that's likely to break the EC2 images.
>>
>> Yes, that's essentially the only reason we haven't looked at disabling
>> Xen completely for a while now, so <sad trombone>.
>
> Heh. Didn't know you could play on a trombone!

It's sad because I can't really play the trombone and it sounds horrible.

> As I had mentioned in the past - if there are Xen related bugs on
> Fedora please CC me on them. Or perhaps CC xen-devel@lists.xenproject.org
> if that is possible.

Indeed, you have been massively helpful.  My comment on it being not
well paid attention to was a reflection on the distro maintainers, not
you.  You've been great once we notice the Xen issue, but that takes a
while on our part and it isn't the best of user experiences :\.

> And as Andy has mentioned - we are moving towards using PVH as a way
> to not use the PV MMU ops. But that is still off (<sad trombone played
> from YouTube>).

OK.  I'll try and do better at keeping up with things.

josh
