Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3JKFif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:38:35 -0400
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:43093 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752332Ab3JKFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:38:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: crown43_84b0e897c7f18
X-Filterd-Recvd-Size: 1587
Message-ID: <1381469910.14017.45.camel@joe-AO722>
Subject: Re: [PATCH 1/2] vsprintf/sysctl: Bugfix, neaten and document %pK
 usages
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Oct 2013 22:38:30 -0700
In-Reply-To: <52578D37.2000004@gmail.com>
References: <0aef7497929fd764a88ca7b3c22f082a5c2fe909.1381468961.git.joe@perches.com>
	 <52578D37.2000004@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 16:31 +1100, Ryan Mallon wrote:
> On 11/10/13 16:25, Joe Perches wrote:
> > Printing kernel pointers via %pK has a minor defect when
> > kptr_restrict is set to 2:  the pointer may be emitted
> > as "pK-error" instead of all 0's when in an interrupt.
> 
> NAK. This is not a defect, as I explained earlier. It is really a defect
> that it _doesn't_ print 'pK-error' in all cases. 'pK-error' is for
> finding kernel bugs.

Not my understanding.

There is no bug to find when emitting a pointer via %pK.

The only issue is that has_capability_noaudit can not
be called from an interrupt.


