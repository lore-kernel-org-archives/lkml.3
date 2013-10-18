Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3JREL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 00:11:28 -0400
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:41060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802Ab3JREL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 00:11:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:7522:7652:10004:10400:10471:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cave51_4673cf4ac4060
X-Filterd-Recvd-Size: 1681
Message-ID: <1382069482.22110.164.camel@joe-AO722>
Subject: Re: [PATCH 00/23 v2] cleanup: introduce
 br/netdev/netif/wiphy_<foo>_ratelimited() and use them to simplify code
From: Joe Perches <joe@perches.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 17 Oct 2013 21:11:22 -0700
In-Reply-To: <1382068363-10088-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1382068363-10088-1-git-send-email-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending to lists only because of multiple X's in the subject line)

On Fri, 2013-10-18 at 11:52 +0800, Kefeng Wang wrote:
> v1-v2:
> 
>   Introduce macro br/netdev/netif/wiphy_XXX_ratelimited() according
>   to Joe Perches's advice. The macros are similar to net_XXX_ratelimited()
>   which is more clarifying than net_ratelimited_function(), then use them
>   to simplify code.

There are some conceptual differences between these
implementations and other <foo>_ratelimited uses.

For every other subsystem but net, there is a per-location
struct ratelimit_state.

Here you've made the global net_ratelimit_state replace all
of these individual structs so there is some new interaction.

Dunno if that's good or bad.



