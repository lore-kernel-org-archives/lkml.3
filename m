Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3JJKQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:16:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3JJKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:15:57 -0400
Date: Thu, 10 Oct 2013 12:17:05 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
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
Message-ID: <20131010101704.GC11874@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <5254D397.9030307@zytor.com>
 <1381292648.645.259.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381292648.645.259.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:24:08PM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2013-10-08 at 20:55 -0700, H. Peter Anvin wrote:
> > Why not add a minimum number to pci_enable_msix(), i.e.:
> > 
> > pci_enable_msix(pdev, msix_entries, nvec, minvec)
> > 
> > ... which means "nvec" is the number of interrupts *requested*, and
> > "minvec" is the minimum acceptable number (otherwise fail).
> 
> Which is exactly what Ben (the other Ben :-) suggested and that I
> supports...

Ok, this suggestion sounded in one or another form by several people.
What about name it pcim_enable_msix_range() and wrap in couple more
helpers to complete an API:

int pcim_enable_msix_range(pdev, msix_entries, nvec, minvec);
	<0 - error code
	>0 - number of MSIs allocated, where minvec >= result <= nvec

int pcim_enable_msix(pdev, msix_entries, nvec);
	<0 - error code
	>0 - number of MSIs allocated, where 1 >= result <= nvec 

int pcim_enable_msix_exact(pdev, msix_entries, nvec);
	<0 - error code
	>0 - number of MSIs allocated, where result == nvec

The latter's return value seems odd, but I can not help to make
it consistent with the first two.


(Sorry if you see this message twice - my MUA seems struggle with one of CC).

> Cheers,
> Ben.
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
