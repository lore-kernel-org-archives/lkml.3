Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaHNInS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:43:18 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43916 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaHNInR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:43:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
 <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com> <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
From: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Date: Thu, 14 Aug 2014 10:42:55 +0200
Message-ID: <CAKszPguBSGVLwM13r0_b0fL0pCD2JvrtpataXB92jiv6k5+=UQ@mail.gmail.com>
Subject: Fwd: Kernel 3.16.0 USB crash
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciao,

thank you very much for replay, you are right: it's UAS module. Now
I'm using Ubuntu 14.04 with kernel 3.16.1 from
http://kernel.ubuntu.com/~kernel-ppa/mainline/, there is no
/proc/config.gz, but but there is a config file in /boot:

b0@hp850ssd:~⟫ grep USB_UAS /boot/config-3.16.1-031601-generic
CONFIG_USB_UAS=m

When I attach my external USB disk I've 30 seconds before my laptop
freeze, here is my dmesg output, disk is not mounted:

[ 1508.375855] usb 3-4: new SuperSpeed USB device number 3 using xhci_hcd
[ 1508.392674] usb 3-4: New USB device found, idVendor=152d, idProduct=0567
[ 1508.392683] usb 3-4: New USB device strings: Mfr=10, Product=11,
SerialNumber=5
[ 1508.392688] usb 3-4: Product: USB to ATA/ATAPI Bridge
[ 1508.392692] usb 3-4: Manufacturer: JMicron
[ 1508.392695] usb 3-4: SerialNumber: 152D00539000
[ 1508.912469] usbcore: registered new interface driver usb-storage
[ 1508.916444] scsi2 : uas
[ 1508.916555] usbcore: registered new interface driver uas
[ 1512.916445] scsi 2:0:0:0: Direct-Access     JMicron  Generic
  0100 PQ: 0 ANSI: 6
[ 1512.919131] sd 2:0:0:0: Attached scsi generic sg1 type 0
[ 1512.919704] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[ 1512.919707] sd 2:0:0:0: [sdb] 4096-byte physical blocks
[ 1512.922763] sd 2:0:0:0: [sdb] Write Protect is off
[ 1512.922766] sd 2:0:0:0: [sdb] Mode Sense: 67 00 10 08
[ 1512.923950] sd 2:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA

If I remove kernel/drivers/usb/storage/uas.ko there is not a crash,
laptop keep working, disk is not mounted:

[ 1628.808425] usb 3-4: new SuperSpeed USB device number 4 using xhci_hcd
[ 1628.825188] usb 3-4: New USB device found, idVendor=152d, idProduct=0567
[ 1628.825197] usb 3-4: New USB device strings: Mfr=10, Product=11,
SerialNumber=5
[ 1628.825201] usb 3-4: Product: USB to ATA/ATAPI Bridge
[ 1628.825205] usb 3-4: Manufacturer: JMicron
[ 1628.825208] usb 3-4: SerialNumber: 152D00539000

 If I use a normal micro USB cable (not USB 3.0 one) I can mount my
disk (with uas module):

[ 2786.654048] usb 2-2: new high-speed USB device number 6 using xhci_hcd
[ 2786.782930] usb 2-2: New USB device found, idVendor=152d, idProduct=0567
[ 2786.782940] usb 2-2: New USB device strings: Mfr=10, Product=11,
SerialNumber=5
[ 2786.782945] usb 2-2: Product: USB to ATA/ATAPI Bridge
[ 2786.782949] usb 2-2: Manufacturer: JMicron
[ 2786.782953] usb 2-2: SerialNumber: 152D00539000
[ 2864.810537] usb 2-2: USB disconnect, device number 6
[ 2868.364551] usb 2-2: new high-speed USB device number 7 using xhci_hcd
[ 2868.493558] usb 2-2: New USB device found, idVendor=152d, idProduct=0567
[ 2868.493564] usb 2-2: New USB device strings: Mfr=10, Product=11,
SerialNumber=5
[ 2868.493566] usb 2-2: Product: USB to ATA/ATAPI Bridge
[ 2868.493568] usb 2-2: Manufacturer: JMicron
[ 2868.493570] usb 2-2: SerialNumber: 152D00539000
[ 2869.018205] scsi4 : uas
[ 2869.018294] usbcore: registered new interface driver uas
[ 2873.017269] scsi 4:0:0:0: Direct-Access     JMicron  Generic
  0100 PQ: 0 ANSI: 6
