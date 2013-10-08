Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3JHHzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 03:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab3JHHzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 03:55:48 -0400
Date: Tue, 8 Oct 2013 09:56:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH RFC 05/77] PCI/MSI: Convert pci_msix_table_size() to a
 public interface
Message-ID: <20131008075658.GE10669@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <e8b51bd48c24d0fc4ee8adea5c138c9bf84191e9.1380703262.git.agordeev@redhat.com>
 <20131007181043.GA27396@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007181043.GA27396@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 02:10:43PM -0400, Tejun Heo wrote:
> On Wed, Oct 02, 2013 at 12:48:21PM +0200, Alexander Gordeev wrote:
> > Make pci_msix_table_size() to return a error code if the device
> > does not support MSI-X. This update is needed to facilitate a
> > forthcoming re-design MSI/MSI-X interrupts enabling pattern.
> > 
> > Device drivers will use this interface to obtain maximum number
> > of MSI-X interrupts the device supports and use that value in
> > the following call to pci_enable_msix() interface.
> 
> Hmmm... I probably missed something but why is this necessary?  To
> discern between -EINVAL and -ENOSPC?  If so, does that really matter?

pci_msix_table_size() is kind of helper and returns 0 if a device does
not have MSI-X table. If we want drivers to use it we need return -EINVAL
for MSI-X incapable/disabled devices. Nothing about -ENOSPC.

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
