Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab3J0WOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:14:15 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:57671 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754236Ab3J0WON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:14:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3866:3867:3868:3871:3874:4321:5007:6691:7652:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: teeth06_7667cb587d5e
X-Filterd-Recvd-Size: 1716
Message-ID: <1382912049.30941.5.camel@joe-AO722>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 15:14:09 -0700
In-Reply-To: <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 22:02 +0000, Ben Hutchings wrote:
> On Sun, 2013-10-27 at 14:58 -0700, Joe Perches wrote:
> > On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> > > Physical addresses may be wider than virtual addresses (e.g. on i386
> > > with PAE) and must not be formatted with %p.
> > 
> > %pa works.  %pa also prefixes with 0x.
> 
> Only as long as pci_resource_start() happens to be an lvalue.  I'd
> rather not introduce that assumption.

pci_resource_start returns a resource_size_t which is a phys_addr_t.

Changing that from an lvalue would cause a _lot_ of breakage.


