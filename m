Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3JJQaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:30:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44646 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688Ab3JJQaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:30:01 -0400
Message-ID: <5256D5AB.4050105@zytor.com>
Date: Thu, 10 Oct 2013 09:28:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
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
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
References: <cover.1380703262.git.agordeev@redhat.com> <5254D397.9030307@zytor.com> <1381292648.645.259.camel@pasglop> <20131010101704.GC11874@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20131010101704.GC11874@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 03:17 AM, Alexander Gordeev wrote:
> On Wed, Oct 09, 2013 at 03:24:08PM +1100, Benjamin Herrenschmidt wrote:
> 
> Ok, this suggestion sounded in one or another form by several people.
> What about name it pcim_enable_msix_range() and wrap in couple more
> helpers to complete an API:
> 
> int pcim_enable_msix_range(pdev, msix_entries, nvec, minvec);
> 	<0 - error code
> 	>0 - number of MSIs allocated, where minvec >= result <= nvec
> 
> int pcim_enable_msix(pdev, msix_entries, nvec);
> 	<0 - error code
> 	>0 - number of MSIs allocated, where 1 >= result <= nvec 
> 
> int pcim_enable_msix_exact(pdev, msix_entries, nvec);
> 	<0 - error code
> 	>0 - number of MSIs allocated, where result == nvec
> 
> The latter's return value seems odd, but I can not help to make
> it consistent with the first two.
> 

Is there a reason for the wrappers, as opposed to just specifying either
1 or nvec as the minimum?

	-hpa


