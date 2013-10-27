Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3J0W16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:27:58 -0400
Received: from ozlabs.org ([203.10.76.45]:51218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab3J0W14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:27:56 -0400
Message-ID: <1382912874.3371.9.camel@concordia>
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
From: Michael Ellerman <michael@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Date: Mon, 28 Oct 2013 09:27:54 +1100
In-Reply-To: <20131025100103.GA317@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
	 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
	 <20131024105158.GB13159@mtj.dyndns.org>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com>
	 <20131024114133.GA26610@dhcp-26-207.brq.redhat.com>
	 <5269D5D1.60103@start.ca>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B73B0@saturn3.aculab.com>
	 <20131025100103.GA317@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-25 at 12:01 +0200, Alexander Gordeev wrote:
> On Fri, Oct 25, 2013 at 10:10:02AM +0100, David Laight wrote:
> > What this doesn't resolve is a driver requesting a lot of interrupts
> > early on and leaving none for later drivers.
> 
> If this problem really exists anywhere besides pSeries?
> 
> I can imagine x86 hitting lack of vectors in interrupt table when
> number of CPUs exceeds hundreds, but do we have this problem now?
> 
> > Really the system needs to allocate the minimum number to all
> > drivers before giving out any extra ones - I've NFI how this
> > would be arranged!
> 
> Do not know. The pSeries quota approach seems more reasonable to me.

When the system boots each driver should get a fair share of the
available MSIs, the quota achieves this.

But ideally the sysadmin would then be able to override that, and give
more MSIs to one device, the quota doesn't allow that.

Hopefully we'll see the number of available MSIs grow faster than the
number required by devices (usually driven by NR_CPUs), and so this will
become a non-problem.

cheers

