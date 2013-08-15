Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3HOQqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:46:09 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:59517 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab3HOQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130813034054.GA18218@roeck-us.net>
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
 <52082EF8.10005@roeck-us.net> <CAFEAcA94ygwRPSsfxs3DvOcTZbdafLiEHys94FG4aXUx+A1t=A@mail.gmail.com>
 <20130813034054.GA18218@roeck-us.net>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 15 Aug 2013 17:45:42 +0100
Message-ID: <CAFEAcA_-S8z6ZMr8TMPvkcTyyCSMOj1DExVsY4JDQjRXDU5WGw@mail.gmail.com>
Subject: Re: [Qemu-devel] SCSI bus failures with qemu-arm in kernel 3.8+
To: Guenter Roeck <linux@roeck-us.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 04:40, Guenter Roeck <linux@roeck-us.net> wrote:
> Patch tested and working with qemu 1.5.2, using the configuration file
> from the yocto project. Patch applied on top of kernel version 3.11-rc5.

OK, I tested this on PB926+PCI backplane hardware, and it is
definitely better than current mainline, in that the test USB
card that I have no longer causes the kernel to generate this sort of
backtrace:

ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-pci 0000:00:1e.2: EHCI Host Controller
ehci-pci 0000:00:1e.2: new USB bus registered, assigned bus number 1
ehci-pci 0000:00:1e.2: irq 91, io mem 0x50002000
ehci-pci 0000:00:1e.2: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 3.10.0+ ehci_hcd
usb usb1: SerialNumber: 0000:00:1e.2
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-pci 0000:00:1e.0: OHCI PCI host controller
ohci-pci 0000:00:1e.0: new USB bus registered, assigned bus number 2
irq 93: nobody cared (try booting with the "irqpoll" option)
CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0+ #9
[<c00187d4>] (unwind_backtrace+0x0/0xf0) from [<c0015b48>]
(show_stack+0x10/0x14)
[<c0015b48>] (show_stack+0x10/0x14) from [<c0054cac>]
(__report_bad_irq+0x24/0xb8)
[<c0054cac>] (__report_bad_irq+0x24/0xb8) from [<c005511c>]
(note_interrupt+0x1cc/0x230)
[<c005511c>] (note_interrupt+0x1cc/0x230) from [<c005363c>]
(handle_irq_event_percpu+0xac/0x1c4)
[<c005363c>] (handle_irq_event_percpu+0xac/0x1c4) from [<c005377c>]
(handle_irq_event+0x28/0x38)
[<c005377c>] (handle_irq_event+0x28/0x38) from [<c00558c8>]
(handle_level_irq+0x80/0xd4)
[<c00558c8>] (handle_level_irq+0x80/0xd4) from [<c0052fb4>]
(generic_handle_irq+0x2c/0x40)
[<c0052fb4>] (generic_handle_irq+0x2c/0x40) from [<c016bf38>]
(fpga_irq_handle+0x3c/0x50)
[<c016bf38>] (fpga_irq_handle+0x3c/0x50) from [<c0052fb4>]
(generic_handle_irq+0x2c/0x40)
[<c0052fb4>] (generic_handle_irq+0x2c/0x40) from [<c0013e8c>]
(handle_IRQ+0x30/0x84)
[<c0013e8c>] (handle_IRQ+0x30/0x84) from [<c0008750>] (vic_handle_irq+0x5c/0x9c)
[<c0008750>] (vic_handle_irq+0x5c/0x9c) from [<c00165c0>] (__irq_svc+0x40/0x4c)
Exception stack(0xc7829cc8 to 0xc7829d10)
9cc0:                   00000001 0000000a 00000100 20000013 00000002 00000024
9ce0: c7828000 c0476980 3fb96c1c c0443950 c04693c0 00000001 c0456a50 c7829d10
9d00: c0025f38 c0025fa8 20000013 ffffffff
[<c00165c0>] (__irq_svc+0x40/0x4c) from [<c0025fa8>] (__do_softirq+0x80/0x1b4)
[<c0025fa8>] (__do_softirq+0x80/0x1b4) from [<c00263a4>] (irq_exit+0x54/0x90)
[<c00263a4>] (irq_exit+0x54/0x90) from [<c0013e90>] (handle_IRQ+0x34/0x84)
[<c0013e90>] (handle_IRQ+0x34/0x84) from [<c0008750>] (vic_handle_irq+0x5c/0x9c)
[<c0008750>] (vic_handle_irq+0x5c/0x9c) from [<c00165c0>] (__irq_svc+0x40/0x4c)
Exception stack(0xc7829d80 to 0xc7829dc8)
9d80: 00000000 0000005d 20000000 00000000 c79bb7e0 c0446990 60000013 c79c0000
9da0: 0000005d 00000000 c04469c4 00000001 00000000 c7829dc8 c00555c8 c0054460
9dc0: 40000013 ffffffff
[<c00165c0>] (__irq_svc+0x40/0x4c) from [<c0054460>] (__setup_irq+0x1f4/0x3f0)
[<c0054460>] (__setup_irq+0x1f4/0x3f0) from [<c00548ac>]
(request_threaded_irq+0xb4/0x138)
[<c00548ac>] (request_threaded_irq+0xb4/0x138) from [<c01fa7a8>]
(usb_add_hcd+0x4f0/0x6f0)
[<c01fa7a8>] (usb_add_hcd+0x4f0/0x6f0) from [<c0206bdc>]
(usb_hcd_pci_probe+0x200/0x36c)
[<c0206bdc>] (usb_hcd_pci_probe+0x200/0x36c) from [<c017467c>]
(pci_device_probe+0x68/0x90)
[<c017467c>] (pci_device_probe+0x68/0x90) from [<c01b3a80>]
(driver_probe_device+0x78/0x200)
[<c01b3a80>] (driver_probe_device+0x78/0x200) from [<c01b3c94>]
(__driver_attach+0x8c/0x90)
[<c01b3c94>] (__driver_attach+0x8c/0x90) from [<c01b2288>]
(bus_for_each_dev+0x58/0x88)
[<c01b2288>] (bus_for_each_dev+0x58/0x88) from [<c01b29e8>]
(bus_add_driver+0xd8/0x220)
[<c01b29e8>] (bus_add_driver+0xd8/0x220) from [<c01b4258>]
(driver_register+0x78/0x144)
[<c01b4258>] (driver_register+0x78/0x144) from [<c0410820>]
(do_one_initcall+0x94/0x154)
[<c0410820>] (do_one_initcall+0x94/0x154) from [<c04109cc>]
(kernel_init_freeable+0xec/0x1b0)
[<c04109cc>] (kernel_init_freeable+0xec/0x1b0) from [<c0323104>]
(kernel_init+0x8/0xe4)
[<c0323104>] (kernel_init+0x8/0xe4) from [<c00130b0>] (ret_from_fork+0x14/0x24)
handlers:
[<c01f7e48>] usb_hcd_irq
Disabling IRQ #93

