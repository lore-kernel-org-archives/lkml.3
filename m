Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3FKNmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 09:42:43 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48034 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FKNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 09:42:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130611123814.GA9854@lnx-rg>
References: <20130611123814.GA9854@lnx-rg>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 11 Jun 2013 15:42:21 +0200
Message-ID: <CACQ1gAisWv++hh1J6XSQq=5_QioYb8e1gEUNMYGeOEM7vsrR=A@mail.gmail.com>
Subject: Re: rtl8192cu: slow path warning and connection problem v3.10-rc5
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/11 Richard GENOUD <richard.genoud@gmail.com>:
> Hi,
>
> I've got an usb wireless adapter TP-Link TL-WN725N
> http://www.tp-link.com/ca/products/details/?categoryid=241&model=TL-WN725N
> It is based on the rtl8192cu chip.
> I'm running a recent kernel (3.10-rc5) on a arm-based board (at91sam9g35-ek).
> and last linux-firmwares (2892af0)
> # iw wlan0 connect test
> # [   70.718750] wlan0: authenticate with 00:1c:10:69:90:fe
> [   70.718750] wlan0: Allocated STA 00:1c:10:69:90:fe
> [   70.742187] wlan0: Inserted STA 00:1c:10:69:90:fe
> [   70.742187] wlan0: send auth to 00:1c:10:69:90:fe (try 1/3)
> [   70.757812] wlan0: authenticated
> [   70.757812] wlan0: moving STA 00:1c:10:69:90:fe to state 2
> [   70.765625] rtl8192cu 1-2.3:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
> [   70.773437] rtl8192cu 1-2.3:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [   70.789062] wlan0: associate with 00:1c:10:69:90:fe (try 1/3)
> [   70.804687] wlan0: RX AssocResp from 00:1c:10:69:90:fe (capab=0x401 status=0 aid=1)
> [   70.812500] wlan0: moving STA 00:1c:10:69:90:fe to state 3
> [   70.820312] wlan0: moving STA 00:1c:10:69:90:fe to state 4
> [   70.828125] wlan0: associated
> [   71.187500] ------------[ cut here ]------------
> [   71.187500] WARNING: at kernel/workqueue.c:1365 __queue_work+0x180/0x1f8()
> [   71.187500] CPU: 0 PID: 593 Comm: kworker/0:2 Not tainted 3.10.0-rc5-00133-g691a986 #6
> [   71.187500] Workqueue: rtl92c_usb rtl_watchdog_wq_callback
> [   71.187500] [<c000d2a0>] (unwind_backtrace+0x0/0xf0) from [<c000ba34>] (show_stack+0x10/0x14)
> [   71.187500] [<c000ba34>] (show_stack+0x10/0x14) from [<c00150fc>] (warn_slowpath_common+0x48/0x64)
> [   71.187500] [<c00150fc>] (warn_slowpath_common+0x48/0x64) from [<c00151e0>] (warn_slowpath_null+0x1c/0x24)
> [   71.187500] [<c00151e0>] (warn_slowpath_null+0x1c/0x24) from [<c0029878>] (__queue_work+0x180/0x1f8)
> [   71.187500] [<c0029878>] (__queue_work+0x180/0x1f8) from [<c0029ee8>] (queue_work_on+0x44/0x50)
> [   71.187500] [<c0029ee8>] (queue_work_on+0x44/0x50) from [<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0)
> [   71.187500] [<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0) from [<c002a138>] (process_one_work+0x110/0x358)
> [   71.187500] [<c002a138>] (process_one_work+0x110/0x358) from [<c002a728>] (worker_thread+0xf4/0x308)
> [   71.187500] [<c002a728>] (worker_thread+0xf4/0x308) from [<c002f8b4>] (kthread+0xa4/0xb0)
> [   71.187500] [<c002f8b4>] (kthread+0xa4/0xb0) from [<c00091b0>] (ret_from_fork+0x14/0x24)
> [   71.187500] ---[ end trace 5f274d456b3a4c7f ]---

I've should have check this before, but the connection problem is
corrected with the patch "rtlwifi: rtl8192cu: Fix problem in
connecting to WEP or WPA(1) networks"
Sorry for that...

Anyway, running 3.10-rc5 with the for-davem wireless branch, I still
have the slow path warning


# iw wlan0 connect test
# [   42.226562] wlan0: authenticate with 00:1c:10:69:90:fe
[   42.226562] wlan0: Allocated STA 00:1c:10:69:90:fe
[   42.250000] wlan0: Inserted STA 00:1c:10:69:90:fe
[   42.250000] wlan0: send auth to 00:1c:10:69:90:fe (try 1/3)
[   42.281250] wlan0: authenticated
[   42.289062] wlan0: moving STA 00:1c:10:69:90:fe to state 2
[   42.296875] rtl8192cu 1-2.3:1.0 wlan0: disabling HT as WMM/QoS is
not supported by the AP
[   42.304687] rtl8192cu 1-2.3:1.0 wlan0: disabling VHT as WMM/QoS is
not supported by the AP
[   42.312500] wlan0: associate with 00:1c:10:69:90:fe (try 1/3)
[   42.335937] wlan0: RX AssocResp from 00:1c:10:69:90:fe (capab=0x401
status=0 aid=1)
[   42.343750] wlan0: moving STA 00:1c:10:69:90:fe to state 3
[   42.343750] wlan0: moving STA 00:1c:10:69:90:fe to state 4
[   42.351562] wlan0: associated

[   44.179687] ------------[ cut here ]------------
[   44.179687] WARNING: at kernel/workqueue.c:1365 __queue_work+0x180/0x1f8()
[   44.179687] CPU: 0 PID: 580 Comm: kworker/0:2 Not tainted
3.10.0-rc5-00150-g4b16b55 #10
[   44.179687] Workqueue: rtl92c_usb rtl_watchdog_wq_callback
[   44.179687] [<c000d2a0>] (unwind_backtrace+0x0/0xf0) from
[<c000ba34>] (show_stack+0x10/0x14)
[   44.179687] [<c000ba34>] (show_stack+0x10/0x14) from [<c00150fc>]
(warn_slowpath_common+0x48/0x64)
[   44.179687] [<c00150fc>] (warn_slowpath_common+0x48/0x64) from
[<c00151e0>] (warn_slowpath_null+0x1c/0x24)
[   44.179687] [<c00151e0>] (warn_slowpath_null+0x1c/0x24) from
[<c0029878>] (__queue_work+0x180/0x1f8)
[   44.179687] [<c0029878>] (__queue_work+0x180/0x1f8) from
[<c0029ee8>] (queue_work_on+0x44/0x50)
[   44.179687] [<c0029ee8>] (queue_work_on+0x44/0x50) from
[<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0)
[   44.179687] [<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0)
from [<c002a138>] (process_one_work+0x110/0x358)
[   44.179687] [<c002a138>] (process_one_work+0x110/0x358) from
[<c002a728>] (worker_thread+0xf4/0x308)
[   44.179687] [<c002a728>] (worker_thread+0xf4/0x308) from
[<c002f8b4>] (kthread+0xa4/0xb0)
[   44.179687] [<c002f8b4>] (kthread+0xa4/0xb0) from [<c00091b0>]
(ret_from_fork+0x14/0x24)
[   44.179687] ---[ end trace d23aec3c204a06ee ]---

regards,
Richard.
