Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaAEV4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 16:56:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30949 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaAEV4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:56:16 -0500
Date: Mon, 6 Jan 2014 00:56:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dan LaManna <dan.lamanna@gmail.com>
Cc: devel@driverdev.osuosl.org, andrea.merello@gmail.com,
        gregkh@linuxfoundation.org, rusty@rustcorp.com.au,
        linville@tuxdriver.com, linux-kernel@vger.kernel.org,
        teobaluta@gmail.com
Subject: Re: [PATCH] Staging: rtl8187se: fix styling issues in r8180_wx.c
Message-ID: <20140105215603.GI30234@mwanda>
References: <1388956656-10790-1-git-send-email-dan.lamanna@gmail.com>
 <20140105214555.GH30234@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140105214555.GH30234@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 12:45:55AM +0300, Dan Carpenter wrote:
> On Sun, Jan 05, 2014 at 04:17:36PM -0500, Dan LaManna wrote:
> > @@ -1358,22 +1358,22 @@ static inline int is_same_network(struct ieee80211_network *src,
> >  		 * We treat all <hidden> with the same BSSID and channel
> >  		 * as one network
> >  		 */
> > -		return (((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
> > +		return ((src->ssid_len == dst->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) && /* YJ,mod, 080819,for hidden ap */
> >  			(src->channel == dst->channel) &&
> >  			!memcmp(src->bssid, dst->bssid, ETH_ALEN) &&
> >  			(!memcmp(src->ssid, dst->ssid, src->ssid_len) || (ieee->iw_mode == IW_MODE_INFRA)) &&  /* YJ,mod, 080819,for hidden ap */
> >  			((src->capability & WLAN_CAPABILITY_IBSS) ==
> >  			(dst->capability & WLAN_CAPABILITY_IBSS)) &&
> >  			((src->capability & WLAN_CAPABILITY_BSS) ==
> > -			(dst->capability & WLAN_CAPABILITY_BSS)));
> > +			(dst->capability & WLAN_CAPABILITY_BSS));
> >  }
> >  
> 
> Break this up.
> 
> 	if (src->channel != dst->channel)
> 		return 0;
> 
> 	if (memcmp(src->bssid, dst->bssid, ETH_ALEN) != 0)
> 		return 0;
> 
> 	if (ieee->iw_mode == IW_MODE_INFRA) {

I have this one reversed.  It should be:

	if (ieee->iw_mode != IW_MODE_INFRA) {

regards,
dan carpenter

