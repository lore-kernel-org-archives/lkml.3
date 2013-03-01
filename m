Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3CAILL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:11:11 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:56459 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CAILK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com> <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 1 Mar 2013 09:10:50 +0100
Message-ID: <CACQ1gAgz+nko3S4=KC=fAa8-V0gEchB05W6y1edOxYRmB9W0UQ@mail.gmail.com>
Subject: Re: Bug in mtd_get_device_size()?
To: Brian Norris <computersforpeace@gmail.com>
Cc: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/28 Brian Norris <computersforpeace@gmail.com>:
> + Richard
>
> On Thu, Feb 28, 2013 at 4:30 AM, Velykokhatko, Sergey
> <Sergey.Velykokhatko@mcc-med.de> wrote:
>> I got today such case:
>>
>>       * Kernel 3.8
>>
>>       * We are using M29F2G16 NAND chip with 4096 blocks, each has 128k
>>
>>       * Configured with CONFIG_MTD_UBI_BEB_LIMIT=100
>
> This is your problem. See below for more comments.
>
>>       * Our rootfs partition contains 640 EBs
>>
>>       * At system start comes following error message:
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.375000] Creating 6 MTD
>> partitions on "atmel_nand":
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.375000]
>> 0x000000000000-0x000000020000 : "obsolete_bootstrap"
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.381000]
>> 0x000000020000-0x000000320000 : "kernel_a"
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.386000]
>> 0x000000320000-0x000000620000 : "kernel_b"
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.392000]
>> 0x000000620000-0x000005620000 : "rootfs_a"
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.399000]
>> 0x000005620000-0x00000a620000 : "rootfs_b"
>>
>> Feb 28 09:23:09 (none) kern.notice kernel: [    0.406000]
>> 0x00000a620000-0x000020000000 : "config_data"
>>
>> ...
>>
>>
>>
>> Feb 28 09:23:10 (none) kern.info kernel: [    0.546000] NET: Registered
>> protocol family 17
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.557000] UBI: attaching
>> mtd3 to ubi0
>>
>> Feb 28 09:23:10 (none) kern.info kernel: [    0.748000] usb 1-2: new
>> high-speed USB device number 2 using atmel-ehci
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.810000] UBI: scanning is
>> finished
>>
>> Feb 28 09:23:10 (none) kern.warn kernel: [    0.821000] UBI warning:
>> print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling,
>> reserved 115, need 400
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: attached mtd3
>> (name "rootfs_a", size 80 MiB) to ubi0
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: PEB size:
>> 131072 bytes (128 KiB), LEB size: 129024 bytes
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: min./max. I/O
>> unit sizes: 2048/2048, sub-page size 512
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: VID header
>> offset: 512 (aligned 512), data offset: 2048
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: good PEBs:
>> 640, bad PEBs: 0, corrupted PEBs: 0
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: user volume:
>> 1, internal volumes: 1, max. volumes count: 128
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: max/mean
>> erase counter: 399/202, WL threshold: 4096, image sequence number: 548304255
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: available
>> PEBs: 0, total reserved PEBs: 640, PEBs reserved for bad PEB handling: 115
>>
>> Feb 28 09:23:10 (none) kern.notice kernel: [    0.827000] UBI: background
>> thread "ubi_bgt0d" started, PID 288
>>
>> UBI wanted to reserve 400 blocks on MTD with 640. Hm... During debugging I
>> found that mtd_get_device_size() gives the size of whole flash memory back
>> (4096 blocks * 128kB). I guess that I found small error. With micro patch
>> the problem seems to be corrected for my case
>
> Your patch is wrong, actually. mtd_get_device_size() should get "the
> size of the entire flash chip", so if mtd is a partition, you *want*
> to return the size of its 'master'.
>
> In fact, everything is behaving as expected (by the designers; not by
> you). Because your BEB_LIMIT=100, you are reserving 100*size/1024
> (that is 9.8% of your total size, or 400 blocks) in *every* partition.
> I don't see why you need that high of a limit, though. Check your NAND
> data sheet, but the limit defaults reasonably to 20 (or, about 2%).
> That would reserve only 80 blocks on your system, and you would not
> see these warnings/errors, since you already have 115 blocks reserved.
That's rigth !
There's also some documentation on how the overhead is calculated here :
http://www.linux-mtd.infradead.org/doc/ubi.html#L_overhead
and some more explanations a little bellow, in the "Reserved blocks
for bad block handling" section

>
> You might want to read the comments in this commit:
>
> commit ba4087e956d336488c6df9dfca65d1e70cf480f1
> Author: Richard Genoud <richard.genoud@gmail.com>
> Date:   Tue Jul 10 18:23:41 2012 +0200
>
>     UBI: use the whole MTD device size to get bad_peb_limit
>
> It might be worth revisiting the conclusions of those arguments; it
> essentially limits your partitions to a certain minimum size. But as
> far as I can tell, the code works as documented.
>
> Brian



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
