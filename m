Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaAPA3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:29:39 -0500
Received: from smtprelay0061.hostedemail.com ([216.40.44.61]:48943 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856AbaAPA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:29:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wing30_1964866808b45
X-Filterd-Recvd-Size: 1761
Message-ID: <1389832172.14001.41.camel@joe-AO722>
Subject: Re: [PATCH net-next 1/2] random32: add prandom_u32_lt_N and convert
 "misuses" of reciprocal_divide
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Zawadzki <darkjames-ws@darkjames.pl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Wed, 15 Jan 2014 16:29:32 -0800
In-Reply-To: <1389828228-30312-2-git-send-email-dborkman@redhat.com>
References: <1389828228-30312-1-git-send-email-dborkman@redhat.com>
	 <1389828228-30312-2-git-send-email-dborkman@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-16 at 00:23 +0100, Daniel Borkmann wrote:
> Many functions have open coded a function that return a random
> number in range [0,N-1]. Also, only because we have a function
> that is named reciprocal_divide(), it has not much to do with
> the pupose where it is being used when a previous reciprocal_value()
> has not been obtained.

prandom_u32_lt_N?

I do not like the camelcase name and thought the
prandom_u32_max was better.

How about using

u32 prandom_u32_max(u32 max)
{
	return (u32)(((u64)prandom_u32() * max) >> 32);
}

u32 prandom_u32_range(u32 a, u32 b)
{
	if (b < a)
		swap(a, b);

	return a + (u32)(((u64)prandom_u32() * (b - a)) >> 32);
}


