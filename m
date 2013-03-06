Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3CFBfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:35:53 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:14536 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3CFBfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:35:51 -0500
From: "Linlei (Lei Lin)" <lei.lin@huawei.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Yili (Neil)" <neil.yi@huawei.com>, Wangyuhua <yuhua.wang@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        stable <stable@vger.kernel.org>,
        "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIFVTQjogc3RvcmFnZTogZml4IEh1YXdlaSBtb2Rl?=
 =?utf-8?Q?_switching_regression?=
Thread-Topic: [PATCH] USB: storage: fix Huawei mode switching regression
Thread-Index: AQHOGYkwYqDzWwwHJ0GSIo8W5u3mqZiX3U8A
Date: Wed, 6 Mar 2013 01:34:44 +0000
Message-ID: <43F99538ECE41341993F359D4AA4FB5F4B3783F2@szxeml560-mbs.china.huawei.com>
References: <87obezs888.fsf@nemi.mork.no>
	<1362403161-23501-1-git-send-email-bjorn@mork.no>
	<910F9D9E13B84F4C8FA771DC9BDE99F32709833E@szxeml546-mbx.china.huawei.com>
 <8738waqhx2.fsf@nemi.mork.no>
In-Reply-To: <8738waqhx2.fsf@nemi.mork.no>
Accept-Language: en-US, ja-JP, zh-CN
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.36.157]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r261ZvkZ010698

Hello Mork,

>> ------ Because in the embedded linux system, Android, or Chrome OS, 
>> etc. They don't integrate userspace usb_modeswitch utility for 
>> switching.

>Why not?  If they can upgrade the kernel, then they most certainly can install a userspace utility.

>There is no excuse for an embedded system to do this differently.
>Please see e.g. OpenWRT as an example of an embedded system doing this correctly.

But currently Android and Chrome OS has not integrated the usb_modeswitch utility.
>From a vendor's point of view, our purpose is to make our devices be supported natively by those OS.

So we consider that add the switch function to the kernel resolves the problem from the source.
Then this function will be inherited by Android & Chrome OS.

Regards,
Lin Lei


-----é‚®ä»¶åŸä»¶-----
å‘ä»¶äºº: BjÃ¸rn Mork [mailto:bjorn@mork.no] 
å‘é€æ—¶é—´: 2013å¹´3æœˆ5æ—¥ 18:07
æ”¶ä»¶äºº: Fangxiaozhi (Franko)
æŠ„é€: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying (Zihan); Linlei (Lei Lin); Greg KH; Yili (Neil); Wangyuhua (Roger, Credit); Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net; sebastian@breakpoint.cc; stable
ä¸»é¢˜: Re: [PATCH] USB: storage: fix Huawei mode switching regression

"Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> writes:

> ------ commit 200e0d99 and commit cd060956, only put the switch 
> command into kernel, instead of userspace usb_modeswitch utility.

Yes. And that is the problem.  It was agreed years ago that this functionality belongs in userspace.  Ref e.g
https://lkml.org/lkml/2009/12/15/332
https://lkml.org/lkml/2010/4/19/216
https://lkml.org/lkml/2012/2/28/569

Please note the re-occurrence of this discussion, despite the fact that Matthew's message from 2009 should be quite clear.

> ------ Because in the embedded linux system, Android, or Chrome OS, 
> etc. They don't integrate userspace usb_modeswitch utility for 
> switching.

Why not?  If they can upgrade the kernel, then they most certainly can install a userspace utility.

There is no excuse for an embedded system to do this differently.
Please see e.g. OpenWRT as an example of an embedded system doing this correctly.

> ----- In commit 200e0d99, we send the Linux switching command to 
> Huawei devices, so on PC Linux, you can get the largest capacity of 
> Huawei device, including the CDROM feature. So I think this solution 
> can meet the user's requirement in Linux.

No, it does not.  Some users have already configured their system to disable switching or to switch using a different message.  The patch does not address this at all.


>> Known regressions caused by this:
>>  - Some of the devices support multiple modes, using different
>>   switching commands.  There are existing configurations taking
>>   advantage of this.
>
> -------But in this multiple modes, there is only one is for Linux. We 
> don't advice the user to use the other mode not for Linux. It may 
> cause some unexpected problem.


