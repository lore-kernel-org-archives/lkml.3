Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab3H3NYD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:24:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37477 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3H3NXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:23:47 -0400
Date: Fri, 30 Aug 2013 09:23:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com
Subject: Re: [PATCH v4 09/10] swiotlb-xen: support autotranslate guests
Message-ID: <20130830132312.GF21239@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308151200580.4470@kaball.uk.xensource.com>
 <1376565054-24153-9-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130815200738.GD5337@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1308282112300.6397@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308282112300.6397@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Did you run any performance tests to see if adding the extra
> > spinlock (as the native SWIOTLB already has its own lock) and handling
> > of the tree is affecting it?

.. bla bla..

> I haven't done any measurements but consider that the spin_lock is
> already only used to access the red-black tree that keeps track of
> dma_addr -> phys_addr mappings.
> So it's taken at setup time once, then every time we call
> xen_bus_to_phys and the guest is an autotraslate guest.
> If the guest is not autotraslate there are no additional locks.
> 
> That makes me realize that we don't need any spin_locks at all: there
> are no risks of concurrent accesses and modifications of the tree
> because there are no changes on the tree once it's setup at boot time.
> We can get rid of the spin_lock entirely as concurrent read accesses on
> the tree are obviously fine.

Nice :-) I think that (and the goto) were the only concerns I had.

Thanks!
