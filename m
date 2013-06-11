Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3FKMi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:38:27 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43619 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3FKMiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:38:25 -0400
Date: Tue, 11 Jun 2013 14:38:15 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: rtl8192cu: slow path warning and connection problem v3.10-rc5
Message-ID: <20130611123814.GA9854@lnx-rg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got an usb wireless adapter TP-Link TL-WN725N
http://www.tp-link.com/ca/products/details/?categoryid=241&model=TL-WN725N
It is based on the rtl8192cu chip.
I'm running a recent kernel (3.10-rc5) on a arm-based board (at91sam9g35-ek).
and last linux-firmwares (2892af0)

The problem I've got it that the device authenticates to the AP
(with a slow path warning), but there's no traffic (I can't get an IP
address from DHCP for example).

Here is the log:
***Insert the TP-Link key
[   22.710937] usb 1-2.3: new high-speed USB device number 3 using atmel-ehci
[   22.828125] rtl8192cu: Chip version 0x10
[   22.921875] rtl8192cu: MAC address: a0:f3:c1:1a:28:5f
[   22.929687] rtl8192cu: Board Type 0
[   22.929687] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[   22.937500] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[   22.953125] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   22.968750] rtlwifi: wireless switch is on

# ip link set wlan0 up
[   34.656250] rtl8192cu: MAC auto ON okay!
[   34.695312] rtl8192cu: Tx queue select: 0x05
# iw dev wlan0 scan
BSS 00:1c:10:69:90:fe (on wlan0)
	TSF: 1046528539 usec (0d, 00:17:26)
	freq: 2412
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -58.00 dBm
	last seen: 500 ms ago
	Information elements from Probe Response frame:
	SSID: test
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 1
	TIM: DTIM Count 1 DTIM Period 2 Bitmap Control 0x0 Bitmap[0] 0x0
	ERP: Barker_Preamble_Mode
	Extended supported rates: 24.0 36.0 48.0 54.0 
# iw wlan0 connect test
[   51.851562] wlan0: authenticate with 00:1c:10:69:90:fe
[   51.859375] wlan0: Allocated STA 00:1c:10:69:90:fe
[   51.867187] wlan0: Inserted STA 00:1c:10:69:90:fe
[   51.875000] wlan0: direct probe to 00:1c:10:69:90:fe (try 1/3)
# [   52.078125] wlan0: direct probe to 00:1c:10:69:90:fe (try 2/3)
[   52.281250] wlan0: direct probe to 00:1c:10:69:90:fe (try 3/3)
[   52.484375] wlan0: authentication with 00:1c:10:69:90:fe timed out
[   52.484375] wlan0: Removed STA 00:1c:10:69:90:fe
[   52.492187] wlan0: Destroyed STA 00:1c:10:69:90:fe

# iw wlan0 connect test
# [   70.718750] wlan0: authenticate with 00:1c:10:69:90:fe
[   70.718750] wlan0: Allocated STA 00:1c:10:69:90:fe
[   70.742187] wlan0: Inserted STA 00:1c:10:69:90:fe
[   70.742187] wlan0: send auth to 00:1c:10:69:90:fe (try 1/3)
[   70.757812] wlan0: authenticated
[   70.757812] wlan0: moving STA 00:1c:10:69:90:fe to state 2
[   70.765625] rtl8192cu 1-2.3:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
[   70.773437] rtl8192cu 1-2.3:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
[   70.789062] wlan0: associate with 00:1c:10:69:90:fe (try 1/3)
[   70.804687] wlan0: RX AssocResp from 00:1c:10:69:90:fe (capab=0x401 status=0 aid=1)
[   70.812500] wlan0: moving STA 00:1c:10:69:90:fe to state 3
[   70.820312] wlan0: moving STA 00:1c:10:69:90:fe to state 4
[   70.828125] wlan0: associated
[   71.187500] ------------[ cut here ]------------
[   71.187500] WARNING: at kernel/workqueue.c:1365 __queue_work+0x180/0x1f8()
[   71.187500] CPU: 0 PID: 593 Comm: kworker/0:2 Not tainted 3.10.0-rc5-00133-g691a986 #6
[   71.187500] Workqueue: rtl92c_usb rtl_watchdog_wq_callback
[   71.187500] [<c000d2a0>] (unwind_backtrace+0x0/0xf0) from [<c000ba34>] (show_stack+0x10/0x14)
[   71.187500] [<c000ba34>] (show_stack+0x10/0x14) from [<c00150fc>] (warn_slowpath_common+0x48/0x64)
[   71.187500] [<c00150fc>] (warn_slowpath_common+0x48/0x64) from [<c00151e0>] (warn_slowpath_null+0x1c/0x24)
[   71.187500] [<c00151e0>] (warn_slowpath_null+0x1c/0x24) from [<c0029878>] (__queue_work+0x180/0x1f8)
[   71.187500] [<c0029878>] (__queue_work+0x180/0x1f8) from [<c0029ee8>] (queue_work_on+0x44/0x50)
[   71.187500] [<c0029ee8>] (queue_work_on+0x44/0x50) from [<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0)
[   71.187500] [<c01fd850>] (rtl_watchdog_wq_callback+0x290/0x4e0) from [<c002a138>] (process_one_work+0x110/0x358)
[   71.187500] [<c002a138>] (process_one_work+0x110/0x358) from [<c002a728>] (worker_thread+0xf4/0x308)
[   71.187500] [<c002a728>] (worker_thread+0xf4/0x308) from [<c002f8b4>] (kthread+0xa4/0xb0)
[   71.187500] [<c002f8b4>] (kthread+0xa4/0xb0) from [<c00091b0>] (ret_from_fork+0x14/0x24)
[   71.187500] ---[ end trace 5f274d456b3a4c7f ]---
iw dev wlan0 link
Connected to 00:1c:10:69:90:fe (on wlan0)
	SSID: test
	freq: 2412
	RX: 8896 bytes (256 packets)
	TX: 80 bytes (2 packets)
	signal: -48 dBm
	tx bitrate: 1.0 MBit/s

	bss flags:	short-slot-time
	dtim period:	0
	beacon int:	100
