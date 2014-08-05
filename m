Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbaHEXb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754193AbaHEXbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:31:10 -0400
Date: Tue, 5 Aug 2014 19:30:58 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance() in scheduler
Message-ID: <20140805233058.GI13858@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org> <20140730014829.344302554@linuxfoundation.org> <20140730065312.GA1652@laptop.redhat.com> <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com> <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com> <CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com> <CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com> <20140805210728.GH13858@redhat.com> <CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Aug 05, 2014 at 03:36:39PM -0700, Linus Torvalds wrote:
> > Actually, "perf probe" does (via HAVE_DWARF_SUPPORT), to place probes
> > and to extract variables at those probes, much as systemtap does.
> > Without var-tracking, probes placed at most interior points of
> > functions will make variables inaccessible.
> 
> .. and as mentioned, -O2 already does that for many things, even
> *with* tracking.

The whole point of variable tracking was to make -O2 usable (though
still imperfect) for those who use debuggers and such tools.


> [...]  I don't understand how you guys can be so cavalier about a
> compiler bug that has already resulted in actual real problems.

No one is minimizing the problem.  We are looking for a knob for those
who know that their compiler does not have that bug.  (Plus, those who
don't care about debug data could use CONFIG_DEBUG_INFO=n with the bad
compiler.)


> You bring up theoretical cases that nobody has actually reported
> [...]

I assure you that the years of effort that went into gcc variable
tracking was justified with actual reports.


> Do you compile without -O2 too? Because I *guarantee* you that with
> -O2 (even with tracking), you'll get "local variable 'xyz' optimized
> away" cases.

One gets many fewer than without it, and also fewer false positives
(where the non-var-tracking debuginfo claims a variable may be
available, but points to the wrong place).


> [...]  Until you can get the compiler people to have some sane way
> to know the problem is gone, I'm not going to maintain a kernel that
> uses a known-broken compiler feature. It's that simple.

Would you consider a patch that does a gcc COMPARE_DEBUG-based test?


- FChE
