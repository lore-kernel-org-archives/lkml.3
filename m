Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3JCVqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:46:33 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:33127 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3JCVq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:46:29 -0400
Message-ID: <1380836781.3419.17.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH RFC 01/77] PCI/MSI: Fix return value when
 populate_msi_sysfs() failed
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jon Mason <jon.mason@intel.com>
CC: Alexander Gordeev <agordeev@redhat.com>, <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "Ingo Molnar" <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Matt Porter <mporter@kernel.crashing.org>, <stable@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux390@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <x86@kernel.org>,
        <linux-ide@vger.kernel.org>, <iss_storagedev@hp.com>,
        <linux-nvme@lists.infradead.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <e1000-devel@lists.sourceforge.net>,
        <linux-driver@qlogic.com>,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, <linux-scsi@vger.kernel.org>
Date: Thu, 3 Oct 2013 22:46:21 +0100
In-Reply-To: <20131003003905.GK6768@jonmason-lab>
References: <cover.1380703262.git.agordeev@redhat.com>
	 <3ff5236944aae69f2cd934b5b6da7c1c269df7c1.1380703262.git.agordeev@redhat.com>
	 <20131003003905.GK6768@jonmason-lab>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20192.004
X-TM-AS-Result: No--20.388900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 17:39 -0700, Jon Mason wrote:
> On Wed, Oct 02, 2013 at 12:48:17PM +0200, Alexander Gordeev wrote:
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> 
> Since you are changing the behavior of the msix_capability_init
> function on populate_msi_sysfs error, a comment describing why in this
> commit would be nice.
[...]

This function was already treating that error as fatal, and freeing the
MSIs.  The change in behaviour is that it now returns the error code in
this case, rather than 0.  This is obviously correct and properly
described by the one-line summary.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

