Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3FZOXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:23:32 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40996 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab3FZOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:22:55 -0400
Date: Wed, 26 Jun 2013 16:22:43 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: rtl8192cu: slow path warning
Message-ID: <20130626142241.GA13107@lnx-rg>
References: <20130611123814.GA9854@lnx-rg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611123814.GA9854@lnx-rg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [mar., 11.06.2013 14:38:15], Richard GENOUD wrote:
> Hi,
> 
> I've got an usb wireless adapter TP-Link TL-WN725N
> http://www.tp-link.com/ca/products/details/?categoryid=241&model=TL-WN725N
> It is based on the rtl8192cu chip.
> I'm running a recent kernel (3.10-rc5) on a arm-based board (at91sam9g35-ek).
> and last linux-firmwares (2892af0)
> 
> Here is the log:
> ***Insert the TP-Link key
> [   22.710937] usb 1-2.3: new high-speed USB device number 3 using atmel-ehci
> [   22.828125] rtl8192cu: Chip version 0x10
> [   22.921875] rtl8192cu: MAC address: a0:f3:c1:1a:28:5f
> [   22.929687] rtl8192cu: Board Type 0
> [   22.929687] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [   22.937500] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
> [   22.953125] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> [   22.968750] rtlwifi: wireless switch is on
> 
> # ip link set wlan0 up
> [   34.656250] rtl8192cu: MAC auto ON okay!
> [   34.695312] rtl8192cu: Tx queue select: 0x05
> # iw dev wlan0 scan
> BSS 00:1c:10:69:90:fe (on wlan0)
> 	TSF: 1046528539 usec (0d, 00:17:26)
> 	freq: 2412
> 	beacon interval: 100
> 	capability: ESS ShortSlotTime (0x0401)
> 	signal: -58.00 dBm
> 	last seen: 500 ms ago
> 	Information elements from Probe Response frame:
> 	SSID: test
> 	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
> 	DS Parameter set: channel 1
> 	TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
> 	ERP: Barker_Preamble_Mode
> 	Extended supported rates: 24.0 36.0 48.0 54.0 
> # iw wlan0 connect test
> [   51.851562] wlan0: authenticate with 00:1c:10:69:90:fe
> [   51.859375] wlan0: Allocated STA 00:1c:10:69:90:fe
> [   51.867187] wlan0: Inserted STA 00:1c:10:69:90:fe
> [   51.875000] wlan0: direct probe to 00:1c:10:69:90:fe (try 1/3)
> # [   52.078125] wlan0: direct probe to 00:1c:10:69:90:fe (try 2/3)
> [   52.281250] wlan0: direct probe to 00:1c:10:69:90:fe (try 3/3)
> [   52.484375] wlan0: authentication with 00:1c:10:69:90:fe timed out
> [   52.484375] wlan0: Removed STA 00:1c:10:69:90:fe
> [   52.492187] wlan0: Destroyed STA 00:1c:10:69:90:fe
> 
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
Hi,

Using 3.10-rc7, I'm still seeing the warning, BUT ONLY on the first
connection.

