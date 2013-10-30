Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3J3W6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:58:42 -0400
Received: from smtprelay0114.hostedemail.com ([216.40.44.114]:50194 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751510Ab3J3W6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:58:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3870:3871:3872:3874:4321:5007:6120:6691:7652:7903:10004:10400:10848:10967:11232:11658:11914:12043:12050:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: game29_85b2be7876f31
X-Filterd-Recvd-Size: 1902
Message-ID: <1383173916.9435.53.camel@joe-AO722>
Subject: Re: [RFC PATCH -next] Fix printk_once build errors due to
 __read_mostly
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-metag@vger.kernel.org
Date: Wed, 30 Oct 2013 15:58:36 -0700
In-Reply-To: <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	 <20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 13:48 -0700, Andrew Morton wrote:
> On Wed, 30 Oct 2013 10:18:21 +0000 James Hogan <james.hogan@imgtec.com> wrote:
[]
> > Note that this actually adds a recursive include, since <linux/cache.h>
> > includes <linux/kernel.h>, which includes <linux/printk.h>. The actual
> > dependencies are all in macros so it doesn't actually seem to result in
> > any build failures, but it's clearly less than ideal.
> 
> Yitch.

Yeah.

There are about ~700 files in the tree that use __read_mostly.
Only about ~25 of those actually #include <linux/cache.h>

I did a script that adds the #include, but 700 files is a _lot_.

For today's next:

$ git grep -w --name-only __read_mostly | \
  xargs grep -P -l "^\s*#\s*include\s+<linux/cache.h>" | wc -l
28

$ git grep -w --name-only __read_mostly | \
  xargs grep -P -L "^\s*#\s*include\s+<linux/cache.h>" | wc -l
716

Untangling that crud is nasty.

