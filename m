Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbaKRUMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:12:34 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33335 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaKRUMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:12:19 -0500
From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
To: jorge.ramirez-ortiz@linaro.org, balbi@ti.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: add USB3 support to the printer driver
Date: Tue, 18 Nov 2014 15:11:53 -0500
Message-Id: <1416341514-28499-1-git-send-email-jorge.ramirez-ortiz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds USB3 support to the printer driver.
Tests used two binaries (host/device) to handle the file transfer

[gadget] $ dmesg

 net2280 0000:02:00.0: usb_reset_338x: Defect 7374 FsmValue 0xf0000000
 net2280 0000:02:00.0: usb_reinit_338x: Defect 7374 FsmValue f0000000
 net2280 0000:02:00.0: irq 35 for MSI/MSI-X
 net2280 0000:02:00.0: PLX NET228x/USB338x USB Peripheral Controller
 net2280 0000:02:00.0: irq 35, pci mem ffffc90005574000, chip rev 00ab
 net2280 0000:02:00.0: version: 2005 Sept 27/v3.0; dma enabled legacy mode
 printer gadget: Printer Gadget, version: 2007 OCT 06
 printer gadget: printer ready
 net2280 0000:02:00.0: Operate Defect 7374 workaround soft this time
 net2280 0000:02:00.0: It will operate on cold-reboot and SS connect
 net2280 0000:02:00.0: ep0_start_338x: Defect 7374 FsmValue 10000000
 net2280 0000:02:00.0: INFO: Defect 7374 workaround waited about 40uSec for 
Control Read Data Phase ACK
 printer gadget: super-speed config #1: printer
 printer gadget: Using interface 0

[gadget]$ sudo ./usbdevice 
[sudo] password for jramirez: 
Receive file: 
..done  
Transfer rate => 461 Mbits/sec [57MB/sec]
 - file size : 58 MB 
 - time      : 1.15 sec 
Dump file: /tmp/dump.txt 
..done 


[host]$ sudo ./usbhost file.txt
Opening device 0525:A4A8...

Device properties:
        bus number: 4
         port path: 2 (from root hub)
 device speed: 5000 Mbit/s (USB SuperSpeed)

Reading device descriptor:
            length: 18
      device class: 0
               S/N: 3
           VID:PID: 0525:A4A8
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

[host]$ lsusb
Bus 002 Device 006: ID 05ac:1303 Apple, Inc. iPod Shuffle 4.Gen
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 009: ID 0525:a4a8 Netchip Technology, Inc. Linux-USB Printer 
Gadget
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID 0403:6001 Future Technology Devices International, Ltd 
FT232 USB-Serial (UART) IC
Bus 001 Device 003: ID 046d:0990 Logitech, Inc. QuickCam Pro 9000
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
