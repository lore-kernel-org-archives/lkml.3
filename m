Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3FZWPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:15:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993Ab3FZWPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:15:16 -0400
Message-ID: <1372284901.30572.625.camel@ul30vt.home>
Subject: Re: [PATCH 6/6] x86/PCI: quirk Thunderbolt PCI-to-PCI bridges
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Date: Wed, 26 Jun 2013 16:15:01 -0600
In-Reply-To: <CAErSpo6aQMtav89V8wyu+NZxro91o1MnB1ViG-4ExrCgLPKmjg@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	 <1372177330-28013-7-git-send-email-mika.westerberg@linux.intel.com>
	 <20130625141556.2f9de7b1@jbarnes-desktop> <20130626121757.GP9294@intel.com>
	 <CAErSpo6aQMtav89V8wyu+NZxro91o1MnB1ViG-4ExrCgLPKmjg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 14:59 -0600, Bjorn Helgaas wrote:
> [+cc Alex]
> 
> On Wed, Jun 26, 2013 at 6:17 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > On Tue, Jun 25, 2013 at 02:15:56PM -0700, Jesse Barnes wrote:
> >> On Tue, 25 Jun 2013 19:22:10 +0300
> >> Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> >>
> >> > +   if (!(pci_probe & PCI_NOASSIGN_ROMS)) {
> >> > +           pr_info("Thunderbolt host router detected disabling ROMs\n");
> >> > +           pci_probe |= PCI_NOASSIGN_ROMS;
> >> > +   }
> >>
> >> I wonder if this should just be the default on x86?  Or do we allocate
> >> ROM space to address some other platform where we need it and the BIOS
> >> doesn't do it for the devices we care about?
> >
> > Good question. In our case it definitely helps to have pci=norom the
> > default. Can't tell if it might break something that depends on the current
> > behaviour.
> 
> I think the current default behavior is that if the BIOS has assigned
> the ROM BAR, we keep that assignment, and if it hasn't, we allocate
> MEM space for it.  And "pci=norom" means that we don't allocate MEM
> space for it, even if the BIOS hasn't assigned it.
> 
> "pci=norom" is only implemented on x86.  I think most other arches
> allocate MEM space for ROMs, with no way to turn that off.  PA-RISC
> seems to ignore ROMs (dino_fixup_bus()), but that looks like the
> exception.
>
> I'm slightly concerned that if we make the x86 default be "never
> assign space for ROMs unless the BIOS has done it," we might break
> virtualized guests that need access to ROMs.  Alex?

Yep, I'm more than slightly concerned by that too.  Whenever possible we
want to pass the ROM to the guest since it may end up being a boot
device or drivers within the guest may require it.  We can pass the ROM
to the guest from an image file, but that requires someplace from which
to dump the image, which is usually PCI sysfs.  Thanks,

Alex

