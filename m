Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3CEJGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:06:06 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:30227 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3CEJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:06:01 -0500
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: Oliver Neukum <oneukum@suse.de>
CC: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
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
Thread-Index: AQHOGM1yHvGzXjho9E6JnFnGf6g04ZiWXYtQ///nR4CAAIZVUA==
Date: Tue, 5 Mar 2013 09:05:06 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F32709994F@szxeml546-mbx.china.huawei.com>
References: <fe8c966212fb.12fbfe8c9662@huawei.com>
 <87obezs888.fsf@nemi.mork.no>
 <910F9D9E13B84F4C8FA771DC9BDE99F327098368@szxeml546-mbx.china.huawei.com>
 <3774811.9hgnDZEBaM@linux-5eaq.site>
In-Reply-To: <3774811.9hgnDZEBaM@linux-5eaq.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r25968QM006460

Dear Oliver:

> -----Original Message-----
> From: Oliver Neukum [mailto:oneukum@suse.de]
> Sent: Tuesday, March 05, 2013 4:49 PM
> To: Fangxiaozhi (Franko)
> Cc: BjÃ¸rn Mork; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org;
> Xueguiying (Zihan); Linlei (Lei Lin); greg@kroah.com; Yili (Neil); Wangyuhua
> (Roger, Credit); Huqiao (C); balbi@ti.com; mdharm-usb@one-eyed-alien.net;
> sebastian@breakpoint.cc
> Subject: Re: v3.8 regression: Huawei mode switching fails (was Re: [PATCH
> 2/2]linux-usb:optimize to match the Huawei USB storage devices and support
> new switch command)
> 
> On Tuesday 05 March 2013 02:28:07 Fangxiaozhi wrote:
> 
> Hi,
> 
> > 	1. As far as I know, usb_modeswitch is now only integrated in the PC Linux.
> It isn't integrated to other system with linux kernel, such as Android, Chrome
> OS, etc. On these system, how can we switch the device?
> 
> Then those systems will have to add modeswitch.
> If we are to do mode switching in kernel space, there has to be an additional
> technical benefit over the existing and well working solution in user space.
-----The vendor doesn't want to add the modeswitch on their system. We try to push them to do it, but they don't agree.
> 
> > 	2. usb_modeswitch often sends the Windows switching command to
> switch Huawei device, but not sends Linux switching command. This maybe
> causes some unexpected problem.
> 
> You have two commands? What is the difference? Anyway, if usb_modeswitch
> has issues, these problems need to be fixed.
------Sorry, it is one command, but with different values in it for different system, such as:
	1. For Windows:
	{0x11, 0x06, 0x00, 0x00, 0x00, 0x01, 0x01, 0x00,
-			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
	2. For Mac OS: 
	{0x11, 0x06, 0x10, 0x00, 0x00, 0x01, 0x01, 0x00,
-			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
	3. For Linux:
	{0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
-			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

	Sometimes, modeswitch will send the command for Windows  to device on Linux system, but not the command for Linux. 
> 
> Independent from that, there is a problem with user space mode switching.
> Namely it doesn't work with reset_resume(). Thus we cannot do sane S4 with
> the user space solution.
> However, the problem cannot be solved by merely by adding the switch to the
> storage driver.
-----For this issue, can you offer more details? And we can try to solve it together.
> 
> 	Regards
> 		Oliver

Best Regards,
Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
