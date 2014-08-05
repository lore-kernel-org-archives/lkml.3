Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaHEWgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 18:36:42 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:38026 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaHEWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 18:36:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140805210728.GH13858@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
	<CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
	<CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
	<20140805210728.GH13858@redhat.com>
Date: Tue, 5 Aug 2014 15:36:39 -0700
X-Google-Sender-Auth: rA6-4-Kf-wHyzaJyk2GKhrrBarY
Message-ID: <CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance()
 in scheduler
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 2:07 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Actually, "perf probe" does (via HAVE_DWARF_SUPPORT), to place probes
> and to extract variables at those probes, much as systemtap does.
> Without var-tracking, probes placed at most interior points of
> functions will make variables inaccessible.

.. and as mentioned, -O2 already does that for many things, even
*with* tracking.

In other words, anybody who relies on it has already learnt to work
around it. Or, more likely, there just isn't anybody who relies on it.

I don't understand how you guys can be so cavalier about a compiler
bug that has already resulted in actual real problems. You bring up
theoretical cases that nobody has actually reported, and are
apparently ignoring the fact that the compiler generates INCORRECT
CODE. So on one hand we have known breakage, on the other we have
theoretical "I can make an example" arguments of behavior that no sane
user has ever done.

Do you compile without -O2 too? Because I *guarantee* you that with
-O2 (even with tracking), you'll get "local variable 'xyz' optimized
away" cases.

Christ.

I have asked the compiler people at least twice whether there is some
way to limit it to just gcc-4.9.0/1, but the compiler people didn't
step up and say that it was safe.

In the meantime, crazy people can choose to compile with known-broken
compilers. Until you can get the compiler people to have some sane way
to know the problem is gone, I'm not going to maintain a kernel that
uses a known-broken compiler feature. It's that simple.

              Linus
