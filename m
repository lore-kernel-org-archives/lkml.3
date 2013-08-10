Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab3HJTEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 15:04:45 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:44678 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3HJTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:04:44 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
References: <52062353.9030800@rus.uni-stuttgart.de>
	<Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
Date: Sat, 10 Aug 2013 21:04:43 +0200
Message-ID: <CAPBO7Tbi0mjPOs7migmvm9TUyezsMfxpFrGxZMPodd2hvbXY5A@mail.gmail.com>
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
From: Josep Lladonosa <jlladono@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Richter <richter@rus.uni-stuttgart.de>, linux@brodo.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 August 2013 14:04, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 10 Aug 2013, Thomas Richter wrote:
>
>> Which modules are relevant for handling the communication with the
>> device, and where would you suggest to start looking? I assume
>> yenta_socket is one thing for the cartbus adapter, then we have ehci_hcd
>> and ehci_pci. Do I assume correctly that we can rule out the ohci_hcd
>> module since that is not involved?
>
> That's right.
>
>>  What about other usb modules? I would
>> probably need a short recap on through which modules the user data flows
>> before the write is triggered, and which modules are involved in the
>> configuration of the NEC ehci host adapter.
>
> Start with just the ones you have identified.  If that doesn't fix the
> problem then we can look further.
>

Hello,

Have you tried to wait for 5 minutes? It could also be related to it
what happens to my kernel 3.11.0-rc4 (and rc3) and USB

I plug the drive. Only after 5 minutes of high-speed of USb bus, it mounts.


Aug 10 20:56:09 minijep kernel: [  234.401608] usb 1-3: USB
disconnect, device number 3
Aug 10 20:56:43 minijep kernel: [  268.790914] usb 3-1.2: new
high-speed USB device number 6 using ehci-pci
Aug 10 20:56:43 minijep kernel: [  268.886687] usb 3-1.2: New USB
device found, idVendor=090c, idProduct=1000
Aug 10 20:56:43 minijep kernel: [  268.886695] usb 3-1.2: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Aug 10 20:56:43 minijep kernel: [  268.886699] usb 3-1.2: Product: DISK Pro
Aug 10 20:56:43 minijep kernel: [  268.886702] usb 3-1.2: Manufacturer: USB
Aug 10 20:56:43 minijep kernel: [  268.886705] usb 3-1.2:
SerialNumber: AA04012700008773
Aug 10 20:56:43 minijep mtp-probe: checking bus 3, device 6:
"/sys/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.2"
Aug 10 20:56:43 minijep kernel: [  268.887447] usb-storage 3-1.2:1.0:
USB Mass Storage device detected
Aug 10 20:56:43 minijep kernel: [  268.887714] scsi9 : usb-storage 3-1.2:1.0
Aug 10 20:56:43 minijep mtp-probe: bus: 3, device: 6 was not an MTP device
Aug 10 20:56:44 minijep kernel: [  269.889527] scsi 9:0:0:0:
Direct-Access     USB      DISK Pro         1100 PQ: 0 ANSI: 0 CCS
Aug 10 20:56:44 minijep kernel: [  269.890025] sd 9:0:0:0: Attached
scsi generic sg3 type 0
Aug 10 20:56:44 minijep kernel: [  269.892356] sd 9:0:0:0: [sdc]
3963904 512-byte logical blocks: (2.02 GB/1.88 GiB)
Aug 10 20:56:44 minijep kernel: [  269.893461] sd 9:0:0:0: [sdc] Write
Protect is off
Aug 10 20:57:14 minijep kernel: [  300.109604] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 20:57:45 minijep kernel: [  331.207924] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 20:58:16 minijep kernel: [  362.210362] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 20:58:47 minijep kernel: [  393.212774] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 20:59:18 minijep kernel: [  424.279257] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 20:59:49 minijep kernel: [  455.345574] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 21:00:20 minijep kernel: [  486.347994] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 21:00:51 minijep kernel: [  517.350252] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 21:00:52 minijep kernel: [  517.494528]  sdc: sdc1
Aug 10 21:01:22 minijep kernel: [  548.352623] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 21:01:53 minijep kernel: [  579.355037] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci
Aug 10 21:02:24 minijep kernel: [  610.485609] usb 3-1.2: reset
high-speed USB device number 6 using ehci-pci










> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
--
Salutacions...Josep
--
