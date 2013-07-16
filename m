Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab3GPS3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:29:18 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57873 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab3GPS3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:29:16 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
References: <20130711214830.611455274@linuxfoundation.org>
	<20130712005023.GB31005@thunk.org>
	<20130712051451.GC25815@1wt.eu>
	<alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz>
	<s5hwqoqv4oo.wl%tiwai@suse.de>
	<20130716165933.GU22506@sirena.org.uk>
	<3908561D78D1C84285E8C5FCA982C28F31C845B1@ORSMSX106.amr.corp.intel.com>
Date: Tue, 16 Jul 2013 11:29:15 -0700
X-Google-Sender-Auth: Edr46Hti5trZr7VQR01wHwmD5jM
Message-ID: <CA+55aFzViZyMydimtes+a7neRRg1ibW5QUg3+bV2kjQASvgSpg@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        David Lang <david@lang.hm>,
        "ksummit-2013-discuss@lists.linux-foundation.org" 
	<ksummit-2013-discuss@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:58 AM, Luck, Tony <tony.luck@intel.com> wrote:
>
> Linux testing is (realistically) done by inflicting changes on gradually wider
> sets of end users.

However, one thing that people should keep in mind that the testing is
often self-selecting.

This is particularly true for "obvious fixes". The _only_ early
testers tend to be the people who saw the problem in the first place,
and the fact that a patch fixes it for *them* can be very very
misleading during that early testing phase. Because obviously that
self-selecting group of people were somehow fundamentally different
from the rest of the world, and different in a way that was very
particular to the problem.

This is in particular what we've often seen with things like the PCI
layer resource management, and what we used to see a lot back in the
bad old days wrt suspend/resume. And it's why I'd really prefer for
even "obvious" patches to not be backported all that aggressively
unless there is very strong pressure. It's very much why that stable
documentation talks about "critical" issues.

There have been tons of obvious patches that turned out to simply be
wrong - often for very non-obvious reasons. Even when they are small.
And the problems seldom get caught in early testing, often exactly
because of this self-selecting property of testers (and test*ing* -
when you fix a particular behavior, you tend to test the behavior
you're trying to fix, you don't test the other cases that the patch
wasn't about).

Anyway, the point I'm making is that Q&A is limited and often even
actively misleading ("Hey, I have three tested-by's, so it must be
fine"), and we might actually want to have a new class of
"non-critical patch that might be worth backporting to stable, but
only do so after it's been in a release for some time". Because while
it might be an "obvious" fix, maybe it's not critical enough that it
needs to be backported _now_ - maybe it could wait a month or two, and
get wider testing.

               Linus