# udhcpc -i wlan0 -f -n -q
udhcpc (v1.21.0) started
Sending discover...
Sending discover...
Sending discover...
No lease, failing
**** inserting another key (an older cisco/linksys WUSG54GC)
# [  108.875000] usb 1-2.2: new high-speed USB device number 4 using atmel-ehci
[  109.109375] usb 1-2.2: reset high-speed USB device number 4 using atmel-ehci
[  109.242187] ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
[  109.265625] ieee80211 phy1: rt2x00_set_rf: Info - RF chipset 0006 detected
[  109.273437] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'

# ip link set wlan1 up
[  116.234375] ieee80211 phy1: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[  116.250000] ieee80211 phy1: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29
# iw dev wlan1 scan
BSS 00:1c:10:69:90:fe (on wlan1)
	TSF: 1144496990 usec (0d, 00:19:04)
	freq: 2412
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -27.00 dBm
	last seen: 1429 ms ago
	SSID: test
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Parameter set: channel 1
	ERP: Barker_Preamble_Mode
	Extended supported rates: 24.0 36.0 48.0 54.0 
BSS 00:17:9a:84:fb:94 (on wlan1)
	TSF: 5965523554325 usec (69d, 01:05:23)
	freq: 2437
	beacon interval: 100
	capability: ESS Privacy ShortPreamble ShortSlotTime (0x0431)
	signal: -55.00 dBm
	last seen: 960 ms ago
	Information elements from Probe Response frame:
	SSID: paratronic
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 12.0 24.0 36.0 
	DS Parameter set: channel 6
	Country: GB	Environment: Indoor/Outdoor
		Channels [1 - 13] @ 14 dBm
	ERP: <no flags>
	Extended supported rates: 9.0 18.0 48.0 54.0 
	WMM:	 * Parameter version 1
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec
# iw wlan1 connect test
[  135.710937] wlan1: authenticate with 00:1c:10:69:90:fe
[  135.718750] wlan1: Allocated STA 00:1c:10:69:90:fe
[  135.726562] wlan1: Inserted STA 00:1c:10:69:90:fe
[  135.734375] wlan1: send auth to 00:1c:10:69:90:fe (try 1/3)
[  135.742187] wlan1: authenticated
[  135.742187] wlan1: moving STA 00:1c:10:69:90:fe to state 2
# [  135.750000] rt2800usb 1-2.2:1.0 wlan1: disabling HT as WMM/QoS is not supported by the AP
[  135.757812] rt2800usb 1-2.2:1.0 wlan1: disabling VHT as WMM/QoS is not supported by the AP
[  135.773437] wlan1: associate with 00:1c:10:69:90:fe (try 1/3)
[  135.773437] wlan1: RX AssocResp from 00:1c:10:69:90:fe (capab=0x401 status=0 aid=2)
[  135.789062] wlan1: moving STA 00:1c:10:69:90:fe to state 3
[  135.796875] wlan1: moving STA 00:1c:10:69:90:fe to state 4
[  135.812500] wlan1: associated

# udhcpc -i wlan1 -f -n -q
udhcpc (v1.21.0) started
Sending discover...
Sending select for 10.125.0.205...
Lease of 10.125.0.205 obtained, lease time 60
deleting routers
route: SIOCDELRT: No such process
# ping 10.125.0.201
PING 10.125.0.201 (10.125.0.201): 56 data bytes

--- 10.125.0.201 ping statistics ---
3 packets transmitted, 0 packets received, 100% packet loss
# ping 10.125.0.1
PING 10.125.0.1 (10.125.0.1): 56 data bytes
64 bytes from 10.125.0.1: seq=0 ttl=64 time=6.966 ms
64 bytes from 10.125.0.1: seq=1 ttl=64 time=2.677 ms
64 bytes from 10.125.0.1: seq=2 ttl=64 time=2.895 ms

--- 10.125.0.1 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 2.677/4.179/6.966 ms
# 

So it works allright with the other key, but not with the tp-link one.

Did I do something wrong ?

Regards,
Richard.
