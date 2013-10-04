Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab3JDIdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 04:33:51 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60570 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752846Ab3JDIdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 04:33:44 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
Date: Fri, 4 Oct 2013 09:31:49 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7371@saturn3.aculab.com>
In-Reply-To: <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH RFC 00/77] Re-design MSI/MSI-X interrupts enablement pattern
Thread-Index: Ac7A24Xh24Ru1N/rSJKnB/t2ngSngQAAEvWg
References: <cover.1380703262.git.agordeev@redhat.com> <1380840585.3419.50.camel@bwh-desktop.uk.level5networks.com> <20131004082920.GA4536@dhcp-26-207.brq.redhat.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Alexander Gordeev" <agordeev@redhat.com>,
        "Ben Hutchings" <bhutchings@solarflare.com>
Cc: <linux-mips@linux-mips.org>, "VMware, Inc." <pv-drivers@vmware.com>,
        <linux-nvme@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, "Andy King" <acking@vmware.com>,
        <linux-scsi@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <x86@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
        <linux-pci@vger.kernel.org>, <iss_storagedev@hp.com>,
        <linux-driver@qlogic.com>, "Tejun Heo" <tj@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        "Jon Mason" <jon.mason@intel.com>,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        <e1000-devel@lists.sourceforge.net>,
        "Martin Schwidefsky" <schwidefsky@de.ibm.com>, <linux390@de.ibm.com>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It seems to me that a more useful interface would take a minimum and
> > maximum number of vectors from the driver.  This wouldn't allow the
> > driver to specify that it could only accept, say, any even number within
> > a certain range, but you could still leave the current functions
> > available for any driver that needs that.
> 
> Mmmm.. I am not sure I am getting it. Could you please rephrase?

One possibility is for drivers than can use a lot of interrupts to
request a minimum number initially and then request the additional
ones much later on.
That would make it less likely that none will be available for
devices/drivers that need them but are initialised later.

	David



