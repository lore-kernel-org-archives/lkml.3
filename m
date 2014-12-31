Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaLaWUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:20:04 -0500
Received: from imap.thunk.org ([74.207.234.97]:48045 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaLaWUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:20:01 -0500
Date: Wed, 31 Dec 2014 17:19:48 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arend van Spriel <arend@broadcom.com>, Jiri Kosina <jkosina@suse.cz>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Message-ID: <20141231221948.GB29273@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arend van Spriel <arend@broadcom.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 01:57:59PM -0800, Linus Torvalds wrote:
> Side note: does anybody think that was really a good idea to begin
> with? I mean, Cisco iOS is just _soooo_ universally loved, right?

Well, at the time when it was "ip" came out, Cisco had a defacto
monopoly on routing equipment, and some of the folks who were working
on Linux networking had this insane dream of having Linux be better at
the routing game than Cisco (there was this minor issue of Cisco
having hardware assist for their fastpath :-).  So I think I
*understand* the rationale behind the design choice, even though it's
probably not the decision I would have made at the time, and certainly
not with the benefit of 20/20 hindsight!

And I won't say that I *loved* IOS, but I certainly used it enough
when I was working in the MIT Network Operations group.  :-)

> And yeah, I refuse to use "ip link" or other insane commands. Let's
> face it, "ifconfig" and "route" are perfectly fine commands, and a
> whole lot less confusing than "ip" with random crap after it.  I'm
> really not seeing why that "ip" command was seen as an improvement.

The real problem is that they were trying to do way more complicated
things in terms of routing rules (including some stuff that could be
done by Cisco IOS).  So if you want to try to do the insanely
complicated stuff, you have to use the "ip route" command.

Meh.  Could it have been shoehorned into the legacy "route" command?
Perhaps, although it would have been a bit of mess, I suspect.

The question I find more interesting is how many people are actually
*using* all of the complexity that currently can only be accessed via
the "ip", "tc", and "ss" commands.

But in any case, given that "ip", "tc", "ss", etc. are using the IOS
syntax, most users will probably find it confusing and surprising that
"iw" is using something different.  It's probably too hard to maintain
script compatibility to make such a UX change to iw at this point,
though.  And besides, most users are probably using "ifconfig",
"route", and if they're not using network-manager or wicdw, they're
using "iwconfig" or "iwlist" --- so it's a moot point.  :-)

						- Ted
