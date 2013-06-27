Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3F0Nyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:54:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:17984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685Ab3F0Nyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:54:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,952,1363158000"; 
   d="scan'208";a="356649656"
Date: Thu, 27 Jun 2013 16:58:19 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
Message-ID: <20130627135819.GX9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo58bCG4=hwC73VY+nXPk9-dZUb5eWERZ_wTtAfrXtBVmg@mail.gmail.com>
 <CAE9FiQW9xuu6WjH59td6Jve10kokoxU4mNqj4DRyg7beqBzHDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW9xuu6WjH59td6Jve10kokoxU4mNqj4DRyg7beqBzHDA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:26:59PM -0700, Yinghai Lu wrote:
> On Wed, Jun 26, 2013 at 3:18 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> >> Thunderbolt PCI-to-PCI bridges typically use BIOS "assisted" enumeration.
> >> This means that the BIOS will allocate bridge resources based on some
> >> assumptions of a maximum Thunderbolt chain. It also disables native PCIe
> >> hotplug of the root port where the Thunderbolt host router is connected.
> 
> We should not need tricks in this patch after
> 
> https://patchwork.kernel.org/patch/2766521/
> 
> [2/3] PCI / ACPI: Use boot-time resource allocation rules during hotplug

Unfortunately that patch is not enough :-( We still need to make sure that
we don't add anything to the bridge window sizes like __pci_bus_size_bridges()
is currently doing (e.g similar to pci=hpmemsize=0,hpiosize=0 for the
Thunderbolt bridges).
