Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaCNHsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 03:48:09 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:40162 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755409AbaCNHsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 03:48:07 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:560:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3871:3872:4250:4321:5007:7652:8603:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ring64_297e442563d23
X-Filterd-Recvd-Size: 1330
Message-ID: <1394783283.2970.2.camel@joe-AO722>
Subject: Re: [PATCH] mtip32xx: switch to vmalloc() to mitigate high order
 allocation failures
From: Joe Perches <joe@perches.com>
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, asamymuthupa@micron.com
Date: Fri, 14 Mar 2014 00:48:03 -0700
In-Reply-To: <532237F4.3010309@micron.com>
References: <532237F4.3010309@micron.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 15:57 -0700, Sam Bradshaw wrote:
> The mtip_port kmalloc() allocation is relatively high order, in
> particular since the recent doubling of the size of the scatterlist
> container.  The allocation has been shown to fail during SRSI under
> fragmented or low memory conditions.  Switching to vmalloc() mitigates
> the problem.  Converted both mtip_port and driver_data allocations for
> consistency.

It'd probably be better to use kmalloc and then
only if it fails use vmalloc.

See examples like net/sched/sch_hhf.c


