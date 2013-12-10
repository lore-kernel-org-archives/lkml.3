Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3LJWHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:07:46 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:2591 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab3LJWHo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:07:44 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI9371I542I1432I14ffIzz1f42h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz8275ch1de098h8275bh8275dh1de097h186068hz2dh109h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h22d0h2336h1155h)
X-WSS-ID: 0MXM2NI-07-EIF-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Josh Boyer <jwboyer@fedoraproject.org>, Guenter Roeck <linux@roeck-us.net>,
        Dave Airlie <airlied@redhat.com>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: RE: Radeon crash with v3.13-rc3-157-g17b2112
Thread-Topic: Radeon crash with v3.13-rc3-157-g17b2112
Thread-Index: AQHO9fO7SIT1xErrR0GU70OVra6yEJpN+8fw
Date: Tue, 10 Dec 2013 22:07:36 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D030A9EC63@satlexdag05.amd.com>
References: <CA+5PVA747A4283Rz-_udrFZqihgYo3_YYKw4n8Qqv5oUNQfz1w@mail.gmail.com>
In-Reply-To: <CA+5PVA747A4283Rz-_udrFZqihgYo3_YYKw4n8Qqv5oUNQfz1w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: jwboyer@gmail.com [mailto:jwboyer@gmail.com] On Behalf Of Josh
> Boyer
> Sent: Tuesday, December 10, 2013 5:04 PM
> To: Deucher, Alexander; Guenter Roeck; Dave Airlie
> Cc: Linux-Kernel@Vger. Kernel. Org; DRI mailing list; Linus Torvalds
> Subject: Radeon crash with v3.13-rc3-157-g17b2112
> 
> Hi All,
> 
> Booting today's rawhide kernel fails on my Dell XPS 8300 machine.  I
> added nomodeset to the command line because it seemed to glitch out
> when doing the handoff to the radeon driver and that let me boot far
> enough to start networking.  I then loaded the radeon driver with:
> modprobe radeon modeset=1 and was greeted with the backtrace below.
> 
> I haven't done a bisect yet, but I can if needs be.  I was hoping this
> would trigger someone's memory.  Plain 3.13-rc3 works, so it's
> something in the DRM merge that Linus did after -rc3.  Given the
> backtrace, this one might be suspect:
> 
> commit ec39f64bba3421c2060fcbd1aeb6eec81fe0a42d
> Author: Guenter Roeck <linux@roeck-us.net>
> Date:   Fri Nov 22 21:52:00 2013 -0800
> 
>     drm/radeon/dpm: Convert to use devm_hwmon_register_with_groups
> 

Should be fixed by the patch in:
https://bugs.freedesktop.org/show_bug.cgi?id=72457

Alex

