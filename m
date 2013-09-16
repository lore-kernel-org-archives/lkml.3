Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3IPQNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:13:20 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:50003 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751101Ab3IPQNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:13:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: kitty30_90b89f9f9973e
X-Filterd-Recvd-Size: 1458
Message-ID: <1379347993.1934.16.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dan.carpenter@oracle.com, JBeulich@suse.com,
        kosaki.motohiro@gmail.com, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
Date: Mon, 16 Sep 2013 09:13:13 -0700
In-Reply-To: <20130916160717.1621.qmail@science.horizon.com>
References: <20130916160717.1621.qmail@science.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 12:07 -0400, George Spelvin wrote:
> it gave me an idea.  We could put this padding logic straight
> into vsprintf and clean up all the callers.
[]
> Since the only pad character currently used is space, we could omit the
> argument and use something like %127%, but gcc gets even more confused
> by that.
> 
> The code is easy enough.  But any suggestions for ways to represent it
> in the format string would be appreciated.

%*p<new_type><pad_char> (space assumed if not existing)

