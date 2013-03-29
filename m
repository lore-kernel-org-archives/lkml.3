Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab3C2Rn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:43:29 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:41216 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755858Ab3C2Rn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:43:27 -0400
Message-ID: <5155CB29.3010305@fold.natur.cuni.cz>
Date: Fri, 29 Mar 2013 18:11:05 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20100101 Firefox/19.0 SeaMonkey/2.16
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [Update][PATCH] PCI / ACPI: Always resume devices on ACPI wakeup
 notifications
References: <2282655.IicBMMa6jN@vostro.rjw.lan> <1396732.fV788D0xgr@vostro.rjw.lan> <2699206.HmPyNvCpNR@vostro.rjw.lan> <5155ADD2.3090005@fold.natur.cuni.cz> <20130329160535.GA5113@xanatos>
In-Reply-To: <20130329160535.GA5113@xanatos>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah,
  please let me know if you feel the test was screwed by laptop-mode-tools
kicking in, although I believed they were not running while I was on AC power.
I was testing under these conditions:

vostro ~ # grep . /sys/bus/pci/devices/*/power/control
/sys/bus/pci/devices/0000:00:00.0/power/control:auto
/sys/bus/pci/devices/0000:00:02.0/power/control:auto
/sys/bus/pci/devices/0000:00:16.0/power/control:auto
/sys/bus/pci/devices/0000:00:1a.0/power/control:auto
/sys/bus/pci/devices/0000:00:1b.0/power/control:auto
/sys/bus/pci/devices/0000:00:1c.0/power/control:auto
/sys/bus/pci/devices/0000:00:1c.1/power/control:auto
/sys/bus/pci/devices/0000:00:1c.3/power/control:auto
/sys/bus/pci/devices/0000:00:1c.4/power/control:auto
/sys/bus/pci/devices/0000:00:1c.7/power/control:auto
/sys/bus/pci/devices/0000:00:1d.0/power/control:auto
/sys/bus/pci/devices/0000:00:1f.0/power/control:auto
/sys/bus/pci/devices/0000:00:1f.2/power/control:auto
/sys/bus/pci/devices/0000:00:1f.3/power/control:auto
/sys/bus/pci/devices/0000:05:00.0/power/control:auto
/sys/bus/pci/devices/0000:09:00.0/power/control:auto
/sys/bus/pci/devices/0000:0b:00.0/power/control:auto
/sys/bus/pci/devices/0000:11:00.0/power/control:auto
vostro ~ # grep . /sys/bus/pci/devices/*/power/runtime_status
/sys/bus/pci/devices/0000:00:00.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:02.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:16.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:1a.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1b.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.0/power/runtime_status:suspended
/sys/bus/pci/devices/0000:00:1c.1/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.3/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.4/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1c.7/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1d.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.0/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.2/power/runtime_status:active
/sys/bus/pci/devices/0000:00:1f.3/power/runtime_status:suspended
/sys/bus/pci/devices/0000:05:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:09:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:0b:00.0/power/runtime_status:active
/sys/bus/pci/devices/0000:11:00.0/power/runtime_status:active
vostro ~ # 

My apologies if that twisted the test and thanks for you detailed explanations.

I will spot below, however, a few questions.

Sarah Sharp wrote:
> On Fri, Mar 29, 2013 at 04:05:54PM +0100, Martin Mokrejs wrote:

