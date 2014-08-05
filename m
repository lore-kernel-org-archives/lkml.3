Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaHEX7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:59:31 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:56167 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaHEX73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140805233058.GI13858@redhat.com>
References: <20140730014827.565626091@linuxfoundation.org>
	<20140730014829.344302554@linuxfoundation.org>
	<20140730065312.GA1652@laptop.redhat.com>
	<CA+55aFzr_wJzt6RpojXpDo-ashV_N7sP+j7Ba0ND9mSpr7MKRQ@mail.gmail.com>
	<CA+5PVA5FPD8hp_7=M-VNoUG1Mw9R0Xkn2Yo50eo28ojzrcB5Aw@mail.gmail.com>
	<CA+55aFwvRcr98M=425eCR8K04X-uAVjH2bs3hudkySVKM4VqVg@mail.gmail.com>
	<CA+5PVA79a-BoMMAzryH0O3NFz6KY1f9REAmE=T00ErfcUfCGEg@mail.gmail.com>
	<20140805210728.GH13858@redhat.com>
	<CA+55aFwq72kDdRSWXKhyO1j=_PAKB960+RNOD6Cou0wZTa+5Hw@mail.gmail.com>
	<20140805233058.GI13858@redhat.com>
Date: Tue, 5 Aug 2014 16:59:28 -0700
X-Google-Sender-Auth: iOfvH-hhTh4dUvH0x96TUI7SBe4
Message-ID: <CA+55aFz_wx5BVir=WviqwE_ysKMXb1Ka8T7L+Gq2NT9S=yo2_w@mail.gmail.com>
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

On Tue, Aug 5, 2014 at 4:30 PM, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Would you consider a patch that does a gcc COMPARE_DEBUG-based test?

Yes. But as mentioned, we don't have a really good way to do that. I
guess we can do something similar to what "cc-option" does, but that
will end up doing it for every single kernel build. I'd love to have
something like this be done at kconfig time (along with all the
*other* crazy conditional compiler options we do), but I guess that's
a largely independent issue.

And afaik, it will basically disallow every gcc version since 4.5 up
until 4.9.2 gets released. And afaik, even current gcc actually fails
the compare-debug test for at least some inputs, so ...

                 Linus
