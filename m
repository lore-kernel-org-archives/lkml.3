Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3CEIsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:48:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3CEIsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:48:40 -0500
From: Oliver Neukum <oneukum@suse.de>
To: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>, "Yili (Neil)" <neil.yi@huawei.com>,
        "Wangyuhua (Roger, Credit)" <wangyuhua@huawei.com>,
        "Huqiao (C)" <huqiao36@huawei.com>, "balbi@ti.com" <balbi@ti.com>,
        "mdharm-usb@one-eyed-alien.net" <mdharm-usb@one-eyed-alien.net>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>
Subject: Re: v3.8 regression: Huawei mode switching fails (was Re: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage devices and support new switch command)
Date: Tue, 05 Mar 2013 09:48:55 +0100
Message-ID: <3774811.9hgnDZEBaM@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.8.0-rc7-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <910F9D9E13B84F4C8FA771DC9BDE99F327098368@szxeml546-mbx.china.huawei.com>
References: <fe8c966212fb.12fbfe8c9662@huawei.com> <87obezs888.fsf@nemi.mork.no> <910F9D9E13B84F4C8FA771DC9BDE99F327098368@szxeml546-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013 02:28:07 Fangxiaozhi wrote:

Hi,

> 	1. As far as I know, usb_modeswitch is now only integrated in the PC Linux. It isn't integrated to other system with linux kernel, such as Android, Chrome OS, etc. On these system, how can we switch the device?

Then those systems will have to add modeswitch.
If we are to do mode switching in kernel space, there has to be
an additional technical benefit over the existing and well working solution
in user space.

> 	2. usb_modeswitch often sends the Windows switching command to switch Huawei device, but not sends Linux switching command. This maybe causes some unexpected problem.

You have two commands? What is the difference? Anyway, if usb_modeswitch
has issues, these problems need to be fixed.

Independent from that, there is a problem with user space mode switching.
Namely it doesn't work with reset_resume(). Thus we cannot do sane S4
with the user space solution.
However, the problem cannot be solved by merely by adding the switch
to the storage driver.

	Regards
		Oliver

