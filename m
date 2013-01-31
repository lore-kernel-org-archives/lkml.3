Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3AaRru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:47:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36644 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547Ab3AaRrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:47:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: pciehp: hide ENTRY messages behind ctrl_dbg()
Date: Thu, 31 Jan 2013 18:54:01 +0100
Message-ID: <1450113.teKM2dvJbO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo7grYijCUZGWGM4jao+MUqXYQ66q1az6bbKPMX4_Jwcyg@mail.gmail.com>
References: <1359367251.883.13.camel@x61.thuisdomein> <CAErSpo7grYijCUZGWGM4jao+MUqXYQ66q1az6bbKPMX4_Jwcyg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2013 10:13:17 AM Bjorn Helgaas wrote:
> [+cc Rafael]
> 
> On Mon, Jan 28, 2013 at 3:00 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > In each suspend and resume cycle my laptop prints these messages at
> > KERN_INFO level:
> >     pciehp 0000:00:1c.1:pcie04: pciehp_suspend ENTRY
> >     pciehp 0000:00:1c.0:pcie04: pciehp_suspend ENTRY
> >
> > and
> >     pciehp 0000:00:1c.0:pcie04: pciehp_resume ENTRY
> >     pciehp 0000:00:1c.1:pcie04: pciehp_resume ENTRY
> >
> > Messages like these are probably only useful while debugging pciehp, so
> > let's hide them behind the ctrl_dbg() macro.
> >
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > 0) Compile tested only!
> >
> > 1) Perhaps a better solution is to drop these messages entirely.
> >
> >  drivers/pci/hotplug/pciehp_core.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
> > index 939bd1d..ed1702d 100644
> > --- a/drivers/pci/hotplug/pciehp_core.c
> > +++ b/drivers/pci/hotplug/pciehp_core.c
> > @@ -293,7 +293,8 @@ static void pciehp_remove(struct pcie_device *dev)
> >  #ifdef CONFIG_PM
> >  static int pciehp_suspend (struct pcie_device *dev)
> >  {
> > -       dev_info(&dev->device, "%s ENTRY\n", __func__);
> > +       struct controller *ctrl = get_service_data(dev);
> > +       ctrl_dbg(ctrl, "%s ENTRY\n", __func__);
> >         return 0;
> 
> I'd propose to just drop these messages completely.  Rafael, would you
> have any objection to that?

No, I wouldn't.

> 
> >  }
> >
> > @@ -303,8 +304,8 @@ static int pciehp_resume (struct pcie_device *dev)
> >         struct slot *slot;
> >         u8 status;
> >
> > -       dev_info(&dev->device, "%s ENTRY\n", __func__);
> >         ctrl = get_service_data(dev);
> > +       ctrl_dbg(ctrl, "%s ENTRY\n", __func__);
> >
> >         /* reinitialize the chipset's event detection logic */
> >         pcie_enable_notification(ctrl);
> > --

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
