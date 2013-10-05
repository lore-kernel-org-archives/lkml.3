Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3JEVsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 17:48:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:46609 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab3JEVsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 17:48:21 -0400
Message-ID: <1381009586.645.141.camel@pasglop>
Subject: Re: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement
 pattern
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>, linux-kernel@vger.kernel.org,
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
Date: Sun, 06 Oct 2013 08:46:26 +1100
In-Reply-To: <20131005142054.GA11270@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
	 <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com>
	 <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
	 <1380922156.3214.49.camel@bwh-desktop.uk.level5networks.com>
	 <20131005142054.GA11270@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-05 at 16:20 +0200, Alexander Gordeev wrote:
> So my point is - drivers should first obtain a number of MSIs they *can*
> get, then *derive* a number of MSIs the device is fine with and only then
> request that number. Not terribly different from memory or any other type
> of resource allocation ;)

What if the limit is for a group of devices ? Your interface is racy in
that case, another driver could have eaten into the limit in between the
calls.

Ben.


