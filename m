Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967056Ab3E2VEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 17:04:02 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18021 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966943Ab3E2VDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 17:03:55 -0400
Date: Wed, 29 May 2013 17:03:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jan Beulich <JBeulich@suse.com>, xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-pciback: more uses of cached MSI-X capability offset
Message-ID: <20130529210346.GC2450@phenom.dumpdata.com>
References: <51A6113302000078000D99A3@nat28.tlf.novell.com>
 <CAErSpo53UtV2bHVEMYWaHk-j5cVWxhYfX76qP=m1Q4gxsc8mUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo53UtV2bHVEMYWaHk-j5cVWxhYfX76qP=m1Q4gxsc8mUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 02:51:11PM -0600, Bjorn Helgaas wrote:
> On Wed, May 29, 2013 at 6:31 AM, Jan Beulich <JBeulich@suse.com> wrote:
> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >
> > ---
> >  drivers/xen/xen-pciback/pci_stub.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> I assume you'll take this, Konrad.  Let me know if you need me to do anything.

Yes, in my queue as we speak. Thanks.
> 
> > --- 3.10-rc3/drivers/xen/xen-pciback/pci_stub.c
> > +++ 3.10-rc3-xen-pciback-MSI-X-cap/drivers/xen/xen-pciback/pci_stub.c
> > @@ -106,7 +106,7 @@ static void pcistub_device_release(struc
> >         else
> >                 pci_restore_state(dev);
> >
> > -       if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> > +       if (dev->msix_cap) {
> >                 struct physdev_pci_device ppdev = {
> >                         .seg = pci_domain_nr(dev->bus),
> >                         .bus = dev->bus->number,
> > @@ -371,7 +371,7 @@ static int pcistub_init_device(struct pc
> >         if (err)
> >                 goto config_release;
> >
> > -       if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
> > +       if (dev->msix_cap) {
> >                 struct physdev_pci_device ppdev = {
> >                         .seg = pci_domain_nr(dev->bus),
> >                         .bus = dev->bus->number,
> >
> >
> >
