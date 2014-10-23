Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbaJWTV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:21:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:12585 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaJWTVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:21:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="405001353"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Arnd Hannemann <arnd@arndnet.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Ilw] WARNING: drivers/net/wireless/iwlwifi/mvm/tx.c:197
 iwl_mvm_set_tx_params+0x5f4/0x630 [iwlmvm]()
Thread-Topic: [Ilw] WARNING: drivers/net/wireless/iwlwifi/mvm/tx.c:197
 iwl_mvm_set_tx_params+0x5f4/0x630 [iwlmvm]()
Thread-Index: AQHP7vToxh1K35tli0296vSR1ex4rZw+DvFw
Date: Thu, 23 Oct 2014 19:21:12 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B55331A@hasmsx107.ger.corp.intel.com>
References: <5449525A.6000009@arndnet.de>
In-Reply-To: <5449525A.6000009@arndnet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9NJM2xG018393

> Hi,
> 
> on recent Linus git, I regulary get the following backtrace (since 3.17 around
> or so).
> HW is Intel Corporation Wireless 7260 (rev 83)
> 
> [ 1774.340980] ------------[ cut here ]------------
> [ 1774.341003] WARNING: CPU: 2 PID: 2402 at
> /home/arnd/Projekte/kernel/linux-
> 2.6/drivers/net/wireless/iwlwifi/mvm/tx.c:197
> iwl_mvm_set_tx_params+0x5f4/0x630 [iwlmvm]()

Yep  - fix is in my tree already.

> [ 1774.341004] Got an HT rate for a non data frame 0x8
> [ 1774.341005] Modules linked in: ccm xt_CHECKSUM iptable_mangle
> xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter ip_tables
> ebtable_nat ebtables x_tables dm_crypt cdc_ncm uvcvideo usbnet
> videobuf2_vmalloc videobuf2_memops mii videobuf2_core cdc_wdm
> cdc_acm v4l2_common videodev media btusb deflate ctr twofish_generic
> twofish_x86_64_3way twofish_x86_64 twofish_common camellia_generic
> camellia_x86_64 serpent_sse2_x86_64 serpent_generic xts blowfish_generic
> blowfish_x86_64 blowfish_common cast5_generic cast_common
> des3_ede_x86_64 des_generic cmac xcbc rmd160 sha512_generic
> crypto_null af_key xfrm_algo rfcomm bnep bluetooth arc4 binfmt_misc
> snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi
> x86_pkg_temp_thermal coretemp kvm_intel dm_multipath kvm
> ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul
> glue_helper snd_hda_intel microcode snd_hda_controller joydev serio_raw
> iwlmvm snd_hda_codec lpc_ich mac80211 snd_hwdep wmi thinkpad_
>  acpi nvra
> m tpm_tis snd_pcm iwlwifi cfg80211 snd_seq_midi snd_seq_midi_event
> snd_rawmidi snd_seq snd_seq_device snd_timer snd xhci_pci xhci_hcd
> soundcore btrfs xor raid6_pq rtsx_pci_sdmmc rtsx_pci psmouse i915
> i2c_algo_bit drm_kms_helper ahci libahci e1000e ptp drm pps_core video
> [ 1774.341060] CPU: 2 PID: 2402 Comm: wpa_supplicant Tainted: P
> 3.18.0-rc1aha+ #1
> [ 1774.341061] Hardware name: LENOVO 20AQCTO1WW/20AQCTO1WW,
> BIOS GJET79WW (2.29 ) 09/03/2014
> [ 1774.341063]  0000000000000009 ffff880302b93728 ffffffff8168e85a
> 0000000000000000
> [ 1774.341065]  ffff880302b93778 ffff880302b93768 ffffffff8104c5d1
> ffff880302b937d8
> [ 1774.341067]  ffff8802e4a82480 ffff8800a520b026 0000000000000000
> ffff88030d7f9a88
> [ 1774.341069] Call Trace:
> [ 1774.341074]  [<ffffffff8168e85a>] dump_stack+0x46/0x58
> [ 1774.341078]  [<ffffffff8104c5d1>] warn_slowpath_common+0x81/0xa0
> [ 1774.341080]  [<ffffffff8104c636>] warn_slowpath_fmt+0x46/0x50
> [ 1774.341089]  [<ffffffffc06f97a4>] iwl_mvm_set_tx_params+0x5f4/0x630
> [iwlmvm]
> [ 1774.341095]  [<ffffffffc06f9a24>] iwl_mvm_tx_skb+0x54/0x350 [iwlmvm]
> [ 1774.341101]  [<ffffffffc06f152f>] iwl_mvm_mac_tx+0xaf/0x1b0 [iwlmvm]
> [ 1774.341104]  [<ffffffff8104c7c6>] ? put_online_cpus+0x56/0x80
> [ 1774.341120]  [<ffffffffc060cf91>] __ieee80211_tx+0x271/0x380 [mac80211]
> [ 1774.341133]  [<ffffffffc060f7ca>] ieee80211_tx+0xca/0x100 [mac80211]
> [ 1774.341144]  [<ffffffffc060fa01>] ieee80211_xmit+0xa1/0x100 [mac80211]
> [ 1774.341155]  [<ffffffffc061033a>]
> ieee80211_subif_start_xmit+0x66a/0xd10 [mac80211]
> [ 1774.341160]  [<ffffffff8159a019>] dev_hard_start_xmit+0x169/0x3d0
> [ 1774.341163]  [<ffffffff815ba362>] sch_direct_xmit+0xe2/0x1e0
> [ 1774.341166]  [<ffffffff8159a4c7>] __dev_queue_xmit+0x247/0x560
> [ 1774.341168]  [<ffffffff8159a7f0>] dev_queue_xmit+0x10/0x20
> [ 1774.341171]  [<ffffffff81675c5d>] packet_sendmsg+0xe8d/0x1130
> [ 1774.341174]  [<ffffffff8157f132>] ? sock_recvmsg+0xa2/0xd0
> [ 1774.341176]  [<ffffffff8157ee43>] sock_sendmsg+0x93/0xd0
> [ 1774.341179]  [<ffffffff811aee00>] ? evict+0x110/0x180
> [ 1774.341182]  [<ffffffff811a9c2b>] ? __d_free+0x2b/0x50
> [ 1774.341185]  [<ffffffff811b0f33>] ? __fdget+0x13/0x20
> [ 1774.341187]  [<ffffffff8157eff1>] SYSC_sendto+0x121/0x1c0
> [ 1774.341189]  [<ffffffff81580032>] ? __sys_recvmsg+0x42/0x80
> [ 1774.341192]  [<ffffffff8157fb0e>] SyS_sendto+0xe/0x10
> [ 1774.341194]  [<ffffffff81695452>] system_call_fastpath+0x12/0x17
> [ 1774.341195] ---[ end trace f25bbefa3f5a7aa1 ]---
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
