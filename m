Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3JQIzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:55:19 -0400
Received: from smtprelay0057.hostedemail.com ([216.40.44.57]:40103 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751099Ab3JQIzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:55:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1978:2196:2199:2393:2553:2559:2562:2740:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4250:4321:4385:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bu
X-HE-Tag: spy18_108bae66b4000
X-Filterd-Recvd-Size: 2116
Message-ID: <1382000112.22110.103.camel@joe-AO722>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>, tony.luck@intel.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Thu, 17 Oct 2013 01:55:12 -0700
In-Reply-To: <20131017084014.GD5036@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
	 <1381978749.22110.76.camel@joe-AO722>
	 <20131017063059.GB14946@gchen.bj.intel.com>
	 <1381993136.22110.95.camel@joe-AO722>
	 <20131017073824.GC14946@gchen.bj.intel.com>
	 <1381998750.22110.101.camel@joe-AO722> <20131017084014.GD5036@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 10:40 +0200, Borislav Petkov wrote:
> On Thu, Oct 17, 2013 at 01:32:30AM -0700, Joe Perches wrote:
> > On Thu, 2013-10-17 at 03:38 -0400, Chen Gong wrote:
> > > the point is we can use GENMASK like GENMASK(end_bit, start_bit) but
> > > we don't know the value of end_bit/start_bit at compile-time.
> > 
> > True.
> > 
> > The BUILD_BUG_ON idea is just to avoid people using
> > 	GENMASK(1, 2)
> 
> They'll notice the 0 pretty quickly when they test their code.
> 
> Let's add those checks only when it is really necessary and people have
> actually made that mistake repeatedly.

It's cost free to add the BUILD_BUG_ON
and perhaps you underestimate the runtime
bug checking effort,

