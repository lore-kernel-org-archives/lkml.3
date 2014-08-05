Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbaHEQtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:49:18 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:53740 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaHEQtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:49:16 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
Date: Tue, 5 Aug 2014 09:49:15 -0700
X-Google-Sender-Auth: RsCsiFkJqEkSl4apnQCAiu2ytZ0
Message-ID: <CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 4:31 AM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>
> Sorry to bring this back up after the fact, but it's important for a
> number of things in various distros

You said that before, and I ignored you before, because you didn't
actually give any examples.

>.  I don't disagree it should be
> disabled by default, but making it unconditional is going to force the
> distributions that care about perf, systemtap, and debuggers to
> manually revert this.

Bah. I bet I use 'perf' more than most, and it doesn't care about
debug info. Sure, if you want the annotated source code, or put probes
in place, you want the line number information, but the amount of
debug information it needs is miniscule, and not impacted bu this at
all afaik.

And systemtap people have more problems than this.

Debuggers? Again, people who actually use kgdb have bigger issues than
some slightly worse local variable tracking.  People care about the
frame pointer information and type information, but if you use kgdb on
the kernel you can damn well look at the assembly code and source code
annotation for local variable information.

So I call bullshit. Give a real example of real-world use, not some
random handwaving of cases that happen to use debug info but - at
least for the kernel - don't actually care about the variable
tracking.

The variable tracking is absolutely the *least* important part of the
debug info. By a huge margin. To the point of being entirely
irrelevant for the kernel. You make it sound like you lose all debug
information, when in reality that's not the case at all.

Trust me, you lose *way* more debug information because the kernel
uses "-O2" rather than "-O".

               Linus
