Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab3LQWdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:33:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab3LQWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:33:09 -0500
Message-ID: <1387319587.30327.18.camel@bling.home>
Subject: Re: [PATCH 3/3] pci: Add Virtual Channel to save/restore support
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 15:33:07 -0700
In-Reply-To: <CAErSpo6TH7QghPMhDxrohEz5rUtSiQEh_VR66f+jckPUWjey0g@mail.gmail.com>
References: <20131210183339.26294.14581.stgit@bling.home>
	 <20131210184845.26294.81385.stgit@bling.home>
	 <20131217004815.GA4781@google.com> <1387318331.30327.16.camel@bling.home>
	 <CAErSpo6TH7QghPMhDxrohEz5rUtSiQEh_VR66f+jckPUWjey0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 15:24 -0700, Bjorn Helgaas wrote:
> On Tue, Dec 17, 2013 at 3:12 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Mon, 2013-12-16 at 17:48 -0700, Bjorn Helgaas wrote:
> >> On Tue, Dec 10, 2013 at 11:48:45AM -0700, Alex Williamson wrote:
> 
> >> > +static void pci_vc_load_arb_table(struct pci_dev *dev, int pos)
> >> > +{
> >> > +   u32 ctrl;
> >> > +
> >> > +   pci_read_config_dword(dev, pos + PCI_VC_PORT_CTRL, &ctrl);
> >> > +   pci_write_config_dword(dev, pos + PCI_VC_PORT_CTRL, ctrl | 1);
> >> > +   if (pci_wait_for_pending(dev, pos + PCI_VC_PORT_STATUS, 1))
> 
> >> spec says these are 16-bit registers; shouldn't these be "word" accesses?
> >
> > The control registers are 32-bit, the status registers are 16-bit.
> > pci_wait_for_pending uses word access.
> 
> The "VC Resource Control Registers" at offset 14h + (n * 0Ch) are 32
> bits, but I was referring to the PCI_VC_PORT_CTRL accesses, sorry I
> didn't make that clear.  I'm looking at 7.11.4 "Port VC Control
> Register" at offset 12 (0Ch), and that one looks like 16 bits to me.

Indeed it is.  Will fix.  Thanks,

Alex

