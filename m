Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052AbaCFFRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 00:17:32 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:49884 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaCFFRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 00:17:31 -0500
Message-ID: <531804E7.2040406@gmail.com>
Date: Wed, 05 Mar 2014 23:17:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: xHCI regression in stable 3.13.5 with USB3 card reader
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a USB 3.0 multi-card reader device:

Bus 004 Device 002: ID 05e3:0743 Genesys Logic, Inc.

which seems to work fine in 3.13.4 (Fedora version kernel-3.13.4-200 
specifically) but fails in 3.13.5 (specifically kernel-3.13.5-202). 
Below is what I get in dmesg. Essentially there's a bunch of 
input/output errors making the reader mostly unusable.

This is on an Intel Haswell machine with this controller:

00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series 
Chipset Family USB xHCI [8086:8c31] (rev 05)

It looks like there were some XHCI commits that went into 3.13.5 so it 
seems likely one of those is the cause. I can try current git if there's 
anything in there that's likely to fix it. But it does seem like a 
regression got into the stable kernel in this respect.

[   25.177926] usb 4-2: Disable of device-initiated U1 failed.
[   26.906531] usb 4-2: reset SuperSpeed USB device number 2 using xhci_hcd
[   26.918439] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a00
[   26.918441] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a40
[   26.921116] sd 6:0:0:0: [sdc] Unhandled error code
[   26.921118] sd 6:0:0:0: [sdc]
[   26.921120] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[   26.921120] sd 6:0:0:0: [sdc] CDB:
[   26.921121] Read(10): 28 00 00 00 08 23 00 00 f0 00
[   26.921126] end_request: I/O error, dev sdc, sector 2083
[   27.208871] sd 6:0:0:0: [sdc] Media Changed
[   27.208874] sd 6:0:0:0: [sdc]
[   27.208875] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   27.208876] sd 6:0:0:0: [sdc]
[   27.208877] Sense Key : Unit Attention [current]
[   27.208878] sd 6:0:0:0: [sdc]
[   27.208880] Add. Sense: Not ready to ready change, medium may have 
changed
[   27.208880] sd 6:0:0:0: [sdc] CDB:
[   27.208881] Read(10): 28 00 00 00 08 24 00 00 ef 00
[   27.208886] end_request: I/O error, dev sdc, sector 2084
[   27.210467] FAT-fs (sdc1): FAT read failed (blocknr 35)
[   49.420334] usb 4-2: Disable of device-initiated U1 failed.
[   51.139080] usb 4-2: reset SuperSpeed USB device number 2 using xhci_hcd
[   51.150979] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a00
[   51.150981] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a40
[   51.153663] sd 6:0:0:0: [sdc] Unhandled error code
[   51.153665] sd 6:0:0:0: [sdc]
[   51.153666] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[   51.153667] sd 6:0:0:0: [sdc] CDB:
[   51.153668] Read(10): 28 00 00 00 08 25 00 00 ee 00
[   51.153672] end_request: I/O error, dev sdc, sector 2085
[   51.441377] sd 6:0:0:0: [sdc] Media Changed
[   51.441379] sd 6:0:0:0: [sdc]
[   51.441380] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[   51.441381] sd 6:0:0:0: [sdc]
[   51.441382] Sense Key : Unit Attention [current]
[   51.441384] sd 6:0:0:0: [sdc]
[   51.441385] Add. Sense: Not ready to ready change, medium may have 
changed
[   51.441386] sd 6:0:0:0: [sdc] CDB:
[   51.441386] Read(10): 28 00 00 00 08 26 00 00 ed 00
[   51.441391] end_request: I/O error, dev sdc, sector 2086
[   51.441454] FAT-fs (sdc1): FAT read failed (blocknr 37)
[   51.442083] FAT-fs (sdc1): FAT read failed (blocknr 37)
[   51.442570] FAT-fs (sdc1): FAT read failed (blocknr 235)
[  164.219227] usb 4-2: Disable of device-initiated U1 failed.
[  165.938731] usb 4-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  165.950669] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a00
[  165.950672] xhci_hcd 0000:00:14.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff88003f912a40
[  165.953366] sd 6:0:0:0: [sdc] Unhandled error code
[  165.953368] sd 6:0:0:0: [sdc]
[  165.953369] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
[  165.953370] sd 6:0:0:0: [sdc] CDB:
[  165.953371] Read(10): 28 00 00 00 08 27 00 00 ec 00
[  165.953375] end_request: I/O error, dev sdc, sector 2087
[  166.240995] sd 6:0:0:0: [sdc] Media Changed
[  166.240997] sd 6:0:0:0: [sdc]
[  166.240999] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  166.241000] sd 6:0:0:0: [sdc]
[  166.241000] Sense Key : Unit Attention [current]
[  166.241002] sd 6:0:0:0: [sdc]
[  166.241003] Add. Sense: Not ready to ready change, medium may have 
changed
[  166.241004] sd 6:0:0:0: [sdc] CDB:
[  166.241005] Read(10): 28 00 00 00 08 28 00 00 eb 00
[  166.241010] end_request: I/O error, dev sdc, sector 2088
[  166.241055] FAT-fs (sdc1): FAT read failed (blocknr 39)
