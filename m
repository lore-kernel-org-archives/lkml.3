Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3FZPyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:54:10 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:55248 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3FZPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:54:07 -0400
Message-ID: <51CB0E9C.50408@lwfinger.net>
Date: Wed, 26 Jun 2013 10:54:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Richard GENOUD <richard.genoud@gmail.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
References: <20130611123814.GA9854@lnx-rg> <20130626142241.GA13107@lnx-rg>
In-Reply-To: <20130626142241.GA13107@lnx-rg>
Content-Type: multipart/mixed;
 boundary="------------040103060308080909040200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040103060308080909040200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 06/26/2013 09:22 AM, Richard GENOUD wrote:
> Using 3.10-rc7, I'm still seeing the warning, BUT ONLY on the first
> connection.
>
> [   40.312500] usb 2-2: default language 0x0409
> [   40.312500] usb 2-2: udev 2, busnum 2, minor = 129
> [   40.320312] usb 2-2: New USB device found, idVendor=0bda, idProduct=8176
> [   40.328125] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   40.328125] usb 2-2: Product: 802.11n WLAN Adapter
> [   40.335937] usb 2-2: Manufacturer: Realtek
> [   40.343750] usb 2-2: SerialNumber: 00e04c000001
> [   40.343750] usb 2-2: usb_probe_device
> [   40.351562] usb 2-2: configuration #1 chosen from 1 choice
> [   40.351562] usb 2-2: adding 2-2:1.0 (config #1, interface 0)
> [   40.500000] cfg80211: Calling CRDA to update world regulatory domain
> [   40.648437] rtl8192cu 2-2:1.0: usb_probe_interface
> [   40.656250] rtl8192cu 2-2:1.0: usb_probe_interface - got id
> [   40.664062] rtl8192cu: Chip version 0x10
> [   40.757812] rtl8192cu: MAC address: a0:f3:c1:1e:02:a0
> [   40.765625] rtl8192cu: Board Type 0
> [   40.773437] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
> [   40.773437] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
> [   40.781250] usbcore: registered new interface driver rtl8192cu
> [   40.835937] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> [   40.843750] rtlwifi: wireless switch is on
> # ip link set wlan0 up
> [   59.921875] rtl8192cu: MAC auto ON okay!
> [   59.960937] rtl8192cu: Tx queue select: 0x05
> # iw wlan0 connect test
> [   75.390625] wlan0: authenticate with f8:1a:67:1a:df:88
> [   75.421875] wlan0: send auth to f8:1a:67:1a:df:88 (try 1/3)
> [   75.437500] wlan0: authenticated
> [   75.453125] wlan0: associate with f8:1a:67:1a:df:88 (try 1/3)
> [   75.460937] wlan0: RX AssocResp from f8:1a:67:1a:df:88 (capab=0x401 status=0 aid=2)
> [   75.468750] wlan0: associated
> [   76.375000] ------------[ cut here ]------------
> [   76.375000] WARNING: at kernel/workqueue.c:1365 __queue_work+0x168/0x200()
> [   76.375000] Modules linked in: rtl8192cu rtl8192c_common rtlwifi mac80211 cfg80211 rfkill ehci_atmel ehci_hcd atmel_usba_udc udc_core ohci_hcd
> [   76.375000] CPU: 0 PID: 308 Comm: kworker/0:1 Not tainted 3.10.0-rc7 #36
> [   76.375000] Workqueue: rtl92c_usb rtl_watchdog_wq_callback [rtlwifi]
> [   76.375000] [<c000d9bc>] (unwind_backtrace+0x0/0xf0) from [<c000b9ec>] (show_stack+0x10/0x14)
> [   76.375000] [<c000b9ec>] (show_stack+0x10/0x14) from [<c0015c00>] (warn_slowpath_common+0x4c/0x68)
> [   76.375000] [<c0015c00>] (warn_slowpath_common+0x4c/0x68) from [<c0015c38>] (warn_slowpath_null+0x1c/0x24)
> [   76.375000] [<c0015c38>] (warn_slowpath_null+0x1c/0x24) from [<c0029e40>] (__queue_work+0x168/0x200)
> [   76.375000] [<c0029e40>] (__queue_work+0x168/0x200) from [<c0029f2c>] (queue_work_on+0x44/0x50)
> [   76.375000] [<c0029f2c>] (queue_work_on+0x44/0x50) from [<bf09bb54>] (rtl_watchdog_wq_callback+0x320/0x404 [rtlwifi])
> [   76.375000] [<bf09bb54>] (rtl_watchdog_wq_callback+0x320/0x404 [rtlwifi]) from [<c002b168>] (process_one_work+0x10c/0x354)
> [   76.375000] [<c002b168>] (process_one_work+0x10c/0x354) from [<c002b784>] (worker_thread+0x130/0x380)
> [   76.375000] [<c002b784>] (worker_thread+0x130/0x380) from [<c0030330>] (kthread+0xa4/0xb0)
> [   76.375000] [<c0030330>] (kthread+0xa4/0xb0) from [<c00092f0>] (ret_from_fork+0x14/0x24)
> [   76.375000] ---[ end trace e116b4b3d671f3d2 ]---

The WARNING is the result of a workqueue not being initialized for the USB driver.

Please try the attached patch. As you have posted on a public mailing list, May 
I assume that it will be OK to use your address in Reported-by/Tested-by lines 
in the patch submission?

Thanks,

Larry


--------------040103060308080909040200
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_init_work"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_init_work"

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
@@ -1008,7 +1008,7 @@ static void _rtl_pci_prepare_bcn_tasklet
 	return;
 }
 
-static void rtl_lps_change_work_callback(struct work_struct *work)
+void rtl_lps_change_work_callback(struct work_struct *work)
 {
 	struct rtl_works *rtlworks =
 	    container_of(work, struct rtl_works, lps_change_work);
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/ps.h
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/ps.h
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/ps.h
@@ -49,5 +49,6 @@ void rtl_swlps_rf_awake(struct ieee80211
 void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
 void rtl_p2p_ps_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
 void rtl_p2p_info(struct ieee80211_hw *hw, void *data, unsigned int len);
+void rtl_lps_change_work_callback(struct work_struct *work);
 
 #endif
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/usb.c
@@ -1070,6 +1070,8 @@ int rtl_usb_probe(struct usb_interface *
 	spin_lock_init(&rtlpriv->locks.usb_lock);
 	INIT_WORK(&rtlpriv->works.fill_h2c_cmd,
 		  rtl_fill_h2c_cmd_work_callback);
+	INIT_WORK(&rtlpriv->works.lps_change_work,
+		  rtl_lps_change_work_callback);
 
 	rtlpriv->usb_data_index = 0;
 	init_completion(&rtlpriv->firmware_loading_complete);

--------------040103060308080909040200--
