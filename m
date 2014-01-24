Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaAXCdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:33:16 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54246 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbaAXCdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:33:15 -0500
X-Sasl-enc: I21ZOsfnHd7AYwL/7v2QdpzlwwpdwCnhiQrVsayeZL4l 1390530793
Date: Thu, 23 Jan 2014 18:34:05 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20140124023405.GA27360@kroah.com>
References: <20140124130122.017195b49e852e4e42b77997@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124130122.017195b49e852e4e42b77997@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:01:22PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_beaconing_flags':
> drivers/staging/rtl8821ae/regd.c:200:20: error: 'IEEE80211_CHAN_NO_IBSS' undeclared (first use in this function)
>       ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
>                     ^
> drivers/staging/rtl8821ae/regd.c:200:20: note: each undeclared identifier is reported only once for each function it appears in
> drivers/staging/rtl8821ae/regd.c:204:11: error: 'IEEE80211_CHAN_PASSIVE_SCAN' undeclared (first use in this function)
>           ~IEEE80211_CHAN_PASSIVE_SCAN;
>            ^
> drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_active_scan_flags':
> drivers/staging/rtl8821ae/regd.c:237:19: error: 'IEEE80211_CHAN_PASSIVE_SCAN' undeclared (first use in this function)
>    if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
>                    ^
> drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_radar_flags':
> drivers/staging/rtl8821ae/regd.c:312:8: error: 'IEEE80211_CHAN_NO_IBSS' undeclared (first use in this function)
>         IEEE80211_CHAN_NO_IBSS |
>         ^
> drivers/staging/rtl8821ae/regd.c:313:8: error: 'IEEE80211_CHAN_PASSIVE_SCAN' undeclared (first use in this function)
>         IEEE80211_CHAN_PASSIVE_SCAN;
>         ^
> drivers/staging/rtl8821ae/regd.c: In function '_rtl_regd_init_wiphy':
> drivers/staging/rtl8821ae/regd.c:410:18: error: 'WIPHY_FLAG_CUSTOM_REGULATORY' undeclared (first use in this function)
>   wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY;
>                   ^
> drivers/staging/rtl8821ae/regd.c:411:19: error: 'WIPHY_FLAG_STRICT_REGULATORY' undeclared (first use in this function)
>   wiphy->flags &= ~WIPHY_FLAG_STRICT_REGULATORY;
>                    ^
> drivers/staging/rtl8821ae/regd.c:412:19: error: 'WIPHY_FLAG_DISABLE_BEACON_HINTS' undeclared (first use in this function)
>   wiphy->flags &= ~WIPHY_FLAG_DISABLE_BEACON_HINTS;
>                    ^
> drivers/staging/rtl8821ae/base.c: In function '_rtl_init_mac80211':
> drivers/staging/rtl8821ae/base.c:372:4: error: 'struct ieee80211_hw' has no member named 'channel_change_time'
>   hw->channel_change_time = 100;
>     ^
> drivers/staging/rtl8821ae/base.c: In function 'rtl_beacon_statistic':
> drivers/staging/rtl8821ae/base.c:1185:2: error: implicit declaration of function 'compare_ether_addr' [-Werror=implicit-function-declaration]
>   if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
>   ^
> drivers/staging/rtl8821ae/ps.c: In function 'rtl_swlps_beacon':
> drivers/staging/rtl8821ae/ps.c:530:2: error: implicit declaration of function 'compare_ether_addr' [-Werror=implicit-function-declaration]
>   if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
>   ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8812ae_dm_txpwr_track_set_pwr':
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:1476:5: warning: array subscript has type 'char' [-Wchar-subscripts]
>      rtl_set_bbreg(hw, RA_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[final_ofdm_swing_index]);
>      ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:1525:5: warning: array subscript has type 'char' [-Wchar-subscripts]
>      rtl_set_bbreg(hw, RB_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[final_ofdm_swing_index]);
>      ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_txpwr_track_set_pwr':
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:2113:5: warning: array subscript has type 'char' [-Wchar-subscripts]
>      rtl_set_bbreg(hw, RA_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[final_ofdm_swing_index]);
>      ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_check_edca_turbo':
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:2656:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'u64' [-Wformat=]
>    RT_TRACE(COMP_TURBO, DBG_LOUD,
>    ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:2658:3: warning: format '%lx' expects argument of type 'long unsigned int', but argument 2 has type 'u64' [-Wformat=]
>    RT_TRACE(COMP_TURBO, DBG_LOUD,
>    ^
> drivers/staging/rtl8821ae/rtl8821ae/trx.c: In function '_rtl8821ae_translate_rx_signal_stuff':
> drivers/staging/rtl8821ae/rtl8821ae/trx.c:461:7: error: implicit declaration of function 'compare_ether_addr' [-Werror=implicit-function-declaration]
>        (!compare_ether_addr(mac->bssid, (fc & IEEE80211_FCTL_TODS) ?
>        ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_clear_txpower_tracking_state':
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u invokes undefined behavior [-Waggressive-loop-optimizations]
>    rtldm->bb_swing_idx_ofdm[p] = rtldm->default_ofdm_index;
>                                ^
> drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
>   for (p = RF90_PATH_A; p < MAX_RF_PATH; ++p) {
>   ^
> 
> Caused by commit 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI
> WIFI driver").  Did you really want to merge a new driver right now, not
> wait until after the merge window?

Yes, it's stand-alone and worked for me and is shipping in at least one
distro already.  Looks like I need another depends option in the Kconfig
file, I'll fix this up, thanks.

greg k-h
