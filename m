Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLaUcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 15:32:19 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:5997 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbaLaUcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 15:32:17 -0500
X-IronPort-AV: E=Sophos;i="5.07,675,1413270000"; 
   d="scan'208";a="53986903"
Message-ID: <54A45D4D.7070302@broadcom.com>
Date: Wed, 31 Dec 2014 21:32:13 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jkosina@suse.cz>,
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
References: <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz> <54A41000.3040306@broadcom.com> <20141231173113.GA443@thunk.org>
In-Reply-To: <20141231173113.GA443@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/14 18:31, Theodore Ts'o wrote:
> On Wed, Dec 31, 2014 at 04:02:24PM +0100, Arend van Spriel wrote:
>>
>> It is unfortunately indeed. I think iwconfig and friends will never go away
>> although iw is a better alternative, simply because people don't like to
>> change their home-made scripts/tools. WIRELESS_EXT actually is largely, but
>> not entirely, gone in upstream drivers and what we are talking about here is
>> CFG80211_WEXT which allows WEXT userspace to interact with cfg80211-based
>> drivers through a compatibility layer.
>
> Most poeple are still using "route" and "ifconfig" instead of "ip".
> Deal with it.  Personally, I find it much easier to use the existing
> commands instead of figuring all of the various subcommands, and the
> options to the subcommands to commands like "ip" and "iw".  At least
> "ip help route" will give me all of the options to "ip route", where
> as "iw help phy" doesn't tell give me the options; instead I have to
> paw through 300 lines of "iw help" in order to find the command I
> need.  So having a better user interface / help system so people can
> better understand how to use iw would be a great step forward.

Agree. I can't even recall using "ip" ever. iw help system does provide 
command specific help. The phy keyword is both a command and a selector 
key, which I realize is confusing to the user, eg. 'iw help info' does 
provide help for the 'info' subcommand.

> Better yet, why not hack into the "iw" command backwards compatibility
> so that if argv[0] is "iwlist" or "iwconfig", it provides the limited
> subset compatibility to the legacy commands.  Then all you need to do
> is to convince the distributions to set up the packaging rules so that
> "iw" conflicts with wireless-tools, and you will be able to get
> everyone switched over to iw after at least seven years.

Thanks. If there are still drivers, upstream or out-of-tree, providing 
only WEXT API this will not work unless iwconfig/iwlist can distinguish 
those from cfg80211-based drivers (which is possible) and fallback to 
WEXT ioctl syscalls. Just not sure if it is worth the effort. As you 
stated below, it does not seem "evil" to retain WEXT if that is 
providing users what they need.

Regards,
Arend

> Note that I said *seven* years --- there are people who try to use an
> enterprise kernel, or an older Debian Stable or Ubuntu LTS userspace,
> with a newer kernel, and and if said users notice, and complain, Linus
> *will* revert the commit.  (Note that I've worked at more than one
> company where I was forced to use an older Ubuntu LTS or RHEL distro
> if I wanted to connect to the intranet, and I was using bleeding edge
> kernels --- and if anything like that had broken, I would have
> complained directly to Linus, cc'ing the patch author and the wireless
> maintainers with the revert.  And while I fortunately am not trying to
> do upstream development with a stable distro, be sure there are other
> such folks around who have to live with similar restrictions.)
>
>     	      	  	     	   - Ted
>
> P.S.  If you really think it's evil that users use the
> simpler-to-understand iwconfig/iwlist interface over the iw command
> line interface, if you provide full backwards compatibility for the
> iwconfig/iwlist commands so you can "take over" from wireless-tools,
> you could even have a mode which, in addition to doing what the user
> wants, prints a "by the way, here's the equivalent if you want to use
> the iw command instead".  I don't see the reason of allowing users to
> continue to use iwconfig and iwlist, though --- face it, route and
> ifconfig are going to be around for a long time; why not let users use
> iwconfig and iwlist if it's sufficient for their needs?


