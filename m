Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaLaPVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:21:14 -0500
Received: from mout1.freenet.de ([195.4.92.91]:50566 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaLaPVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:21:12 -0500
Message-ID: <54A412CE.6010803@maya.org>
Date: Wed, 31 Dec 2014 16:14:22 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Arend van Spriel <arend@broadcom.com>
CC: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
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
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originated-At: 79.222.3.235!36396
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Wed, 31 Dec 2014, Arend van Spriel wrote:
> 
>> The thing with WEXT is that it will stay as is. So if tools like wicd 
>> want to support new features like P2P it will need to make the switch. I 
>> checked out wicd repo and found a number of iwconfig calls and they kick 
>> off wpa_supplicant with wext driver.
> 
> Unfortunately this is by no means just about wicd. I have already received 
> a few off-list mails from people who were wondering why their home-made 
> scripts / tools, which are running 'iwconfig' directly suddenly stopped to 
> work, and that it was indeed fallout of WEXT going away. Given the very 
> short time this has been in mainline, you can probably imagine the 
> fireworks once this appears in major release.

It is not just the userspace tools (I prefer them, too), which need
wext, but a lot of drivers, too, such as Mediathek drivers e.g. which
perform *much* better compared to rt2x00, especially concerning USB
chips like the one used by Linksys AE3000 (3x3 Mimo)
(https://wikidevi.com/wiki/Linksys_AE3000), which achieves average
throughputs around 14 MB/s *average* with scp of big (> 10 GB) crypted
files even through reinforced-concrete floor(!) - rt2x00 is *far* away
of providing such a performance.

Next bad point of rt2x00 e.g. is the huge CPU overhead - compare
rt5572sta on Raspi with rt2x00 running netperf and you will see the huge
problem of rt2x00 (which is covered on x86 by mostly oversized multi
core CPUs).

Another big advantage of rt5572sta is: it is *stable* over a lot of
kernel versions (as long as the kernel didn't break interfaces - but
there are patches to catch them).

Even ath9k, which usually is a really fine driver, is broken on some
kernel versions (link and throughput is not stable - my use case depends
*heavily* on very high and longterm stable throughput). That's why I'm
using a VM for my ath9k-device to be independent of these quality
problems of mac80211 (or maybe ath9k - don't know) over different kernel
versions.


All in all:
If you want to get rid of wext, you still have to go a *very* long way
to get the same *stable* and high throughput quality with *all* chips
depending on mac80211 and not just a few flagship drivers like Atheros.



Kind regards,
Andreas Hartmann
