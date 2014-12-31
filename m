Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaLaRoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 12:44:25 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:60711 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaLaRoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 12:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <20141231173113.GA443@thunk.org>
References: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz>
	<20141230212326.GA29263@pd.tnic>
	<54A328C2.5080606@lwfinger.net>
	<alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz>
	<alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
	<54A3D955.6020809@broadcom.com>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com>
	<54A3E1F1.7030807@broadcom.com>
	<alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
	<54A41000.3040306@broadcom.com>
	<20141231173113.GA443@thunk.org>
Date: Wed, 31 Dec 2014 09:44:22 -0800
X-Google-Sender-Auth: 9fRlm9pqjQzTRTQv4Dgf2C2pX9A
Message-ID: <CA+55aFwQTHLKbeowuv8Lm+347i9KJ9itpOGDRATZxT-tnYHHZA@mail.gmail.com>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Arend van Spriel <arend@broadcom.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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

On Wed, Dec 31, 2014 at 9:31 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Most poeple are still using "route" and "ifconfig" instead of "ip".
> Deal with it.

Indeed. This whole "let's throw out the old and broken" stuff is a disease.

It would have been much better (and it's still an option, as Ted
points out) for the new commands to provide compatibility with what
users - and scripts - have been doing for ages with the old ones.

As it is, this inability for the new tools to just do what the old
tools did clearly just means that not just the old tools, but all the
old infrastructure, will need to be around for years to come.

Thinking you can just start from a clean slate is naive, bordering on
stupid. "New and improved" is only really improved if it also takes
backwards compatibility into account, rather than saying "now
everybody must do things the new and improved - and different - way"

We've succeeded in getting rid of some old interfaces in the kernel,
but it has usually been for some *really* esoteric stuff that nobody
does by hand. And even then it has generally been an uphill battle,
and in most cases we've ended up having the rule that new capabilities
absolutely *have* to be a superset of the old, and we continue to
support the old model using the new code.

It's entirely possible that we might be able to cut down on the WEXT
support a tiny bit by slowly removing some parts of it that nobody
uses and depends on, but the whole "let's just make it a non-option"
was clearly just a drug-fueled bad fantasy.

                     Linus