Although I do not agree with this, I do not argue that the Linux defaults should change.  The point is that this was configurable prior to the patch and it is not after.  This is a regression for any user who has deliberately chosen to use the Windows mode.

Wrt the Linux vs Windows modes:  We all appreciate the work from Huawei trying to support Linux in the best possible way.  But implementing special firmware modes for Linux is not necessarily best for Linux. We do have some experience with system BIOSes implementing special hooks for Linux, and they usually add more problems than they solve.  It is very easy for Linux to resemble whatever Windows does when talking to hardware, and that is the method that has proven to work best.

Ref for example this comment in drivers/acpi/acpica/utosi.c :

/*
 * Strings supported by the _OSI predefined control method (which is
 * implemented internally within this module.)
 *
 * March 2009: Removed "Linux" as this host no longer wants to respond true
 * for this string. Basically, the only safe OS strings are windows-related
 * and in many or most cases represent the only test path within the
 * BIOS-provided ASL code.
 *
 * The last element of each entry is used to track the newest version of
 * Windows that the BIOS has requested.
 */


>> 
>>  - There is a real use case for disabling mode switching and
>>   instead mounting the exposed storage device. This becomes
>>   impossible with switching logic inside the usb-storage driver.
>
> ----In commit 200e0d99, the switching command will ask Huawei device 
> to offer the CDROM(and /or SD) port together. After switching, users 
> also can get the mounting storage device.

Yes, I understand that the firmware does this by default.  But you also have (unsupported and undocumented) ways of disabling this.  Some users do that.  Some users may also want to mount the device before switching for other reasons.

The fact that your firmware lets the user mount the CD after switch does not completely prevent some users from wanting to mount it before switching.


>> 
>>  - At least on device fail as a result of the usb-storage switching
>>   command, becoming completely unswitchable. This is possibly a
>>   firmware bug, but still a regression because the device work as
>>   expected using usb_modeswitch defaults.
>
> ----- If the kernel solution encounters this issue, then it also will 
> occur with usb_modeswitch.

Well, it does not.  Blacklisting usb-storage works around the issue.

The command sent by usb-storage makes the firmware reset once, but it appears with the exact same identity as before. This makes usb-storage repeat the switch command, which now has no effect.  Then usb_modeswitch tries, but is refused.

switches from:

Mar  5 10:23:20 nemi kernel: [46342.029477] USB Mass Storage support registered.
Mar  5 10:23:57 nemi kernel: [46378.704337] usb 7-1: new high-speed USB device number 34 using ehci-pci Mar  5 10:23:57 nemi kernel: [46378.842526] usb 7-1: New USB device found, idVendor=12d1, idProduct=1446 Mar  5 10:23:57 nemi kernel: [46378.842542] usb 7-1: New USB device strings: Mfr=4, Product=3, SerialNumber=5 Mar  5 10:23:57 nemi kernel: [46378.842552] usb 7-1: Product: HUAWEI MBIM Device Mar  5 10:23:57 nemi kernel: [46378.842560] usb 7-1: Manufacturer: Huawei Technologies Mar  5 10:23:57 nemi kernel: [46378.842569] usb 7-1: SerialNumber: Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿

to:

Mar  5 10:24:01 nemi kernel: [46382.924327] usb 7-1: new high-speed USB device number 35 using ehci-pci Mar  5 10:24:01 nemi kernel: [46383.063590] usb 7-1: New USB device found, idVendor=12d1, idProduct=1446 Mar  5 10:24:01 nemi kernel: [46383.063606] usb 7-1: New USB device strings: Mfr=4, Product=3, SerialNumber=5 Mar  5 10:24:01 nemi kernel: [46383.063615] usb 7-1: Product: HUAWEI MBIM Device Mar  5 10:24:01 nemi kernel: [46383.063624] usb 7-1: Manufacturer: Huawei Technologies Mar  5 10:24:01 nemi kernel: [46383.063633] usb 7-1: SerialNumber: Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿


The 3 commands sent (not the difference in the last one from usb_modeswitch):