However it still doesn't seem to reliably detect the USB harddisk
plugged into the card, so I think there may be further issues, possibly
some subset of those Arnd identified and fixed with this patch:
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/93397

so I'd like to continue testing.

The other thing this patch should (IMHO) have is the
line in pci_versatile_setup() which tells QEMU that the
kernel really does expect hardware-like behaviour:

--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -295,6 +295,19 @@ int __init pci_versatile_setup(int nr, struct
pci_sys_data *sys)
        __raw_writel(PHYS_OFFSET, local_pci_cfg_base + PCI_BASE_ADDRESS_2);

        /*
+        * For many years the kernel and QEMU were symbiotically buggy
+        * in that they both assumed the same broken IRQ mapping.
+        * QEMU therefore attempts to auto-detect old broken kernels
+        * so that they still work on newer QEMU as they did on old
+        * QEMU. Since we now use the correct (ie matching-hardware)
+        * IRQ mapping we write a definitely different value to a
+        * PCI_INTERRUPT_LINE register to tell QEMU that we expect
+        * real hardware behaviour and it need not be backwards
+        * compatible for us. This write is harmless on real hardware.
+        */
+       __raw_writel(0, VERSATILE_PCI_VIRT_BASE+PCI_INTERRUPT_LINE);
+
+       /*
         * Do not to map Versatile FPGA PCI device into memory space
         */
        pci_slot_ignore |= (1 << myslot);

I appreciate that QEMU-specific code in the kernel is a bit ugly, but
(a) 99.9% of the people running this code are going to be running it on QEMU
(b) the bugs in this area have been extremely long-standing in both
the kernel and QEMU and so there are a lot of legacy kernel images
out there that worked just fine with QEMU
(c) it's rather less code than I have in QEMU as the QEMU-side part
of this backwards-compatibility autodetection.

(Without this line QEMU will guess whether the kernel is broken
or not and will get it right most but not necessarily all of the time.)

thanks
-- PMM
