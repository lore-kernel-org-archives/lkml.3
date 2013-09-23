Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3IWCQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:16:45 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:46688 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753020Ab3IWCQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:16:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3653:3743:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:7652:7903:7904:8604:9393:10004:10400:10848:11232:11658:11914:12043:12049:12517:12519:12555:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beast58_5788333437c31
X-Filterd-Recvd-Size: 1968
Message-ID: <1379902599.3575.9.camel@joe-AO722>
Subject: Re: [PATCH 01/12] ping.h: Remove extern from function prototypes
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Date: Sun, 22 Sep 2013 19:16:39 -0700
In-Reply-To: <523FA098.9050200@gmail.com>
References: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
	 <523FA098.9050200@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 11:59 +1000, Ryan Mallon wrote:
> This seems like a lot of code churn for very little benefit. At a quick
> glance:
> 
>   git grep extern include/ | wc -l
>   11427
> 
> Not all of those will need to be removed, but that is still a huge
> number to change, and doesn't include extern usage in C files or local
> headers. You are probably never going to remove all the instances, so
> what is the point of just randomly doing a handful?

Rather more than a handful.

The ratio of function prototypes without extern to
function prototypes with extern is currently ~2.5:1

So:

Standardization without extern
Line count reduction (~10%)
Miscellaneous neatening at the same time
Removal of all unnecessary externs from include/net

There are ~8500 instances in include/
There are ~1500 instances in include/net/

After this series, 0 in include/net/

Start somewhere, go from there...

$ git grep -E "^\s*\bextern(\s+\w+){1,4}\s*\(\s*[^\*]" include/ | wc -l
8395
$ git grep -E "^\s*\bextern(\s+\w+){1,4}\s*\(\s*[^\*]" include/net/ | wc -l
1471


