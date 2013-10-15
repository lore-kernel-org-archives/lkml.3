Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3JOCo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 22:44:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55360 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3JOCo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 22:44:57 -0400
Date: Tue, 15 Oct 2013 03:44:52 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [3.11.4] Thunderbolt/PCI unplug oops in pci_pme_list_scan
Message-ID: <20131015024452.GA31951@srcf.ucam.org>
References: <CAMxnaaUim-MCDpaTiLmBqN3wfxjn9V6XE_n4SMfuO=vqeT6rVA@mail.gmail.com>
 <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4KU9VAC=SnKuYH3EPz8NuozixAhUQBKv+=Y=76wywdTg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:50:38PM -0600, Bjorn Helgaas wrote:
> [+cc Rafael, Mika, Kirill, linux-pci]
> 
> On Mon, Oct 14, 2013 at 4:47 PM, Andreas Noever
> <andreas.noever@gmail.com> wrote:
> > When I unplug the Thunderbolt ethernet adapter on my MacBookPro Linux
> > crashes a few seconds later. Using
> > echo 1 > /sys/bus/pci/devices/0000:08:00.0/remove
> > to remove a bridge two levels above the device triggers the fault immediately:
> 
> There have been significant changes in acpiphp related to Thunderbolt
> since v3.11.

Apple don't expose Thunderbolt via ACPI, so it appears as native PCIe. 
I'd be surprised if acpiphp makes a difference here.

(Whine whine Intel continuing to refuse to provide documentation for a 
widely shipped part whine whine)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
