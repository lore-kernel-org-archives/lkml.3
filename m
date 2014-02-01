Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaBASl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 13:41:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:51269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbaBASlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 13:41:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,760,1384329600"; 
   d="scan'208";a="474398805"
Date: Sat, 1 Feb 2014 20:48:22 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "PCI: Remove from bus_list and release resources
 in pci_release_dev()"
Message-ID: <20140201184822.GO18029@intel.com>
References: <20140130131236.GW18029@intel.com>
 <1676758.QjUXk2223P@vostro.rjw.lan>
 <CAE9FiQX_AuSPq159AwDHP+n0k6FK3pS2CNttPFAJP2K-84ho1w@mail.gmail.com>
 <14676899.LOmsodapl3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14676899.LOmsodapl3@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 03:38:29PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: Revert "PCI: Remove from bus_list and release resources in pci_release_dev()"
> 
> Revert commit ef83b0781a73 "PCI: Remove from bus_list and release
> resources in pci_release_dev()" that made some nasty race conditions
> become possible.  For example, if a Thunderbolt link is unplugged
> and then replugged immediately, the pci_release_dev() resulting from
> the hot-remove code path may be racing with the hot-add code path
> which after that commit causes various kinds of breakage to happen
> (up to and including a hard crash of the whole system).
> 
> Moreover, the problem that commit ef83b0781a73 attempted to address
> cannot happen any more after commit 8a4c5c329de7 "PCI: Check parent
> kobject in pci_destroy_dev()", because pci_destroy_dev() will now
> return immediately if it has already been executed for the given
> device.
> 
> Note, however, that the invocation of msi_remove_pci_irq_vectors()
> removed by commit ef83b0781a73 from pci_free_resources() along with
> the other changes made by it is not added back because of subsequent
> code changes depending on that modification.
> 
> Fixes: ef83b0781a73 (PCI: Remove from bus_list and release resources in pci_release_dev())
> Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks, that fixes the problem I'm seeing.
