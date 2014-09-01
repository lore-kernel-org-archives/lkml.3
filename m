Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaIAJCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:02:25 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58627 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaIAJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <54009A50.9010707@intel.com>
References: <1409068061-10855-1-git-send-email-ricardo.ribalda@gmail.com>
 <53FDEA48.9030301@intel.com> <CAPybu_1Tzik3yegY2rrXKd7ii1Bzn-ep-gXG5MDZ-rJ2D71-Rw@mail.gmail.com>
 <53FDF8D9.60103@intel.com> <CAPybu_363MD6bFesB44JkkjJYyi+B8KFG9Q1s6aeKNmvvNCz=A@mail.gmail.com>
 <53FF0765.3050509@intel.com> <CAPybu_0gf3XKsBFsxGPptq9m588K81fdh1sbOgMWM+hDVaHiWQ@mail.gmail.com>
 <CAPybu_1UytoxXk-t7u_3vQ6KL-5DmVUz1u5PiDLysBCvgit--A@mail.gmail.com>
 <53FF48B1.5090901@intel.com> <CAPybu_2rgn-DEUKfdmGsaAsFSQJ_zz6fsdnD0dHmyCPW4B-+WA@mail.gmail.com>
 <54009A50.9010707@intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 1 Sep 2014 11:02:03 +0200
Message-ID: <CAPybu_2ZQ9iPA_FfYn2Mqg5vXn40HuFCcVv1Zg900YavKCDxUQ@mail.gmail.com>
Subject: Re: [PATCH] xhci-ring: Fix Null pointer dereference
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The promised dmesg output. Still some "xhci_drop_endpoint called with..."

Thanks!

Sep  1 10:52:00 neopili kernel: [  193.123108] usb 2-2: new SuperSpeed
USB device number 2 using xhci_hcd
Sep  1 10:52:00 neopili kernel: [  193.142204] usb 2-2: New USB device
found, idVendor=0525, idProduct=a4a5
Sep  1 10:52:00 neopili kernel: [  193.142211] usb 2-2: New USB device
strings: Mfr=3, Product=4, SerialNumber=0
Sep  1 10:52:00 neopili kernel: [  193.142215] usb 2-2: Product: Mass
Storage Gadget
Sep  1 10:52:00 neopili kernel: [  193.142218] usb 2-2: Manufacturer:
Linux 3.16.0-qtec-standard+ with net2280
Sep  1 10:52:00 neopili systemd-udevd[221]: unknown key
'SYSFS{manufacturer}' in /etc/udev/rules.d/52-digilent-usb.rules:35
Sep  1 10:52:00 neopili systemd-udevd[221]: invalid rule
'/etc/udev/rules.d/52-digilent-usb.rules:35'
Sep  1 10:52:00 neopili systemd-udevd[221]: unknown key 'BUS' in
/lib/udev/rules.d/60-libgnuradio-fcd3.7.3.rules:2
Sep  1 10:52:00 neopili systemd-udevd[221]: invalid rule
'/lib/udev/rules.d/60-libgnuradio-fcd3.7.3.rules:2'
Sep  1 10:52:00 neopili systemd-udevd[1720]: failed to execute
'/lib/udev/mtp-probe' 'mtp-probe
/sys/devices/pci0000:00/0000:00:1c.6/0000:0e:00.0/usb2/2-2 2 2': No
such file or directory
Sep  1 10:52:00 neopili kernel: [  193.289553] usb-storage 2-2:1.0:
USB Mass Storage device detected
Sep  1 10:52:00 neopili kernel: [  193.289745] usb-storage 2-2:1.0:
Quirks match for vid 0525 pid a4a5: 10000
Sep  1 10:52:00 neopili kernel: [  193.289820] scsi host6: usb-storage 2-2:1.0
Sep  1 10:52:00 neopili kernel: [  193.289991] usbcore: registered new
interface driver usb-storage
Sep  1 10:52:00 neopili kernel: [  193.312632] usbcore: registered new
interface driver uas
Sep  1 10:52:01 neopili kernel: [  194.288067] scsi 6:0:0:0:
Direct-Access     Linux    File-Stor Gadget 0316 PQ: 0 ANSI: 2
Sep  1 10:52:01 neopili kernel: [  194.288957] sd 6:0:0:0: Attached
scsi generic sg2 type 0
Sep  1 10:52:01 neopili kernel: [  194.290003] sd 6:0:0:0: [sdb] 32768
512-byte logical blocks: (16.7 MB/16.0 MiB)
Sep  1 10:52:01 neopili kernel: [  194.403012] usb 2-2: reset
SuperSpeed USB device number 2 using xhci_hcd
Sep  1 10:52:01 neopili kernel: [  194.419901] xhci_hcd 0000:0e:00.0:
xHCI xhci_drop_endpoint called with disabled ep ffff8805e68915c8
Sep  1 10:52:01 neopili kernel: [  194.419907] xhci_hcd 0000:0e:00.0:
xHCI xhci_drop_endpoint called with disabled ep ffff8805e6891580
Sep  1 10:52:31 neopili kernel: [  224.908382] usb 2-2: reset
SuperSpeed USB device number 2 using xhci_hcd
Sep  1 10:52:31 neopili kernel: [  224.925090] xhci_hcd 0000:0e:00.0:
xHCI xhci_drop_endpoint called with disabled ep ffff8805e68915c8
Sep  1 10:52:31 neopili kernel: [  224.925100] xhci_hcd 0000:0e:00.0:
xHCI xhci_drop_endpoint called with disabled ep ffff8805e6891580
Sep  1 10:52:31 neopili kernel: [  224.926327] sd 6:0:0:0: [sdb] Write
Protect is off
Sep  1 10:52:31 neopili kernel: [  224.926336] sd 6:0:0:0: [sdb] Mode
Sense: 00 00 00 00

On Fri, Aug 29, 2014 at 5:20 PM, Mathias Nyman <mathias.nyman@intel.com> wrote:
> On 08/28/2014 06:09 PM, Ricardo Ribalda Delgado wrote:
>> Sure, but the hw leaves my desk until next monday in 30 minutes.
>>
>> So unless you send the patch right now you will have to wait for
>> results until next Monday
>>
>> Thanks!
>>
>
> Great, anytime you can test it is appreciated.
> Added the patch to the bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=75521
>
> Patch looks like this:
>
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index c020b09..7aee5a3 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -3544,6 +3544,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
>         for (i = 1; i < 31; ++i) {
>                 struct xhci_virt_ep *ep = &virt_dev->eps[i];
>
> +               /* reset device sets ep states to disabled, also halted ones */
> +               ep->ep_state &= ~(EP_HALTED || SET_DEQ_PENDING);
> +               ep->stopped_td = NULL;
> +
>                 if (ep->ep_state & EP_HAS_STREAMS) {
>                         xhci_warn(xhci, "WARN: endpoint 0x%02x has streams on device reset, freeing streams.\n",
>                                         xhci_get_endpoint_address(i));
>
>
> -Mathias
>



-- 
Ricardo Ribalda
