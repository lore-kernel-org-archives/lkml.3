Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbaDPWsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:48:00 -0400
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:40522 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754206AbaDPWr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:47:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:8957:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13095:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit73_4579b93572363
X-Filterd-Recvd-Size: 1756
Message-ID: <1397688476.3105.13.camel@joe-AO725>
Subject: Re: [PATCH 1/1] fs/xfs/xfs_log.c: Fix comparison to bool
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>, hch <hch@infradead.org>
Date: Wed, 16 Apr 2014 15:47:56 -0700
In-Reply-To: <20140416151557.ac032e9621027faa8fc7f86d@linux-foundation.org>
References: <20140413220917.a566d048eb0cc55b5ec9f7be@skynet.be>
	 <20140416151557.ac032e9621027faa8fc7f86d@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 15:15 -0700, Andrew Morton wrote:
> On Sun, 13 Apr 2014 22:09:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> > Fixing coccinelle warning
[]
> > @@ -2376,7 +2376,7 @@ next_lv:
[]
> > -			if (record_cnt == 0 && ordered == false) {
> > +			if (record_cnt == 0 && !ordered) {
[]
> There was nothing wrong with that code.  I suspect coccinelle bustage.

Not really.

It's more a conceit that consistent uses of direct
boolean variable tests are less likely to be error
prone than variable comparisons to boolean literals.

Many style guides, CodingStyle not included, suggest
avoiding comparisons to boolean literals.

There is a checkpatch --strict message when comparing
a literal true/false.

I tend not to change these unless there are multiple
styles in the same subsystem/file.

