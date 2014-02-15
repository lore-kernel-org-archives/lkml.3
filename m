Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaBOS2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 13:28:17 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:34062 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbaBOS2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 13:28:16 -0500
Message-ID: <52FFB1BE.8060408@msgid.tls.msk.ru>
Date: Sat, 15 Feb 2014 22:28:14 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: screen goes blank when loading gma500_gfx (atom D2500)
References: <52F68BEF.5030305@msgid.tls.msk.ru> <20140210104431.63f1a754@alan.etchedpixels.co.uk>
In-Reply-To: <20140210104431.63f1a754@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.5.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10.02.2014 14:44, One Thousand Gnomes wrote:
>> fbcon is loaded so it isn't an issue.
>>
>> I tried 3.10 kernel initially (the above messages are from it), next
>> I tried 3.13 kernel too, and that one behaves exactly the same.
>>
>> As far as I remember, this system never worked with graphics well.
>> Previous kernel (from which I updated) was 3.2 which had no
>> gma500 module (local build).
>>
>> What are the steps to debug this further?
> 
> Check you have X86_SYSFB and SIMPLEFB disabled

Neither of these options exists in 3.10 config.  In 3.13 I had X86_SYSFB set
to y initially (SIMPLEFB doesn't exist there too), but setting it to n does
not make any difference.

> Boot with drm.debug=6
> 
> collect the logs

I used `modprobe drm debug=6' (initially booting with gma500_gfx module
disabled), followed with `modprobe gma500_gfx'.  After loading module
the screen goes blank as before, and monitor says 'no signal detected'.

Here are the logs:

[599286.739923] Linux agpgart interface v0.103
[599286.765176] [drm] Initialized drm 1.1.0 20060810
[599303.673734] gma500 0000:00:02.0: setting latency timer to 64
[599303.673883] [drm:psb_intel_opregion_setup], Public ACPI methods supported
[599303.673887] [drm:psb_intel_opregion_setup], ASLE supported
[599303.673923] gma500 0000:00:02.0: irq 50 for MSI/MSI-X
[599303.673950] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT CEDARVIEW      d
[599303.673959] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[599303.673969] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[599303.673975] [drm:parse_edp], EDP timing in vbt t1_t3 2000 t8 10 t9 2000 t10 500 t11_t12 5000
[599303.673980] [drm:parse_edp], VBT reports EDP: Lane_count 1, Lane_rate 6, Bpp 24
[599303.673984] [drm:parse_edp], VBT reports EDP: VSwing  0, Preemph 0
[599303.688094] acpi device:29: registered as cooling_device2
[599303.688446] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[599303.688557] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
[599303.689160] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[599303.689188] [drm] No driver support for vblank timestamp query.
[599303.740423] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSDDC_C
[599303.741222] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-B
[599303.741732] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
[599303.741736] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
[599303.742242] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
[599303.742246] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
[599303.742997] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-C
[599303.743305] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.743510] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.783922] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[599303.803958] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[599303.803996] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
[599303.844370] [drm:cdv_intel_single_pipe_active], pipe enabled 0
[599303.864408] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
[599303.877172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
[599303.877184] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1]
[599303.881764] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSBLC_B
[599303.881778] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1] probed modes :
[599303.881783] [drm:drm_mode_debug_printmodeline], Modeline 22:"1920x1080" 60 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
[599303.881791] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1]
[599303.886292] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
[599303.886298] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1] disconnected
[599303.886304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
[599303.886811] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
[599303.886815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
[599303.886820] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2]
[599303.891350] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
[599303.891357] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2] disconnected
[599303.891362] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2]
[599303.891569] [drm:cdv_dp_detect], DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
[599303.891876] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.892082] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.892085] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.892391] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.892595] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.892598] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.892904] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.893109] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.893112] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.893417] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.893622] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.893625] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.893944] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.894151] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.894154] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.894460] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.894665] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.894669] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.894975] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.895180] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.895183] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.895489] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.895694] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.895697] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.896002] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.896207] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.896210] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.896515] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.896720] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599303.896723] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599303.896741] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2] probed modes :
[599303.896745] [drm:drm_mode_debug_printmodeline], Modeline 27:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[599303.896752] [drm:drm_mode_debug_printmodeline], Modeline 25:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[599303.896759] [drm:drm_mode_debug_printmodeline], Modeline 24:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
[599303.896766] [drm:drm_mode_debug_printmodeline], Modeline 26:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
[599303.896773] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
[599303.896780] [drm:drm_setup_crtcs],
[599303.896785] [drm:drm_enable_connectors], connector 7 enabled? no
[599303.896789] [drm:drm_enable_connectors], connector 9 enabled? yes
[599303.896792] [drm:drm_enable_connectors], connector 12 enabled? no
[599303.896796] [drm:drm_enable_connectors], connector 14 enabled? no
[599303.896800] [drm:drm_enable_connectors], connector 18 enabled? no
[599303.896803] [drm:drm_enable_connectors], connector 20 enabled? yes
[599303.896807] [drm:drm_target_preferred], looking for cmdline mode on connector 9
[599303.896811] [drm:drm_target_preferred], looking for preferred mode on connector 9
[599303.896815] [drm:drm_target_preferred], found mode 1920x1080
[599303.896818] [drm:drm_target_preferred], looking for cmdline mode on connector 20
[599303.896821] [drm:drm_target_preferred], looking for preferred mode on connector 20
[599303.896825] [drm:drm_target_preferred], found mode 1024x768
[599303.896828] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
[599303.896836] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 4
[599303.896841] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 3
[599303.896862] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
[599546.148642] [drm:drm_helper_hpd_irq_event], [CONNECTOR:7:VGA-1] status updated from disconnected to connected
[599546.153261] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
[599546.153270] [drm:drm_helper_hpd_irq_event], [CONNECTOR:12:DVI-D-1] status updated from disconnected to disconnected
[599546.153779] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
[599546.153783] [drm:drm_helper_hpd_irq_event], [CONNECTOR:14:DP-1] status updated from disconnected to disconnected
[599546.158258] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
[599546.158264] [drm:drm_helper_hpd_irq_event], [CONNECTOR:18:DVI-D-2] status updated from disconnected to disconnected
[599546.158471] [drm:cdv_dp_detect], DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
[599546.158780] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.158987] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.158991] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599546.159297] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.159502] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.159505] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599546.159810] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.160015] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.160018] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599546.160324] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.160528] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
[599546.160531] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
[599546.160843] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack

This is 3.10.29, monitor is connected to VGA connector.

Thank you!

/mjt
