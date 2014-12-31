Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaLaWaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:30:25 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30320 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaLaWaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:30:15 -0500
X-IronPort-AV: E=Sophos;i="5.07,675,1413270000"; 
   d="scan'208";a="53862042"
Message-ID: <54A478F3.4090602@broadcom.com>
Date: Wed, 31 Dec 2014 23:30:11 +0100
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
References: <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz> <54A41000.3040306@broadcom.com> <20141231173113.GA443@thunk.org> <54A45D4D.7070302@broadcom.com> <20141231214421.GA29273@thunk.org>
In-Reply-To: <20141231214421.GA29273@thunk.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/14 22:44, Theodore Ts'o wrote:
> On Wed, Dec 31, 2014 at 09:32:13PM +0100, Arend van Spriel wrote:
>>
>> Agree. I can't even recall using "ip" ever. iw help system does provide
>> command specific help. The phy keyword is both a command and a selector key,
>> which I realize is confusing to the user, eg. 'iw help info' does provide
>> help for the 'info' subcommand.
>
> Yeah, the confusing part is that "ip" tends to use "verb object"
> scheme, which is consistent with the Cisco IOS command set it was
> trying to emulate.   So for ip, you do something like
>
> ip link info eth0
>
> Where as for "iw" it's almost exactly backwards, i.e.:
>
> iw wlan0 info
>
> It's actually rather unfortunate that there is no consistency between
> many of these tools, for example:
>
> ethtool --show-features eth0
>
> If we were going to create a new interface, wouldn't be nice if we
> could have some kind of consistency?  Sigh; oh well, water under the
> bridge at this point.

And on that water there are different ships with different captains ;-)

>> Thanks. If there are still drivers, upstream or out-of-tree, providing only
>> WEXT API this will not work unless iwconfig/iwlist can distinguish those
>> from cfg80211-based drivers (which is possible) and fallback to WEXT ioctl
>> syscalls. Just not sure if it is worth the effort. As you stated below, it
>> does not seem "evil" to retain WEXT if that is providing users what they
>> need.
>
> Is it really that much effort?  Unless there is some license
> incompatibility nonsense (i.e., GPLv2 vs GPLv3), the code's already
> there in the wireless-tools source.  It would just be a matter of
> trying the new ioctls first, and then falling back to the WEXT ones if
> needed, right?

I don't think it is much effort. I think the nl80211 netlink api is not 
an ioctl, but yeah it seems trivial. But if WEXT needs to stay for 
people using WEXT-only drivers, it may be fine to keep cfg80211 wext 
compatibility in place.

Regards,
Arend

> Cheers,
>
> 					- Ted

