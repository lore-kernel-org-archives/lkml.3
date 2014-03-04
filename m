Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbaCDBlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:41:04 -0500
Received: from dliviu.plus.com ([80.229.23.120]:52350 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147AbaCDBlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:41:02 -0500
Date: Tue, 4 Mar 2014 01:39:06 +0000
From: Liviu Dudau <liviu@dudau.co.uk>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 5/6] pci: Use parent domain number when allocating
 child busses.
Message-ID: <20140304013906.GB13582@bart.dudau.co.uk>
Mail-Followup-To: Tanmay Inamdar <tinamdar@apm.com>,
	Liviu Dudau <Liviu.Dudau@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>
References: <1393867996-32299-1-git-send-email-Liviu.Dudau@arm.com>
 <1393867996-32299-6-git-send-email-Liviu.Dudau@arm.com>
 <CACoXjcnP80rSaYqy2EK8SBh8Q=5E8kh_GQ84Y_0hg3WrQ=fy+A@mail.gmail.com>
 <20140303235132.GA13582@bart.dudau.co.uk>
 <CACoXjc=FM5Bohpw6xmD0OCRX40gX2EHzWmf0dXgDosY-Wg8=ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACoXjc=FM5Bohpw6xmD0OCRX40gX2EHzWmf0dXgDosY-Wg8=ZA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Mar  4 01:41:00 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53152f2c3191475620746
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 04:42:11PM -0800, Tanmay Inamdar wrote:
> Hello,
> 
> Please see inline.
> 
> On Mon, Mar 3, 2014 at 3:51 PM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > On Mon, Mar 03, 2014 at 03:14:47PM -0800, Tanmay Inamdar wrote:
> >> Hello Liviu,
> >>
> >> Thanks for fixing up domain_nr. Now I have moved on further to a new
> >> domain_nr related warning dump :-)
> >>
> >> -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> >> xgene-pcie 1f500000.pcie: (rc) x8 gen-3 link up
> >> pci_bus 0001:00: scanning bus
> >> pci_setup_device:1101 domain_nr = 1
> >> pci 0001:00:00.0: [e008:e004] type 01 class 0x060400
> >> pci 0001:00:00.0: reg 0x10: [mem 0x4000000000-0x7fffffffff 64bit]
> >> pci 0001:00:00.0: calling xgene_pcie_fixup_bridge+0x0/0x80
> >> pci 0001:00:00.0: Hiding X-Gene pci host bridge resources 0001:00:00.0
> >> pci 0001:00:00.0: supports D1 D2
> >> pci_bus 0001:00: fixups for bus
> >> pci 0001:00:00.0: scanning [bus 03-03] behind bridge, pass 0
> >> pci 0001:00:00.0: bridge configuration invalid ([bus 03-03]), reconfiguring
> >> pci 0001:00:00.0: scanning [bus 00-00] behind bridge, pass 1
> >> ** pci_scan_bridge:855  pci_domain_nr(bus) = 1
> >> ** pci_alloc_child_bus:681  pci_domain_nr(bus) = 1
> >> pci_bus 0001:01: scanning bus
> >> pci_setup_device:1101 domain_nr = 0
> >
> > Why does the domain_nr change here?
> 
> The bridge device pointer for parent and child should be same right? I
> think this is not the case here. Please look at the log at the bottom
> that I captured after trying your suggestions.
> 
> >
> >> pci 0000:01:00.0: [15b3:1003] type 00 class 0x020000
> >> pci 0000:01:00.0: reg 0x10: [mem 0x00100000-0x001fffff 64bit]
> >> pci 0000:01:00.0: reg 0x18: [mem 0x00800000-0x00ffffff 64bit pref]
> >> pci 0000:01:00.0: reg 0x30: [mem 0x01000000-0x010fffff pref]
> >> ------------[ cut here ]------------
> >> WARNING: CPU: 0 PID: 1 at
> >> /home/tinamdar/work/open-source/linux/fs/sysfs/dir.c:52
> >> sysfs_warn_dup+0x80/0xc0()
> >> sysfs: cannot create duplicate filename '/bus/pci/devices/0000:01:00.0'
> >> Modules linked in:
> >> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5+ #40
> >> Call trace:
> >> [<ffffffc000088180>] dump_backtrace+0x0/0x140
> >> [<ffffffc0000882d0>] show_stack+0x10/0x20
> >> [<ffffffc0004f65ac>] dump_stack+0x74/0xc4
> >> [<ffffffc000096e04>] warn_slowpath_common+0x84/0xc0
> >> [<ffffffc000096e8c>] warn_slowpath_fmt+0x4c/0x60
> >> [<ffffffc0001b83dc>] sysfs_warn_dup+0x7c/0xc0
> >> [<ffffffc0001b8894>] sysfs_do_create_link_sd.isra.2+0xf4/0x100
> >> [<ffffffc0001b88bc>] sysfs_create_link+0x1c/0x40
> >> [<ffffffc0003250b0>] bus_add_device+0x110/0x1c0
> >> [<ffffffc000322f1c>] device_add+0x31c/0x520
> >> [<ffffffc0002c444c>] pci_device_add+0xec/0x140
> >> [<ffffffc0004f1758>] pci_scan_single_device+0x98/0xe0
> >> [<ffffffc0002c44e8>] pci_scan_slot+0x48/0x120
> >> [<ffffffc0002c5368>] pci_scan_child_bus+0x48/0x140
> >> [<ffffffc0002c522c>] pci_scan_bridge+0x4ec/0x5e0
> >> [<ffffffc0002c53c8>] pci_scan_child_bus+0xa8/0x140
> >> [<ffffffc0004f1b30>] pci_rescan_bus+0x10/0x40
> >> [<ffffffc0006a12ac>] xgene_pcie_probe_bridge+0x660/0x72c
> >> [<ffffffc000327d20>] platform_drv_probe+0x20/0x60
> >> [<ffffffc000325e30>] really_probe+0xf0/0x220
> >> [<ffffffc000326080>] __driver_attach+0xa0/0xc0
> >> [<ffffffc000323ed4>] bus_for_each_dev+0x54/0xa0
> >> [<ffffffc0003258bc>] driver_attach+0x1c/0x40
> >> [<ffffffc00032548c>] bus_add_driver+0x14c/0x220
> >> [<ffffffc00032683c>] driver_register+0x5c/0x120
> >> [<ffffffc000327cdc>] __platform_driver_register+0x5c/0x80
> >> [<ffffffc0006a0c40>] xgene_pcie_driver_init+0x14/0x20
> >> [<ffffffc0000814c0>] do_one_initcall+0xe0/0x160
> >> [<ffffffc00068c934>] kernel_init_freeable+0x134/0x1d8
> >> [<ffffffc0004f07ac>] kernel_init+0xc/0xe0
> >> ---[ end trace 3ee052d463aab7f3 ]---
> >> ------------[ cut here ]------------
> >> WARNING: CPU: 0 PID: 1 at
> >> /home/tinamdar/work/open-source/linux/drivers/pci/probe.c:1380
> >> pci_device_add+0x128/0x140()
> >> -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> >>
> >> I have made a small fix above your patch. After the fix is applied,
> >> dumps are gone and the enumeration finishes up smoothly for all the
> >> ports.
> >> Since the change is small, just pasting it here. Please review and
> >> apply if it's clean.
> >
> > Honestly, I have no idea. I kept staring at the code for a better part of an hour
> > trying to decipher what the intent of the code was, without too much progress. I
> > still don't understand why the code in pci_alloc_child_bus() takes a shortcut when
> > the bridge argument is NULL when in my opinion it should use parent->bridge instead
> > and continue as normal.
> >
> >>
> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> index a12cda5..aac8366 100644
> >> --- a/drivers/pci/probe.c
> >> +++ b/drivers/pci/probe.c
> >> @@ -693,7 +693,7 @@ static struct pci_bus *pci_alloc_child_bus(struct
> >> pci_bus *parent,
> >>         }
> >>
> >>         child->self = bridge;
> >> -       child->bridge = get_device(&bridge->dev);
> >> +       child->bridge = get_device(parent->bridge);
> >>         child->dev.parent = child->bridge;
> >
> > Hmm, not sure why this is needed. What does get_device(&bridge->dev)
> > return for you? The next line sets child->dev.parent to child->bridge,
> > but with your change I'm not sure we end up using the correct parent.
> >
> > Can you try to revert your change and modify the implementation of pci_domain_nr() in arm64
> > to look like this:
> >
> > static inline int pci_domain_nr(struct pci_bus *bus)
> > {
> >         struct pci_host_bridge *bridge;
> >
> >         while (bus->parent)
> >                 bus = bus->parent;
> >
> >         bridge = to_pci_host_bridge(bus->bridge);
> >         if (bridge)
> >                 return bridge->domain_nr;
> >
> >         return 0;
> > }
> >
> 
> This did not work for me.
> 
> 
> > Please let me know what results you get.
> >
> I am printing following values
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a12cda5..c89f86a 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -695,6 +695,8 @@ static struct pci_bus *pci_alloc_child_bus(struct
> pci_bus *parent,
>         child->self = bridge;
>         child->bridge = get_device(&bridge->dev);
>         child->dev.parent = child->bridge;
> +       printk("%s:%d bus = %p , bridge_dev = %p, domain = %d\n",
> +               __func__, __LINE__, child, child->bridge,
> pci_domain_nr(parent));

I see that you are using parent here.

>         pci_set_bus_of_node(child);
>         pci_set_bus_speed(child);
> 
> @@ -1095,6 +1097,8 @@ int pci_setup_device(struct pci_dev *dev)
>         dev_set_name(&dev->dev, "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
>                      dev->bus->number, PCI_SLOT(dev->devfn),
>                      PCI_FUNC(dev->devfn));
> +       printk("%s:%d bus = %p , bridge_dev = %p, domain = %d\n",
> +               __func__, __LINE__, dev->bus, dev->bus->bridge,
> pci_domain_nr(dev->bus));
> 
>         pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
>         dev->revision = class & 0xff;
> 
> Following looks suspicious to me.
> 
> bridge_dev = ffffffc7e03ffc00 for bus 0 in domain 1 while bridge_dev =
> ffffffc7e03f7098 for bus 1 in domain 1.
> 
>  Log -->
> -----------------------------------------------------------------------------------------------------------------------------
> xgene-pcie 1f500000.pcie: (rc) x8 gen-3 link up
> pci_bus 0001:00: scanning bus
> pci_setup_device:1101 bus = ffffffc7e0060400 , bridge_dev =
> ffffffc7e03ffc00, domain = 1

This is domain = 1, bus = 0, right?

> pci 0001:00:00.0: [e008:e004] type 01 class 0x060400
> pci 0001:00:00.0: reg 0x10: [mem 0x4000000000-0x7fffffffff 64bit]
> pci 0001:00:00.0: calling xgene_pcie_fixup_bridge+0x0/0x80
> pci 0001:00:00.0: Hiding X-Gene pci host bridge resources 0001:00:00.0
> pci 0001:00:00.0: supports D1 D2
> pci_bus 0001:00: fixups for bus
> pci 0001:00:00.0: scanning [bus 03-03] behind bridge, pass 0
> pci 0001:00:00.0: bridge configuration invalid ([bus 03-03]), reconfiguring
> pci 0001:00:00.0: scanning [bus 00-00] behind bridge, pass 1
> pci_alloc_child_bus:699 bus = ffffffc7e0063000 , bridge_dev =
> ffffffc7e03f7098, domain = 1

This is domain = 1, bus = 1, correct?

> pci_bus 0001:01: scanning bus
> pci_setup_device:1101 bus = ffffffc7e0063000 , bridge_dev =
> ffffffc7e03f7098, domain = 0

Then this is ... ? bus pointer matches 0001:01, same for bridge_dev, but
suddenly domain is 0 ? That means that when the child was created, the
bridge->dev was not setup? (in which case your patch would make sense).

It would be really helpful if you could add more tracing messages so that
we can figure out why the domain ends up being zero here. 

Many thanks,
Liviu


> pci 0000:01:00.0: [15b3:1003] type 00 class 0x020000
> pci 0000:01:00.0: reg 0x10: [mem 0x00100000-0x001fffff 64bit]
> pci 0000:01:00.0: reg 0x18: [mem 0x00800000-0x00ffffff 64bit pref]
> pci 0000:01:00.0: reg 0x30: [mem 0x01000000-0x010fffff pref]
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at
> /home/tinamdar/work/open-source/linux/fs/sysfs/dir.c:52
> sysfs_warn_dup+0x80/0xc0()
> sysfs: cannot create duplicate filename '/bus/pci/devices/0000:01:00.0'
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5+ #50
> -----------------------------------------------------------------------------------------------------------------------------
> 
> 
> > Best regards,
> > Liviu
> >
> >
> >>         pci_set_bus_of_node(child);
> >>         pci_set_bus_speed(child);
> >>
> >> Thanks,
> >> Tanmay
> >>
> >> On Mon, Mar 3, 2014 at 9:33 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > pci_alloc_child_bus() uses the newly allocated child bus to figure
> >> > out the domain number that is going to use for setting the device
> >> > name. A better option is to use the parent bus domain number.
> >> >
> >> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> >
> >> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> > index 26237a0..a12cda5 100644
> >> > --- a/drivers/pci/probe.c
> >> > +++ b/drivers/pci/probe.c
> >> > @@ -677,7 +677,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> >> >          * now as the parent is not properly set up yet.
> >> >          */
> >> >         child->dev.class = &pcibus_class;
> >> > -       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> >> > +       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(parent), busnr);
> >> >
> >> >         /*
> >> >          * Set up the primary, secondary and subordinate
> >> > --
> >> > 1.9.0
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > --
> > -------------------
> >    .oooO
> >    (   )
> >     \ (  Oooo.
> >      \_) (   )
> >           ) /
> >          (_/
> >
> >  One small step
> >    for me ...
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

