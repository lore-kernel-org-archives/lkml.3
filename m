Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3GNTiM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:38:12 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42630 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3GNTiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:38:09 -0400
Message-ID: <51E2FE1C.207@openvz.org>
Date: Sun, 14 Jul 2013 23:38:04 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-wireless@vger.kernel.org
Subject: [3.10.1] strange kernel crash after thousands suspend-resume cycles
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first and only warning had happened here:

Jul 14 20:42:50 zurg kernel: [  225.991608] ------------[ cut here ]------------
Jul 14 20:42:50 zurg kernel: [  225.991613] WARNING: at net/mac80211/pm.c:113 __ieee80211_suspend+0x6ad/0x6d0()
Jul 14 20:42:50 zurg kernel: [  225.991633] Modules linked in: iwldvm iwlwifi nfsd auth_rpcgss oid_registry nfs_acl nfs 
lockd sunrpc bridge stp llc tun fuse snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep 
snd_pcm snd_page_alloc thinkpad_acpi snd_seq_midi snd_seq_midi_event iTCO_wdt snd_rawmidi intel_powerclamp coretemp 
hid_logitech_dj cdc_ncm uvcvideo kvm_intel kvm usbnet videobuf2_vmalloc videobuf2_memops mii videobuf2_core videodev 
cdc_wdm cdc_acm snd_seq snd_seq_device snd_timer i915 snd soundcore lpc_ich mfd_core wmi drm_kms_helper sdhci_pci sdhci 
e1000e ptp
Jul 14 20:42:50 zurg kernel: [  225.991635] CPU: 0 PID: 4940 Comm: pm-suspend Not tainted 3.10.1-zurg-00001-gaa457b5 #107
Jul 14 20:42:50 zurg kernel: [  225.991636] Hardware name: LENOVO 4291QY6/4291QY6, BIOS 8DET51WW (1.21 ) 08/02/2011
Jul 14 20:42:50 zurg kernel: [  225.991637]  0000000000000009 ffff8803f5761c40 ffffffff81621b62 ffff8803f5761c78
Jul 14 20:42:50 zurg kernel: [  225.991638]  ffffffff8104e8b1 ffff880405560640 0000000000000000 ffff8804055612f8
Jul 14 20:42:50 zurg kernel: [  225.991639]  ffff8804055612f8 ffff880405560860 ffff8803f5761c88 ffffffff8104e98a
Jul 14 20:42:50 zurg kernel: [  225.991640] Call Trace:
Jul 14 20:42:50 zurg kernel: [  225.991643]  [<ffffffff81621b62>] dump_stack+0x19/0x1b
Jul 14 20:42:50 zurg kernel: [  225.991646]  [<ffffffff8104e8b1>] warn_slowpath_common+0x61/0x80
Jul 14 20:42:50 zurg kernel: [  225.991647]  [<ffffffff8104e98a>] warn_slowpath_null+0x1a/0x20
Jul 14 20:42:50 zurg kernel: [  225.991648]  [<ffffffff815fefad>] __ieee80211_suspend+0x6ad/0x6d0
Jul 14 20:42:50 zurg kernel: [  225.991651]  [<ffffffff815d1a5a>] ieee80211_suspend+0x1a/0x30
Jul 14 20:42:50 zurg kernel: [  225.991653]  [<ffffffff8157ee87>] wiphy_suspend+0x77/0x200
Jul 14 20:42:50 zurg kernel: [  225.991654]  [<ffffffff8157ee10>] ? addresses_show+0xa0/0xa0
Jul 14 20:42:50 zurg kernel: [  225.991656]  [<ffffffff816220dc>] legacy_suspend+0x28/0x60
Jul 14 20:42:50 zurg kernel: [  225.991659]  [<ffffffff81350816>] __device_suspend+0x2c6/0x330
Jul 14 20:42:50 zurg kernel: [  225.991660]  [<ffffffff813520c8>] dpm_suspend+0x58/0x220
Jul 14 20:42:50 zurg kernel: [  225.991661]  [<ffffffff813524d7>] dpm_suspend_start+0x57/0x60
Jul 14 20:42:50 zurg kernel: [  225.991663]  [<ffffffff8108e2e0>] suspend_devices_and_enter+0x70/0x480
Jul 14 20:42:50 zurg kernel: [  225.991665]  [<ffffffff8108e868>] pm_suspend+0x178/0x260
Jul 14 20:42:50 zurg kernel: [  225.991666]  [<ffffffff8108d7b5>] state_store+0x75/0xf0
Jul 14 20:42:50 zurg kernel: [  225.991668]  [<ffffffff8124856f>] kobj_attr_store+0xf/0x20
Jul 14 20:42:50 zurg kernel: [  225.991670]  [<ffffffff81197ff3>] sysfs_write_file+0xd3/0x150
Jul 14 20:42:50 zurg kernel: [  225.991673]  [<ffffffff811306d9>] vfs_write+0xb9/0x1c0
Jul 14 20:42:50 zurg kernel: [  225.991674]  [<ffffffff81130fe9>] SyS_write+0x49/0xa0
Jul 14 20:42:50 zurg kernel: [  225.991677]  [<ffffffff81630919>] system_call_fastpath+0x16/0x1b
Jul 14 20:42:50 zurg kernel: [  225.991678] ---[ end trace 996fb345fab7f015 ]---

