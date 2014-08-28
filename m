Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbaH1MgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:36:22 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:49061 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaH1MgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
 <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 28 Aug 2014 14:36:00 +0200
Message-ID: <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mathias

This is the dmesg output after your patch. No WARN(), no crash :), but
still some weird messages:

[  146.511623] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[  146.531652] usb 2-2: New USB device found, idVendor=0525, idProduct=a4a5
[  146.531661] usb 2-2: New USB device strings: Mfr=3, Product=4, SerialNumber=0
[  146.531666] usb 2-2: Product: Mass Storage Gadget
[  146.531670] usb 2-2: Manufacturer: Linux 3.16.0-qtec-standard+ with net2280
[  147.772743] usb-storage 2-2:1.0: USB Mass Storage device detected
[  147.773018] usb-storage 2-2:1.0: Quirks match for vid 0525 pid a4a5: 10000
[  147.773185] scsi host6: usb-storage 2-2:1.0
[  147.773361] usbcore: registered new interface driver usb-storage
[  147.788950] usbcore: registered new interface driver uas
[  148.772699] scsi 6:0:0:0: Direct-Access     Linux    File-Stor
Gadget 0316 PQ: 0 ANSI: 2
[  148.773192] sd 6:0:0:0: Attached scsi generic sg2 type 0
[  148.774860] sd 6:0:0:0: [sdb] 32768 512-byte logical blocks: (16.7
MB/16.0 MiB)
[  148.888294] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  148.905202] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  148.905207] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  148.906324] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  148.912639] sd 6:0:0:0: [sdb] Test WP failed, assume Write Enabled
[  149.014972] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  149.128640] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.145953] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.145963] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.147525] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  149.268626] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.285563] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.285573] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.286904] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  149.404621] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.421397] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.421404] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.422855] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  149.431667]  sdb: unknown partition table
[  149.544713] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.561649] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.561658] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.563021] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  149.680733] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.697766] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.697774] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.699025] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  149.706700] sd 6:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[  149.706712] sd 6:0:0:0: [sdb] Attached SCSI disk
[  149.820933] usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
[  149.837887] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc88
[  149.837895] xhci_hcd 0000:0e:00.0: xHCI xhci_drop_endpoint called
with disabled ep ffff880036f3cc40
[  149.839242] xhci_hcd 0000:0e:00.0: Error: Failed finding new dequeue state
[  155.752101] usb 3-1.5.6: reset high-speed USB device number 10 using ehci-pci
[  155.866642] cdc_acm 3-1.5.6:1.1: This device cannot do calls on its
own. It is not a modem.
[  155.866756] cdc_acm 3-1.5.6:1.1: ttyACM0: USB ACM device
[  155.867613] usb 3-1.5.6: usbfs: process 1521 (pool) did not claim
interface 0 before use
[  160.471327] pool[1680]: segfault at fffffffffc0e61c0 ip
00007f570f036200 sp 00007f570639f0d0 error 5 in
libc-2.19.so[7f570efee000+19f000]

Thanks!

On Thu, Aug 28, 2014 at 12:50 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hello
>
> On Thu, Aug 28, 2014 at 12:41 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
>> On 08/27/2014 07:10 PM, Ricardo Ribalda Delgado wrote:
>>> Perhaps we could apply both patches to current tree and backport mine
>>> to older kernels?
>>>
>>
>> The already applied patch fixes many other issues than just this one.
>> backporting it to stable < 3.13 turned out to not be that difficult, stable maintainers
>> said they can do it themselves.
>
> then I agree, there is absolutely no need for my patch :).
>
> I have a broken gadget driver that was very good at triggering the
> bug, I will try it out with your patch.
>
>
> Thanks!
>
>>
>> Stable kernels prefer patches that are already upstream, as Documentation/stable_kernel_rules.txt states:
>> "- It or an equivalent fix must already exist in Linus' tree (upstream)."
>>
>> There is no need for the other patch anymore, not upstream nor to stable
>>
>> -Mathias
>>
>
>
>
> --
> Ricardo Ribalda



-- 
Ricardo Ribalda
