Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaKUUXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:23:15 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:45483 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaKUUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:23:14 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUT3Pn0ZCMsgp9dyDvoaiszCrQRc4159Tyggo5wA6Mp7w@mail.gmail.com>
References: <alpine.DEB.2.11.1411202204030.3950@nanos>
	<20141120221122.GA25393@htj.dyndns.org>
	<alpine.DEB.2.11.1411202315230.3950@nanos>
	<20141120230514.GB25393@htj.dyndns.org>
	<CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
	<20141120233920.GC25393@htj.dyndns.org>
	<CALCETrUh_6tWdTyDwZ4U1BDSnN1khbGDGBvCTO3MVcdU-X23QA@mail.gmail.com>
	<20141121162742.GB15461@htj.dyndns.org>
	<CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
	<CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
	<20141121170805.GD30603@home.goodmis.org>
	<CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
	<CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
	<CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
	<CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
	<20141121142301.564f7eb7@gandalf.local.home>
	<CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
	<CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
	<CALCETrX9CNx+Zs3timzxoccrqia1RiaOe5dj7crENnt2W6PGjg@mail.gmail.com>
	<CA+5PVA4mgpAg53bQKnXXgY3N0mkEZrUYf4rgOTHCV-pbK9UF3g@mail.gmail.com>
	<CALCETrUT3Pn0ZCMsgp9dyDvoaiszCrQRc4159Tyggo5wA6Mp7w@mail.gmail.com>
Date: Fri, 21 Nov 2014 15:23:13 -0500
X-Google-Sender-Auth: Pozhhf03YgossGDDXFWgBoT4MVE
Message-ID: <CA+5PVA5L1Vcs+nrJWZ+jXgnhQMZ_L22rksopPnO7Wt04jD3kUQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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

On Fri, Nov 21, 2014 at 3:16 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Nov 21, 2014 at 12:14 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> On Fri, Nov 21, 2014 at 2:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Fri, Nov 21, 2014 at 11:46 AM, Linus Torvalds
>>> <torvalds@linux-foundation.org> wrote:
>>>> On Fri, Nov 21, 2014 at 11:34 AM, Linus Torvalds
>>>> <torvalds@linux-foundation.org> wrote:
>>>>>
>>>>> So I kind of agree, but it wouldn't be my primary worry. My primary
>>>>> worry is actually paravirt doing something insane.
>>>>
>>>> Btw, on that tangent, does anybody actually care about paravirt any more?
>>>>
>>>
>>> Amazon, for better or for worse.
>>>
>>>> I'd love to start moving away from it. It makes a lot of the low-level
>>>> code completely impossible to follow due to the random indirection
>>>> through "native" vs "paravirt op table". Not just the page table
>>>> handling, it's all over.
>>>>
>>>> Anybody who seriously does virtualization uses hw virtualization that
>>>> is much better than it used to be. And the non-serious users aren't
>>>> that performance-sensitive by definition.
>>>>
>>>> I note that the Fedora kernel config seems to include paravirt by
>>>> default, so you get a lot of the crazy overheads..
>>>
>>> I think that there is a move toward deprecating Xen PV in favor of
>>> PVH, but we're not there yet.
>>
>> A move where?  The Xen stuff in Fedora is ... not paid attention to
>> very much.  If there's something we should be looking at turning off
>> (or on), we're happy to take suggestions.
>
> A move in the Xen project.  As I understand it, Xen wants to deprecate
> PV in favor of PVH, but PVH is still experimental.

OK.

> I think that dropping PARAVIRT in Fedora might be a bad idea for
> several more releases, since that's likely to break the EC2 images.

Yes, that's essentially the only reason we haven't looked at disabling
Xen completely for a while now, so <sad trombone>.

josh