> josh
> 
> [  105.179966] [drm] radeon kernel modesetting enabled.
> [  105.202044] checking generic (d0000000 5b0000) vs hw (d0000000 10000000)
> [  105.202046] fb: conflicting fb hw usage radeondrmfb vs VESA VGA -
> removing generic driver
> [  105.224345] Console: switching to colour dummy device 80x25
> [  105.237823] [drm] initializing kernel modesetting (CAICOS
> 0x1002:0x6779 0x1B0A:0x909D).
> [  105.237931] [drm] register mmio base: 0xFE620000
> [  105.237934] [drm] register mmio size: 131072
> [  105.238185] ATOM BIOS: DeLL
> [  105.238929] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
> 0x000000003FFFFFFF (1024M used)
> [  105.238935] radeon 0000:01:00.0: GTT: 1024M 0x0000000040000000 -
> 0x000000007FFFFFFF
> [  105.238939] [drm] Detected VRAM RAM=1024M, BAR=256M
> [  105.238944] [drm] RAM width 64bits DDR
> [  105.241655] [TTM] Zone  kernel: Available graphics memory: 6130458 kiB
> [  105.241659] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> [  105.241662] [TTM] Initializing pool allocator
> [  105.242085] [TTM] Initializing DMA pool allocator
> [  105.243633] [drm] radeon: 1024M of VRAM memory ready
> [  105.243678] [drm] radeon: 1024M of GTT memory ready.
> [  105.287598] [drm] GART: num cpu pages 262144, num gpu pages 262144
> [  105.289406] [drm] enabling PCIE gen 2 link speeds, disable with
> radeon.pcie_gen2=0
> [  105.297354] [drm] Loading CAICOS Microcode
> [  105.332526] [drm] PCIE GART of 1024M enabled (table at
> 0x0000000000273000).
> [  105.334094] radeon 0000:01:00.0: WB enabled
> [  105.334100] radeon 0000:01:00.0: fence driver on ring 0 use gpu
> addr 0x0000000040000c00 and cpu addr 0xffff8803001ebc00
> [  105.334105] radeon 0000:01:00.0: fence driver on ring 3 use gpu
> addr 0x0000000040000c0c and cpu addr 0xffff8803001ebc0c
> [  105.345578] radeon 0000:01:00.0: fence driver on ring 5 use gpu
> addr 0x0000000000072118 and cpu addr 0xffffc90012d32118
> [  105.345640] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [  105.345643] [drm] Driver supports precise vblank timestamp query.
> [  105.345942] radeon 0000:01:00.0: irq 48 for MSI/MSI-X
> [  105.346091] radeon 0000:01:00.0: radeon: using MSI.
> [  105.346782] [drm] radeon: irq initialized.
> [  105.401411] [drm] ring test on 0 succeeded in 2 usecs
> [  105.401478] [drm] ring test on 3 succeeded in 1 usecs
> [  105.589796] [drm] ring test on 5 succeeded in 2 usecs
> [  105.589806] [drm] UVD initialized successfully.
> [  105.622555] [drm] Enabling audio 0 support
> [  105.622899] [drm] ib test on ring 0 succeeded in 0 usecs
> [  105.622954] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  105.623115] [drm] ib test on ring 3 succeeded in 0 usecs
> [  105.776249] [drm] ib test on ring 5 succeeded
> [  105.839096] [drm] Radeon Display Connectors
> [  105.839100] [drm] Connector 0:
> [  105.839102] [drm]   HDMI-A-1
> [  105.839104] [drm]   HPD2
> [  105.839106] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468
> 0x646c 0x646c
> [  105.839109] [drm]   Encoders:
> [  105.839111] [drm]     DFP1: INTERNAL_UNIPHY1
> [  105.839113] [drm] Connector 1:
> [  105.839114] [drm]   DVI-D-1
> [  105.839116] [drm]   HPD4
> [  105.839118] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458
> 0x645c 0x645c
> [  105.839121] [drm]   Encoders:
> [  105.839123] [drm]     DFP2: INTERNAL_UNIPHY
> [  105.839124] [drm] Connector 2:
> [  105.839126] [drm]   VGA-1
> [  105.839128] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438
> 0x643c 0x643c
> [  105.839131] [drm]   Encoders:
> [  105.839133] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> [  105.839439] [drm] Internal thermal controller with fan control
> [  105.840309] BUG: unable to handle kernel paging request at
> 000000010000211f
> [  105.840316] IP: [<ffffffffa075afdd>]
> hwmon_attributes_visible+0x1d/0x50 [radeon]
> [  105.840342] PGD 319c07067 PUD 0
> [  105.840346] Oops: 0000 [#1] SMP
> [  105.840349] Modules linked in: radeon(+) ipt_MASQUERADE iptable_nat
> nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle tun bridge stp llc
> ebtable_nat ebtables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_intel x86_pkg_temp_thermal arc4 brcmsmac cordic brcmutil
> snd_hda_codec coretemp b43 kvm_intel snd_hwdep snd_seq kvm
> snd_seq_device snd_pcm mac80211 cfg80211 broadcom tg3 ptp ssb
> mmc_core
> rfkill snd_page_alloc snd_timer crct10dif_pclmul bcma snd iTCO_wdt
> pps_core crc32_pclmul crc32c_intel mei_me iTCO_vendor_support mei
> lpc_ich ghash_clmulni_intel mfd_core i2c_i801 soundcore shpchp dcdbas
> serio_raw microcode nfsd auth_rpcgss nfs_acl lockd sunrpc binfmt_misc
> i2c_algo_bit
> [  105.840403]  drm_kms_helper ttm usb_storage drm i2c_core
> [  105.840408] CPU: 1 PID: 1403 Comm: modprobe Not tainted
> 3.13.0-0.rc3.git1.1.fc21.x86_64 #1
> [  105.840413] Hardware name: Dell Inc. XPS 8300  /0Y2MRG, BIOS A06
> 10/17/2011
> [  105.840416] task: ffff8802fe038000 ti: ffff8803101fe000 task.ti:
> ffff8803101fe000
> [  105.840419] RIP: 0010:[<ffffffffa075afdd>]  [<ffffffffa075afdd>]
> hwmon_attributes_visible+0x1d/0x50 [radeon]
> [  105.840438] RSP: 0018:ffff8803101ff8a8  EFLAGS: 00010282
> [  105.840441] RAX: 00000000ffffffff RBX: ffffffffa0825000 RCX:
> 0000000000000006
> [  105.840444] RDX: 0000000000000000 RSI: ffffffffa0825000 RDI:
> ffff8802e8001be0
> [  105.840446] RBP: ffff8803101ff8b0 R08: 0000000000000000 R09:
> 0000000000000000
> [  105.840449] R10: 0000000000000001 R11: 0000000000000000 R12:
> ffff8802e8001bf0
> [  105.840452] R13: 0000000000000000 R14: ffffffffa07df800 R15:
> ffffffffa0824f60
> [  105.840455] FS:  00007fe6cdbb6740(0000) GS:ffff880322000000(0000)
> knlGS:0000000000000000
> [  105.840459] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  105.840462] CR2: 000000010000211f CR3: 00000002f157a000 CR4:
> 00000000000407e0
> [  105.840465] Stack:
> [  105.840466]  0000000000000000 ffff8803101ff900 ffffffff81285363
> ffffffff8128413b
> [  105.840472]  ffff8802e8016250 ffff8802e8016250 0000000000000000
> 0000000000000000
> [  105.840476]  ffffffffa0824f40 ffff8802e8001bf0 ffffffff81d23420
> ffff8803101ff930
> [  105.840481] Call Trace:
> [  105.840485]  [<ffffffff81285363>] internal_create_group+0xc3/0x280
> [  105.840490]  [<ffffffff8128413b>] ? sysfs_addrm_finish+0x1b/0x70
> [  105.840494]  [<ffffffff8128573a>] sysfs_create_groups+0x4a/0xa0
> [  105.840498]  [<ffffffff8149e9be>] device_add+0x43e/0x660
> [  105.840502]  [<ffffffff8149ebfa>] device_register+0x1a/0x20
> [  105.840506]  [<ffffffff8158c272>]
> hwmon_device_register_with_groups+0xc2/0x120
> [  105.840522]  [<ffffffffa075b39a>] radeon_hwmon_init+0x6a/0x90 [radeon]
> [  105.840538]  [<ffffffffa075d27b>] radeon_pm_init+0x56b/0x970 [radeon]
> [  105.840554]  [<ffffffffa07292cc>] radeon_modeset_init+0x41c/0x9c0
> [radeon]
> [  105.840569]  [<ffffffffa0702218>] radeon_driver_load_kms+0xe8/0x220
> [radeon]
> [  105.840580]  [<ffffffffa001b444>] drm_dev_register+0xa4/0x1e0 [drm]
> [  105.840588]  [<ffffffffa001d512>] drm_get_pci_dev+0x92/0x140 [drm]
> [  105.840603]  [<ffffffffa06fe449>] radeon_pci_probe+0xa9/0xd0 [radeon]
> [  105.840607]  [<ffffffff813bf6c5>] local_pci_probe+0x45/0xa0
> [  105.840611]  [<ffffffff813c0935>] ? pci_match_device+0xc5/0xd0
> [  105.840615]  [<ffffffff813c0a91>] pci_device_probe+0x111/0x120
> [  105.840619]  [<ffffffff814a1a65>] driver_probe_device+0x125/0x3a0
> [  105.840622]  [<ffffffff814a1db3>] __driver_attach+0x93/0xa0
> [  105.840626]  [<ffffffff814a1d20>] ? __device_attach+0x40/0x40
> [  105.840629]  [<ffffffff8149f90b>] bus_for_each_dev+0x6b/0xb0
> [  105.840632]  [<ffffffff814a13ee>] driver_attach+0x1e/0x20
> [  105.840636]  [<ffffffff814a0fc8>] bus_add_driver+0x188/0x260
> [  105.840640]  [<ffffffffa084c000>] ? 0xffffffffa084bfff
> [  105.840644]  [<ffffffff814a2424>] driver_register+0x64/0xf0
> [  105.840647]  [<ffffffffa084c000>] ? 0xffffffffa084bfff
> [  105.840651]  [<ffffffff813bf070>] __pci_register_driver+0x60/0x70
> [  105.840659]  [<ffffffffa001d6da>] drm_pci_init+0x11a/0x130 [drm]
> [  105.840663]  [<ffffffffa084c000>] ? 0xffffffffa084bfff
> [  105.840675]  [<ffffffffa084c09c>] radeon_init+0x9c/0xba [radeon]
> [  105.840679]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
> [  105.840683]  [<ffffffff8105ced3>] ? set_memory_nx+0x43/0x50
> [  105.840688]  [<ffffffff8110682b>] load_module+0x1eab/0x26d0
> [  105.840692]  [<ffffffff81101de0>] ? store_uevent+0x40/0x40
> [  105.840696]  [<ffffffff811071e6>] SyS_finit_module+0x86/0xb0
> [  105.840708]  [<ffffffff817682e9>] system_call_fastpath+0x16/0x1b
> [  105.840710] Code: c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66
> 66 66 90 55 48 83 ef 10 48 89 e5 53 48 89 f3 e8 9a 61 d4 e0 48 8b 80
> 60 04 00 00 <83> b8 20 21 00 00 02 74 12 48 81 fb c0 4f 82 a0 74 11 48
> 81 fb
> [  105.840750] RIP  [<ffffffffa075afdd>]
> hwmon_attributes_visible+0x1d/0x50 [radeon]
> [  105.840767]  RSP <ffff8803101ff8a8>
> [  105.840769] CR2: 000000010000211f
> [  105.840781] ---[ end trace 6a7e0717b7614a5d ]---
> [  105.924812] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  106.225933] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  106.527171] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  106.828275] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  107.129455] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  107.430532] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  107.731724] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD
> [  108.032805] ALSA sound/pci/hda/hda_eld.c:684 HDMI ATI/AMD: no
> speaker allocation for ELD


