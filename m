Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaBJQj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 11:39:27 -0500
Received: from smtprelay0186.hostedemail.com ([216.40.44.186]:47993 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751807AbaBJQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 11:39:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1960:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:7652:7974:10004:10400:10848:11232:11473:11658:11914:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:14040,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coat81_348536903ce03
X-Filterd-Recvd-Size: 1779
Message-ID: <1392050359.2507.10.camel@joe-AO722>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Calvin Owens <jcalvinowens@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 08:39:19 -0800
In-Reply-To: <1392030546.4128.11.camel@jlt4.sipsolutions.net>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 12:09 +0100, Johannes Berg wrote:
> On Wed, 2014-02-05 at 20:44 -0800, Joe Perches wrote:
> 
> > Perhaps use a more common kernel style
> > 
> > struct ieee80211_reason_descriptions {
> > 	u16		code;
> > 	const char *	desc;
> > }
> > 
> > and enumerate the reason codes with #defines and use a
> > macro to populate the descriptions
> > 
> > #define IEEE80211_REASON_RESERVED		0
> > #define IEEE80211_REASON_UNSPECIFIED		1
[]
> Isn't it more efficient to just let the compiler generate it with a big
> switch() statement?

That'd be fine too.

The benefit of the #defines is that you typically
get an external .h file for the entries.

Calvin's suggested code looked pretty fragile.


