Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaIPXir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:38:47 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35236 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbaIPXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:38:45 -0400
Date: Tue, 16 Sep 2014 17:38:41 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: matwey@sai.msu.ru, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, matwey.kornilov@gmail.com
Subject: Re: [PATCH] Export functions from pcie-designware
Message-ID: <20140916233841.GJ5050@google.com>
References: <1409401476-5002-1-git-send-email-matwey@sai.msu.ru>
 <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DzNo3Y6=R4mA=h0+RjWoM6UBCqXxqeEqUM4iu5RjrBEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 10:07:30AM -0300, Fabio Estevam wrote:
> On Sat, Aug 30, 2014 at 9:24 AM,  <matwey@sai.msu.ru> wrote:
> > From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
> >
> > pcie-spear13xx when built as module requires the functions from pcie-designware.
> > Export them properly.

I don't know how valuable pcie-spear13xx as a module is.  No other host
drivers are supported as a module.  Maybe we should just change
pcie-spear13xx from tristate to bool?

> >
> > Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> > ---
> >  drivers/pci/host/pcie-designware.c |  7 +++++++
> >  drivers/pci/host/pcie-designware.h | 14 +++++++-------
> >  2 files changed, 14 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> > index 52bd3a1..7914b92c 100644
> > --- a/drivers/pci/host/pcie-designware.c
> > +++ b/drivers/pci/host/pcie-designware.c
> > @@ -89,6 +89,7 @@ int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val)
> >
> >         return PCIBIOS_SUCCESSFUL;
> >  }
> > +EXPORT_SYMBOL(dw_pcie_cfg_read);
> 
> What about using EXPORT_SYMBOL_GPL instead?
> 
> > -int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> > -int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
> > -irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
> > -void dw_pcie_msi_init(struct pcie_port *pp);
> > -int dw_pcie_link_up(struct pcie_port *pp);
> > -void dw_pcie_setup_rc(struct pcie_port *pp);
> > -int dw_pcie_host_init(struct pcie_port *pp);
> > +extern int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
> > +extern int dw_pcie_cfg_write(void __iomem *addr, int where, int size, u32 val);
> > +extern irqreturn_t dw_handle_msi_irq(struct pcie_port *pp);
> > +extern void dw_pcie_msi_init(struct pcie_port *pp);
> > +extern int dw_pcie_link_up(struct pcie_port *pp);
> > +extern void dw_pcie_setup_rc(struct pcie_port *pp);
> > +extern int dw_pcie_host_init(struct pcie_port *pp);
> 
> Why is this needed?

- This is logically separate from the EXPORT_SYMBOL change, so it should be
  a separate patch.

- I wouldn't take a patch adding "extern" to function declarations in a
  header file because I recently removed them all, e.g.,
  http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=f39d5b72913e.
