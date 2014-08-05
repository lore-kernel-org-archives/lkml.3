Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaHEQWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:22:17 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:56251 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbaHEQWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:22:15 -0400
Message-ID: <53E1033E.8060605@msgid.tls.msk.ru>
Date: Tue, 05 Aug 2014 20:15:58 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: screen goes blank when loading gma500_gfx (atom D2500)
References: <52F68BEF.5030305@msgid.tls.msk.ru> <20140210104431.63f1a754@alan.etchedpixels.co.uk> <52FFB1BE.8060408@msgid.tls.msk.ru> <533FBB96.5010602@msgid.tls.msk.ru> <53E1024A.2040309@msgid.tls.msk.ru>
In-Reply-To: <53E1024A.2040309@msgid.tls.msk.ru>
X-Enigmail-Version: 1.6
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

05.08.2014 20:11, Michael Tokarev wrote:
> Hello again.
> 
> It's been 4 more months since last message in this thread (which was mine).
> Now kernel 3.16 has been released, and I decided to give it a try.  And it
> behaves just like all previous kernels, -- once gma500_gfx module is loaded,
> screen goes blank, monitor turns off ("no signal detected") and nothing to
> be seen until reboot.
> 
> Can we try to debug this somehow, after more than half a year?... :)

Current debugging (by 3.16), after:

 modprobe drm debug=6
 modprobe gma500_gfx

on a freshly booted system:

