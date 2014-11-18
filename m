Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaKROTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:19:44 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:41972 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbaKROTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:19:40 -0500
Message-ID: <546B5578.8040809@linaro.org>
Date: Tue, 18 Nov 2014 09:19:36 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]  usb: gadget: USB3 support to the legacy printer driver
References: <546A829A.8030106@linaro.org> <20141118003028.GA11280@saruman>
In-Reply-To: <20141118003028.GA11280@saruman>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe/Greg

Thanks for your comments on my previous attempt.
I think I addressed them here.
I added some logs of a run captured on a recent kernel, fixed the indentations,
replaced the if/else with a switch statement and removed the copyright.

Note that the tests seem to indicate a performance issue on the net2280 driver: the
exact same tests using the usb338x.c driver from PLX allows for transfer speeds of 1Gbps.

cheers
Jorge

File transfer test using g_printer on 10b5:3380
================================================

The host will transfer a file to the device using the g_printer driver.

0) enable the net2280 on the g_printer:
--------------------------------------

        From 8e306693839a77bfe3411a842d4d20acb9dae9e3 Mon Sep 17 00:00:00 2001
        From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
        Date: Mon, 17 Nov 2014 22:31:59 -0500
        Subject: [PATCH] use the 338x
      
        ---
         drivers/usb/gadget/legacy/printer.c | 4 ++--
         1 file changed, 2 insertions(+), 2 deletions(-)
      
       diff --git a/drivers/usb/gadget/legacy/printer.c