> 
>> Nevertheless, I went to check if if the USB3 socket dies after first unplug of device
>> or not anymore thanks to the patch being tested:
>>
>> I plugged into the USB3.0 socket a mouse, it worked. Around its unplug I got:
>>
>> [   94.954779] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
>> [   94.954795] hub 3-0:1.0: hub_suspend
>> [   94.954802] usb usb3: bus auto-suspend, wakeup 1
>> [   94.954817] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
>> [   94.954835] xhci_hcd 0000:0b:00.0: xhci_suspend: stopping port polling.
>> [   94.954857] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
>> [   94.954898] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_suspend: 0
>> [   94.954983] xhci_hcd 0000:0b:00.0: PME# enabled
>> [  169.622513] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0004
>> [  169.623057] hub 2-1:1.0: port 2, status 0101, change 0001, 12 Mb/s
>> [  169.777012] hub 2-1:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
>> [  169.856992] usb 2-1.2: new low-speed USB device number 4 using ehci-pci
>>
>> and the port was dead, no matter what "lsusb -v or -vv" options I tried. At about
>> [  169.622513] I plugged the mouse into a USB2.0 socket (do not know if that is 1a.0 or 1d.0).
> 
> All right, I wonder if the USB core/xHCI driver is forgetting to clear a
> port status change bit after the device is unplugged.  That can cause
> the xHCI host to not give us a port status change event later (and thus
> no PME).  Looking at the logs later, it doesn't seem like we do this
> though.
> 
>> If I run lsusb -vv it does (with the problematic patch):
>>
>> [ 1760.414086] pcieport 0000:00:1c.4: PME# disabled
>> [ 1760.434314] xhci_hcd 0000:0b:00.0: PME# disabled
>> [ 1760.434327] xhci_hcd 0000:0b:00.0: enabling bus mastering
>> [ 1760.434338] xhci_hcd 0000:0b:00.0: // Setting command ring address to 0xd6007001
>> [ 1760.434360] xhci_hcd 0000:0b:00.0: Port Status Change Event for port 2
> 
> Ok, so the xHCI driver *is* getting a port status change event, and thus
> must have gotten a PME.  So the PCI layer is doing its job.
> 
>> [ 1760.434363] xhci_hcd 0000:0b:00.0: resume root hub
>> [ 1760.434367] xhci_hcd 0000:0b:00.0: handle_port_status: starting port polling.
>> [ 1760.434378] xhci_hcd 0000:0b:00.0: xhci_resume: starting port polling.
>> [ 1760.434383] xhci_hcd 0000:0b:00.0: hcd_pci_runtime_resume: 0
>> [ 1760.434388] usb usb3: usb auto-resume
>> [ 1760.434407] hub 3-0:1.0: hub_resume
>> [ 1760.434439] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
>> [ 1760.434440] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
>> [ 1760.434464] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x202a0
>> [ 1760.434465] xhci_hcd 0000:0b:00.0: Get port status returned 0x10100
>> [ 1760.434492] xhci_hcd 0000:0b:00.0: clear port connect change, actual port 1 status  = 0x2a0
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
>> [ 1760.434642] usb usb4: usb wakeup-resume
>> [ 1760.434646] usb usb4: usb auto-resume
>> [ 1760.434661] hub 4-0:1.0: hub_resume
>> [ 1760.434683] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
>> [ 1760.434684] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
>> [ 1760.434710] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
>> [ 1760.434711] xhci_hcd 0000:0b:00.0: Get port status returned 0x2a0
>> [ 1760.434727] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
>> [ 1760.434757] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 0 status  = 0xe0002a0
>> [ 1760.434784] xhci_hcd 0000:0b:00.0: set port remote wake mask, actual port 1 status  = 0xe0002a0
>> [ 1760.434791] hub 4-0:1.0: hub_suspend
>> [ 1760.434796] usb usb4: bus auto-suspend, wakeup 1
>> [ 1760.434807] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
>> [ 1760.553734] xhci_hcd 0000:0b:00.0: xhci_hub_status_data: stopping port polling.
>> [ 1760.553751] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>> [ 1760.574793] xhci_hcd 0000:0b:00.0: get port status, actual port 0 status  = 0x2a0
>> [ 1760.574794] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
>> [ 1760.575300] xhci_hcd 0000:0b:00.0: get port status, actual port 1 status  = 0x2a0
>> [ 1760.575301] xhci_hcd 0000:0b:00.0: Get port status returned 0x100
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

I am not sure I understand what you mean. The proposed patch makes the
situation worse. To be able to use the xHCI port for second and later times,
I have to plugin a device and run 'lsusb -vv' to get the device detected
before the "port" falls asleep. This is NOT necessary for the SandyBridge
USB2.0 port under same conditions (well, regarding the disclaimer I made
on the very top of this message, from the other thread where Ying found that
I had laptop-mode-tools installed I realized that laptop-mode-tools
fiddled with xHCI port while NOT with EHCI port. Please correct me if
I was wrong. So, please re-consider your above conclusions. Most importantly,
I don not understand the "This is the host simply not reporting the USB 2.0
port connect at all.". Did you mean "USB 3.0 instead"?

Other than that, I am ready to file a bug report to Dell's Pro Support site
but from my last experience they were quite clue-less regarding the broken
"express card PresDet detection". ;-) I bet they could replace the TexasInstruments
USB3.0 card which is a separate thing in the laptop. At least I could get
the TI hardware which has hopefully fixed the redriver. ;-)
How could I reproduce the issue in Win7 which are on the laptop? I mean,
the change the PM handling to reproduce what I got on linux under laptop-mode-tools?
;)

> 
> Can you send me the output of `sudo lspci -vvv -n` again?

Will send after I reboot into a clean state and re-test the behavior while
laptop-mode-tools are gone. Maybe the issue will remain anyways.
So so far I tested effectively as under:

echo auto > /sys/bus/pci/devices/0000:0b:00.0/power/control

and without laptop-mode-tools trickery I should be now testing under

echo on > /sys/bus/pci/devices/0000:0b:00.0/power/control

, right?

Thank you,
Martin
