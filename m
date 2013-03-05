Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3CEC3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:29:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:13436 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab3CEC3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:29:06 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: RE: v3.8 regression: Huawei mode switching fails (was Re: [PATCH
 2/2]linux-usb:optimize to match the Huawei USB storage devices and support
 new switch command)
Thread-Topic: v3.8 regression: Huawei mode switching fails (was Re: [PATCH
 2/2]linux-usb:optimize to match the Huawei USB storage devices and support
 new switch command)
Thread-Index: AQHOGM1yHvGzXjho9E6JnFnGf6g04ZiWXYtQ
Date: Tue, 5 Mar 2013 02:28:07 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F327098368@szxeml546-mbx.china.huawei.com>
References: <fe8c966212fb.12fbfe8c9662@huawei.com>
 <87obezs888.fsf@nemi.mork.no>
In-Reply-To: <87obezs888.fsf@nemi.mork.no>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.34.145]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r252TBJh004960

Dear Mork:

	Thank you very much for your test.

> -----Original Message-----
> From: BjÃ¸rn Mork [mailto:bjorn@mork.no]
> Sent: Monday, March 04, 2013 7:41 PM
> To: Fangxiaozhi (Franko)
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Xueguiying
> (Zihan); Linlei (Lei Lin); greg@kroah.com; Yili (Neil); Wangyuhua (Roger, Credit);
> Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
> sebastian@breakpoint.cc
> Subject: v3.8 regression: Huawei mode switching fails (was Re: [PATCH
> 2/2]linux-usb:optimize to match the Huawei USB storage devices and support
> new switch command)
> 
> Hello Franko,
> 
> This patch causes a number of regressions for both the Huawei devices I have
> available for testing. One of them is completely unusable in v3.8 (unable to
> switch to modem mode) unless the usb-storage driver is disabled.
------Which device, can you tell me more information?
------Which model? And what's its firmware version?
> 
> I realize that some devices are historically handled by the usb-storage driver,
> but userspace modeswitching is the rule for new devices AFAIK.
> I see absolutely no valid argument for adding new devices.  And there is
> absolutely no excuse for adding devices which have been handled by
> userspace switching for years!  The patch does not just "optimize"
> matching.  It adds a large number of devices which were previously handled
> just fine by usb_modeswitch. This is guaranteed to confuse users with existing
> configurations, and users looking up any of the existing documentation
> pointing to usb_modeswitch.
------Yes. But there is some problems for this:
	1. As far as I know, usb_modeswitch is now only integrated in the PC Linux. It isn't integrated to other system with linux kernel, such as Android, Chrome OS, etc. On these system, how can we switch the device?

	2. usb_modeswitch often sends the Windows switching command to switch Huawei device, but not sends Linux switching command. This maybe causes some unexpected problem.
> 
> There is no need to repeat the discussion of kernel vs userspace switching.  I
> will only note that userspace switching:
>  - has been selected as the rule for new devices,
>  - allow the user to temporarily disable switching e.g. for mounting and
>    inspecting the usb-storage exported data,
>  - allow the user/system to apply device specific switching quirks
> 
> 
> The v3.7->v3.8 regressions I observe are:
> 
> 1) Temporarily disabling mode switching and mounting the CD image is now
>   impossible. Mode switching can only be disabled by blacklisting
>   usb-storage, which of course prevents usb-storage from working
> 
>   Prior to v3.8, modeswitching could easily be disabled by userspace
>   configuration. The change breaks existing configurations.
> 
> 2) Switching to non-default modes is now impossible.  The E392  (initially
> appearing as 12d1:1505) Windows drivers will use a different  command than
> the one used by Linux, causing the device to select a  different configuration
> in Linux and Windows. This forces Linux and  Windows to see the device
> differently.
> 
>  Prior to v3.8, different modeswitching commands could be configured  per
> device. The change breaks existing configurations.
> 
> 3) Switching fails for some devices. The E367 (initially appearing as
>  12d1:1446) does not switch when it receives the command sent by
> usb-storage.  But the command disable further switching, preventing
> userspace switching from working as well.
> 
>  Prior to v3.8, the device would switch fine using a default  usb_modeswitch
> configuration. The change breaks existing  configurations.
> 
>  I do note that there is a slight difference between the known working
> usb_modeswitch command:
> 
> 
> 55534243123456780000000000000011062000000100000000000000000000
> 
>  and the command sent by usb-storage:
> 
> 	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
> 			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> 
>  I assume the cause of the failure is either this difference or some  timing
> issue.
> 
> Anyway, I believe this patch must be reverted.  It disables currently used, well
> documented, and extremely useful, userspace funtionaliy for all devices
> implicitly added by the conversion from device matching to vendor matching.
> 
> 
> 
> BjÃ¸rn

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