b/drivers/usb/gadget/legacy/printer.c
       index 456730b..ba919a0 100644
       --- a/drivers/usb/gadget/legacy/printer.c
       +++ b/drivers/usb/gadget/legacy/printer.c
       @@ -99,8 +99,8 @@ static struct printer_dev usb_printer_gadget;
      
        /* Thanks to NetChip Technologies for donating this product ID.
         */
       -#define PRINTER_VENDOR_NUM     0x0525          /* NetChip */
       -#define PRINTER_PRODUCT_NUM    0xa4a8          /* Linux-USB Printer Gadget */
       +#define PRINTER_VENDOR_NUM     0x10B5        
       +#define PRINTER_PRODUCT_NUM    0x3380        
      
        /* Some systems will want different product identifiers published in the
         * device descriptor, either numbers or strings or both.  These string
       --
       1.9.1


1) Host logs:
-------------

[jramirez@miro ~]$ lsusb
Bus 002 Device 006: ID 05ac:1303 Apple, Inc. iPod Shuffle 4.Gen
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 007: ID 10b5:3380 Comodo (PLX?)
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 0403:6001 Future Technology Devices International, Ltd FT232
USB-Serial (UART) IC
Bus 001 Device 003: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

[jramirez@miro ~]$ lsusb -s 004:007 -v

Bus 004 Device 007: ID 10b5:3380 Comodo (PLX?)
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0         9
  idVendor           0x10b5 Comodo (PLX?)
  idProduct          0x3380
  bcdDevice            3.18
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           44
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         7 Printer
      bInterfaceSubClass      1 Printer
      bInterfaceProtocol      2 Bidirectional
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0

 
[jramirez@miro host.git (master%)]$ sudo ./usbhost file.wav
[sudo] password for jramirez:
Opening device 10B5:3380...

Device properties:
        bus number: 4
         port path: 2 (from root hub)
 device speed: 5000 Mbit/s (USB SuperSpeed)

Reading device descriptor:
            length: 18
      device class: 0
               S/N: 3
           VID:PID: 10B5:3380
         bcdDevice: 0318
   iMan:iProd:iSer: 1:2:3
          nb confs: 1

Reading BOS descriptor: 2 caps
    USB 2.0 extension:
      attributes             : 06
    USB 3.0 capabilities:
      attributes             : 00
      supported speeds       : 000F
      supported functionality: 01

Reading first configuration descriptor:
             nb interfaces: 1
              interface[0]: id = 0
interface[0].altsetting[0]: num endpoints = 2
   Class.SubClass.Protocol: 07.01.02
       endpoint[0].address: 81
           max packet size: 0400
          polling interval: 00
                 max burst: 00   (USB 3.0)
        bytes per interval: 0000 (USB 3.0)
       endpoint[1].address: 01
           max packet size: 0400
          polling interval: 00
                 max burst: 00   (USB 3.0)
        bytes per interval: 0000 (USB 3.0)

Claiming interface 0...

Reading string descriptors:
   String (0x01): "Linux 3.18.0-rc5+ with net2280"
   String (0x02): "Printer Gadget"
Transfering: endpoint_out 1, size 61387314
 - number of bulk transfers : 7494
 - max user transfer size   : 8192 bytes
 - max usb transfer size    : 1024 bytes

2) Device Logs:
--------------

[jramirez@dali ~]$ cat /proc/version
Linux version 3.18.0-rc5+ (jramirez@localhost.localdomain) (gcc version 4.8.3
20140911 (Red Hat 4.8.3-7) (GCC) ) #1 SMP Mon Nov 17 21:59:22 EST 2014


[   72.345683] net2280 0000:02:00.0: usb_reset_338x: Defect 7374 FsmValue 0xf0000000
[   72.345706] net2280 0000:02:00.0: usb_reinit_338x: Defect 7374 FsmValue f0000000
[   72.345748] net2280 0000:02:00.0: irq 35 for MSI/MSI-X
[   72.345798] net2280 0000:02:00.0: PLX NET228x/USB338x USB Peripheral Controller
[   72.345801] net2280 0000:02:00.0: irq 35, pci mem ffffc90004960000, chip rev 00ab
[   72.345803] net2280 0000:02:00.0: version: 2005 Sept 27/v3.0; dma enabled legacy mode
[   86.630589] printer gadget: Printer Gadget, version: 2007 OCT 06
[   86.630593] printer gadget: printer ready
[   86.630599] net2280 0000:02:00.0: Operate Defect 7374 workaround soft this time
[   86.630600] net2280 0000:02:00.0: It will operate on cold-reboot and SS connect
[   86.630709] net2280 0000:02:00.0: ep0_start_338x: Defect 7374 FsmValue 10000000
[   86.870669] net2280 0000:02:00.0: INFO: Defect 7374 workaround waited about
[   86.875065] printer gadget: super-speed config #1: printer
[   86.875077] printer gadget: Using interface 0


[jramirez@dali device.git (master%)]$ sudo ./usbdevice
Receiving file

Transfer rate => 462 Mbits/sec [57MB/sec]
 - file size : 58 MB
 - time      : 1.12 sec


As mentioned above, using the usb338x driver from PLX instead of the net2280 from
kernel.org, the effective file transfer rate increases 1Gbps.


3) Patch:
---------



>From 9b5ee9330c5c02cf51328c350036c1dac998b732 Mon Sep 17 00:00:00 2001
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Date: Thu, 25 Sep 2014 16:17:20 -0400
Subject: [PATCH 2/3] usb: gadget: add USB3 support to the printer driver

Add SS descriptors to support the capabilities provided by USB3 controller
drivers; unit tests run using a PLX 3380 [max transfer speed measured of 1Gbps]

This driver shall fallback to lower operating modes when the higher ones are
not available.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
---
 drivers/usb/gadget/legacy/printer.c | 65 +++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/legacy/printer.c b/drivers/usb/gadget/legacy/printer.c
index 6474081..456730b 100644
--- a/drivers/usb/gadget/legacy/printer.c
+++ b/drivers/usb/gadget/legacy/printer.c
@@ -208,6 +208,43 @@ static struct usb_descriptor_header *hs_printer_function[] = {
     NULL
 };
 
+/*
+ * Added endpoint descriptors for 3.0 devices
+ */
+
+static struct usb_endpoint_descriptor ss_ep_in_desc = {
+    .bLength =              USB_DT_ENDPOINT_SIZE,
+    .bDescriptorType =      USB_DT_ENDPOINT,
+    .bmAttributes =         USB_ENDPOINT_XFER_BULK,
+    .wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_in_comp_desc = {
+    .bLength =              sizeof(ss_ep_in_comp_desc),
+    .bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_endpoint_descriptor ss_ep_out_desc = {
+    .bLength =              USB_DT_ENDPOINT_SIZE,
+    .bDescriptorType =      USB_DT_ENDPOINT,
+    .bmAttributes =         USB_ENDPOINT_XFER_BULK,
+    .wMaxPacketSize =       cpu_to_le16(1024),
+};
+
+struct usb_ss_ep_comp_descriptor ss_ep_out_comp_desc = {
+    .bLength =              sizeof(ss_ep_out_comp_desc),
+    .bDescriptorType =      USB_DT_SS_ENDPOINT_COMP,
+};
+
+static struct usb_descriptor_header *ss_printer_function[] = {
+    (struct usb_descriptor_header *) &intf_desc,
+    (struct usb_descriptor_header *) &ss_ep_in_desc,
+    (struct usb_descriptor_header *) &ss_ep_in_comp_desc,
+    (struct usb_descriptor_header *) &ss_ep_out_desc,
+    (struct usb_descriptor_header *) &ss_ep_out_comp_desc,
+    NULL
+};
+
 static struct usb_otg_descriptor otg_descriptor = {
     .bLength =              sizeof otg_descriptor,
     .bDescriptorType =      USB_DT_OTG,
@@ -220,7 +257,20 @@ static const struct usb_descriptor_header *otg_desc[] = {
 };
 
 /* maxpacket and other transfer characteristics vary by speed. */
-#define ep_desc(g, hs, fs) (((g)->speed == USB_SPEED_HIGH)?(hs):(fs))
+static inline struct usb_endpoint_descriptor *ep_desc(struct usb_gadget *gadget,
+                    struct usb_endpoint_descriptor *fs,
+                    struct usb_endpoint_descriptor *hs,
+                    struct usb_endpoint_descriptor *ss)
+{
+    switch(gadget->speed) {
+    case USB_SPEED_SUPER:
+        return ss;
+    case USB_SPEED_HIGH:
+        return hs;
+    default:
+        return fs;
+    }
+}
 
 /*-------------------------------------------------------------------------*/
 
@@ -793,11 +843,12 @@ set_printer_interface(struct printer_dev *dev)
 {
     int            result = 0;
 
-    dev->in_ep->desc = ep_desc(dev->gadget, &hs_ep_in_desc, &fs_ep_in_desc);
+    dev->in_ep->desc = ep_desc(dev->gadget, &fs_ep_in_desc, &hs_ep_in_desc,
+                &ss_ep_in_desc);
     dev->in_ep->driver_data = dev;
 
-    dev->out_ep->desc = ep_desc(dev->gadget, &hs_ep_out_desc,
-                    &fs_ep_out_desc);
+    dev->out_ep->desc = ep_desc(dev->gadget, &fs_ep_out_desc,
+                    &hs_ep_out_desc, &ss_ep_out_desc);
     dev->out_ep->driver_data = dev;
 
     result = usb_ep_enable(dev->in_ep);
@@ -1016,9 +1067,11 @@ autoconf_fail:
     /* assumes that all endpoints are dual-speed */
     hs_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
     hs_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
+    ss_ep_in_desc.bEndpointAddress = fs_ep_in_desc.bEndpointAddress;
+    ss_ep_out_desc.bEndpointAddress = fs_ep_out_desc.bEndpointAddress;
 
     ret = usb_assign_descriptors(f, fs_printer_function,
-            hs_printer_function, NULL);
+            hs_printer_function, ss_printer_function);
     if (ret)
         return ret;
 
@@ -1253,7 +1306,7 @@ static __refdata struct usb_composite_driver printer_driver = {
     .name           = shortname,
     .dev            = &device_desc,
     .strings        = dev_strings,
-    .max_speed      = USB_SPEED_HIGH,
+    .max_speed      = USB_SPEED_SUPER,
     .bind        = printer_bind,
     .unbind        = printer_unbind,
 };
-- 
1.9.1

