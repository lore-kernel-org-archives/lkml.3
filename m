Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaLaRbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 12:31:31 -0500
Received: from imap.thunk.org ([74.207.234.97]:47808 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaLaRb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 12:31:29 -0500
Date: Wed, 31 Dec 2014 12:31:13 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
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
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
Message-ID: <20141231173113.GA443@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Arend van Spriel <arend@broadcom.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A41000.3040306@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 04:02:24PM +0100, Arend van Spriel wrote:
> 
> It is unfortunately indeed. I think iwconfig and friends will never go away
> although iw is a better alternative, simply because people don't like to
> change their home-made scripts/tools. WIRELESS_EXT actually is largely, but
> not entirely, gone in upstream drivers and what we are talking about here is
> CFG80211_WEXT which allows WEXT userspace to interact with cfg80211-based
> drivers through a compatibility layer.

Most poeple are still using "route" and "ifconfig" instead of "ip".
Deal with it.  Personally, I find it much easier to use the existing
commands instead of figuring all of the various subcommands, and the
options to the subcommands to commands like "ip" and "iw".  At least
"ip help route" will give me all of the options to "ip route", where
as "iw help phy" doesn't tell give me the options; instead I have to
paw through 300 lines of "iw help" in order to find the command I
need.  So having a better user interface / help system so people can
better understand how to use iw would be a great step forward.

Better yet, why not hack into the "iw" command backwards compatibility
so that if argv[0] is "iwlist" or "iwconfig", it provides the limited
subset compatibility to the legacy commands.  Then all you need to do
is to convince the distributions to set up the packaging rules so that
"iw" conflicts with wireless-tools, and you will be able to get
everyone switched over to iw after at least seven years. 

Note that I said *seven* years --- there are people who try to use an
enterprise kernel, or an older Debian Stable or Ubuntu LTS userspace,
with a newer kernel, and and if said users notice, and complain, Linus
*will* revert the commit.  (Note that I've worked at more than one
company where I was forced to use an older Ubuntu LTS or RHEL distro
if I wanted to connect to the intranet, and I was using bleeding edge
kernels --- and if anything like that had broken, I would have
complained directly to Linus, cc'ing the patch author and the wireless
maintainers with the revert.  And while I fortunately am not trying to
do upstream development with a stable distro, be sure there are other
such folks around who have to live with similar restrictions.)

   	      	  	     	   - Ted

P.S.  If you really think it's evil that users use the
simpler-to-understand iwconfig/iwlist interface over the iw command
line interface, if you provide full backwards compatibility for the
iwconfig/iwlist commands so you can "take over" from wireless-tools,
you could even have a mode which, in addition to doing what the user
wants, prints a "by the way, here's the equivalent if you want to use
the iw command instead".  I don't see the reason of allowing users to
continue to use iwconfig and iwlist, though --- face it, route and
ifconfig are going to be around for a long time; why not let users use
iwconfig and iwlist if it's sufficient for their needs?

