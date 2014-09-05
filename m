Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaIEVJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:09:30 -0400
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:45266 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752378AbaIEVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:09:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3874:4321:5007:6119:6120:7652:7808:7901:7903:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12740:13018:13019:13069:13137:13146:13150:13161:13229:13230:13231:13255:13311:13357:14039:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: worm38_354ac18c2822f
X-Filterd-Recvd-Size: 2218
Message-ID: <1409951364.2618.28.camel@joe-AO725>
Subject: Re: [PATCH] gcc: clamp gcc version to most highest specific header
 version available
From: Joe Perches <joe@perches.com>
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sasha Levin <sasha.levin@oracle.com>, akpm@linuxfoundation.org,
        mingo@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard.weinberger@gmail.com>
Date: Fri, 05 Sep 2014 14:09:24 -0700
In-Reply-To: <8bf23840962ec5a33b1bfae7fdf8b0a0f94c4227.1409949573.git.hannes@stressinduktion.org>
References: <5409CC39.3060608@oracle.com>
	 <8bf23840962ec5a33b1bfae7fdf8b0a0f94c4227.1409949573.git.hannes@stressinduktion.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-05 at 22:39 +0200, Hannes Frederic Sowa wrote:
> As announced in [1] gcc will increase its major number yearly but we don't
> need to include gcc version specific quirks for every version normally.
> 
> This patch allows to compile every kernel with all new versions of gcc
> without adding a specific compiler-gccX.h header. We do so by clamping
> the __GNUC__ version to the most specific version dependent header file.
> 
> If someone adds a new gccX.h file __GCC_CLAMP_VERSION_HEADER also needs
> to be modified.
> 
> The decision if chained including of header files (e.g. gcc5.h includes
> gcc4.h) is necessary or should be avoided can be postponed until more
> experience in using the official gcc release is gained.

I think the churn rate in the gcc compiler specific
#include headers will be low enough that a single
combined file should be acceptable.

Keeping all the gcc #defines together seems more
readable to me.

The trivial integration I did eliminated one
duplicate #define as well as that hack for
#include gcc_header(__GNUC__)




