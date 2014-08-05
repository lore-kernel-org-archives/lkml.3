Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaHEVHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 17:07:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaHEVHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 17:07:39 -0400
Date: Tue, 5 Aug 2014 17:07:28 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Josh Stone <jistone@redhat.com>
Subject: Re: [PATCH 3.15 33/37] Fix gcc-4.9.0 miscompilation of load_balance() in scheduler
Message-ID: <20140805210728.GH13858@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org> <20140730014829.344302554@linuxfoundation.org> <20140730065312.GA1652@laptop.redhat.com> <CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com> <CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com> <CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com> <CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

> >>.  I don't disagree it should be
> >> disabled by default, but making it unconditional is going to force the
> >> distributions that care about perf, systemtap, and debuggers to
> >> manually revert this.
> >
> > Bah. I bet I use 'perf' more than most, and it doesn't care about
> > debug info. 

Actually, "perf probe" does (via HAVE_DWARF_SUPPORT), to place probes
and to extract variables at those probes, much as systemtap does.
Without var-tracking, probes placed at most interior points of
functions will make variables inaccessible.

Do you need a fully worked out example to see this?

- FChE
