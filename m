Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaLaTsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 14:48:31 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:8127 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbaLaTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 14:48:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,674,1413270000"; 
   d="scan'208";a="53857087"
Message-ID: <54A45309.6080606@broadcom.com>
Date: Wed, 31 Dec 2014 20:48:25 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@freenet.de>
CC: Jiri Kosina <jkosina@suse.cz>,
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
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz> <54A3D955.6020809@broadcom.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DD72E@hasmsx107.ger.corp.intel.com> <54A3E1F1.7030807@broadcom.com> <alpine.LNX.2.00.1412311505100.31609@pobox.suse.cz> <54A412CE.6010803@maya.org>
In-Reply-To: <54A412CE.6010803@maya.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/14 16:14, Andreas Hartmann wrote:
> Jiri Kosina wrote:
>> On Wed, 31 Dec 2014, Arend van Spriel wrote:
>>
>>> The thing with WEXT is that it will stay as is. So if tools like wicd
>>> want to support new features like P2P it will need to make the switch. I
>>> checked out wicd repo and found a number of iwconfig calls and they kick
>>> off wpa_supplicant with wext driver.
>>
>> Unfortunately this is by no means just about wicd. I have already received
>> a few off-list mails from people who were wondering why their home-made
>> scripts / tools, which are running 'iwconfig' directly suddenly stopped to
>> work, and that it was indeed fallout of WEXT going away. Given the very
>> short time this has been in mainline, you can probably imagine the
>> fireworks once this appears in major release.
>
> It is not just the userspace tools (I prefer them, too), which need
> wext, but a lot of drivers, too, such as Mediathek drivers e.g. which
> perform *much* better compared to rt2x00, especially concerning USB
> chips like the one used by Linksys AE3000 (3x3 Mimo)
> (https://wikidevi.com/wiki/Linksys_AE3000), which achieves average
> throughputs around 14 MB/s *average* with scp of big (>  10 GB) crypted
> files even through reinforced-concrete floor(!) - rt2x00 is *far* away
> of providing such a performance.
>
> Next bad point of rt2x00 e.g. is the huge CPU overhead - compare
> rt5572sta on Raspi with rt2x00 running netperf and you will see the huge
> problem of rt2x00 (which is covered on x86 by mostly oversized multi
> core CPUs).
>
> Another big advantage of rt5572sta is: it is *stable* over a lot of
> kernel versions (as long as the kernel didn't break interfaces - but
> there are patches to catch them).
>
> Even ath9k, which usually is a really fine driver, is broken on some
> kernel versions (link and throughput is not stable - my use case depends
> *heavily* on very high and longterm stable throughput). That's why I'm
> using a VM for my ath9k-device to be independent of these quality
> problems of mac80211 (or maybe ath9k - don't know) over different kernel
> versions.
>
>
> All in all:
> If you want to get rid of wext, you still have to go a *very* long way
> to get the same *stable* and high throughput quality with *all* chips
> depending on mac80211 and not just a few flagship drivers like Atheros.

Hi Andreas,

That's a nice list of unrelated stuff. This has all nothing to do with 
WEXT. Actually, you can build rt5572sta with cfg80211 support 
(RT_CFG80211_SUPPORT). This thread is about the configuration API and 
not about driver performance.

Regards,
Arend

> Kind regards,
> Andreas Hartmann
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

