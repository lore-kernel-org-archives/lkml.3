Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaAEWt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:49:26 -0500
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:50799 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751371AbaAEWtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:49:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:4250:4321:5007:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: curve98_178b158f55d09
X-Filterd-Recvd-Size: 2462
Message-ID: <1388962160.5808.33.camel@joe-AO722>
Subject: Re: [PATCH] Staging: rtl8187se: fix styling issues in r8180_wx.c
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan LaManna <dan.lamanna@gmail.com>, gregkh@linuxfoundation.org,
        teobaluta@gmail.com, andrea.merello@gmail.com, linville@tuxdriver.com,
        rusty@rustcorp.com.au, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Jan 2014 14:49:20 -0800
In-Reply-To: <20140105214555.GH30234@mwanda>
References: <1388956656-10790-1-git-send-email-dan.lamanna@gmail.com>
	 <20140105214555.GH30234@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 00:45 +0300, Dan Carpenter wrote:
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

[]

> 	if (src->capability & WLAN_CAPABILITY_IBSS !=
> 	    dst->capability & WLAN_CAPABILITY_IBSS)

Needs parentheses

	if ((src->capability & WLAN_CAPABILITY_IBSS) !=
	    (dst->capability & WLAN_CAPABILITY_IBSS))

> 		return 0;
> 	if (src->capability & WLAN_CAPABILITY_BSS !=
> 	    dst->capability & WLAN_CAPABILITY_BSS)
> 	    	return 0;

here too.


