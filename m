Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaFNQGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:06:07 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:36581 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754875AbaFNQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:06:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3868:3870:3871:3872:4321:4605:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: land09_8c147a5f6633e
X-Filterd-Recvd-Size: 1509
Message-ID: <1402761961.2756.12.camel@joe-AO725>
Subject: Re: [PATCH] Coccinelle : Script to detect cast after memory
 allocation
From: Joe Perches <joe@perches.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Date: Sat, 14 Jun 2014 09:06:01 -0700
In-Reply-To: <20140614154541.GA4179@himangi-Dell>
References: <20140614154541.GA4179@himangi-Dell>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-14 at 21:15 +0530, Himangi Saraogi wrote:
> This script detects cases of use of cast for the value returned by
> kmalloc, kzalloc, kcalloc, kmem_cache_alloc, kmem_cache_zalloc,
> kmem_cache_alloc_node, kmalloc_node and kzalloc_node and removes
> the cast as it is not useful. This Coccinelle script replaces
> drop_kmalloc_cast.cocci as it removes the casting in more limited
> cases of kmalloc, kzalloc and kcalloc.

Perhaps make this more generic for any void *?

Something like:

@@
void *t;
type other;
@@

-       (other *)t
+       t