ffff8802306ef900 2477597193 S Bo:7:034:1 -115 31 = 55534243 00000000 00000000 00001011 06200000 01010001 00000000 000000
ffff8802306ef900 2477597881 C Bo:7:034:1 0 31 >

ffff8802306ef900 2481816603 S Bo:7:035:1 -115 31 = 55534243 00000000 00000000 00001011 06200000 01010001 00000000 000000
ffff8802306ef900 2481816802 C Bo:7:035:1 0 31 >

ffff8802306ef900 2482455758 S Bo:7:035:1 -115 31 = 55534243 12345678 00000000 00000011 06200000 01000000 00000000 000000
ffff8802306ef900 2485457009 C Bo:7:035:1 -2 0



Changing the command embedded in drivers/usb/storage/initializers.c to resemble the default from usb_modeswitch makes the in-kernel switching work for this device.  But we do not know the effect on other devices.
And this kind of workarounds is not something you can easily make any user do in the kernel, while it is a simple configuration file or command line option in usb_modeswitch.

this diff on top of v3.8.2:

bjorn@nemi:/usr/local/src/git/linux$ git diff diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 7ab9046..6869415 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -116,8 +116,8 @@ static int usb_stor_huawei_scsi_init(struct us_data *us)
        int result = 0;
        int act_len = 0;
        struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
-       char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
-                       0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+       char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00,
+                       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
 
        bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
        bcbw->Tag = 0;


results in:

ffff880221402440 3307649125 S Bo:7:040:1 -115 31 = 55534243 00000000 00000000 00001011 06200000 01000000 00000000 000000
ffff880221402440 3307649322 C Bo:7:040:1 0 31 >

which switches from:

Mar  5 10:37:47 nemi kernel: [47208.756338] usb 7-1: new high-speed USB device number 40 using ehci-pci Mar  5 10:37:47 nemi kernel: [47208.893231] usb 7-1: New USB device found, idVendor=12d1, idProduct=1446 Mar  5 10:37:47 nemi kernel: [47208.893245] usb 7-1: New USB device strings: Mfr=4, Product=3, SerialNumber=5 Mar  5 10:37:47 nemi kernel: [47208.893254] usb 7-1: Product: HUAWEI MBIM Device Mar  5 10:37:47 nemi kernel: [47208.893263] usb 7-1: Manufacturer: Huawei Technologies Mar  5 10:37:47 nemi kernel: [47208.893272] usb 7-1: SerialNumber: Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿

to:

Mar  5 10:37:51 nemi kernel: [47212.880322] usb 7-1: new high-speed USB device number 41 using ehci-pci Mar  5 10:37:51 nemi kernel: [47213.016734] usb 7-1: New USB device found, idVendor=12d1, idProduct=1506 Mar  5 10:37:51 nemi kernel: [47213.016748] usb 7-1: New USB device strings: Mfr=4, Product=3, SerialNumber=5 Mar  5 10:37:51 nemi kernel: [47213.016757] usb 7-1: Product: HUAWEI MBIM Device Mar  5 10:37:51 nemi kernel: [47213.016766] usb 7-1: Manufacturer: Huawei Technologies Mar  5 10:37:51 nemi kernel: [47213.016774] usb 7-1: SerialNumber: Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿Ã¿ Mar  5 10:37:51 nemi kernel: [47213.016816] device: '7-1': device_add


As I said, I am fully aware that this might be a firmware issue.  The firmware of this device is probably not meant for production, and there is a possibility that it is unavailable to the general public.

But the point is still that such issues may occur, and that working around them in userspace is a simple configuration matter.  That's one important reason to keep this in userspace.

> ------ In our opinions, it is better to switch Huawei device in 
> kernel.
> ------ usb_modeswitch is a tool for Linux. 
> ------ We can not guarantee it will be integrated in all the system 
> which integrates linux kernel. But linux kernel itself can.

The device also needs a userspace application to configure, connect and monitor it.  Should we put that into the kernel as well? Nope.

These devices will not work without userspace support.  Fix the distros instead if they lack proper userspace mode switching support.


BjÃ¸rn
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