[   46.463381] Linux agpgart interface v0.103
[   46.491487] [drm] Initialized drm 1.1.0 20060810
[   56.585520] [drm:psb_intel_opregion_setup] Public ACPI methods supported
[   56.585528] [drm:psb_intel_opregion_setup] ASLE supported
[   56.585563] gma500 0000:00:02.0: irq 50 for MSI/MSI-X
[   56.585591] [drm:psb_intel_init_bios] Using VBT from OpRegion: $VBT CEDARVIEW      d
[   56.585604] [drm:drm_mode_debug_printmodeline] Modeline 0:"1920x1080" 0 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[   56.585609] [drm:parse_sdvo_device_mapping] No SDVO device info is found in VBT
[   56.585617] [drm:parse_edp] EDP timing in vbt t1_t3 2000 t8 10 t9 2000 t10 500 t11_t12 5000
[   56.585621] [drm:parse_edp] VBT reports EDP: Lane_count 1, Lane_rate 6, Bpp 24
[   56.585624] [drm:parse_edp] VBT reports EDP: VSwing  0, Preemph 0
[   56.598203] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   56.598902] acpi device:28: registered as cooling_device2
[   56.599109] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input11
[   56.599326] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[   56.599366] [drm] No driver support for vblank timestamp query.
[   56.650918] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter intel drm LVDSDDC_C
[   56.651842] [drm:cdv_intel_dp_i2c_init] i2c_init DPDDC-B
[   56.652352] [drm:cdv_intel_dp_aux_ch] dp_aux_ch timeout status 0x51440064
[   56.652356] [drm:cdv_intel_dp_i2c_aux_ch] aux_ch failed -110
[   56.652863] [drm:cdv_intel_dp_aux_ch] dp_aux_ch timeout status 0x51440064
[   56.652866] [drm:cdv_intel_dp_i2c_aux_ch] aux_ch failed -110
[   56.653706] [drm:cdv_intel_dp_i2c_init] i2c_init DPDDC-C
[   56.654014] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.654223] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.714765] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[   56.714812] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[   56.775220] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:10:VGA-1]
[   56.900606] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:10:VGA-1] probed modes :
[   56.900617] [drm:drm_mode_debug_printmodeline] Modeline 26:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
[   56.900624] [drm:drm_mode_debug_printmodeline] Modeline 36:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   56.900630] [drm:drm_mode_debug_printmodeline] Modeline 29:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
[   56.900637] [drm:drm_mode_debug_printmodeline] Modeline 28:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   56.900643] [drm:drm_mode_debug_printmodeline] Modeline 37:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   56.900649] [drm:drm_mode_debug_printmodeline] Modeline 38:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
[   56.900656] [drm:drm_mode_debug_printmodeline] Modeline 39:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   56.900662] [drm:drm_mode_debug_printmodeline] Modeline 40:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
[   56.900669] [drm:drm_mode_debug_printmodeline] Modeline 41:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   56.900675] [drm:drm_mode_debug_printmodeline] Modeline 42:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
[   56.900681] [drm:drm_mode_debug_printmodeline] Modeline 30:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   56.900687] [drm:drm_mode_debug_printmodeline] Modeline 31:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   56.900694] [drm:drm_mode_debug_printmodeline] Modeline 32:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
[   56.900700] [drm:drm_mode_debug_printmodeline] Modeline 33:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
[   56.900706] [drm:drm_mode_debug_printmodeline] Modeline 34:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   56.900713] [drm:drm_mode_debug_printmodeline] Modeline 35:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   56.900719] [drm:drm_mode_debug_printmodeline] Modeline 27:"640x350" 70 25170 640 656 752 800 350 387 389 449 0x40 0x9
[   56.900724] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:12:LVDS-1]
[   56.905268] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter intel drm LVDSBLC_B
[   56.905276] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:12:LVDS-1] probed modes :
[   56.905283] [drm:drm_mode_debug_printmodeline] Modeline 43:"1920x1080" 60 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[   56.905288] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:15:DVI-D-1]
[   56.909759] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter intel drm HDMIB
[   56.909765] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:15:DVI-D-1] disconnected
[   56.909770] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:DP-1]
[   56.910277] [drm:cdv_intel_dp_aux_ch] dp_aux_ch timeout status 0x51440064
[   56.910281] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:17:DP-1] disconnected
[   56.910285] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:21:DVI-D-2]
[   56.914833] [drm:drm_do_probe_ddc_edid] drm: skipping non-existent adapter intel drm HDMIC
[   56.914839] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:21:DVI-D-2] disconnected
[   56.914844] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:23:DP-2]
[   56.915051] [drm:cdv_dp_detect] DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
[   56.915423] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.915630] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.915634] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.915940] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.916145] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.916149] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.916454] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.916659] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.916663] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.916969] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.917173] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.917176] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.917482] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.917686] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.917689] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.917996] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.918204] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.918209] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.918514] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.918719] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.918723] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.919028] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.919233] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.919237] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.919542] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.919747] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.919750] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.920055] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.920260] [drm:cdv_intel_dp_i2c_aux_ch] aux_i2c nack
[   56.920263] [drm:i2c_algo_dp_aux_xfer] dp_aux_xfer return -121
[   56.920281] [drm:drm_helper_probe_single_connector_modes_merge_bits] [CONNECTOR:23:DP-2] probed modes :
[   56.920288] [drm:drm_mode_debug_printmodeline] Modeline 48:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   56.920295] [drm:drm_mode_debug_printmodeline] Modeline 46:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   56.920301] [drm:drm_mode_debug_printmodeline] Modeline 45:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[   56.920308] [drm:drm_mode_debug_printmodeline] Modeline 47:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[   56.920314] [drm:drm_mode_debug_printmodeline] Modeline 44:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[   56.920318] [drm:drm_setup_crtcs]
[   56.920324] [drm:drm_enable_connectors] connector 10 enabled? yes
[   56.920327] [drm:drm_enable_connectors] connector 12 enabled? yes
[   56.920331] [drm:drm_enable_connectors] connector 15 enabled? no
[   56.920335] [drm:drm_enable_connectors] connector 17 enabled? no
[   56.920338] [drm:drm_enable_connectors] connector 21 enabled? no
[   56.920342] [drm:drm_enable_connectors] connector 23 enabled? yes
[   56.920346] [drm:drm_target_preferred] looking for cmdline mode on connector 10
[   56.920349] [drm:drm_target_preferred] looking for preferred mode on connector 10
[   56.920353] [drm:drm_target_preferred] found mode 1280x1024
[   56.920356] [drm:drm_target_preferred] looking for cmdline mode on connector 12
[   56.920360] [drm:drm_target_preferred] looking for preferred mode on connector 12
[   56.920363] [drm:drm_target_preferred] found mode 1920x1080
[   56.920367] [drm:drm_target_preferred] looking for cmdline mode on connector 23
[   56.920370] [drm:drm_target_preferred] looking for preferred mode on connector 23
[   56.920373] [drm:drm_target_preferred] found mode 1024x768
[   56.920377] [drm:drm_setup_crtcs] picking CRTCs for 4096x4096 config
[   56.920388] [drm:drm_setup_crtcs] desired mode 1280x1024 set on crtc 5
[   56.920397] [drm:drm_setup_crtcs] desired mode 1920x1080 set on crtc 7
[   56.920417] [drm] Initialized gma500 1.0.0 20140314 for 0000:00:02.0 on minor 0

Thanks,

/mjt

