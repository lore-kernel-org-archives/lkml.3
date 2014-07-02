Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbaGBTMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:12:50 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:56978 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbaGBTMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:12:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>
Subject: Re: [PATCH v8 2/9] pci: Export find_pci_host_bridge() function.
Date: Wed, 02 Jul 2014 21:12:05 +0200
Message-ID: <7101568.8DVJFku5jp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACoXjck+aU33=kSy=KCGABNXNR7tj2KndAiBqEDK7wQ_Qei80Q@mail.gmail.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <1404240214-9804-3-git-send-email-Liviu.Dudau@arm.com> <CACoXjck+aU33=kSy=KCGABNXNR7tj2KndAiBqEDK7wQ_Qei80Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LDuM8Rxu3xdE/SDk4g208Z1ObAAB0ugG9sVnrHSqJfB
 dOQBgGGKBdlF2n85mtxNRclibzNR2Qp2jLZX6/CXjn0coeV5lC
 Hh/vE5HXQtsmyixI63fBuFNRtIqhkC66eetVpyiZDbkMk6NZKt
 JjCErFELSiIXXvgVBCYDSvyidSRhRxHheEIvX54nal4csOWqCh
 7pRfVfmWABJmJgXInhA1KCXmVigt18/w+L49w96/DMqNPYjjhq
 u2RnnwufYhccKusPLjZQcyzsJVsIj2qSof6fEo9YNZU31TQVyV
 HH2N90yQQCvJaQmVZa2W/MPcA2zULKAR1X7O5YS8QpZdR5fsXq
 7PE5+vIaJEZP83AMCav4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2014 11:06:38 Tanmay Inamdar wrote:
> On Tue, Jul 1, 2014 at 11:43 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > This is a useful function and we should make it visible outside the
> > generic PCI code. Export it as a GPL symbol.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > ---
> >  drivers/pci/host-bridge.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
> > index 0e5f3c9..36c669e 100644
> > --- a/drivers/pci/host-bridge.c
> > +++ b/drivers/pci/host-bridge.c
> > @@ -16,12 +16,13 @@ static struct pci_bus *find_pci_root_bus(struct pci_bus *bus)
> >         return bus;
> >  }
> >
> > -static struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> > +struct pci_host_bridge *find_pci_host_bridge(struct pci_bus *bus)
> >  {
> >         struct pci_bus *root_bus = find_pci_root_bus(bus);
> >
> >         return to_pci_host_bridge(root_bus->bridge);
> >  }
> > +EXPORT_SYMBOL_GPL(find_pci_host_bridge);
> 
> Is there any specific reason behind making this symbol GPL? I think
> the other functions in this file are just EXPORT_SYMBOL. Ultimately
> companies which have non gpl Linux modules (nvidia) will face issue
> using this API.
> 
> The same applies to 'of_create_pci_host_bridge'.

I think EXPORT_SYMBOL_GPL() is better here. The new symbols are unlikely
to be used by a peripheral device driver, and PCI host controllers are
already restricted by EXPORT_SYMBOL_GPL.

nvidia will certainly not do a PCI host controller driver that is not
upstream or not GPL-compatible.

	Arnd
