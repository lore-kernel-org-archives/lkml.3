Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab3LIS4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:56:51 -0500
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:56362 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932779Ab3LIS4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:56:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3870:3871:3872:3874:4321:5007:6119:6120:7652:7901:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:13869:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cub97_3b4030f731e40
X-Filterd-Recvd-Size: 1514
Message-ID: <1386615406.8168.16.camel@joe-AO722>
Subject: Re: [PATCH 1/3] softirq: Use ffs in __do_softirq
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Mon, 09 Dec 2013 10:56:46 -0800
In-Reply-To: <20131209184454.GA1811@localhost.localdomain>
References: <cover.1384656563.git.joe@perches.com>
	 <8d10077333476c5c0e054cf060006999cf150f0c.1384656563.git.joe@perches.com>
	 <20131209184454.GA1811@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 19:44 +0100, Frederic Weisbecker wrote:
> On Sun, Nov 17, 2013 at 01:55:10AM -0800, Joe Perches wrote:
> > Possible speed improvement of the __do_softirq function by using ffs
> > instead of using a while loop with an & 1 test then single bit shift.
[]
> Perhaps using for_each_set_bit() would simplify that more?

It might simplify the appearance of the code but it
would/could expand the amount of generated code because
for_each_set_bit uses an address_of(unsigned long) and
the value tested is an unsigned int.

extra dereferences, can't be in a register, etc...


