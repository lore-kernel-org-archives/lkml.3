Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3J0Wym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:54:42 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:42397 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752982Ab3J0Wyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:54:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3866:3867:3868:3872:3873:3874:4321:5007:6119:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13071:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: peace31_45b9e060a5104
X-Filterd-Recvd-Size: 1868
Message-ID: <1382914478.30941.18.camel@joe-AO722>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 15:54:38 -0700
In-Reply-To: <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
	 <1382911111.30941.2.camel@joe-AO722>
	 <1382911333.2994.55.camel@deadeye.wl.decadent.org.uk>
	 <1382912049.30941.5.camel@joe-AO722>
	 <1382912801.2994.61.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-27 at 22:26 +0000, Ben Hutchings wrote:
> I don't think so.  This doesn't find anything:
>     git grep '&[ (]*pci_resource_start'
> and I was able to build drivers/{net,pci,scsi}/ successfully with
> pci_resource_start() changed to an inline function.

Hi again Ben.  You're right.

It could be nice though to have some mechanism to get from
a pci_resource_start/end that could be emitted via %pa
without an intermediate or casting like
(unsigned long long)pci_resource_<foo>(struct resource *)

There are at least a few dozen uses of dmesg/seq_printf with
%llx or %lx and (some_cast)pci_resource_<foo> that could be
converted.

