Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbbAEH0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 02:26:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbbAEH0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 02:26:53 -0500
Date: Mon, 5 Jan 2015 08:26:48 +0100
From: Michal Kubecek <mkubecek@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Arend van Spriel <arend@broadcom.com>,
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
Message-ID: <20150105072648.GA30744@unicorn.suse.cz>
References: <54A3D955.6020809@broadcom.com>
 <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com>
 <54A3E1F1.7030807@broadcom.com>
 <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
 <54A41000.3040306@broadcom.com>
 <20141231173113.GA443@thunk.org>
 <54A45D4D.7070302@broadcom.com>
 <20141231214421.GA29273@thunk.org>
 <CA+55aFzp2bWctqpiHyZVC9ZCtW3wN_bPsGjcbqKFgu9KOZtAJw@mail.gmail.com>
 <20150101194417.GN24112@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150101194417.GN24112@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 02:44:17PM -0500, Lennart Sorensen wrote:

> not handling IPv6 (I think that has been fixed by now), and many
> other awfulnesses.

Some basic setting can be done. But it illustrates nicely what is wrong
with the idea of extending ifconfig to support new features. IPv6
addresses are added and removed (which is how it really works) while
with IPv4, ifconfig keeps pretending interface has exactly one address
and to set more, a virtual interface must be created. In reality, both
IPv4 and IPv6 addresses are handled in pretty much the same way.

This "virtual interface" does not actually exist so that its parameters
can't be set; and worse, if you try, ifconfig silently sets them for the
actual interface (try e.g. "ifconfig eth0:0 mtu 1400"). You also can't
use its name with other commands. Just google for users asking why
iptables or tcpdump does not recognize their 'eth0:0'... and then people
come and say that ip (unlike ifconfig) is confusing.

But, yes, as the old ioctl interface can't be removed, lot of people
will claim that ifconfig "just works" and that it must be preserved. And
they will teach new generations of linux users to use it. So I'm afraid
this exact discussion will be still repeated even after next 15 years.

> Would be nice if all features of the ip command were actually documented,
> but they clearly are not.

As far as I can say, there may still be some missing parts but in recent
versions, both manual pages and "ip ... help" cover the functions quite
well (even if they are a bit too terse sometimes). On the other hand,
"route --help" doesn't even tell me how to add a simple route.

                                                        Michal Kubecek

