Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312AbaFTUIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:08:06 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:45964 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757585AbaFTUIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:08:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:5007:7652:7904:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coal30_805b9112e0a25
X-Filterd-Recvd-Size: 1882
Message-ID: <1403294880.4076.7.camel@joe-AO725>
Subject: Re: [PATCH] staging:rtl8821ae: rewrite legacy wifi check in
 halbcoutsrc
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: Nicholas Krause <xerofoify@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, pebolle@tiscali.nl, himangi774@gmail.com,
        bergo.torino@gmail.com, linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2014 13:08:00 -0700
In-Reply-To: <20140620195926.GY5500@mwanda>
References: <1403283410-7022-1-git-send-email-xerofoify@gmail.com>
	 <20140620195926.GY5500@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 22:59 +0300, Dan Carpenter wrote:
> On Fri, Jun 20, 2014 at 12:56:50PM -0400, Nicholas Krause wrote:
> > Rewrites the wireless check for legacy checking in function
> > halbtc_legacy to check for both Mode A and B.
> 
> You're just guessing that A and B were intended but it could have been
> something B and G...
> 
> Don't do this.  Just leave the static checker warning there so someone
> can fix it properly instead of introducing a second new bug and hiding
> the warning so it's impossible to find.
> 

It's most likely G anyway:

drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.c:     if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_G))
drivers/staging/rtl8821ae/btcoexist/halbtcoutsrc.c:     if ((mac->mode == WIRELESS_MODE_B) || (mac->mode == WIRELESS_MODE_B))

Larry probably has a better idea.