after that kernel has worked fine for a hour and has done thousands s2ram suspend-resume cycles

but 'mei_me' has started generating endless noise...

Jul 14 21:52:28 zurg kernel: [ 2749.332358] cfg80211: Regulatory domain changed to country: RU
Jul 14 21:52:28 zurg kernel: [ 2749.332368] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 21:52:28 zurg kernel: [ 2749.332373] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 21:52:28 zurg kernel: [ 2749.332378] cfg80211:   (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 3000 mBm)
Jul 14 21:52:29 zurg kernel: [ 2749.928395] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
Jul 14 21:52:35 zurg kernel: [ 2755.840385] IPv6: ADDRCONF(NETDEV_UP): wwan0: link is not ready
Jul 14 21:52:54 zurg kernel: [ 2775.005762] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.007722] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.011081] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.011534] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.011560] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.011752] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.013369] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.013731] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.013756] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.013980] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.014346] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.014666] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.014710] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.014906] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.015319] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.015720] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.015746] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.015934] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 21:52:54 zurg kernel: [ 2775.016381] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

a lot of noise:

blind@zurg:~/src/linux$ sudo grep -c 'unexpected reset' /var/log/messages
161627

Jul 14 22:02:27 zurg kernel: [ 3347.409622] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:02:57 zurg kernel: [ 3377.430828] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:03:27 zurg kernel: [ 3407.451988] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:03:57 zurg kernel: [ 3437.473180] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:04:27 zurg kernel: [ 3467.494366] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:04:30 zurg kernel: [ 3470.587230] cfg80211: Calling CRDA to update world regulatory domain
Jul 14 22:04:30 zurg kernel: [ 3470.595539] cfg80211: World regulatory domain updated:
Jul 14 22:04:30 zurg kernel: [ 3470.595549] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:04:30 zurg kernel: [ 3470.595555] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.595559] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.595563] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.595567] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.595570] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.595595] cfg80211: Calling CRDA for country: GB
Jul 14 22:04:30 zurg kernel: [ 3470.605175] cfg80211: Regulatory domain changed to country: GB
Jul 14 22:04:30 zurg kernel: [ 3470.605185] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:04:30 zurg kernel: [ 3470.605191] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.605195] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.605198] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.605202] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Jul 14 22:04:30 zurg kernel: [ 3470.605205] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 14 22:04:33 zurg kernel: [ 3473.271126] wlan0: authenticate with 48:5d:60:e1:76:0e
Jul 14 22:04:33 zurg kernel: [ 3473.272752] wlan0: send auth to 48:5d:60:e1:76:0e (try 1/3)
Jul 14 22:04:33 zurg kernel: [ 3473.275101] wlan0: authenticated
Jul 14 22:04:33 zurg kernel: [ 3473.275877] wlan0: associate with 48:5d:60:e1:76:0e (try 1/3)
Jul 14 22:04:33 zurg kernel: [ 3473.279186] wlan0: RX AssocResp from 48:5d:60:e1:76:0e (capab=0x411 status=0 aid=3)
Jul 14 22:04:33 zurg kernel: [ 3473.285250] wlan0: associated
Jul 14 22:04:33 zurg kernel: [ 3473.285307] cfg80211: Calling CRDA for country: RU
Jul 14 22:04:33 zurg kernel: [ 3473.288113] cfg80211: Regulatory domain changed to country: RU
Jul 14 22:04:33 zurg kernel: [ 3473.288116] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:04:33 zurg kernel: [ 3473.288117] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:04:33 zurg kernel: [ 3473.288118] cfg80211:   (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 3000 mBm)
Jul 14 22:04:57 zurg kernel: [ 3497.515565] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:05:27 zurg kernel: [ 3527.536767] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:05:57 zurg kernel: [ 3557.557918] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:06:27 zurg kernel: [ 3587.579166] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:06:57 zurg kernel: [ 3617.600307] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:07:27 zurg kernel: [ 3647.621479] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:07:58 zurg kernel: [ 3677.642714] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:08:28 zurg kernel: [ 3707.663909] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:08:30 zurg kernel: [ 3710.269613] cfg80211: Calling CRDA to update world regulatory domain
Jul 14 22:08:30 zurg kernel: [ 3710.278641] cfg80211: World regulatory domain updated:
Jul 14 22:08:30 zurg kernel: [ 3710.278651] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:08:30 zurg kernel: [ 3710.278657] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.278661] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.278665] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.278669] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.278673] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.278699] cfg80211: Calling CRDA for country: GB
Jul 14 22:08:30 zurg kernel: [ 3710.287280] cfg80211: Regulatory domain changed to country: GB
Jul 14 22:08:30 zurg kernel: [ 3710.287290] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:08:30 zurg kernel: [ 3710.287295] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.287299] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.287302] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.287306] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Jul 14 22:08:30 zurg kernel: [ 3710.287310] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 14 22:08:33 zurg kernel: [ 3712.911957] wlan0: send auth to 48:5d:60:e1:76:0e (try 1/3)
Jul 14 22:08:33 zurg kernel: [ 3712.914326] wlan0: authenticated
Jul 14 22:08:33 zurg kernel: [ 3712.915010] wlan0: associate with 48:5d:60:e1:76:0e (try 1/3)
Jul 14 22:08:33 zurg kernel: [ 3712.923070] wlan0: RX AssocResp from 48:5d:60:e1:76:0e (capab=0x411 status=0 aid=3)
Jul 14 22:08:33 zurg kernel: [ 3712.931781] wlan0: associated
Jul 14 22:08:33 zurg kernel: [ 3712.931831] cfg80211: Calling CRDA for country: RU
Jul 14 22:08:33 zurg kernel: [ 3712.934361] cfg80211: Regulatory domain changed to country: RU
Jul 14 22:08:33 zurg kernel: [ 3712.934364] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 14 22:08:33 zurg kernel: [ 3712.934366] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 14 22:08:33 zurg kernel: [ 3712.934367] cfg80211:   (5735000 KHz - 5835000 KHz @ 20000 KHz), (N/A, 3000 mBm)
Jul 14 22:08:58 zurg kernel: [ 3737.685081] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:09:28 zurg kernel: [ 3767.706178] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:09:58 zurg kernel: [ 3797.727380] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:10:28 zurg kernel: [ 3827.748601] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:10:58 zurg kernel: [ 3857.769825] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:11:28 zurg kernel: [ 3887.791017] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:11:58 zurg kernel: [ 3917.812199] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:12:28 zurg kernel: [ 3947.833375] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:12:58 zurg kernel: [ 3977.854562] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:13:28 zurg kernel: [ 4007.875742] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:13:58 zurg kernel: [ 4037.896935] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:14:28 zurg kernel: [ 4067.918110] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:14:58 zurg kernel: [ 4097.939255] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:15:28 zurg kernel: [ 4127.960477] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

