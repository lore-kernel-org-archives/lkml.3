Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbaFRTdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:33:55 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45439 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaFRTdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:33:51 -0400
Date: Wed, 18 Jun 2014 12:33:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
        benoit.taine@lip6.fr
Subject: Re: [RFC PATCH] checkpatch: Attempt to find unnecessary 'out of
 memory' messages
Message-ID: <20140618193345.GR4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402419340.30479.18.camel@joe-AO725>
 <20140611074704.GS5015@mwanda>
 <1402502500.6169.5.camel@joe-AO725>
 <alpine.DEB.2.02.1406140937370.2003@localhost6.localdomain6>
 <alpine.DEB.2.02.1406141151170.2045@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406141151170.2045@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061819-8236-0000-0000-0000033351C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 11:51:41AM +0200, Julia Lawall wrote:
> 
> 
> On Sat, 14 Jun 2014, Julia Lawall wrote:
> 
> > With a semantic patch that searches for the various calls and then a 
> > string containing the letters "emory", I get removals of the messages 
> > below.  Do any of these messages look useful?  For example, some are 
> > generated with specific functions, such as IRDA_ERROR or BT_ERR.  If none 
> > of the messages look useful, should just one big patch go to trivial, or 
> > should the patches go to the individual maintainers?
> 
> Sorry, I left out all the strings...

I would like the rcu-torture message to stay:

> -		pr_err("rcu-torture: Out of memory, need: %d", size);

This is in a module that is not loaded into any reasonable production
kernel, and has helped me to catch typos.

							Thanx, Paul