[   40.312500] usb 2-2: default language 0x0409
[   40.312500] usb 2-2: udev 2, busnum 2, minor = 129
[   40.320312] usb 2-2: New USB device found, idVendor=0bda, idProduct=8176
[   40.328125] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   40.328125] usb 2-2: Product: 802.11n WLAN Adapter
[   40.335937] usb 2-2: Manufacturer: Realtek
[   40.343750] usb 2-2: SerialNumber: 00e04c000001
[   40.343750] usb 2-2: usb_probe_device
[   40.351562] usb 2-2: configuration #1 chosen from 1 choice
[   40.351562] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
[   40.500000] cfg80211: Calling CRDA to update world regulatory domain
[   40.648437] rtl8192cu 2-2:1.0: usb_probe_interface
[   40.656250] rtl8192cu 2-2:1.0: usb_probe_interface - got id
[   40.664062] rtl8192cu: Chip version 0x10
[   40.757812] rtl8192cu: MAC address: a0:f3:c1:1e:02:a0
[   40.765625] rtl8192cu: Board Type 0
[   40.773437] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[   40.773437] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[   40.781250] usbcore: registered new interface driver rtl8192cu
[   40.835937] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   40.843750] rtlwifi: wireless switch is on
# ip link set wlan0 up
[   59.921875] rtl8192cu: MAC auto ON okay!
[   59.960937] rtl8192cu: Tx queue select: 0x05
# iw wlan0 connect test
[   75.390625] wlan0: authenticate with f8:1a:67:1a:df:88
[   75.421875] wlan0: send auth to f8:1a:67:1a:df:88 (try 1/3)
[   75.437500] wlan0: authenticated
[   75.453125] wlan0: associate with f8:1a:67:1a:df:88 (try 1/3)
[   75.460937] wlan0: RX AssocResp from f8:1a:67:1a:df:88 (capab=0x401 status=0 aid=2)
[   75.468750] wlan0: associated
[   76.375000] ------------[ cut here ]------------
[   76.375000] WARNING: at kernel/workqueue.c:1365 __queue_work+0x168/0x200()
[   76.375000] Modules linked in: rtl8192cu rtl8192c_common rtlwifi mac80211 cfg80211 rfkill ehci_atmel ehci_hcd atmel_usba_udc udc_core ohci_hcd
[   76.375000] CPU: 0 PID: 308 Comm: kworker/0:1 Not tainted 3.10.0-rc7 #36
[   76.375000] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
[   76.375000] [<c000d9bc>] (unwind_backtrace+0x0/0xf0) from [<c000b9ec>] (show_stack+0x10/0x14)
[   76.375000] [<c000b9ec>] (show_stack+0x10/0x14) from [<c0015c00>] (warn_slowpath_common+0x4c/0x68)
[   76.375000] [<c0015c00>] (warn_slowpath_common+0x4c/0x68) from [<c0015c38>] (warn_slowpath_null+0x1c/0x24)
[   76.375000] [<c0015c38>] (warn_slowpath_null+0x1c/0x24) from [<c0029e40>] (__queue_work+0x168/0x200)
[   76.375000] [<c0029e40>] (__queue_work+0x168/0x200) from [<c0029f2c>] (queue_work_on+0x44/0x50)
[   76.375000] [<c0029f2c>] (queue_work_on+0x44/0x50) from [<bf09bb54>] (rtl_watchdog_wq_callback+0x320/0x404 [rtlwifi])
[   76.375000] [<bf09bb54>] (rtl_watchdog_wq_callback+0x320/0x404 [rtlwifi]) from [<c002b168>] (process_one_work+0x10c/0x354)
[   76.375000] [<c002b168>] (process_one_work+0x10c/0x354) from [<c002b784>] (worker_thread+0x130/0x380)
[   76.375000] [<c002b784>] (worker_thread+0x130/0x380) from [<c0030330>] (kthread+0xa4/0xb0)
[   76.375000] [<c0030330>] (kthread+0xa4/0xb0) from [<c00092f0>] (ret_from_fork+0x14/0x24)
[   76.375000] ---[ end trace e116b4b3d671f3d2 ]---

# iw wlan0 disconnect 
[   86.289062] wlan0: deauthenticating from f8:1a:67:1a:df:88 by local choice (reason=3)
[   86.312500] cfg80211: Calling CRDA to update world regulatory domain
# iw wlan0 connect test
[   91.671875] wlan0: authenticate with f8:1a:67:1a:df:88
[   91.687500] wlan0: send auth to f8:1a:67:1a:df:88 (try 1/3)
[   91.695312] wlan0: authenticated
[   91.710937] wlan0: associate with f8:1a:67:1a:df:88 (try 1/3)
[   91.718750] wlan0: RX AssocResp from f8:1a:67:1a:df:88 (capab=0x401 status=0 aid=1)
[   91.726562] wlan0: associated

# iw wlan0 disconnect 
[   98.929687] wlan0: deauthenticating from f8:1a:67:1a:df:88 by local choice (reason=3)
[   98.953125] cfg80211: Calling CRDA to update world regulatory domain
# iw wlan0 connect test
[  101.554687] wlan0: authenticate with f8:1a:67:1a:df:88
[  101.578125] wlan0: send auth to f8:1a:67:1a:df:88 (try 1/3)
[  101.585937] wlan0: authenticated
[  101.593750] wlan0: associate with f8:1a:67:1a:df:88 (try 1/3)
[  101.625000] wlan0: RX AssocResp from f8:1a:67:1a:df:88 (capab=0x401 status=0 aid=1)
[  101.632812] wlan0: associated
[  114.523437] wlan0: Connection to AP f8:1a:67:1a:df:88 lost
[  114.546875] cfg80211: Calling CRDA to update world regulatory domain


Best regards,
Richard.
