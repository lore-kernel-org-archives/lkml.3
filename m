Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3JIBep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:34:45 -0400
Received: from ozlabs.org ([203.10.76.45]:47788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962Ab3JIBek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:34:40 -0400
Date: Wed, 9 Oct 2013 12:34:37 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
Message-ID: <20131009013437.GC23780@concordia>
References: <cover.1380703262.git.agordeev@redhat.com>
 <20131008043330.GF31666@concordia>
 <20131008073301.GC10669@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008073301.GC10669@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 09:33:02AM +0200, Alexander Gordeev wrote:
> On Tue, Oct 08, 2013 at 03:33:30PM +1100, Michael Ellerman wrote:
> > On Wed, Oct 02, 2013 at 12:29:04PM +0200, Alexander Gordeev wrote:
> > > This technique proved to be confusing and error-prone. Vast share
> > > of device drivers simply fail to follow the described guidelines.
> > 
> > To clarify "Vast share of device drivers":
> > 
> >  - 58 drivers call pci_enable_msix()
> >  - 24 try a single allocation and then fallback to MSI/LSI
> >  - 19 use the loop style allocation as above
> >  - 14 try an allocation, and if it fails retry once
> >  - 1  incorrectly continues when pci_enable_msix() returns > 0
> > 
> > So 33 drivers (> 50%) successfully make use of the "confusing and
> > error-prone" return value.
> 
> Ok, you caught me - 'vast share' is incorrect and is a subject to
> rewording. But out of 19/58 how many drivers tested fallbacks on the
> real hardware? IOW, which drivers are affected by the pSeries quota?

It's not 19/58, it's 33/58.

As to how many we care about on powerpc I can't say, so you have a point
there. But I still think the interface is not actually that terrible.

cheers
