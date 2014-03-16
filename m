Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaCPUVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 16:21:14 -0400
Received: from colibri.dagami.org ([82.226.230.20]:34511 "EHLO dagami.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932118AbaCPUVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 16:21:12 -0400
X-Greylist: delayed 652 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2014 16:21:11 EDT
User-Agent: SOGoMail 2.1.1b
X-Forward: 192.168.0.1
MIME-Version: 1.0
from: "nb" <nb@dagami.org>
subject: Initio Corporation INIC-1618L SATA chip too slow (seem to use usb1 not usb2)
message-id: <3ff9-53260500-13-661db300@237317515>
to: linux-kernel@vger.kernel.org
content-type: text/plain; charset="utf-8"
date: Sun, 16 Mar 2014 21:10:17 +0100
content-transfer-encoding: 7bit
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My external disk uses a Initio Corporation INIC-1618L SATA chip.
vendor/product are : 0x13fd/0x0840 and bcdDevice is 1.14 making the disk work very slowly 12Mb in spite of 10 times faster. bcdUSB seem to be ok : 2.00
Tried this on 3.13 and 3.14-rc6

Is there a module to load specifically. In my case usb-storage is loaded.

Not really sure it's the right place to post this.
Please cc me, I have not subscribed to the list.

lsusb shows:

Bus 002 Device 011: ID 13fd:0840 Initio Corporation INIC-1618L SATA
Device Descriptor:
bLength 18
bDescriptorType 1
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
idVendor 0x13fd Initio Corporation
idProduct 0x0840 INIC-1618L SATA
bcdDevice 1.14
iManufacturer 1
iProduct 2
iSerial 3
bNumConfigurations 1
Configuration Descriptor:
bLength 9
bDescriptorType 2
wTotalLength 32
bNumInterfaces 1
bConfigurationValue 1
iConfiguration 0
bmAttributes 0xc0
Self Powered
MaxPower 2mA
Interface Descriptor:
bLength 9
bDescriptorType 4
bInterfaceNumber 0
bAlternateSetting 0
bNumEndpoints 2
bInterfaceClass 8 Mass Storage
bInterfaceSubClass 6 SCSI
bInterfaceProtocol 80 Bulk-Only
iInterface 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x81 EP 1 IN
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0040 1x 64 bytes
bInterval 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x02 EP 2 OUT
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0040 1x 64 bytes
bInterval 0

dmesg shows:

[ 9295.428122] usb 2-1: new full-speed USB device number 6 using uhci_hcd
[ 9295.572067] usb 2-1: not running at top speed; connect to a high speed hub
[ 9295.600069] usb 2-1: New USB device found, idVendor=13fd, idProduct=0840
[ 9295.600081] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 9295.600086] usb 2-1: Product: External
[ 9295.600090] usb 2-1: Manufacturer: Generic
[ 9295.600094] usb 2-1: SerialNumber: 533134504A44305132353239
[ 9295.603150] usb-storage 2-1:1.0: USB Mass Storage device detected
[ 9295.608156] scsi6 : usb-storage 2-1:1.0
[ 9296.613036] scsi 6:0:0:0: Direct-Access Generic External 1.14 PQ: 0 ANSI: 4
[ 9296.614845] sd 6:0:0:0: Attached scsi generic sg2 type 0
[ 9296.619005] sd 6:0:0:0: [sdb] 234441647 512-byte logical blocks: (120 GB/111 GiB)
[ 9296.622005] sd 6:0:0:0: [sdb] Write Protect is off
[ 9296.622013] sd 6:0:0:0: [sdb] Mode Sense: 23 00 00 00
[ 9296.624986] sd 6:0:0:0: [sdb] No Caching mode page found
[ 9296.624994] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 9296.636002] sd 6:0:0:0: [sdb] No Caching mode page found
[ 9296.636074] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 9296.732999] sdb: sdb1 sdb2
[ 9296.747997] sd 6:0:0:0: [sdb] No Caching mode page found
[ 9296.748052] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[ 9296.748061] sd 6:0:0:0: [sdb] Attached SCSI disk
[ 9300.207477] EXT4-fs (sdb1): recovery complete
[ 9300.207495] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)

