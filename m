Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3DXUJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 16:09:21 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:36818 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab3DXUJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 16:09:19 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXAwh=jg4f8AGV+-Moxc-kWJrjRhZ8+9pF4s41wDbba4A@mail.gmail.com>
References: <CA+icZUXAwh=jg4f8AGV+-Moxc-kWJrjRhZ8+9pF4s41wDbba4A@mail.gmail.com>
Date: Wed, 24 Apr 2013 22:09:18 +0200
Message-ID: <CA+icZUWUof6BJQWefi-dYfFhO_hRLF5aKsOVO0CAbFCo_UVn2w@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 10:00 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Apr 24, 2013 at 10:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> There will be no linux-next release tomorrow (April 25).
>>
>> Changes since 20130423:
>>
>> The net-next tree lost its build failure.
>>
>> The staging tree gained a build failure for which I disabled a driver.
>>
>> The arm-soc tree gained a conflict against the pm tree.
>>
>> ----------------------------------------------------------------------------
>>
>
> [ CC linux-pm and linux-usb (ehci) folks ]
>
> This happens with my external USB mouse after suspend/resume.
>
> Excerpt (full dmesg and kernel-config attached):
>
> $ dmesg | egrep -i 'usb|async' | grep 1-1.2
> [    1.258602] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
> [    1.368649] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> [    1.368661] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [    1.368668] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> [    1.368672] usb 1-1.2: Manufacturer: Logitech
> [    1.957999] input: Logitech USB-PS/2 Optical Mouse as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
> [   62.353997] usb 1-1.2: reset low-speed USB device number 3 using ehci-pci
> [   62.636893] PM: Device 1-1.2 failed to resume async: error -32
> [   64.243543] usb 1-1.2: USB disconnect, device number 3
> [   64.380328] usb 1-1.2: new low-speed USB device number 5 using ehci-pci
> [   64.477612] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> [   64.477618] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [   64.477621] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> [   64.477623] usb 1-1.2: Manufacturer: Logitech
> [   64.481934] input: Logitech USB-PS/2 Optical Mouse as
> /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input11
>

Thos 3 lines IIRC are important (one line missing above):

[   62.353997] usb 1-1.2: reset low-speed USB device number 3 using ehci-pci
[   62.636877] dpm_run_callback(): usb_dev_resume+0x0/0x20 returns -32
[   62.636893] PM: Device 1-1.2 failed to resume async: error -32

- Sedat -

> Any help/hints/infos welcome :-)!
>
> Regards,
> - Sedat .-
