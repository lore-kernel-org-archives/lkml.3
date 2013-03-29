Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133Ab3C2V3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:29:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47009 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab3C2V3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:29:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [Update][PATCH] PCI / ACPI: Always resume devices on ACPI wakeup notifications
Date: Fri, 29 Mar 2013 22:37:12 +0100
Message-ID: <1600150.ItUTnFh37v@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130329160535.GA5113@xanatos>
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <5155ADD2.3090005@fold.natur.cuni.cz> <20130329160535.GA5113@xanatos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 29, 2013 09:05:35 AM Sarah Sharp wrote:
> On Fri, Mar 29, 2013 at 04:05:54PM +0100, Martin Mokrejs wrote:
> > [   36.594171] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
> > [   36.594202] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
> > [   36.594247] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
> > [   36.594349] xhci_hcd 0000:0b:00.0: PME# enabled
> > [   36.703695] r8169 0000:05:00.0 eth0: link down
> > [   37.098299] microcode: CPU0 updated to revision 0x28, date = 2012-04-24
> > [   37.098941] microcode: CPU1 updated to revision 0x28, date = 2012-04-24
> > [   37.098944] perf_event_intel: PEBS enabled due to microcode update
> > [   38.343029] r8169 0000:05:00.0 eth0: link up
> > [   39.094944] r8169 0000:05:00.0 eth0: link down
> > [   41.492768] r8169 0000:05:00.0 eth0: link up
> > [   62.782910] xhci_hcd 0000:0b:00.0: Poll event ring: 4294943584
> > [   62.782938] xhci_hcd 0000:0b:00.0: op reg status = 0xffffffff
> > [   62.782939] xhci_hcd 0000:0b:00.0: HW died, polling stopped.
> > [   88.754183] pcieport 0000:00:1c.0: PME# enabled
> > [   88.764182] xhci_hcd 0000:0b:00.0: PME# disabled
> > [   88.764192] xhci_hcd 0000:0b:00.0: enabling bus mastering
> > [   88.764206] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
> > [   88.764242] xhci_hcd 0000:0b:00.0: Port Status Change Event for port 2
> > [   88.764246] xhci_hcd 0000:0b:00.0: resume root hub
> > [   88.764259] xhci_hcd 0000:0b:00.0: handle_port_status: starting port polling.
> > [   88.764276] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
> > [   88.764281] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0
> > 
> > 
> > What "HW died? Why 1c.0 is here? What is this device actually doing?
> 
> It's harmless.  The xHCI polling loop to debug the host registers and
> rings simply notices that the registers are reading as all ffs.  I
> believe that's normal when a PCI device is in D3.  I just haven't had
> time to make a patch to disable the polling loop when the host is suspended.
> 
> So, for now, ignore the "HW died, polling stopped." messages.
> 
> > Nevertheless, I went to check if if the USB3 socket dies after first unplug of device
> > or not anymore thanks to the patch being tested:
> > 
> > I plugged into the USB3.0 socket a mouse, it worked. Around its unplug I got:
> > 
> > [   94.954779] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
> > [   94.954795] hub 3-0:1.0: hub_suspend
> > [   94.954802] usb usb3: bus auto-suspend, wakeup 1
> > [   94.954817] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
> > [   94.954835] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
> > [   94.954857] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
> > [   94.954898] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
> > [   94.954983] xhci_hcd 0000:0b:00.0: PME# enabled
> > [  169.622513] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
> > [  169.623057] hub 2-1:1.0: port 2, status 0101, change 0001, 12 Mb/s
> > [  169.777012] hub 2-1:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
> > [  169.856992] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
> > 
> > and the port was dead, no matter what "lsusb -v or -vv" options I tried. At about
> > [  169.622513] I plugged the mouse into a USB2.0 socket (do not know if that is 1a.0 or 1d.0).
> 
> All right, I wonder if the USB core/xHCI driver is forgetting to clear a
> port status change bit after the device is unplugged.  That can cause
> the xHCI host to not give us a port status change event later (and thus
> no PME).  Looking at the logs later, it doesn't seem like we do this
> though.
> 
> > If I run lsusb -vv it does (with the problematic patch):
> > 
> > [ 1760.414086] pcieport 0000:00:1c.4: PME# disabled
> > [ 1760.434314] xhci_hcd 0000:0b:00.0: PME# disabled
> > [ 1760.434327] xhci_hcd 0000:0b:00.0: enabling bus mastering
> > [ 1760.434338] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
> > [ 1760.434360] xhci_hcd 0000:0b:00.0: Port Status Change Event for port 2
> 
> Ok, so the xHCI driver *is* getting a port status change event, and thus
> must have gotten a PME.  So the PCI layer is doing its job.
> 
> > [ 1760.434363] xhci_hcd 0000:0b:00.0: resume root hub
> > [ 1760.434367] xhci_hcd 0000:0b:00.0: handle_port_status: starting port polling.
> > [ 1760.434378] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
> > [ 1760.434383] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0
> > [ 1760.434388] usb usb3: usb auto-resume
> > [ 1760.434407] hub 3-0:1.0: hub_resume
> > [ 1760.434439] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
> > [ 1760.434440] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
> > [ 1760.434464] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x202a0
> > [ 1760.434465] xhci_hcd 0000:0b:00.0: Get port status returned 0x10100
> > [ 1760.434492] xhci_hcd 0000:0b:00.0: clear port connect change, actual port 1 status  = 0x2a0
> 
> Odd.  The port status shows there's no device connected, but there was a
> connect change:
> 
> sarah@xanatos:~$ ./decode-port-status 0x202a0
> port status = 0x0202a0
>  bit  0     (CCS)          0x0, device not connected
>  bit  1     (PED)          0x0, port disabled
>  bit  3     (OCA)          0x0, no over-current condition
>  bit  4     (PR)           0x0, port not in reset
>  bits 8:5   (PLS)          0x5, link is in the RxDetect state
>  bit  9     (PP)           0x1, port power on
>  bits 13:10 (speed)        0x0, Undefined
>  bits 15:14 (indicators)   0x0, port indicators are off
>  bit  17    (CSC)          0x1, connect change
>  bit  18    (PEC)          0x0, no port enable/disable change
>  bit  19    (WRC)          0x0, no warm port reset change
>  bit  20    (OCC)          0x0, no over-current change
>  bit  21    (PRC)          0x0, no port reset change
>  bit  22    (PLC)          0x0, no port link change
>  bit  23    (CEC)          0x0, no port config error change
>  bit  25    (WCE)          0x0, wake on connect disabled
>  bit  26    (WDE)          0x0, wake on disconnect disabled
>  bit  27    (WOE)          0x0, wake on over-current enable disabled
>  bit  30    (DR)           0x0, device is permanently attached
> 
> RxDetect is the "I'm looking for a USB device" port state.
> 
> > [ 1760.434642] usb usb4: usb wakeup-resume
> > [ 1760.434646] usb usb4: usb auto-resume
> > [ 1760.434661] hub 4-0:1.0: hub_resume
> > [ 1760.434683] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
> > [ 1760.434684] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
> > [ 1760.434710] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
> > [ 1760.434711] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
> > [ 1760.434727] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [ 1760.434757] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
> > [ 1760.434784] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
> > [ 1760.434791] hub 4-0:1.0: hub_suspend
> > [ 1760.434796] usb usb4: bus auto-suspend, wakeup 1
> > [ 1760.434807] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
> > [ 1760.553734] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
> > [ 1760.553751] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
> > [ 1760.574793] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
> > [ 1760.574794] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
> > [ 1760.575300] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
> > [ 1760.575301] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
> 
> sarah@xanatos:~$ ./decode-port-status 0x2a0
> port status = 0x0002a0
>  bit  0     (CCS)          0x0, device not connected
>  bit  1     (PED)          0x0, port disabled
>  bit  3     (OCA)          0x0, no over-current condition
>  bit  4     (PR)           0x0, port not in reset
>  bits 8:5   (PLS)          0x5, link is in the RxDetect state
>  bit  9     (PP)           0x1, port power on
>  bits 13:10 (speed)        0x0, Undefined
>  bits 15:14 (indicators)   0x0, port indicators are off
>  bit  17    (CSC)          0x0, no connect change
>  bit  18    (PEC)          0x0, no port enable/disable change
>  bit  19    (WRC)          0x0, no warm port reset change
>  bit  20    (OCC)          0x0, no over-current change
>  bit  21    (PRC)          0x0, no port reset change
>  bit  22    (PLC)          0x0, no port link change
>  bit  23    (CEC)          0x0, no port config error change
>  bit  25    (WCE)          0x0, wake on connect disabled
>  bit  26    (WDE)          0x0, wake on disconnect disabled
>  bit  27    (WOE)          0x0, wake on over-current enable disabled
>  bit  30    (DR)           0x0, device is permanently attached
> 
> Nope, your host really isn't reporting there's a device connected
> *at all*.  That's just broken hardware, and there's really nothing
> software can do if the hardware isn't reporting connect events, even
> with polling.
> 
> It also doesn't sound like the other TI redriver bug.  That bug only
> effected USB 3.0 ports, and when lsusb was run, we would find the port
> in Compliance Mode.  This is the host simply not reporting the USB 2.0
> port connect at all.
> 
> Maybe if we completely disable PCI runtime PM for your host, we can work
> around this bug?

Well, that's what I've just asked Martin to try.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