> julia
> 
> -		printk(KERN_WARNING "pci_bus %04x:%02x: "
> -		       "ignored (out of memory)\n", domain, busnum);
> -		dev_err(&ofdev->dev, "memory allocation failed\n");
> -		dev_err(&pdev->dev, "no memory for adc client\n");
> -		pr_err("%s: No memory for mcbsp\n", __func__);
> -		pr_err("OMAP: SmartReflex: cannot allocate memory for n-value table\n");
> -		pr_err("%s: Unable to allocate memory for %s sr_data\n",
> -		pr_err("Cannot allocate memory for controller slot name\n");
> -		pr_err("Cannot allocate memory for mmc device!\n");
> -		pr_err("Memory allocation for McSPI device failed\n");
> -		pr_err("%s: No memory for [%s]\n", __func__, oh->name);
> -		pr_err("gpio%d: Memory allocation failed\n", id);
> -		pr_err("gpio%d: Memory allocation failed\n", id);
> -		printk("out of memory for root bus resources");
> -		printk(KERN_ERR "omap_dma: No memory for channel queue\n");
> -		dev_err(dev, "%s: memory alloc failed!\n", __func__);
> -			printk(KERN_ERR "%s: no memory for bank\n", __func__);
> -		printk(KERN_ERR "no memory to store dma channel order\n");
> -			printk(KERN_ERR "%s: no memory for bank\n", __func__);
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		printk(KERN_ERR "failed to alloc memory for pm save\n");
> -		       "PM Suspend: cannot allocate memory to save portion "
> -			"of SRAM\n");
> -			pr_err("%s: failed to allocate memory for domain\n",
> -		printk(KERN_NOTICE "%s: memory squeeze. dropping packet.\n", dev->name);
> -		dev_dbg(&dev->dev, "%s: out of memory!\n", __func__);
> -				"PCI: No memory for %s I/O port space\n",
> -				"pci_bus %04x:%02x: ignored (out of memory)\n",
> -			printk(KERN_WARNING "%s: cannot allocate memory\n",
> -		dev_err(gpt->dev, "out of memory\n");
> -		pr_err("nvram: No memory for %s partition\n",
> -		pr_err("wsp_ics: No memory for structs.\n");
> -		pr_err("%s : Failed to allocate memory\n", __func__);
> -		pr_err("MEMORY_ERROR: out of memory, Opal message event not"
> -		       "handled\n");
> -		pr_err("%s: Out of memory, failed to do asynchronous "
> -				"completion init\n", __func__);
> -		pr_err("SYSPARAM: Failed to allocate memory for param data "
> -				"buf\n");
> -		pr_err("SYSPARAM: Failed to allocate memory to read parameter "
> -				"id\n");
> -		pr_err("SYSPARAM: Failed to allocate memory to read parameter "
> -				"size\n");
> -		pr_err("SYSPARAM: Failed to allocate memory to read supported "
> -				"action on the parameter");
> -		pr_err("SYSPARAM: Failed to allocate memory for parameter "
> -				"attributes\n");
> -		dev_err(&dev->dev, "No memory for MSI cascade data\n");
> -		dev_err(&dev->dev, "No memory for MSI structure\n");
> -				"No memory for message register blocks\n");
> -			dev_err(&dev->dev, "No memory for message register\n");
> -		pr_err("%s: cannot allocate memory for group.\n",
> -		dev_err(&dev->dev, "No memory for MSI structure\n");
> -		pr_debug("%s: can't allocate memory\n", __func__);
> -		dev_err(&device->dev, "Out of memory\n");
> -		printk(KERN_ERR "pmi: could not allocate memory.\n");
> -		dev_err(&dev->dev, "Out of memory for cache_sram structure\n");
> -		pr_warning("%s: out of memory\n", __func__);
> -		pr_err("EEH: out of memory, event not handled\n");
> -		dev_dbg(&pdev->dev, "no memory for eic structure\n");
> -		printk(KERN_ERR "failed to alloc memory for pm save\n");
> -		pr_err("Failed to alloc memory for TCM pool!\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "no memory for pcictl context\n");
> -		printk(KERN_INFO "Alchemy: no memory for UART data\n");
> -		       "module %s: no memory for symbol chain buffer\n",
> -			pr_err("Out of kernel memory trying to single-step\n");
> -		printk(KERN_ERR "%s %s(): memory allocation failure\n",
> -		ldm_crit("Out of memory.");
> -		ldm_crit ("Out of memory.");
> -		ldm_crit ("Out of memory.");
> -		ldm_crit ("Out of memory.");
> -		dev_err(&pdev->dev, "Cannot allocate memory.\n");
> -		dev_err(&pdev->dev, "out of memory for context\n");
> -		dev_err(&pdev->dev, "Memory alloc for tps65090_pdata failed\n");
> -		dev_err(&pdev->dev, "failed to allocate memory status\n");
> -			"Memory alloc for bq24735 pdata failed\n");
> -		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
> -		dev_err(psy->dev, "Couldn't allocate memory for supply list\n");
> -		dev_err(dev, "Cannot allocate memory.\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(dev, "%s(): memory allocation failed\n",
> -		pr_err("%s: Out of memory\n", __func__);
> -		pr_err("%s: Out of memory\n", __func__);
> -		dev_err(dev, "could not allocate memory for platform data\n");
> -		dev_err(&idev->dev, "Could not allocate trigger list memory.\n");
> -		printk(KERN_ERR DRV_NAME " %s: out of memory\n", pci_name(dev));
> -		printk(KERN_ERR "%s %s: out of memory!\n",
> -		printk(KERN_ERR DRV_NAME " %s: out of memory :(\n",
> -		dev_err(dev, "Cannot allocate memory.\n");
> -		dev_err(dev, "Failed to allocate memory for exynos_ppmu\n");
> -		dev_err(dev, "Cannot allocate memory.\n");
> -		dev_err(dev, "Failed to allocate memory for exynos_ppmu\n");
> -		printk(KERN_ERR "Not enough memory !\n");
> -		dev_err(&spi->dev, "out of memory\n");
> -			"unable to allocate memory for device info\n");
> -		dev_err(&client->dev, "Couldn't allocate graphical memory.\n");
> -		printk("radeonfb: Memory allocation failed\n");
> -		ERR_MSG("Cannot reserve pixmap memory.\n");
> -		printk(KERN_ERR "matroxfb_crtc2: Not enough memory for CRTC2 control structs\n");
> -		dev_err(info->device, "Failed to allocate memory\n");
> -		dev_err(dev, "no memory for framebuffers\n");
> -		printk(KERN_ERR PFX "no memory to save registers");
> -			dev_err(&pdev->dev, "Card%d, firmware upload "
> -				"failed, not enough memory\n", index + 1);
> -			pr_warn("tty: no memory to save termios state.\n");
> -		printk(KERN_WARNING "ioc3_attach_one"
> -		       ": unable to get memory for the IOC3\n");
> -			       "IOC3 serial memory not available for port\n");
> -		dev_err(uap->port.dev, "no memory for DMA TX buffer\n");
> -				"IOC4 serial memory not available for port\n");
> -		printk(KERN_WARNING "ioc4_attach_one"
> -		       ": unable to get memory for the IOC4\n");
> -		       "ioc4 (%p): unable to get memory for the soft struct\n",
> -			"memory allocation for board structure failed\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for tup\n");
> -		       "cpm_uart_cpm.c: could not allocate coherent memory\n");
> -		printk(KERN_ERR "cannot allocate memory for ports\n");
> -		dev_err(&pdev->dev, "unable to allocate memory\n");
> -		dev_err(&client->dev, "Failed to allocate memory\n");
> -		dev_dbg(&pdev->dev, "out of memory\n");
> -		dev_err(&client->dev, "Failed to allocate memory\n");
> -		dev_err(&client->dev, "Failed to allocate memory\n");
> -		dev_err(&usbinterface->dev, "No more memory for report\n");
> -		pr_err("Not enough memory to queue event %d\n", event_type);
> -		dev_err(dev, "failed to allocate memory for pdata\n");
> -		dev_err(dev, "no memory for private data\n");
> -		dev_err(&pdev->dev, "not enough memory for driver data\n");
> -		dev_err(&pdev->dev, "failed to alloc memory for kbc\n");
> -		dev_err(&pdev->dev, "not enough memory for driver data\n");
> -		dev_err(dev, "could not allocate memory for platform data\n");
> -		dev_err(dev, "could not allocate memory for gpios\n");
> -		dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
> -		dev_err(&pdev->dev, "Not enough memory for keymap\n");
> -		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
> -		dev_err(&pdev->dev, "failed to alloc memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
> -		dev_dbg(dev, "could not allocate memory for private data\n");
> -		dev_err(dev, "could not allocate memory for platform data\n");
> -		dev_err(dev, "could not allocate memory for keymap data\n");
> -		dev_err(dev, "could not allocate memory for keymap\n");
> -		dev_err(&dev->intf->dev, "out of memory\n");
> -		dev_err(&dev->intf->dev, "Out of memory\n");
> -			    "not enough memory for pass-through port\n");
> -		dev_err(dev, "allocate memory for cyapa failed\n");
> -		dev_dbg(&pdev->dev, "out of memory\n");
> -		dev_dbg(&pdev->dev, "out of memory\n");
> -		pr_err("Not enough memory to queue event %d\n", event_type);
> -		dev_err(&pdev->dev, "out of memory\n");
> -		dev_dbg(&serio->dev, "can't allocate memory for a device\n");
> -		dev_err(&ofdev->dev, "memory allocation failed\n");
> -				"Unable to allocate memory for keymap");
> -		dev_err(&pdev->dev, "couldn't allocate memory\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory\n");
> -			"failed to allocate memory for module data\n");
> -		dev_err(dev, "no memory for private data\n");
> -		dev_info(&pdev->dev, "Not enough memory for the device data\n");
> -		dev_err(pcu->dev, "Failed to allocate memory for write buffer\n");
> -		printk(KERN_INFO "joydump: no memory for testing\n");
> -		printk(KERN_ERR "turbografx.c: Not enough memory\n");
> -		pr_err("Not enough memory\n");
> -		printk(KERN_ERR "db9.c: Not enough memory\n");
> -			printk(KERN_DEBUG "pcbit_receive: out of memory\n");
> -		       "HiSax: No memory for IsdnCardState(card %d)\n",
> -				printk(KERN_WARNING "isdn_ppp_write: out of memory!\n");
> -				printk(KERN_WARNING "%s: Memory squeeze, dropping packet.\n", dev->name);
> -		       "ippp: CCP cannot send reset - out of memory\n");
> -			printk(KERN_ERR "ippp: decomp memory allocation failure\n");
> -		       "isdn_tty: Out of memory in ttyI%d senddown\n",
> -		printk(KERN_CRIT "%s: no memory, lost poll ack\n",
> -		printk(KERN_CRIT "%s: no memory, lost register appl.\n",
> -		printk(KERN_CRIT "%s: no memory, lost register appl.\n",
> -		printk(KERN_CRIT "%s: no memory, lost release appl.\n",
> -		printk(KERN_CRIT "%s: no memory, lost poll ack\n",
> -		printk(KERN_CRIT "%s: no memory, lost register appl.\n",
> -		printk(KERN_CRIT "%s: no memory, send config\n",
> -		printk(KERN_CRIT "%s: no memory, send config\n",
> -			printk(KERN_CRIT "%s: no memory, lost register appl.\n",
> -			printk(KERN_CRIT "%s: no memory, lost release appl.\n",
> -		printk(KERN_WARNING "%s: no memory.\n", name);
> -		pr_info("No memory for Infineon ISDN card\n");
> -			printk(KERN_ERR "%s: no memory for bchannel\n",
> -			printk(KERN_ERR "%s: no memory for coeffs\n",
> -			printk(KERN_ERR "%s: no memory for bchannel\n",
> -			printk(KERN_ERR "%s: no memory for coeffs\n",
> -		printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n",
> -			printk(KERN_WARNING "HYSDN: no memory for capi-ctrl.\n");
> -			dev_err(cs->dev, "ISDN_CMD_DIAL: out of memory\n");
> -		pr_err("out of memory\n");
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -			dev_err(cs->dev, "%s: out of memory\n", __func__);
> -			dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		pr_err("%s: out of memory\n", __func__);
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -		pr_err("out of memory\n");
> -		pr_err("out of memory\n");
> -		dev_err(cs->dev, "%s: out of memory\n", __func__);
> -				dev_err(cs->dev, "%s: out of memory\n",
> -		pr_err("out of memory\n");
> -			printk(KERN_WARNING "act2000_sendbuf: Out of memory\n");
> -						       "act2000_isa_receive: no memory\n");
> -			printk(KERN_ERR "%s: no memory for bchannel\n",
> -					printk(KERN_ERR "%s: failed to add "
> -					       "entry to pipeline: %s (out of "
> -					       "memory)\n", __func__, elem->name);
> -		printk(KERN_ERR "%s: No memory for clock entry.\n", __func__);
> -		printk(KERN_WARNING "%s:no memory for teimgr\n", __func__);
> -		printk(KERN_WARNING "capilib_new_ncci: no memory.\n");
> -			"Failed to allocate private memory\n");
> -			"Failed to allocate private memory\n");
> -		dev_err(dev, "failed to allocate memory for device data\n");
> -		dev_err(dev, "failed to allocate memory for private data\n");
> -		dev_err(&pdev->dev, "Memory allocation failed for pmu\n");
> -		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
> -		dev_err(&pdev->dev, "Memory alloc fails for info\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_warn(dev, "Unable to allocate memory for chips\n");
> -		dev_err(dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "failed to allocate memory.\n");
> -		dev_err(&pdev->dev, "Error: No memory\n");
> -		dev_err(dev, "Memory allocation failed\n");
> -		dev_err(&client->dev, "Memory allocation failed\n");
> -		dev_err(&dev->dev, "no memory for device data\n");
> -		dev_err(&dev->dev, "no memory for device data\n");
> -			    "could not allocate memory for private data\n");
> -		dev_err(&i2c->dev, "smsc mfd driver memory allocation failed\n");
> -		dev_err(dev, "could not allocate memory for pdata\n");
> -		dev_err(dev, "could not allocate memory for pdata\n");
> -		dev_err(dev, "twl6030_irq: Memory allocation failed\n");
> -		dev_err(&client->dev, "Memory allocation failed\n");
> -			"Failed to allocate memory for aat2870\n");
> -		dev_err(&i2c->dev, "Memory allocation failed\n");
> -		dev_err(dev, "Memory allocation failed\n");
> -		dev_err(dev, "Couldn't allocate memory for channel clocks\n");
> -		dev_err(dev, "new device %s: Cannot allocate memory\n",
> -		printk (KERN_DEBUG "parport (0x%lx): no memory!\n", base);
> -		dev_err(_dev, "no memory for private data\n");
> -		printk(KERN_WARNING "parport: memory squeeze\n");
> -		printk(KERN_ERR "parport: memory squeeze\n");
> -		printk(KERN_WARNING "%s: memory squeeze, couldn't register %s.\n", port->name, name);
> -		printk(KERN_WARNING "%s: memory squeeze, couldn't register %s.\n", port->name, name);
> -		dev_err(&pdev->dev, "unable to allocate glue memory\n");
> -		dev_dbg(musb->controller, "not enough memory\n");
> -			dev_err(&dev->dev, "Out of memory\n");
> -				dev_err(&dev->dev, "Out of memory\n");
> -		printk(KERN_WARNING "sddr09_read_data: Out of memory\n");
> -		printk(KERN_WARNING "sddr09_write_data: Out of memory\n");
> -		printk(KERN_WARNING "sddr09_write_data: Out of memory\n");
> -		printk(KERN_WARNING "sddr09_read_map: out of memory\n");
> -		printk(KERN_WARNING "alauda_read_data: Out of memory\n");
> -		printk(KERN_WARNING "alauda_write_data: Out of memory\n");
> -		printk(KERN_WARNING "alauda_write_data: Out of memory\n");
> -		dev_err(&intf->dev, "out of memory (acm kzalloc)\n");
> -		dev_err(&intf->dev, "Unable to allocate kernel memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(dev, "not enough memory\n");
> -		dev_err(dev, "not enough memory\n");
> -		dev_err(dwc->dev, "not enough memory\n");
> -		dev_err(dev, "not enough memory\n");
> -		dev_err(dev, "not enough memory\n");
> -		dev_err(dev, "Memory allocation failed\n");
> -		dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
> -		dev_err(&pdev->dev, "failed to allocate memory!\n");
> -			"unable to allocate memory for USB UTMIP config\n");
> -		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
> -		dev_err(dev, "cannot get memory\n");
> -		dev_err(dev, "cannot get memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&usbdev->dev, "submit_async_request out of memory\n");
> -		dev_err(&dev->udev->dev, "Out of memory!\n");
> -		dev_err(&interface->dev, "Out of memory!\n");
> -		dev_err(&intf->dev, "Out of memory\n");
> -		dev_err(&iface->dev, "Out of memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err(&cytherm->udev->dev, "out of memory\n");
> -		dev_err (&interface->dev, "Out of memory\n");
> -		dev_err(&led->udev->dev, "out of memory\n");
> -		dev_err(&interface->dev, "out of memory\n");
> -		dev_err(idev, "Out of memory\n");
> -		dev_err(&mydev->udev->dev, "out of memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&pdev->dev, "Failed to alloc memory for otg\n");
> -		dev_dbg(&pdev->dev, "error allocating memory\n");
> -			"unable to allocate memory for frame pointers\n");
> -		fhci_err(fhci, "no memory for SCC data struct\n");
> -		dev_err(&pdev->dev, "failed to allocate memory for udc\n");
> -		dev_err(&pdev->dev, "allocate ep memory failed\n");
> -		dev_err(&pdev->dev, "allocate status_req memory failed\n");
> -		dev_err(dev, "cannot allocate memory\n");
> -		dev_err(dev, "cannot allocate memory\n");
> -		pr_err("%s: no memory for device structure\n", __func__);
> -		uea_err(usb, "uea_init: not enough memory !\n");
> -		usb_dbg(usbatm_instance, "cxacru_bind: no memory for instance data\n");
> -		usb_err(usbatm, "%s: no memory for instance data!\n", __func__);
> -		atm_err(instance, "%s: no memory for SAR buffer!\n", __func__);
> -		dev_err(dev, "%s: no memory for instance data!\n", __func__);
> -			dev_err(dev, "%s: no memory for buffer %d!\n", __func__, i);
> -		dev_err(dev, "%s: no memory for cell buffer!\n", __func__);
> -		printk(KERN_ERR DRV_NAME "(%s): memory alloc failure\n",
> -		pr_err(PFX "(%s): memory alloc failure\n",
> -			dev_err(&h->pdev->dev, "Cannot get memory "
> -				"for s/g chains.\n");
> -		dev_warn(&h->pdev->dev, "out of memory\n");
> -		dev_warn(&h->pdev->dev, "out of memory\n");
> -		dev_warn(&h->pdev->dev, "out of memory\n");
> -		dev_err(&h->pdev->dev, "out of memory\n");
> -		dev_warn(&h->pdev->dev, "cache not flushed, out of memory.\n");
> -		printk(KERN_ERR "%s:%d fail (no memory for mg_host)\n",
> -				printk(KERN_ERR "cpqarray: out of memory.\n");
> -		printk(KERN_WARNING "cpqarray: Out of memory. "
> -			"Unable to start background processing.\n");
> -		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -		printk( KERN_ERR "cpqarray:  out of memory.\n");
> -			"Memory allocation: status buffer\n");
> -			"Memory allocation: register buffer\n");
> -			"Memory allocation: flag buffer\n");
> -		hid_err(hdev, "Could not allocate memory for driver data\n");
> -				 "can't allocate memory for LED selector\n");
> -		hid_err(hdev, "can't allocate memory for LED ALL\n");
> -			hid_err(hdev, "can't allocate memory for LED %d\n", i);
> -			hid_err(hdev, "Couldn't allocate memory for LED %d\n", n);
> -		dbg_hid("couldn't allocate rdesc memory\n");
> -		hid_err(hdev, "Insufficient memory, cannot allocate driver data\n");
> -		dbg_hid("couldn't allocate rdesc memory (post_reset)\n");
> -		hid_err(hdev, "Failed to allocate memory for mfd cells\n");
> -		hid_err(hid, "Cannot add device, insufficient memory to allocate device properties.\n");
> -				hid_err(hid, "can't allocate memory for LED %d\n", j);
> -			dev_err(dev, "can't allocate memory for LED %d\n", i);
> -		printk(KERN_WARNING "No memory to scan for FTL on %s\n",
> -			dev_err(&mdev->dev, "VMU at (%d, %d) - read fails due"
> -				" to lack of memory\n", mdev->port,
> -			NS_ERR("unable to allocate memory.\n");
> -			NS_ERR("unable to allocate memory.\n");
> -			NS_ERR("unable to allocate memory.\n");
> -		    ("memory allocation error while creating concatenated device \"%s\"\n",
> -		pr_err("fsl-hv: out of memory\n");
> -		bcma_err(bus, "can not allocate memory");
> -				"unable to allocate memory,size = %d.\n", size);
> -		printk(KERN_ERR "vmw_pvscsi: failed to allocate memory.\n");
> -			"%s: failed obtaining a memory for mpi_request\n",
> -		pr_err(MPT3SAS_FMT "unable to allocate memory %d!\n",
> -		printk(MPT2SAS_INFO_FMT "WarpDrive : Direct IO is disabled "
> -		    "Memory allocation failure for RVPG0\n", ioc->name);
> -		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a memory for "
> -		    "mpi_request\n", ioc->name, __func__);
> -		printk(MPT2SAS_ERR_FMT "%s: failed allocating memory"\
> -		    "for iounit_pg3: (%d) bytes\n", ioc->name, __func__, sz);
> -		printk(MPT2SAS_ERR_FMT "unable to allocate memory %d!\n",
> -		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x18, "Event info memory allocation failed");
> -		ipr_err("Dump memory allocation failed\n");
> -		dev_warn(&h->pdev->dev, "out of memory in %s\n", __func__);
> -			dev_warn(&h->pdev->dev, "out of memory at %s:%d\n",
> -		    "%s: [ERROR] Unable to malloc memory.\n", DRIVER_NAME);
> -			   "failed to allocate memory for asynchronous events");
> -			   "failed to allocate memory for s/g list descriptors");
> -			   "failed to allocate memory for the request table");
> -		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
> -			  "allocation failure.\n");
> -					"2615 Memory allocation failed for "
> -					"CT event data, size %d\n",
> -				"2759 Failed allocate memory for FCF round "
> -				"robin failover bmask\n");
> -				"2572 Failed allocate memory for "
> -				"fast-path per-EQ handle array\n");
> -				"2573 Failed allocate memory for msi-x "
> -				"interrupt vector entries\n");
> -				"3327 Failed allocate memory for msi-x "
> -				"interrupt vector mapping\n");
> -					"3335 Failed allocate memory for msi-x "
> -					"interrupt vector mapping\n");
> -			"2576 Failed allocate memory for "
> -			"fast-path EQ record array\n");
> -				"2577 Failed allocate memory for fast-path "
> -				"CQ record array\n");
> -				"2578 Failed allocate memory for fast-path "
> -				"WQ record array\n");
> -				"2545 Failed allocate memory for fast-path "
> -				"CQ map\n");
> -			"0147 Failed to allocate memory for RSCN event\n");
> -				"0148 Failed to allocate memory "
> -				"for LOGO event\n");
> -				"0149 Failed to allocate memory "
> -				"for ELS event\n");
> -			printk(KERN_CRIT"%s: Out of memory for I2O device data.\n",pHba->name);
> -					printk(KERN_CRIT "Out of memory for I2O device data.\n");
> -		dev_err(hba->dev, "LRB Memory allocation failed\n");
> -		    "Unable to allocate memory.\n");
> -		    "Failed to allocate memory for msix_entry.\n");
> -		    "Failed to allocate memory for ha->msix_entries.\n");
> -		    "Unable to allocate memory for request queue ptrs.\n");
> -		    "Unable to allocate memory for response queue ptrs.\n");
> -		    "Unable to allocate memory for ha.\n");
> -		    "Failed to allocate memory for req.\n");
> -		    "Failed to allocate memory for rsp.\n");
> -			    "Failed to allocate memory for npiv_info.\n");
> -			    "Failed to allocate memory for "
> -			    "outstanding_cmds for req_que %p.\n", req);
> -		    "Unable to allocate memory for data.\n");
> -				    "Failed to allocate memory for dsd_dma "
> -				    "for cmd=%p.\n", cmd);
> -		    "Failed to allocate memory for request queue.\n");
> -		    "Failed to allocate memory for response queue.\n");
> -		pmcraid_err("no memory for passthrough buffer\n");
> -		pmcraid_err("failed to allocate memory for ioctl header\n");
> -		pmcraid_err("failed to allocate memory for resource table\n");
> -		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xc, "Event info memory allocation failed");
> -                printk(KERN_ERR "%s: out of memory at line %d\n",
> -		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
> -		       "memory for cmd_list_fusion\n");
> -		printk(KERN_DEBUG "megasas: out of memory\n");
> -			printk(KERN_DEBUG "megasas: Failed to allocate "
> -			       "memory for Fusion context info\n");
> -		printk(KERN_ERR "sr: out of memory.\n");
> -		printk(KERN_ERR "%s: no memory\n", __func__);
> -				    "BG_%d : Memory Allocation Failure\n");
> -			    "BM_%d : Memory alloc failed in create wrb ring.\n");
> -					    "BM_%d : Failed to allocate memory"
> -					    "for ULP_CID_INFO for ULP : %d\n",
> -					    "BM_%d : Failed to allocate memory"
> -					    "for CID_ARRAY for ULP : %d\n",
> -			    "BM_%d : Failed to allocate memory in "
> -			    "hba_setup_cid_tbls\n");
> -		asd_printk("out of memory\n");
> -		asd_printk("no memory for bios_chim struct\n");
> -		asd_printk("no memory for ocm dir\n");
> -			 "Unable to allocate memory for orom\n");
> -			 "Unable to allocate memory for EFI data\n");
> -		pr_err("memory allocation failed, not attaching\n");
> -			"Can't allocate memory for internal usage.\n");
> -		dev_err(dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for struct davinci_mmc_config\n");
> -		pr_err("failed to allocate memory for ibm->acpi->driver\n");
> -		pr_err("failed to allocate memory for key map\n");
> -		pr_err("Out of memory for LED data\n");
> -		dev_err(dev, "Memory alloc failed\n");
> -		dev_err(dev, "Memory alloc failed\n");
> -			"Failed to allocate memory for ACPI GPIO chip\n");
> -		dev_err(&pdev->dev, "%s: Out of memory\n", __func__);
> -		acpi_handle_err(handle, "No memory for bridge object\n");
> -						err ("out of system memory\n");
> -								err ("out of system memory\n");
> -						err ("out of system memory\n");
> -								err (" out of system memory\n");
> -				err ("out of system memory\n");
> -					err ("out of system memory\n");
> -						err ("out of system memory\n");
> -					err ("out of system memory\n");
> -				err ("out of system memory\n");
> -					err ("out of system memory\n");
> -						err ("out of system memory\n");
> -					err ("out of system memory\n");
> -			err ("out of system memory\n");
> -			err ("out of system memory\n");
> -			err ("out of system memory\n");
> -				err ("out of system memory\n");
> -				err ("out of system memory\n");
> -			err ("out of system memory\n");
> -			err ("out of system memory\n");
> -			err ("out of system memory\n");
> -		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
> -		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
> -		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
> -		ctrl_err(p_slot->ctrl, "%s: Cannot allocate memory\n",
> -		err("%s : out of memory\n", __func__);
> -		dev_err(&dev->device, "%s: Out of memory\n", __func__);
> -		err("out of system memory\n");
> -		err("%s - out of memory\n", __func__);
> -		err("%s - out of memory\n", __func__);
> -		err("out of system memory\n");
> -			err("out of system memory\n");
> -		err("out of memory\n");
> -		err ("out of system memory\n");
> -		err ("out of system memory\n");
> -			err ("out of system memory.\n");
> -		err ("out of system memory\n");
> -					err ("out of system memory\n");
> -								err ("out of system memory\n");
> -									err ("out of system memory\n");
> -								err ("out of system memory\n");
> -									err ("out of system memory\n");
> -								err ("out of system memory\n");
> -									err ("out of system memory\n");
> -		printk(KERN_ERR "gsmi: out of memory\n");
> -		printk(KERN_ERR "efivars: Memory allocation failed.\n");
> -		dev_err(dev, "Not enough memory for clock entry.\n");
> -				"Not enough memory for clock connection ID.\n");
> -		dev_err(&pdev->dev, "PAMU isr data memory allocation failed\n");
> -			pr_warn("Out of memory when allocating notify_info "
> -				"for %s.\n", pci_name(dev));
> -		DMERR("No memory left to attempt load for \"%s\"", type_name);
> -		DMWARN("No memory left to attempt log module load for \"%s\"",
> -		DMERR("unable to allocate memory");
> -		DMWARN("Unable to allocate memory for constructor string");
> -		DMERR("Failed to allocate memory for device information");
> -			"multipath: couldn't allocate memory for %s\n",
> -			"multipath: couldn't allocate memory for %s\n",
> -		DMERR("unable to allocate region hash memory");
> -		dev_dbg(&pdev->dev, "Unable to allocate memory for rio_ops\n");
> -		dev_dbg(&pdev->dev, "Unable to allocate memory for mport\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for device\n");
> -		pr_err("RIO: no memory for work struct\n");
> -		dev_printk(KERN_WARNING, &s->dev, "no memory to read tuple\n");
> -		dev_printk(KERN_WARNING, &s->dev, "no memory to read tuple\n");
> -			   "no memory for verifying CIS\n");
> -		dev_printk(KERN_WARNING, &s->dev, "no memory to replace CIS\n");
> -		dev_warn(&s->dev, "no memory to validate CIS\n");
> -		dev_warn(&s->dev, "no memory to validate CIS\n");
> -		printk(KERN_WARNING "out of memory to update resources\n");
> -					printk(KERN_WARNING "out of memory to update resources\n");
> -		pr_err("%s: Failed to allocate memory for pool free operation\n",
> -		pr_err("Failed to allocate memory for pool free operation\n");
> -		DRM_DEBUG_KMS("out of memory when allocating plane\n");
> -		DRM_ERROR("Out of memory\n");
> -		dev_err(dev, "failed to allocate memory\n");
> -		DRM_DEBUG("out of memory\n");
> -		dev_err(dev->dev, "Crtc state error: No memory\n");
> -		dev_err(dev->dev, "no memory\n");
> -		DRM_ERROR("No memory\n");
> -		dev_err(dev->dev, "failed to allocate memory\n");
> -		dev_err(dev_priv->dev->dev, "out of memory for fixed panel mode\n");
> -		DRM_DEBUG_KMS("No memory space for child devices\n");
> -		DRM_ERROR("No memory");
> -		DRM_ERROR("cannot allocate memory for DSI config\n");
> -		DRM_ERROR("Memory allocation failed\n");
> -		DRM_ERROR("Cannot allocate memory for page table array\n");
> -		DRM_ERROR("Memory allocation failed\n");
> -			DRM_ERROR("Failed to allocate memory for bit 17 "
> -				  "record\n");
> -		DRM_DEBUG_KMS("No memory space for child device\n");
> -		DRM_DEBUG_DRIVER("out of memory, not capturing error state\n");
> -		DRM_ERROR("out of memory\n");
> -		DRM_ERROR("Out of memory for hash table\n");
> -		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
> -		printk(KERN_ERR MYNAM "%s::mpt_ioctl_iocinfo() @%d - no memory available!\n",
> -		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_gettargetinfo() - no memory available!\n",
> -			    ": ERROR - Insufficient memory to add adapter!\n",
> -		printk(KERN_ERR "i2o: no memory for query buffer.\n");
> -		osm_err("Insufficient memory to allocate I2O Block disk.\n");
> -		osm_err("%s: Could not allocate memory for context list element"
> -			"\n", c->name);
> -		osm_err("i2o: Insufficient memory to allocate a I2O controller."
> -			"\n");
> -		BT_ERR("Can't allocate memory chunk for firmware");
> -		BT_ERR("Can't allocate memory chunk for firmware");
> -		BT_ERR("Can't allocate memory chunk for firmware");
> -		BT_ERR("Can't allocate memory for control structure");
> -		BT_ERR("Can't allocate memory for data structure");
> -		BT_ERR("Can't allocate memory for mini driver");
> -		BT_ERR("Can not allocate memory for btmrvl_debugfs_data.");
> -		dev_dbg(&pdev->dev, "unable to allocate memory\n");
> -		dev_err(&pdev->dev, "Out of memory\n");
> -			"Slot [%d:%d] unable to allocate memory for IRQ !\n",
> -		dev_err(dev, "could not alloc memory for pin-maps\n");
> -		dev_err(dev, "failed to alloc memory for group name\n");
> -		dev_err(dev, "failed to alloc memory for configs\n");
> -			dev_err(dev, "failed to alloc memory for func name\n");
> -		dev_err(dev, "failed to allocate memory for pin list\n");
> -		dev_err(dev, "failed allocate memory for ping group list\n");
> -		dev_err(dev, "failed to allocate memory for function list\n");
> -			dev_err(dev, "failed to alloc memory for group name\n");
> -			dev_err(dev, "failed to alloc memory for func name\n");
> -			dev_err(dev, "failed to alloc memory for group list "
> -					"in pin function");
> -		dev_err(dev, "could not allocate memory for pinctrl desc\n");
> -		dev_err(dev, "failed to allocate memory for gpio intr data\n");
> -		dev_err(dev, "could not allocate memory for private data\n");
> -		dev_err(dev, "Memory alloc failed\n");
> -		dev_err(dev, "Memory alloc failed\n");
> -		dev_err(dev, "failed to allocate memory for function list\n");
> -		dev_err(dev, "failed allocate memory for ping group list\n");
> -		dev_err(dev, "could not alloc memory for pin-maps\n");
> -		dev_err(dev, "failed to alloc memory for group name\n");
> -		dev_err(dev, "failed to alloc memory for configs\n");
> -			dev_err(dev, "failed to alloc memory for func name\n");
> -		dev_err(dev, "failed to allocate memory for pin list\n");
> -		dev_err(dev, "failed allocate memory for ping group list\n");
> -		dev_err(dev, "failed to allocate memory for function list\n");
> -			dev_err(dev, "failed to alloc memory for group name\n");
> -			dev_err(dev, "failed to alloc memory for func name\n");
> -			dev_err(dev, "failed to alloc memory for group list "
> -					"in pin function");
> -		dev_err(dev, "failed to allocate memory for driver's "
> -				"private data\n");
> -			"cannot allocate pinctrl_map memory for %s\n",
> -		dev_err(dev, "could not allocate memory for wkup eint data\n");
> -			"failed to allocate memory for pct\n");
> -			dev_err(dev, "could not allocate memory for weint_data\n");
> -		dev_err(dev, "could not allocate memory for muxed_data\n");
> -		dev_err(&pdev->dev, "memory allocation fail\n");
> -		dev_err(&pdev->dev, "csave registers memory allocation fail\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "unable to allocate memory for USB2 PHY\n");
> -		dev_err(&pdev->dev, "unable to allocate memory for USB OTG\n");
> -		dev_err(&pdev->dev, "unable to alloc memory for control phy\n");
> -		       "Could not allocate state machine memory\n");
> -		printk(KERN_ERR "%s: ERROR - No Memory for event name\n ",
> -		pr_err("%s: ERROR - Not enough memory for BIOS measurements\n",
> -		printk("%s: ERROR - Not enough  Memory for BIOS measurements\n",
> -				dev_err(ibmvtpm->dev, "Failed to allocate memory for rtce buffer\n");
> -		printk(KERN_ERR "%s: failed to allocate memory for device\n",
> -		dev_err(&pdev->dev, "no memory for private structure\n");
> -		dev_err(&pdev->dev, "no memory for rng structure\n");
> -		printk(KERN_ERR PFX "Out of memory, we're in trouble...\n");
> -			dev_err(ca91cx42_bridge->parent, "Unable to allocate "
> -				"memory for resource name\n");
> -		dev_err(dev, "Failed to allocate memory for dma resource "
> -			"structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for device "
> -			"structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for device "
> -			"structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"master resource structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"slave resource structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"dma resource structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for "
> -		"location monitor resource structure\n");
> -			dev_err(tsi148_bridge->parent, "Unable to allocate "
> -				"memory for resource name\n");
> -		dev_err(tsi148_bridge->parent, "Failed to allocate memory for "
> -			"dma resource structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for device "
> -			"structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for device "
> -			"structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"flush resource structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"master resource structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"slave resource structure\n");
> -			dev_err(&pdev->dev, "Failed to allocate memory for "
> -			"dma resource structure\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory for "
> -		"location monitor resource structure\n");
> -		printk(KERN_ERR "Unable to allocate memory for new dma list\n");
> -		printk(KERN_ERR "Unable to allocate memory for attributes structure\n");
> -		printk(KERN_ERR "Unable to allocate memory for pattern attributes\n");
> -		printk(KERN_ERR "Unable to allocate memory for attributes structure\n");
> -		printk(KERN_ERR "Unable to allocate memory for pci attributes\n");
> -		printk(KERN_ERR "Unable to allocate memory for attributes structure\n");
> -		printk(KERN_ERR "Unable to allocate memory for vme attributes\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -			dev_err(&adev->dev, "No memory for resources\n");
> -		pr_err(PREFIX "Memory allocation error\n");
> -		printk(KERN_ERR PREFIX "Memory allocation error\n");
> -		err("%s: cannot allocate memory\n", __func__);
> -		printk(KERN_ERR "can't allocate memory\n");
> -		printk(KERN_ERR "Memory allocation error\n");
> -		printk(KERN_ERR "Memory allocation error\n");
> -		printk(KERN_ERR "Memory allocation error\n");
> -		pr_err("Unable to allocate memory for name buf\n");
> -			pr_err("Unable to allocate memory for"
> -					" struct t10_vpd\n");
> -		pr_err("Unable to allocate memory for struct pscsi_dev_virt\n");
> -		pr_err("Unable to allocate memory for tl_tmr\n");
> -		pr_err("Unable to allocate memory for tmpbuf.\n");
> -		pr_err("Memory allocation failed for CHAP_A temporary buffer\n");
> -		pr_err("Unable to allocate memory for struct iscsi_login.\n");
> -		pr_err("Unable to allocate memory for response buffer.\n");
> -		pr_err("Unable to allocate memory for request buffer.\n");
> -		pr_err("Unable to allocate memory for"
> -			" struct iscsi_conn_ops.\n");
> -		pr_err("Could not allocate memory for session\n");
> -		pr_err("Unable to allocate memory for"
> -				" struct iscsi_sess_ops.\n");
> -		pr_err("Could not allocate memory for"
> -			" new connection\n");
> -		pr_err("Unable to allocate memory for struct iscsi_np\n");
> -		pr_err("Unable to allocate memory for iscsit_global\n");
> -			pr_err("Unable to allocate memory for"
> -				" NOPOUT ping data.\n");
> -		pr_err("Unable to allocate memory for"
> -			" Task Management command!\n");
> -			pr_err("Unable to allocate memory for"
> -				" incoming text parameters\n");
> -		pr_err("Unable to allocate memory for sendtargets"
> -				" response.\n");
> -		pr_err("Unable to allocate memory for parameter.\n");
> -		pr_err("Unable to allocate memory for parameter name.\n");
> -		pr_err("Unable to allocate memory for parameter value.\n");
> -		pr_err("Unable to allocate memory for"
> -				" struct iscsi_param_list.\n");
> -		pr_err("Unable to allocate memory for struct iscsi_param_list.\n");
> -			pr_err("Unable to allocate memory for struct iscsi_param.\n");
> -		pr_err("Unable to allocate memory for value.\n");
> -		pr_err("Unable to allocate memory for"
> -			" struct iscsi_extra_response.\n");
> -		pr_err("Unable to allocate memory for"
> -			" struct iscsi_conn_recovery.\n");
> -		pr_err("Unable to allocate memory for"
> -				" struct iscsi_tpg_np.\n");
> -			pr_err("Unable to allocate memory"
> -				" for random array.\n");
> -			pr_err("Unable to allocate memory for"
> -				" random array.\n");
> -		pr_err("Unable to allocate memory for random array.\n");
> -		pr_err("Unable to allocate memory for struct iscsi_node_acl\n");
> -		pr_err("Unable to allocate memory for"
> -				" stats_cg->default_groups\n");
> -		pr_err("Unable to allocate memory for"
> -				" stats_cg->default_groups\n");
> -			pr_err("Unable to allocate memory for"
> -					" thread set.\n");
> -		pr_err("Unable to allocate memory for struct se_lun_acl.\n");
> -		pr_err("Unable to allocate memory for struct rd_host\n");
> -		pr_err("Unable to allocate memory for Ramdisk"
> -		       " scatterlist tables\n");
> -		pr_err("Unable to allocate memory for Ramdisk protection"
> -		       " scatterlist tables\n");
> -		pr_err("Unable to allocate memory for struct rd_dev\n");
> -		pr_err("Unable to allocate memory for struct fd_host\n");
> -		pr_err("Unable to allocate memory for struct fd_dev\n");
> -		airo_print_warn("", "Out of memory allocating beacons");
> -			b43legacyerr(dev->wl, "Could not allocate memory "
> -			       "for tssi2dbm table\n");
> -		rsi_dbg(ERR_ZONE, "%s: Failed in memory allocation\n",
> -		rsi_dbg(ERR_ZONE, "%s: Failed to allocate memory\n",
> -		printk(KERN_ERR PFX "Out of memory for firmware buffer.\n");
> -			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
> -			D_SCAN("Fail to allocate scan memory\n");
> -			D_SCAN("fail to allocate memory for scan\n");
> -		IL_ERR("Unable to allocate memory for LQ cmd.\n");
> -		IL_ERR("Not enough memory for txq\n");
> -			LIBIPW_ERROR("Out of memory allocating beacons\n");
> -		IPW_ERROR("Memory allocation for firmware error log "
> -			  "failed.\n");
> -		IPW_ERROR("Unable to allocate memory for log\n");
> -				"ath9k_htc: REG_IN memory allocation failure\n");
> -			ATH5K_ERR(ah, "out of memory\n");
> -		ath6kl_err("unable to allocate memory\n");
> -		ath6kl_err("unable to allocate memory\n");
> -		ath6kl_err("failed to alloc memory for aggr_node\n");
> -		ath6kl_err("failed to alloc memory for connection specific aggr info\n");
> -		ath6kl_err("htc create unable to allocate memory\n");
> -		ath6kl_err("unable to allocate memory\n");
> -			ath6kl_err("Failed to allocate memory for sta aggregation information\n");
> -		b43err(dev->wl, "PR41573 failed. Out of memory!\n");
> -			b43dbg(dev->wl, "SHM-dump: Failed to allocate memory\n");
> -		b43warn(dev->wl, "LO calib: out of memory\n");
> -		b43err(dev->wl, "Could not allocate memory "
> -		       "for tssi2dbm table\n");
> -		IWL_ERR(trans, "Not enough memory for txq\n");
> -				       "fail to allocate memory for scan\n");
> -		IWL_ERR(priv, "Unable to allocate memory for LQ cmd.\n");
> -		wl1271_error("Out of memory setting filters.");
> -		wl1271_error("couldn't allocate target memory map");
> -		wl1271_error("failed to alloc memory to send sched scan stop");
> -		wl1271_error("failed to alloc memory to send sched scan stop");
> -		wl1251_error("Out of memory setting filters.");
> -		wl1251_error("could not allocate memory for rx descriptor");
> -		wl1251_error("couldn't allocate target memory map");
> -		brcmf_err("No memory available for action frame\n");
> -			printk(KERN_WARNING "%s: Unable to allocate memory "
> -			       "for receive ring - halting NIC\n", dev->name);
> -		BUGMSG(D_NORMAL, "Memory squeeze, dropping packet.\n");
> -		BUGMSG(D_NORMAL, "Memory squeeze, dropping packet.\n");
> -		BUGMSG(D_NORMAL, "Memory squeeze, can't acknowledge.\n");
> -		BUGMSG(D_NORMAL, "Memory squeeze, dropping packet.\n");
> -			BUGMSG(D_NORMAL, "Memory squeeze, dropping packet.\n");
> -			printk(KERN_NOTICE "%s: Memory squeeze, dropping packet.\n", dev->name);
> -			netdev_err(cfhsi->ndev, "%s: Out of memory !\n",
> -			netdev_err(cfhsi->ndev, "%s: Out of memory !\n",
> -		DBG_PRINT(INFO_DBG, "%s: Memory allocation failed\n",
> -		DBG_PRINT(INFO_DBG, "%s: Memory allocation failed\n",
> -			"%s: memory allocation failed",
> -			"%s: memory allocation failed",
> -		vxge_debug_init(VXGE_ERR, "%s: memory allocation failed",
> -			"%s: vpath memory allocation failed",
> -				"%s: mac_addr_list : memory allocation failed",
> -			"%s : %d Memory Allocation failed for xmac_stats",
> -			"%s : %d Memory Allocation failed for sw_stats",
> -			"%s : %d Memory Allocation failed for hw_stats",
> -		mlx4_err(dev, "Couldn't allocate memory to save HCA PCI header, aborting\n");
> -		printk("%s: Memory squeeze, dropping packet.\n", dev->name);
> -		seq_puts(seq, "no memory!\n");
> -			"Unable to allocate memory for VF Data Storage\n");
> -				"Failed to allocate memory\n");
> -			BNX2X_ERR("Cannot Configure mulicasts due to lack of memory\n");
> -			BNX2X_ERR("Failed to allocate registry memory\n");
> -			pr_err("%s: ERROR: no memory", __func__);
> -		dev_err(&pdev->dev, "unable to alloc memory for cpsw phy sel\n");
> -		pr_notice("%s: Memory squeeze, dropping packet\n", chan->name);
> -		netdev_warn(sl->dev, "memory squeeze, dropping packet\n");
> -		netdev_err(dev, "out of memory\n");
> -		netdev_err(dev, "out of memory\n");
> -		netdev_warn(dev, "Memory squeeze on cisco_keepalive_send()\n");
> -		netdev_warn(dev, "Memory squeeze on fr_lmi_send()\n");
> -		netdev_warn(dev, "out of memory in ppp_tx_cp()\n");
> -		printk(KERN_ERR "PPPsync: no memory (input pkt)\n");
> -			netdev_err(ppp->dev, "PPP: no memory (VJ comp pkt)\n");
> -				netdev_err(ppp->dev, "PPP: no memory "
> -					   "(VJ decomp)\n");
> -			netdev_err(ppp->dev, "ppp_decompress_frame: "
> -				   "no memory\n");
> -			printk(KERN_ERR "%s: Memory squeeze.\n", dev->name);
> -		printk(KERN_WARNING "%s: memory squeeze, dropping packet.\n", dev->name);
> -		pr_debug("fddi: Local SMT: skb memory exhausted.\n");
> -		printk("%s: dropping packet due to memory squeeze.\n",
> -                printk(KERN_WARNING "%s: Memory squeeze, dropping packet.\n",
> -		IRDA_WARNING("%s(), memory squeeze, dropping frame.\n",
> -				IRDA_WARNING("%s(), memory squeeze, "
> -					     "dropping frame.\n",
> -				       "%s(), memory squeeze, dropping frame.\n", __func__);
> -				IRDA_WARNING("%s(), memory squeeze, "
> -					     "dropping frame.\n",
> -			printk(KERN_ERR "pxa_ir: fir out of memory for receive skb\n");
> -		printk(KERN_ERR "sa1100_ir: out of memory for RX SKB\n");
> -		printk(KERN_ERR "bubble sort kmalloc memory fail@@@\n");
> -		dev_err(&pdev->dev, "failed to reserve memory\n");
> -			"Memory is not available");
> -				"Memory allocation failed for Flash 2.x Read Structure");
> -			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Can not allocate memory for Link request!");
> -			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, LINK_UP_MSG, DBG_LVL_ALL, "Can not allocate memory for Link request!");
> -		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate memory for Flash 1.x");
> -		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate memory for Flash 2.x");
> -		BCM_DEBUG_PRINT(psAdapter, DBG_TYPE_PRINTK, 0, 0, "Can't Allocate Vendor Info Memory for Flash 2.x");
> -		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for section size");
> -		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed.. ");
> -			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed");
> -		DBG_88E("%s: failed to allocate memory\n", __func__);
> -		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
> -		RTLLIB_DEBUG(RTLLIB_DL_ERR, "can't alloc memory for HTInfo\n");
> -		printk("Not enough memory for packet, FIXME\n");
> -		dev_info(&hw->wiphy->dev, "w35und: Rx memory alloc failed\n");
> -			pr_warning("%s: no memory for net_device !\n",
> -		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
> -		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for HTInfo\n");
> -				dgap_err("out of memory");
> -				dgap_err("out of memory");
> -				dgap_err("out of memory");
> -		dev_err(dev, "Failed to allocate memory. Aborting.\n");
> -		pr_err("No memory is available\n");
> -		dev_err(&udev->dev, "%s: Can't alloc memory for vendor request\n",
> -		ERRDRV("out of memory\n");
> -		ERRDRV("out of memory\n");
> -		ERRDRV("out of memory\n");
> -			ERRDRV("out of memory\n");
> -		ERRDRV("out of memory\n");
> -		ERRDRV("out of memory\n");
> -		LOGERR("Could not allocate memory for disk\n");
> -		dev_err(&pdev->dev, "Could not allocate memory\n");
> -		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
> -			"unable to allocate memory for subdevice\n");
> -			"Failed to allocate memory for vpfe_dev\n");
> -		dev_dbg(&spi->dev, "Could not allocate memory for msi001\n");
> -		pr_err("Could not allocate memory for msi3101_state\n");
> -				"Could not allocate memory for rtl2832_sdr_state\n");
> -		dev_err(&pdev->dev, "could not allocate memory\n");
> -			 ("rtw_joinbss_cmd23a: memory allocate for cmd_obj "
> -			  "fail!!!\n"));
> -			BCMLOG_ERR("Insufficient Memory For RX\n");
> -		BCMLOG_ERR("Failed to allocate memory\n");
> -		dev_warn(&cdev->dev, "Could not get memory for virtio\n");
> -				 "Allocating memory for private DASD "
> -				 "data failed\n");
> -				 "Allocating memory for private DASD data "
> -				 "failed\n");
> -			DBF_DEV_EVENT(DBF_WARNING, device, "%s",
> -				"Allocating memory for private DASD data "
> -				      "failed\n");
> -				"Out of memory in netiucv_unpack_skb\n");
> -			"%s: memory allocation failure",
> -		pr_err("i2c-stub: Out of memory\n");
> -		dev_err(&pdev->dev, "Cannot allocate memory\n");
> -		dev_err(&pdev->dev, "Memory allocation failed\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		dev_err(&adev->dev, "cannot allocate memory\n");
> -		printk(KERN_ERR "pnp: Out of Memory\n");
> -		dev_err(xpc_chan, "can't get memory for channels\n");
> -		dev_err(xpc_part, "can't get memory for partition structure\n");
> -		dev_err(&client->dev, "Memory allocation failed\n");
> -			"cannot allocate memory to dispatch datagram\n");
> -			"cannot allocate memory to set cpt state (type=%d)\n",
> -		pr_warn("Failed allocating memory for datagram entry\n");
> -		pr_warn("Failed allocating memory for datagram entry\n");
> -		pr_warn("Failed to allocate memory for VMCI context\n");
> -		pr_warn("Failed to allocate memory for datagram\n");
> -		dev_err(&pdev->dev, "%s: Insufficient memory\n", __func__);
> -			"Can't allocate memory for VMCI device\n");
> -				pr_err("out of memory: dropping\n");
> -		pr_err("memory allocation failed");
> -		dev_err(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
> -		dev_err(&dev->pdev->dev, "amthif: memory allocation for ME message buffer failed.\n");
> -		dev_dbg(&pdev->dev, "out of memory\n");
> -			"%s(%d): kmalloc() returned NULL memory.\n",
> -		dev_err(&spi->dev, "Error: Can't allocate memory!\n");
> -		dev_err(&spi->dev, "Memory allocation for fpga_data failed\n");
> -		printk(KERN_ERR DRIVER_NAME "out of memory\n");
> -		dev_err(&pdev->dev, "out of memory\n");
> -		dev_err(&pdev->dev, "Failed to allocate memory\n");
> -		printk(KERN_ERR "windfarm: Couldn't create MAX6690 sensor: "
> -		       "no memory\n");
> -		printk(KERN_WARNING "windfarm: Memory allocation error"
> -		       " max fan speed\n");
> -		printk(KERN_WARNING "pm121: Memory allocation error\n");
> -		printk(KERN_ERR "rackmeter: failed to allocate memory !\n");
> -		printk(KERN_WARNING "windfarm: Memory allocation error"
> -		       " max fan speed\n");
> -		printk(KERN_WARNING "windfarm: Memory allocation error"
> -		       " max fan speed\n");
> -		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
> -		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
> -		dev_err(&pdev->dev, "could not allocate memory for pdata\n");
> -		dev_err(&pdev->dev, "could not allocate memory for dma_slave\n");
> -		dev_err(old_devdata->dev, "%s: Could not allocate memory for device data\n", __func__);
> -		dev_err(&viodev->dev, "%s: Could not allocate memory for device data\n", __func__);
> -		dev_err(&viodev->dev, "%s: Could not allocate memory for performance counters\n", __func__);
> -		pr_err("Could not allocate memory for device data\n");
> -		dev_err(jrdev, "unable to allocate key input memory\n");
> -		dev_err(jrdev, "unable to allocate key input memory\n");
> -		pr_err("powernow_table memory alloc failure\n");
> -		pr_debug("powernow_table memory alloc failure\n");
> -		printk(KERN_ERR "%s: no memory\n", __func__);
> -		printk(KERN_ERR "%s: no memory for tables\n", __func__);
> -		pr_err("%s: no memory\n", __func__);
> -		pr_err("%s: no memory\n", __func__);
> -		cx231xx_err(DRIVER_NAME ": out of memory!\n");
> -		cx231xx_errdev("out of memory!\n");
> -		cx231xx_errdev("out of memory!\n");
> -		cx231xx_errdev("out of memory!\n");
> -			cx231xx_errdev("out of memory!\n");
> -		printk(KERN_INFO "cx231xx_dvb: memory allocation failed\n");
> -		cx231xx_errdev("out of memory!\n");
> -		cx231xx_errdev("cannot alloc memory for usb buffers\n");
> -		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
> -		cx231xx_errdev("cannot alloc memory for usb buffers\n");
> -		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
> -		cx231xx_errdev("cannot alloc memory for usb buffers\n");
> -		cx231xx_errdev("cannot allocate memory for usbtransfer\n");
> -		cx231xx_errdev("cx231xx-video.c: Out of memory?!\n");
> -		stk1160_err("out of memory for urb array\n");
> -		stk1160_err("out of memory for usb transfers\n");
> -		STK_ERROR("Out of memory !\n");
> -		em28xx_info("em28xx_dvb: memory allocation failed\n");
> -		em28xx_errdev("cannot alloc memory for usb buffers\n");
> -		em28xx_errdev("cannot allocate memory for usb transfer\n");
> -		em28xx_errdev("em28xx-video.c: Out of memory?!\n");
> -		em28xx_info("em28xx_v4l: memory allocation failed\n");
> -		em28xx_err(DRIVER_NAME ": out of memory!\n");
> -		em28xx_errdev("out of memory!\n");
> -		dprintk(dev, 1, "out of memory!\n");
> -		s2255_dev_err(&interface->dev, "out of memory\n");
> -		s2255_dev_err(&interface->dev, "out of memory\n");
> -		dev_err(&interface->dev, "out of memory!\n");
> -					err("no memory for priv for adapter %d fe %d.", n, o);
> -				err("no memory for priv for adapter %d.", n);
> -			err("no memory for priv in 'struct dvb_usb_device'");
> -		err("no memory for 'struct dvb_usb_device'");
> -		dev_err(&intf->dev, "usbvision: out of memory!\n");
> -		dev_err(&interface->dev, "Out of memory\n");
> -		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
> -		printk(KERN_INFO "Cannot allocate memory\n");
> -		tm6000_err("cannot allocate memory for urb buffers\n");
> -		tm6000_err("cannot allocate memory for urb dma pointers\n");
> -		tm6000_err("cannot alloc memory for usb buffers\n");
> -		tm6000_err("cannot allocate memory for usbtransfer\n");
> -		printk(KERN_ERR "tm6000" ": out of memory!\n");
> -		dev_err(&udev->dev, "cam: out of memory !\n");
> -			info("MEM Error no memory");
> -		PWC_ERROR("Oops, could not allocate memory for pwc_device.\n");
> -		PWC_ERROR("Oops, could not allocate memory for pwc_device.\n");
> -			   "Failed to allocate memory"
> -			   " required to read eeprom");
> -			   "failed to allocate memory for firmware2 upload");
> -			   "Failed to allocate memory"
> -			   " required to read eeprom");
> -			   "Unable to allocate memory to control CPU reset");
> -		au0828_isocdbg("cannot alloc memory for usb buffers\n");
> -		au0828_isocdbg("cannot allocate memory for usb transfer\n");
> -		printk(KERN_ERR "%s() Unable to allocate memory\n", __func__);
> -		pr_err("out of memory\n");
> -			"%s: unable to allocate memory for state\n", __func__);
> -		dprintk("%s: not enough memory", __func__);
> -		dprintk("%s: not enough memory", __func__);
> -		dprintk("%s: not enough memory", __func__);
> -		dprintk("%s: not enough memory", __func__);
> -		dprintk("%s: not enough memory", __func__);
> -		printk(KERN_ERR "Can't allocate memory for tda10045 state\n");
> -		printk(KERN_ERR "Can't allocate memory for tda10046 state\n");
> -			dev_err(&pdev->dev, ": could not allocate memory\n");
> -		mfc_err("Not enough memory\n");
> -		mfc_err("Not enough memory\n");
> -		mfc_err("Not enough memory\n");
> -		dev_err(&pdev->dev, "Not enough memory for MFC device\n");
> -		dev_err(&pdev->dev, "Not enough memory for %s\n",
> -		dev_err(aewb->isp->dev, "AEWB: cannot allocate memory for "
> -					"recover configuration.\n");
> -		dev_err(af->isp->dev, "AF: cannot allocate memory for recover "
> -				      "configuration.\n");
> -		dev_err(&pdev->dev, "could not allocate memory\n");
> -		dev_err(dev, "out of memory\n");
> -			mxr_err(mdev, "no memory for '%s'\n",
> -		mxr_err(mdev, "not enough memory for layer.\n");
> -		dev_err(dev, "not enough memory.\n");
> -		dev_err(dev, "failed to get memory for regulators\n");
> -		dev_err(dev, "out of memory\n");
> -		dev_err(dev, "not enough memory.\n");
> -		pr_err("unable to allocate memory for ppi handle\n");
> -			 "unable to allocate memory for file handle object\n");
> -			"unable to allocate memory for encoders sub devices");
> -		v4l2_err(pdev->dev.driver, "Unable to allocate memory"
> -			 " for vpbe_device\n");
> -			"unable to allocate memory for file handle object\n");
> -			 "Memory allocation failed for ccdc_cfg\n");
> -			"unable to allocate memory for subdevice pointers\n");
> -		vpif_err("unable to allocate memory for subdevice pointers\n");
> -		vpif_err("unable to allocate memory for subdevice pointers\n");
> -			"unable to allocate memory for file handle object\n");
> -		printk(KERN_ERR "ran out of memory\n");
> -		sms_err("Can't allocate memory for client id.");
> -		sms_err("Failed to allocate memory for client.");
> -		ERR("out of memory\n");
> -		DEB_S("cannot allocate memory for per open data\n");
> -		ERR("out of memory. aborting.\n");
> -		err("no memory");
> -		IVTVFB_ERR("Failed to allocate memory for osd_info\n");
> -		dprintk(1, KERN_ERR "%s: %s - no memory\n",
> -						"videocodec_attach: no memory\n");
> -		dprintk(1, KERN_ERR "videocodec_register: no memory\n");
> -		DEB_D("not enough kernel memory\n");
> -		pr_err("hexium_probe: not enough kernel memory\n");
> -		pr_err("not enough kernel memory in hexium_attach()\n");
> -		dprintk(MANTIS_ERROR, 1, "Out of memory!, exiting ..");
> -		printk(KERN_ERR "%s ERROR: Out of memory\n", __func__);
> -		printk(KERN_ERR "%s ERROR: Out of memory\n", __func__);
> -		printk(KERN_ERR "cx18: cannot manage card %d, out of memory\n",
> -		dprintk(1, "out of memory\n");
> -		tuner_err("Not enough memory to load firmware file.\n");
> -			tuner_err("Not enough memory to load firmware file.\n");
> -		printk(KERN_ERR "Not enough memory to load firmware file.\n");
> -			printk(KERN_ERR "Not enough memory to load firmware file.\n");
> -		fmerr("No memory to create new SKB\n");
> -		fmerr("Can't allocate operation structure memory\n");
> -		dev_err(&pdev->dev, "not enough memory\n");
> -		pr_err("Cannot allocate memory for RDS buffer.\n");
> -		v4l_err(client, "Could not allocate adv7604_state memory!\n");
> -			"Failed to allocate memory for private data!\n");
> -			"Failed to allocate memory for private data!\n");
> -			"Failed to allocate memory for private data!\n");
> -		v4l_err(client, "Could not allocate adv7842_state memory!\n");
> -		dev_warn(rr3->dev, "Memory allocation faillure\n");
> -		dev_err(dev, "Memory allocation failure\n");
> -		dev_err(rr3->dev, "Memory allocation failure\n");
> -		dev_err(dev, "Memory allocation failure\n");
> -		dev_err(dev, "%s: memory allocation failed!", __func__);
> -		printk(KERN_ERR SPFX "No memory for ib_agent_port_private\n");
> -		printk(KERN_ERR PFX "No memory for ib_mad_local_private\n");
> -		printk(KERN_ERR PFX "No memory for "
> -		       "ib_mad_mgmt_method_table\n");
> -			printk(KERN_ERR PFX "No memory for "
> -			       "ib_mad_mgmt_class_table\n");
> -			printk(KERN_ERR PFX "No memory for "
> -			       "ib_mad_mgmt_vendor_class_table\n");
> -			printk(KERN_ERR PFX "No memory for "
> -			       "ib_mad_mgmt_vendor_class\n");
> -		printk(KERN_ERR PFX "No memory for ib_mad_port_private\n");
> -		pr_err("alias_guid_work: No Memory\n");
> -		pr_err("failed to allocate memory for tunneling qp update\n");
> -			pr_err("failed to allocate memory for tunneling qp update work struct\n");
> -		mlx4_ib_warn(ibdev, "Couldn't allocate id cache entry - out of memory\n");
> -		usnic_err("Failed to allocate chunk for %s - Out of memory\n",
> -		usnic_err("Failed to allocate resources for %s. Out of memory\n",
> -		usnic_err("Failed to alloc vnic for %s - out of memory\n",
> -		usnic_err("Unable to alloc qp_grp - Out of memory\n");
> -		nes_debug(NES_DBG_INIT, "Unable to allocate memory CQP request entries.\n");
> -			nes_debug(NES_DBG_INIT, "%s: out of memory for receive skb\n", netdev->name);
> -			nes_debug(NES_DBG_CM, "Not creating listener memory allocation failed\n");
> -		nes_debug(NES_DBG_INIT, "Unable to allocate memory for mgt structure\n");
> -				nes_debug(NES_DBG_INIT, "%s: out of memory for receive skb\n", netdev->name);
> -		PDBG("%s couldn't allocate memory.\n", __func__);
> -		PDBG("%s couldn't allocate memory.\n", __func__);
> -		PDBG("%s couldn't allocate memory.\n", __func__);
> -		PDBG("%s couldn't allocate memory.\n", __func__);
> -		mthca_err(mdev, "Couldn't allocate memory to save HCA "
> -			  "PCI header, aborting.\n");
> -			mthca_err(mdev, "Couldn't allocate memory to save HCA "
> -				  "bridge PCI header, aborting.\n");
> -		ehca_err(device, "Out of memory device=%p", device);
> -		printk(KERN_ERR "rejected SRP_LOGIN_REQ because no memory.\n");
> -			"Cannot allocate memory for pn544 i2c phy.\n");
> -			"Cannot allocate memory for st21nfca i2c phy.\n");
> -		printk(KERN_ERR MODULE_NAME ": memory allocation failure\n");
> -			printk(KERN_ERR "HP-PB: Unable to allocate memory.\n");
> -		dev_err(&pd->dev, "not enough memory for omap ssi\n");
> -		dev_err(dev, "Could not allocate memory for gpios\n");
> -		dev_err(dev, "Could not allocate memory for nokia_modem_device\n");
> -		dev_err(dev, "No memory for ssi protocol\n");
> -		pr_err("%s: unable to alloc memory\n", __func__);
> -			pr_err("%s: unable to alloc memory\n", __func__);
> -		dev_err(pi->dev, "%s:%d Can't allocate memory!\n",
> -		pr_warn("No memory for %s\n", dma_chan_name(chan));
> -		dev_err(dev, "Memory exhausted!\n");
> -				"%s no memory for channel\n", __func__);
> -		dev_err(tdev->dev, "no free memory for DMA channels!\n");
> -		dev_err(dev, "Memory exhausted!\n");
> -		dev_err(&pdev->dev, "Error: memory allocation failed\n");
> -		dev_err(&pl08x->adev->dev, "%s no memory for pl080 sg\n",
> -				"%s no memory for channel\n", __func__);
> -			dev_err(dev, "no memory for channel %u\n", i);
> -		d40_err(&pdev->dev, "Out of memory\n");
> -		dev_err(fdev->dev, "no free memory for DMA channels!\n");
> -		dev_err(&op->dev, "No enough memory for 'priv'\n");
> -			"No free memory for allocating DMA channels!\n");
> -		dev_err(&pdev->dev, "Not enough memory\n");
> -			"No free memory for allocating dma channels!\n");
> -		dev_err(&pdev->dev, "Not enough memory\n");
> -			"No free memory for allocating dma channels!\n");
> -		dev_err(&pdev->dev, "Not enough memory\n");
> -    PRINTK (KERN_ERR, "out of memory!");
> -		PRINTD(DBG_ERR, "out of memory");
> -    PRINTK (KERN_ERR, "out of memory!");
> -		PRINTK (KERN_ERR, "out of memory!");
> -		printk("%s: Out of memory in send_oam().\n", card->name);
> -		printk (KERN_WARNING "Couldn't allocate memory for VCC buffers. Woops!\n");
> -		printk (KERN_WARNING "Couldn't allocate memory for tx_inuse bits!\n");
> -		printk(KERN_EMERG "%s: memory shortage\n", DEV_LABEL);
> -		befs_error(sb, "befs_btree_find() failed to allocate %zu "
> -			   "bytes of memory", sizeof (befs_btree_node));
> -		pr_err("(%s): Unable to allocate memory for private "
> -		       "portion of superblock. Bailing.\n", sb->s_id);
> -		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
> -			       " info.");
> -		printk(KERN_ERR "qnx6: unable to allocate memory.\n");
> -		ext2_msg(sb, KERN_ERR, "error: not enough memory");
> -		ext2_msg(sb, KERN_ERR, "error: not enough memory");
> -		udf_err(inode->i_sb, "(ino %ld) no free memory\n",
> -					reiserfs_warning(s, "reiserfs-2502",
> -							 "not enough memory "
> -							 "for storing "
> -							 "quotafile name.");
> -			SWARN(silent, s, "", "Cannot allocate memory for "
> -				"journal device name");
> -		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
> -		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
> -		printk(KERN_ERR "%s: Out of kernel memory whilst attempting to "
> -		       "kzalloc [%zd] bytes\n", __func__,
> -		printk(KERN_ERR "%s: Out of memory whilst trying to kmalloc "
> -		       "[%zd] bytes of kernel memory\n", __func__, sizeof(*s));
> -		printk(KERN_ERR "%s: Out of memory whilst attempting to "
> -		       "kmalloc [%zd] bytes\n", __func__,
> -		printk(KERN_ERR "%s: Out of memory whilst attempting to "
> -		       "kmalloc [%zd] bytes\n", __func__,
> -		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
> -		       "GFP_KERNEL memory\n", __func__, sizeof(**daemon));
> -		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
> -		printk(KERN_ERR "%s: Failed to allocate memory\n", __func__);
> -		printk(KERN_ERR "%s: Out of memory whilst attempting "
> -		       "to kmalloc(%zd, GFP_KERNEL)\n", __func__,
> -			printk(KERN_ERR "%s: Out of memory whilst attempting "
> -			       "to kmalloc [%zd] bytes\n", __func__,
> -			printk(KERN_ERR "%s: Out of memory whilst attempting "
> -			       "to kzalloc [%zd] bytes\n", __func__,
> -			printk(KERN_ERR "%s: Out of memory whilst attempting "
> -			       "to kzalloc [%zd] bytes\n", __func__,
> -			printk(KERN_ERR "%s: Out of memory whilst attempting "
> -			       "to kmalloc [%zd] bytes\n", __func__,
> -		       "Not enough memory for quota information structure.\n");
> -		log_print("dlm_add_requestqueue: out of memory len %d", length);
> -		DBG_FLT("binfmt_flat: no memory for decompress workspace\n");
> -		DBG_FLT("binfmt_flat: no memory for read buffer\n");
> -		dprintk("%s: Not enough memory\n", __func__);
> -		printk(KERN_ERR "lockd: reclaimer unable to alloc memory."
> -				" Locks for %s won't be reclaimed!\n",
> -		adfs_error(sb, "not enough memory");
> -		jfs_error(bmp->db_ipbmap->i_sb, "no memory for trim array\n");
> -			pr_info("%s: out of memory\n", __func__);
> -		pr_err("failed to allocate memory for header node\n");
> -			"error: not enough memory");
> -			      "not enough memory for %lu groups", gdb_num + 1);
> -		ubifs_err("out of memory");
> -		ext4_warning(sb, "not enough memory for mmpd_data");
> -			JFFS2_WARNING("Can't allocate memory for summary\n");
> -		JFFS2_WARNING("Can't allocate memory for summary information!\n");
> -				JFFS2_ERROR("can't allocate %u bytes of memory for the symlink target path cache\n", csize);
> -		pr_warn("No memory for compressor allocation. Compression failed.\n");
> -		jffs2_dbg(1, "No memory to allocate inodirty. Fallback to all considered dirty\n");
> -		pr_warn("%s: out of memory loading\n", a->name);
> -		pr_err("rcu-torture: Out of memory, need: %d", size);
> -		VERBOSE_TOROUT_ERRSTRING("out of memory");
> -		VERBOSE_TOROUT_ERRSTRING("out of memory");
> -		audit_panic("out of memory for argv string");
> -		pr_err("lock_torture_stats_print: Out of memory, need: %d",
> -		VERBOSE_TOROUT_STRING("lwsa: Out of memory");
> -		VERBOSE_TOROUT_ERRSTRING("writer_tasks: Out of memory");
> -		pr_info("Failed to allocate memory for command '%s'.\n", arg);
> -		pr_warn("could not add '%s' (out of memory)\n",
> -		audit_log_string(ab, "<no_memory>");
> -			pr_cont("UNEXPECTED_FAIL no memory left\n");
> -		printk(KERN_ERR "list_sort_test: error: cannot allocate "
> -				"memory\n");
> -			printk(KERN_ERR "list_sort_test: error: cannot "
> -					"allocate memory\n");
> -		pr_err("dma_debug_add_bus: out of memory\n");
> -		"MCE: Out of memory while machine check handling\n");
> -			pr_warn("Cannot publish {%u,%u,%u}, no memory\n",
> -		pr_warn("Subscription rejected, no memory\n");
> -		pr_warn("Subscriber rejected, no memory\n");
> -				pr_warn("Incomplete multicast delivery, no memory\n");
> -		pr_warn("Node creation failed, no memory\n");
> -		pr_warn("Link creation failed, no memory\n");
> -		IP_VS_DBG(1, "%s(): no memory\n", __func__);
> -		pr_err("x25_dev: out of memory\n");
> -		dprintk("RPC: %5u %s: no memory available\n",
> -		BT_ERR("Out of memory");
> -		BT_ERR("Out of memory");
> -		BT_ERR("Can't allocate memory for new frame");
> -		BT_ERR("Can't allocate memory for interoperability packet");
> -		BT_ERR("Can't allocate memory for CAPI message");
> -		BT_ERR("Can't allocate memory for new frame");
> -		pr_warning("iucv_external_interrupt: out of memory\n");
> -		_debug("no memory");
> -		pr_info("mpoa: out of memory\n");
> -		pr_info("out of memory\n");
> -		IRDA_ERROR("%s: can't allocate memory\n", __func__);
> -				       "SELinux: ebitmap: out of memory\n");
> -		printk(KERN_ERR "SELinux:  unable to allocate memory for policydb "
> -		       "string of length %d\n", len);
> -		pr_err("encrypted_key: out of memory\n");
> -		snd_printk(KERN_ERR "vx_core: no memory\n");
> -		snd_printk(KERN_ERR "gf1: DMA transfer failure; not enough memory\n");
> -		snd_printk(KERN_ERR "no memory\n");
> -		printk(KERN_WARNING "Loopback MIDI: Failed to allocate memory\n");
> -		printk(KERN_ERR "mpu401: Can't allocate memory\n");
> -		printk(KERN_ERR "sb_mixer: Can't allocate memory\n");
> -		printk(KERN_ERR "opl3: Can't allocate memory for the device control "
> -			"structure \n ");
> -		printk(KERN_ERR "kahlua: out of memory.\n");
> -		printk(KERN_WARNING "Sound Blaster:  failed to allocate MIDI memory.\n");
> -		  printk(KERN_WARNING "Sound Blaster:  failed to allocate MIDI memory.\n");
> -		printk(KERN_WARNING "uart401: Can't allocate memory\n");
> -		dev_err(&pdev->dev, "Cannot allocate memory for HDMI data\n");
> -		dev_err(&i2c->dev, "Can not allocate memory\n");
> -		dev_err(dev, "Can not allocate memory\n");
> -		dev_err(codec->dev, "failed to allocate decs name memory\n");
> -			dev_err(codec->dev, "Can not allocate memory\n");
> -		dev_err(codec->dev, "Can not allocate memory\n");
> -		dev_err(codec->dev, "Cannot allocate memory.\n");
> -		dev_err(&i2c->dev, "Out of memory\n");
> -		dev_err(&i2c->dev, "Can not allocate memory\n");
> -		dev_err(dev, "ASoC: Failed to allocate memory\n");
> -		dev_err(dev, "Unable to allocate memory for sport device\n");
> -			"could not allocate memory for private data\n");
> -			"unable to kmalloc Mixer memory of %d Bytes\n",
> -		printk(KERN_INFO "%s: Couldn't allocate memory\n",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

