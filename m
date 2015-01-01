Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbbAAUOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:14:18 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39006 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbbAAUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:14:16 -0500
MIME-Version: 1.0
In-Reply-To: <20150101194417.GN24112@csclub.uwaterloo.ca>
References: <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
	<54A3D955.6020809@broadcom.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com>
	<54A3E1F1.7030807@broadcom.com>
	<alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
	<54A41000.3040306@broadcom.com>
	<20141231173113.GA443@thunk.org>
	<54A45D4D.7070302@broadcom.com>
	<20141231214421.GA29273@thunk.org>
	<CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
	<20150101194417.GN24112@csclub.uwaterloo.ca>
Date: Thu, 1 Jan 2015 12:14:15 -0800
X-Google-Sender-Auth: DP5J_nuTWQkSD7Xch6g3lccT0_4
Message-ID: <CA+55aFzFT94xrfC+4tdeQOxDnPaxy0f72N+HEQ7NgRxHdvqbGQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Arend van Spriel <arend@broadcom.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 11:44 AM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>
> ifconfig seems to just be broken for many cases of perfectly nice features
> in the kernel.

So I'm not saying "ifconfig is wonderful". It's not.

But I *am* saying that "changing user interfaces and then expecting
people to change is f*cking stupid".

The fact is, ifconfig is simple for the simple cases, but more
importantly, a lot of people learnt how to use it. Saying "you should
all change, because we made up a new syntax" is not good policy.

The people who did "ip" could have fairly easily have done a wrapper
around the same code that also left the old "ifconfig" syntax. Then,
distros could have trivially just dropped the old "ifconfig" package,
and entirely replaced it with the new "ip" package.

As it is, we have two different models, and they'll basically stay
around forever.

For something like ifconfig, very few people care. But *all* the same
arguments are true wrt "iw" and "iwconfig".

The people who are trying to deprecate the WEXT interfaces should put
the blame firmly where it belongs - on the people who thought that
"we'll just ignore all old history".

Because people who think that "we'll just redesign everything" are
actually f*cking morons. Really.

There's a real reason the kernel has the "no regression" policy. And
that reason is that I'm not a moron.

History matter. Legacy uses matter.

                          Linus