[ 2873.018577] sd 4:0:0:0: Attached scsi generic sg1 type 0
[ 2873.018665] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks:
(500 GB/465 GiB)
[ 2873.018670] sd 4:0:0:0: [sdb] 4096-byte physical blocks
[ 2873.019474] sd 4:0:0:0: [sdb] Write Protect is off
[ 2873.019477] sd 4:0:0:0: [sdb] Mode Sense: 67 00 10 08
[ 2873.019796] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, supports DPO and FUA
[ 2873.059496]  sdb: sdb1
[ 2873.061310] sd 4:0:0:0: [sdb] Attached SCSI disk

I've another USB 3.0 disk (WD Element) and it's works with or without
UAS module with USB 3.0 cable:

[ 2326.896391] usb 3-2: new SuperSpeed USB device number 5 using xhci_hcd
[ 2326.912963] usb 3-2: New USB device found, idVendor=1058, idProduct=1042
[ 2326.912969] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=5
[ 2326.912972] usb 3-2: Product: Elements 1042
[ 2326.912975] usb 3-2: Manufacturer: Western Digital
[ 2326.912978] usb 3-2: SerialNumber: 575836314333323131343634
[ 2326.913688] usb-storage 3-2:1.0: USB Mass Storage device detected
[ 2326.914463] scsi3 : usb-storage 3-2:1.0
[ 2327.912103] scsi 3:0:0:0: Direct-Access     WD       Elements 1042
  1007 PQ: 0 ANSI: 6
[ 2327.912829] sd 3:0:0:0: Attached scsi generic sg1 type 0
[ 2327.916641] sd 3:0:0:0: [sdb] Spinning up disk...
[ 2328.919251] .......ready
[ 2334.941694] sd 3:0:0:0: [sdb] 1953519616 512-byte logical blocks:
(1.00 TB/931 GiB)
[ 2334.942058] sd 3:0:0:0: [sdb] Write Protect is off
[ 2334.942064] sd 3:0:0:0: [sdb] Mode Sense: 47 00 10 08
[ 2334.942362] sd 3:0:0:0: [sdb] No Caching mode page found
[ 2334.942367] sd 3:0:0:0: [sdb] Assuming drive cache: write through
[ 2334.955994]  sdb: sdb1
[ 2334.957392] sd 3:0:0:0: [sdb] Attached SCSI disk

I am available to send logs or to carry out the tests you want to do.

Regards.
Claudio



2014-08-13 23:36 GMT+02:00 Matt <jackdachef@gmail.com>:

> On Wed, Aug 13, 2014 at 10:24 PM, Matt <jackdachef@gmail.com> wrote:
> > Hi Claudio,
> >
> > this issue is clearly caused by UAS.
> >
> > if
> >
> > zcat /proc/config.gz | grep UAS
> > # CONFIG_USB_UAS is not set
> >
> > is de-selected, everything's fine
> >
> > when this is selected (usb is compiled as a module here)
> >
> > the system crashes or hardlocks as soon as an USB 3.0 capable drive is
> > connected.
> >
> > During bootup the system crashes as soon as the kernel module is loaded.
> >
> > This happened for me with 3.15.6 and 3.16.0 kernel (and 3.16-rc6).
> >
> > I've a different chipset but the symptoms are similar:
> >
> > 00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset
> > Family USB xHCI (rev 05)
> >
> >
> > So the only solution to work with newer kernels right now is to
> > de-select that option and re-compile the kernel. It doesn't help fix
> > the problem but at least it mitigates the issues for now (crash).
> >
> >
> > Regards
> >
> > Matt
