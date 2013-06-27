Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3F0Hdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:33:44 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48058 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3F0Hdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <51CB0E9C.50408@lwfinger.net>
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg> <51CB0E9C.50408@lwfinger.net>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 27 Jun 2013 09:33:20 +0200
Message-ID: <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
Subject: Re: rtl8192cu: slow path warning
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/26 Larry Finger <Larry.Finger@lwfinger.net>:
> On 06/26/2013 09:22 AM, Richard GENOUD wrote:
>>
>> Using 3.10-rc7, I'm still seeing the warning, BUT ONLY on the first
>> connection.
>>
>> [   40.312500] usb 2-2: default language 0x0409
>> [   40.312500] usb 2-2: udev 2, busnum 2, minor = 129
>> [   40.320312] usb 2-2: New USB device found, idVendor=0bda,
>> idProduct=8176
>> [   40.328125] usb 2-2: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [   40.328125] usb 2-2: Product: 802.11n WLAN Adapter
>> [   40.335937] usb 2-2: Manufacturer: Realtek
>> [   40.343750] usb 2-2: SerialNumber: 00e04c000001
>> [   40.343750] usb 2-2: usb_probe_device
>> [   40.351562] usb 2-2: configuration #1 chosen from 1 choice
>> [   40.351562] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
>> [   40.500000] cfg80211: Calling CRDA to update world regulatory domain
>> [   40.648437] rtl8192cu 2-2:1.0: usb_probe_interface
>> [   40.656250] rtl8192cu 2-2:1.0: usb_probe_interface - got id
>> [   40.664062] rtl8192cu: Chip version 0x10
>> [   40.757812] rtl8192cu: MAC address: a0:f3:c1:1e:02:a0
>> [   40.765625] rtl8192cu: Board Type 0
>> [   40.773437] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
>> [   40.773437] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
>> [   40.781250] usbcore: registered new interface driver rtl8192cu
>> [   40.835937] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
>> [   40.843750] rtlwifi: wireless switch is on
>> # ip link set wlan0 up
>> [   59.921875] rtl8192cu: MAC auto ON okay!
>> [   59.960937] rtl8192cu: Tx queue select: 0x05
>> # iw wlan0 connect test
>> [   75.390625] wlan0: authenticate with f8:1a:67:1a:df:88
>> [   75.421875] wlan0: send auth to f8:1a:67:1a:df:88 (try 1/3)
>> [   75.437500] wlan0: authenticated
>> [   75.453125] wlan0: associate with f8:1a:67:1a:df:88 (try 1/3)
>> [   75.460937] wlan0: RX AssocResp from f8:1a:67:1a:df:88 (capab=0x401
>> status=0 aid=2)
>> [   75.468750] wlan0: associated
>> [   76.375000] ------------[ cut here ]------------
>> [   76.375000] WARNING: at kernel/workqueue.c:1365
>> __queue_work+0x168/0x200()
>> [   76.375000] Modules linked in: rtl8192cu rtl8192c_common rtlwifi
>> mac80211 cfg80211 rfkill ehci_atmel ehci_hcd atmel_usba_udc udc_core
>> ohci_hcd
>> [   76.375000] CPU: 0 PID: 308 Comm: kworker/0:1 Not tainted 3.10.0-rc7
>> #36
>> [   76.375000] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
>> [   76.375000] [<c000d9bc>] (unwind_backtrace+0x0/0xf0) from [<c000b9ec>]
>> (show_stack+0x10/0x14)
>> [   76.375000] [<c000b9ec>] (show_stack+0x10/0x14) from [<c0015c00>]
>> (warn_slowpath_common+0x4c/0x68)
>> [   76.375000] [<c0015c00>] (warn_slowpath_common+0x4c/0x68) from
>> [<c0015c38>] (warn_slowpath_null+0x1c/0x24)
>> [   76.375000] [<c0015c38>] (warn_slowpath_null+0x1c/0x24) from
>> [<c0029e40>] (__queue_work+0x168/0x200)
>> [   76.375000] [<c0029e40>] (__queue_work+0x168/0x200) from [<c0029f2c>]
>> (queue_work_on+0x44/0x50)
>> [   76.375000] [<c0029f2c>] (queue_work_on+0x44/0x50) from [<bf09bb54>]
>> (rtl_watchdog_wq_callback+0x320/0x404 [rtlwifi])
>> [   76.375000] [<bf09bb54>] (rtl_watchdog_wq_callback+0x320/0x404
>> [rtlwifi]) from [<c002b168>] (process_one_work+0x10c/0x354)
>> [   76.375000] [<c002b168>] (process_one_work+0x10c/0x354) from
>> [<c002b784>] (worker_thread+0x130/0x380)
>> [   76.375000] [<c002b784>] (worker_thread+0x130/0x380) from [<c0030330>]
>> (kthread+0xa4/0xb0)
>> [   76.375000] [<c0030330>] (kthread+0xa4/0xb0) from [<c00092f0>]
>> (ret_from_fork+0x14/0x24)
>> [   76.375000] ---[ end trace e116b4b3d671f3d2 ]---
>
>
> The WARNING is the result of a workqueue not being initialized for the USB
> driver.
>
> Please try the attached patch. As you have posted on a public mailing list,
> May I assume that it will be OK to use your address in Reported-by/Tested-by
> lines in the patch submission?
>
> Thanks,
>
> Larry
>
Yes, of course, you can add my
Reported-by: Richard Genoud <richard.genoud@gmail.com>

But the patch doesn't compile on my platform ( since I'm on ARM, I
haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :

ERROR: "rtl_lps_change_work_callback"
[drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!


Best regards,
Richard.

PS: duckducking the warning, I found this automated report also :
https://retrace.fedoraproject.org/faf/reports/142038/

-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