Jul 14 22:44:02 zurg kernel: [ 5839.167859] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:44:32 zurg kernel: [ 5869.189072] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:45:02 zurg kernel: [ 5899.210281] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:45:32 zurg kernel: [ 5929.231465] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:46:02 zurg kernel: [ 5959.252640] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:46:32 zurg kernel: [ 5989.273833] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:47:02 zurg kernel: [ 6019.295021] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:47:32 zurg kernel: [ 6049.316202] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:48:02 zurg kernel: [ 6079.337392] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:48:32 zurg kernel: [ 6109.358577] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:49:02 zurg kernel: [ 6139.379733] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:49:33 zurg kernel: [ 6169.400920] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:50:03 zurg kernel: [ 6199.422111] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:50:33 zurg kernel: [ 6229.443292] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:51:03 zurg kernel: [ 6259.464476] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:51:33 zurg kernel: [ 6289.485675] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
Jul 14 22:52:03 zurg kernel: [ 6319.506868] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING

soon after that kernel had crashed

[ 6349.664704] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6349.664709] mei_me 0000:00:16.0: version message writet failed
[ 6349.664711] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6349.664714] mei_me 0000:00:16.0: version message writet failed
[ 6349.664716] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[ 6349.664719] mei_me 0000:00:16.0: version message writet failed
[ 6349.988121] kernel tried to execute NX-protected page - exploit attempt? (uid: 1000)
[ 6349.988162] BUG: unable to handle kernel paging request at ffff88040b242000
[ 6349.988199] IP: [<ffff88040b242000>] 0xffff88040b241fff
[ 6349.988227] PGD 1ed4067 PUD 1ed7067 PMD 800000040b2001e3
[ 6349.988257] Oops: 0011 [#1] SMP
[ 6349.988276] Modules linked in: iwldvm iwlwifi nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc bridge stp llc 
tun fuse snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc 
thinkpad_acpi snd_seq_midi snd_seq_midi_event iTCO_wdt snd_rawmidi intel_powerclamp coretemp hid_logitech_dj cdc_ncm 
uvcvideo kvm_intel kvm usbnet videobuf2_vmalloc videobuf2_memops mii videobuf2_core videodev cdc_wdm cdc_acm snd_seq 
snd_seq_device snd_timer i915 snd soundcore lpc_ich mfd_core wmi drm_kms_helper sdhci_pci sdhci e1000e ptp
[ 6349.988581] CPU: 3 PID: 5297 Comm: xfce4-panel Tainted: G        W    3.10.1-zurg-00001-gaa457b5 #107
[ 6349.988622] Hardware name: LENOVO 4291QY6/4291QY6, BIOS 8DET51WW (1.21 ) 08/02/2011
[ 6349.988658] task: ffff88040a623e70 ti: ffff880409aec000 task.ti: ffff880409aec000
[ 6349.988691] RIP: 0010:[<ffff88040b242000>]  [<ffff88040b242000>] 0xffff88040b241fff
[ 6349.988728] RSP: 0018:ffff880409aedb98  EFLAGS: 00010006
[ 6349.988752] RAX: ffff8803f554b120 RBX: 00000000f554b138 RCX: 00000000000000c3
[ 6349.988785] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8803f554b120
[ 6349.988816] RBP: ffff880409aedbd8 R08: 00000000000000c3 R09: 001300360002051e
[ 6349.988849] R10: 010043e70007033e R11: 0100003201000004 R12: ffff88040a84c8c8
[ 6349.988880] R13: ffff8803f554b148 R14: 0000000000000001 R15: 0000000000000001
[ 6349.988913] FS:  00007f3779c239c0(0000) GS:ffff88041e2c0000(0000) knlGS:0000000000000000
[ 6349.988949] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6349.988975] CR2: ffff88040b242000 CR3: 000000040a390000 CR4: 00000000000407e0
[ 6349.989008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6349.989040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6349.989071] Stack:
[ 6349.989082]  ffffffff8107a7a8 0000000100000000 00000000000000c3 ffff88040a84c8c0
[ 6349.989121]  0000000000000001 0000000000000001 00000000000000c3 0000000000000286
[ 6349.989159]  ffff880409aedc10 ffffffff8107b994 ffff880405458340 00000000000000e4
[ 6349.989198] Call Trace:
[ 6349.989215]  [<ffffffff8107a7a8>] ? __wake_up_common+0x58/0x90
[ 6349.989244]  [<ffffffff8107b994>] __wake_up_sync_key+0x44/0x60
[ 6349.989272]  [<ffffffff8147b0da>] sock_def_readable+0x3a/0x70
[ 6349.989300]  [<ffffffff8153c6a8>] unix_stream_sendmsg+0x1f8/0x3f0
[ 6349.989330]  [<ffffffff81477a53>] sock_aio_write+0xe3/0x100
[ 6349.989357]  [<ffffffff811300dc>] do_sync_readv_writev+0x6c/0xa0
[ 6349.989386]  [<ffffffff8113138b>] do_readv_writev+0xbb/0x240
[ 6349.989414]  [<ffffffff8147865d>] ? SYSC_recvfrom+0x10d/0x140
[ 6349.989441]  [<ffffffff8113574f>] ? SYSC_newstat+0x2f/0x40
[ 6349.989468]  [<ffffffff811315a5>] vfs_writev+0x35/0x60
[ 6349.989493]  [<ffffffff811316b9>] SyS_writev+0x49/0xa0
[ 6349.989518]  [<ffffffff811439e5>] ? SyS_poll+0x65/0x100
[ 6349.989545]  [<ffffffff81630919>] system_call_fastpath+0x16/0x1b
[ 6349.989572] Code: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 <00> 40 97 0b 04 88 ff ff 08 20 24 0b 04 88 ff ff 08 20 24 0b 04
[ 6349.989748] RIP  [<ffff88040b242000>] 0xffff88040b241fff
[ 6349.989775]  RSP <ffff880409aedb98>
[ 6349.989792] CR2: ffff88040b242000

There was only one mine patch for intel gpu (https://bugs.freedesktop.org/show_bug.cgi?id=54089)
