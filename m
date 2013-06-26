Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3FZMOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:14:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:65330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab3FZMOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,943,1363158000"; 
   d="scan'208";a="360776553"
Date: Wed, 26 Jun 2013 15:17:57 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Message-ID: <20130626121757.GP9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
 <20130625141556.2f9de7b1@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625141556.2f9de7b1@jbarnes-desktop>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 02:15:56PM -0700, Jesse Barnes wrote:
> On Tue, 25 Jun 2013 19:22:10 +0300
> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> 
> > +	if (!(pci_probe & PCI_NOASSIGN_ROMS)) {
> > +		pr_info("Thunderbolt host router detected disabling ROMs\n");
> > +		pci_probe |= PCI_NOASSIGN_ROMS;
> > +	}
> 
> I wonder if this should just be the default on x86?  Or do we allocate
> ROM space to address some other platform where we need it and the BIOS
> doesn't do it for the devices we care about?

Good question. In our case it definitely helps to have pci=norom the
default. Can't tell if it might break something that depends on the current
behaviour.

Bjorn, Greg, Rafael,

What do you think?
