Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463Ab3IEHjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 03:39:10 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:63508 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab3IEHjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 03:39:08 -0400
X-IronPort-AV: E=Sophos;i="4.90,845,1371081600"; 
   d="scan'208";a="8449194"
Message-ID: <1378366746.6935.35.camel@dagon.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] net/core: Order-3 frag allocator causes
 SWIOTLB bouncing under Xen
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org,
        Eric Dumazet <edumazet@google.com>, Li Zefan <lizefan@huawei.com>,
        david.vrabel@citrix.com, Zoltan Kiss <zoltan.kiss@citrix.com>,
        malcolm.crossley@citrix.com, "David S. Miller" <davem@davemloft.net>
Date: Thu, 5 Sep 2013 08:39:06 +0100
In-Reply-To: <20130904211110.GA17758@phenom.dumpdata.com>
References: <1378327638-23956-1-git-send-email-zoltan.kiss@citrix.com>
	 <1378328440.7360.124.camel@edumazet-glaptop>
	 <20130904211110.GA17758@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-04 at 17:11 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Sep 04, 2013 at 02:00:40PM -0700, Eric Dumazet wrote:

> > Maybe you could add proper infrastructure to deal with Xen limitations.
> 
> I think Ian posted at some point an sysctl patch for that (more for
> debugging that anything else). And it kind
> of stalled: http://lists.xen.org/archives/html/xen-devel/2012-10/msg01832.html

I think I though you were looking into it from the swiotlb angle?

In any case I don't have time to look into this further.

> Is that what you mean by proper infrastructure ?
> 
> Oh wait, did you mean via dev and not the whole system wide sysctl?

The system wide sysctl was not acceptable AFAIR, which seems reasonable.

Per-dev is hard because it affects the native drivers for each physical
NIC when running under Xen, not the Xen PV NIC which we fixed by
splitting compound frags into separate slots on the PV ring.

Ian.

