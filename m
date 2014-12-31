Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaLaLJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 06:09:15 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:29936 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaLJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 06:09:13 -0500
X-IronPort-AV: E=Sophos;i="5.07,672,1413270000"; 
   d="scan'208";a="54124822"
Message-ID: <54A3D955.6020809@broadcom.com>
Date: Wed, 31 Dec 2014 12:09:09 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "egrumbach@gmail.com" <egrumbach@gmail.com>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] Revert "cfg80211: make WEXT compatibility unselectable"
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz> <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com> <54A2B807.1020202@hurleysoftware.com> <0BA3FCBA62E2DC44AF3030971E174FB31B5DC915@hasmsx107.ger.corp.intel.com> <alpine.LNX.2.00.1412301610320.31609@pobox.suse.cz> <1419971304.30412.0.camel@egrumbacBox> <alpine.LNX.2.00.1412302135520.31609@pobox.suse.cz> <20141230212326.GA29263@pd.tnic> <54A328C2.5080606@lwfinger.net> <alpine.LNX.2.00.1412302341290.31609@pobox.suse.cz> <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1412302351030.31609@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/14 23:52, Jiri Kosina wrote:
> This reverts commit 24a0aa212ee2dbe44360288684478d76a8e20a0a.
>
> It's causing severe userspace breakage. Namely, all the utilities
> from wireless-utils which are relying on CONFIG_WEXT (which means
> tools like 'iwconfig', 'iwlist', etc) are not working anymore. There
> is a 'iw' utility in newer wireless-tools, which is supposed to be
> a replacement for all the "deprecated" binaries, but it's far away
> from being massively adopted.
>
> Please see [1] for example of the userspace breakage this is causing.
>
> In addition to that, Larry Finger reports [2] that this patch is also
> causing ipw2200 driver being impossible to build.
>
> To me this clearly shows that CONFIG_WEXT is far, far away from being
> "deprecated enough" to be removed.

Hi Jiri,

You mentioned in the discussion and I quote: "*If* wireless maintainers 
think otherwise, I'll send a revert request to Linus for 
consideration.". However, you did not wait for any response from the 
wireless maintainers nor from the author of the patch you are reverting. 
Seems like an overreaction to me though personally I do not disgree with 
the revert itself.

Regards,
Arend

> [1] http://thread.gmane.org/gmane.linux.kernel/1857010
> [2] http://thread.gmane.org/gmane.linux.network/343688
>
> Signed-off-by: Jiri Kosina<jkosina@suse.cz>
> ---
>   net/wireless/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 22ba971..29c8675 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -175,7 +175,7 @@ config CFG80211_INTERNAL_REGDB
>   	  Most distributions have a CRDA package.  So if unsure, say N.
>
>   config CFG80211_WEXT
> -	bool
> +	bool "cfg80211 wireless extensions compatibility"
>   	depends on CFG80211
>   	select WEXT_CORE
>   	help

