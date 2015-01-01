Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbbAAToU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:44:20 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:37417 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbAAToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:44:19 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 1 Jan 2015 14:44:17 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Message-ID: <20150101194417.GN24112@csclub.uwaterloo.ca>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 01:57:59PM -0800, Linus Torvalds wrote:
> Side note: does anybody think that was really a good idea to begin
> with? I mean, Cisco iOS is just _soooo_ universally loved, right?
> 
> And yeah, I refuse to use "ip link" or other insane commands. Let's
> face it, "ifconfig" and "route" are perfectly fine commands, and a
> whole lot less confusing than "ip" with random crap after it.  I'm
> really not seeing why that "ip" command was seen as an improvement.
> 
> (Ok, "ip route" isn't any more complex than "route", but "ip link"
> sure as hell isn't simpler than "ifconfig" for most things I can think
> of)

Well at least in the past (not sure these days), ifconfig was reading
rather inefficiently from /proc rather than using netlink, and it had
annoying bugs like only showing the first 9 characters of the interface
name, not handling IPv6 (I think that has been fixed by now), and many
other awfulnesses.

I just did a quick check to see how ifconfig does longer interface names
and got this:
tun0-12345678:2: error fetching interface information: Device not found

for an interface I had renamed to tun0-123456789

ip had no issue with it.

Renaming it to tun0-12345678 made ifconfig not die on it.  I wonder if
someone failed to understand that 15 character interface names meant
that 15 characters before the NULL should be allowed.  If did show all
of the 14 characters though, so the old cut at 9 character limit is at
least gone these days.

ifconfig seems to just be broken for many cases of perfectly nice features
in the kernel.

So yes some parts of ip are pretty painful, while others are rather nice
(I certainly like ip route, where the output actually matches the syntax
of the input, unlike the route command).

Would be nice if all features of the ip command were actually documented,
but they clearly are not.

-- 
Len Sorensen
