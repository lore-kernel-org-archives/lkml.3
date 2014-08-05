Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaHEQRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 12:17:16 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:51814 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaHEQRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 12:17:14 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Aug 2014 12:17:14 EDT
Message-ID: <53E1024A.2040309@msgid.tls.msk.ru>
Date: Tue, 05 Aug 2014 20:11:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: screen goes blank when loading gma500_gfx (atom D2500)
References: <52F68BEF.5030305@msgid.tls.msk.ru> <20140210104431.63f1a754@alan.etchedpixels.co.uk> <52FFB1BE.8060408@msgid.tls.msk.ru> <533FBB96.5010602@msgid.tls.msk.ru>
In-Reply-To: <533FBB96.5010602@msgid.tls.msk.ru>
X-Enigmail-Version: 1.6
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again.

It's been 4 more months since last message in this thread (which was mine).
Now kernel 3.16 has been released, and I decided to give it a try.  And it
behaves just like all previous kernels, -- once gma500_gfx module is loaded,
screen goes blank, monitor turns off ("no signal detected") and nothing to
be seen until reboot.

Can we try to debug this somehow, after more than half a year?... :)

Thank you,

/mjt

05.04.2014 12:15, Michael Tokarev wrote:
> Hello again
> 
> It's been about 2 months since I sent the original debugging output.  Today I tried
> out 3.14 kernel.  And this one behaves quite similarly, screen goes blank right
> when loading gma500_gfx module.  Here's the dmesg from a freshly booted system
> after doing
> 
>   modprobe drm debug=6
>   modprobe gma500_gfx
> 
> with a monitor connected to VGA port (before loading gma500_gfx, it displays the
> regular text console):
> 
> [   39.863330] Linux agpgart interface v0.103
> [   39.900511] [drm] Initialized drm 1.1.0 20060810
> [   45.012300] [drm:psb_intel_opregion_setup], Public ACPI methods supported
> [   45.012308] [drm:psb_intel_opregion_setup], ASLE supported
> [   45.012345] gma500 0000:00:02.0: irq 50 for MSI/MSI-X
> [   45.012371] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT CEDARVIEW      d
> [   45.012384] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
> [   45.012389] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
> [   45.012397] [drm:parse_edp], EDP timing in vbt t1_t3 2000 t8 10 t9 2000 t10 500 t11_t12 5000
> [   45.012401] [drm:parse_edp], VBT reports EDP: Lane_count 1, Lane_rate 6, Bpp 24
> [   45.012405] [drm:parse_edp], VBT reports EDP: VSwing  0, Preemph 0
> [   45.012478] gma500 0000:00:02.0: GPU: power management timed out.
> [   45.026195] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   45.026891] acpi device:29: registered as cooling_device2
> [   45.027104] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
> [   45.027681] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
> [   45.027726] [drm] No driver support for vblank timestamp query.
> [   45.078928] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSDDC_C
> [   45.079839] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-B
> [   45.080383] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
> [   45.080388] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
> [   45.080896] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
> [   45.080899] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
> [   45.081754] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-C
> [   45.082062] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.082272] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.122742] [drm:cdv_intel_single_pipe_active], pipe enabled 0
> [   45.142780] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
> [   45.142826] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
> [   45.183207] [drm:cdv_intel_single_pipe_active], pipe enabled 0
> [   45.203249] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
> [   45.332286] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] probed modes :
> [   45.332297] [drm:drm_mode_debug_printmodeline], Modeline 23:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x48 0x5
> [   45.332304] [drm:drm_mode_debug_printmodeline], Modeline 33:"1280x1024" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
> [   45.332311] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x1024" 72 132840 1280 1368 1504 1728 1024 1025 1028 1067 0x0 0x6
> [   45.332318] [drm:drm_mode_debug_printmodeline], Modeline 25:"1152x864" 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
> [   45.332325] [drm:drm_mode_debug_printmodeline], Modeline 34:"1024x768" 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
> [   45.332332] [drm:drm_mode_debug_printmodeline], Modeline 35:"1024x768" 70 75000 1024 1048 1184 1328 768 771 777 806 0x40 0xa
> [   45.332338] [drm:drm_mode_debug_printmodeline], Modeline 36:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   45.332345] [drm:drm_mode_debug_printmodeline], Modeline 37:"832x624" 75 57284 832 864 928 1152 624 625 628 667 0x40 0xa
> [   45.332352] [drm:drm_mode_debug_printmodeline], Modeline 38:"800x600" 75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
> [   45.332359] [drm:drm_mode_debug_printmodeline], Modeline 39:"800x600" 72 50000 800 856 976 1040 600 637 643 666 0x40 0x5
> [   45.332365] [drm:drm_mode_debug_printmodeline], Modeline 27:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   45.332372] [drm:drm_mode_debug_printmodeline], Modeline 28:"640x480" 75 31500 640 656 720 840 480 481 484 500 0x40 0xa
> [   45.332379] [drm:drm_mode_debug_printmodeline], Modeline 29:"640x480" 73 31500 640 664 704 832 480 489 491 520 0x40 0xa
> [   45.332385] [drm:drm_mode_debug_printmodeline], Modeline 30:"640x480" 67 30240 640 704 768 864 480 483 486 525 0x40 0xa
> [   45.332392] [drm:drm_mode_debug_printmodeline], Modeline 31:"640x480" 60 25200 640 656 752 800 480 490 492 525 0x40 0xa
> [   45.332398] [drm:drm_mode_debug_printmodeline], Modeline 32:"720x400" 70 28320 720 738 846 900 400 412 414 449 0x40 0x6
> [   45.332405] [drm:drm_mode_debug_printmodeline], Modeline 24:"640x350" 70 25170 640 656 752 800 350 387 389 449 0x40 0x9
> [   45.332411] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1]
> [   45.336961] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSBLC_B
> [   45.336970] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1] probed modes :
> [   45.336977] [drm:drm_mode_debug_printmodeline], Modeline 40:"1920x1080" 60 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
> [   45.336982] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1]
> [   45.341442] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
> [   45.341448] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1] disconnected
> [   45.341453] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
> [   45.341961] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
> [   45.341966] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
> [   45.341971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2]
> [   45.346467] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
> [   45.346474] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2] disconnected
> [   45.346479] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2]
> [   45.346686] [drm:cdv_dp_detect], DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
> [   45.346993] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.347199] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.347202] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.347508] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.347713] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.347717] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.348022] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.348227] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.348231] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.348537] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.348742] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.348745] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.349051] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.349257] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.349261] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.349568] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.349773] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.349776] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.350082] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.350288] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.350291] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.350598] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.350804] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.350807] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.351114] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.351319] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.351322] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.351628] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.351833] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
> [   45.351836] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
> [   45.351854] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2] probed modes :
> [   45.351861] [drm:drm_mode_debug_printmodeline], Modeline 45:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
> [   45.351867] [drm:drm_mode_debug_printmodeline], Modeline 43:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
> [   45.351874] [drm:drm_mode_debug_printmodeline], Modeline 42:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
> [   45.351881] [drm:drm_mode_debug_printmodeline], Modeline 44:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
> [   45.351888] [drm:drm_mode_debug_printmodeline], Modeline 41:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
> [   45.351892] [drm:drm_setup_crtcs],
> [   45.351897] [drm:drm_enable_connectors], connector 7 enabled? yes
> [   45.351901] [drm:drm_enable_connectors], connector 9 enabled? yes
> [   45.351904] [drm:drm_enable_connectors], connector 12 enabled? no
> [   45.351908] [drm:drm_enable_connectors], connector 14 enabled? no
> [   45.351912] [drm:drm_enable_connectors], connector 18 enabled? no
> [   45.351916] [drm:drm_enable_connectors], connector 20 enabled? yes
> [   45.351920] [drm:drm_target_preferred], looking for cmdline mode on connector 7
> [   45.351924] [drm:drm_target_preferred], looking for preferred mode on connector 7
> [   45.351927] [drm:drm_target_preferred], found mode 1280x1024
> [   45.351931] [drm:drm_target_preferred], looking for cmdline mode on connector 9
> [   45.351935] [drm:drm_target_preferred], looking for preferred mode on connector 9
> [   45.351938] [drm:drm_target_preferred], found mode 1920x1080
> [   45.351942] [drm:drm_target_preferred], looking for cmdline mode on connector 20
> [   45.351945] [drm:drm_target_preferred], looking for preferred mode on connector 20
> [   45.351949] [drm:drm_target_preferred], found mode 1024x768
> [   45.351953] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
> [   45.351962] [drm:drm_setup_crtcs], desired mode 1280x1024 set on crtc 3
> [   45.351967] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 4
> [   45.351987] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
> 
> Thank you!
> 
> /mjt
> 
> 15.02.2014 22:28, Michael Tokarev wrote:
>> 10.02.2014 14:44, One Thousand Gnomes wrote:
>>>> fbcon is loaded so it isn't an issue.
>>>>
>>>> I tried 3.10 kernel initially (the above messages are from it), next
>>>> I tried 3.13 kernel too, and that one behaves exactly the same.
>>>>
>>>> As far as I remember, this system never worked with graphics well.
>>>> Previous kernel (from which I updated) was 3.2 which had no
>>>> gma500 module (local build).
>>>>
>>>> What are the steps to debug this further?
>>>
>>> Check you have X86_SYSFB and SIMPLEFB disabled
>>
>> Neither of these options exists in 3.10 config.  In 3.13 I had X86_SYSFB set
>> to y initially (SIMPLEFB doesn't exist there too), but setting it to n does
>> not make any difference.
>>
>>> Boot with drm.debug=6
>>>
>>> collect the logs
>>
>> I used `modprobe drm debug=6' (initially booting with gma500_gfx module
>> disabled), followed with `modprobe gma500_gfx'.  After loading module
>> the screen goes blank as before, and monitor says 'no signal detected'.
>>
>> Here are the logs:
>>
>> [599286.739923] Linux agpgart interface v0.103
>> [599286.765176] [drm] Initialized drm 1.1.0 20060810
>> [599303.673734] gma500 0000:00:02.0: setting latency timer to 64
>> [599303.673883] [drm:psb_intel_opregion_setup], Public ACPI methods supported
>> [599303.673887] [drm:psb_intel_opregion_setup], ASLE supported
>> [599303.673923] gma500 0000:00:02.0: irq 50 for MSI/MSI-X
>> [599303.673950] [drm:psb_intel_init_bios], Using VBT from OpRegion: $VBT CEDARVIEW      d
>> [599303.673959] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1080" 0 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
>> [599303.673969] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
>> [599303.673975] [drm:parse_edp], EDP timing in vbt t1_t3 2000 t8 10 t9 2000 t10 500 t11_t12 5000
>> [599303.673980] [drm:parse_edp], VBT reports EDP: Lane_count 1, Lane_rate 6, Bpp 24
>> [599303.673984] [drm:parse_edp], VBT reports EDP: VSwing  0, Preemph 0
>> [599303.688094] acpi device:29: registered as cooling_device2
>> [599303.688446] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>> [599303.688557] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input11
>> [599303.689160] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>> [599303.689188] [drm] No driver support for vblank timestamp query.
>> [599303.740423] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSDDC_C
>> [599303.741222] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-B
>> [599303.741732] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
>> [599303.741736] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
>> [599303.742242] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
>> [599303.742246] [drm:cdv_intel_dp_i2c_aux_ch], aux_ch failed -110
>> [599303.742997] [drm:cdv_intel_dp_i2c_init], i2c_init DPDDC-C
>> [599303.743305] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.743510] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.783922] [drm:cdv_intel_single_pipe_active], pipe enabled 0
>> [599303.803958] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
>> [599303.803996] gma500 0000:00:02.0: trying to get vblank count for disabled pipe 1
>> [599303.844370] [drm:cdv_intel_single_pipe_active], pipe enabled 0
>> [599303.864408] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1]
>> [599303.877172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:7:VGA-1] disconnected
>> [599303.877184] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1]
>> [599303.881764] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm LVDSBLC_B
>> [599303.881778] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:LVDS-1] probed modes :
>> [599303.881783] [drm:drm_mode_debug_printmodeline], Modeline 22:"1920x1080" 60 144000 1920 2016 2080 2176 1080 1088 1092 1100 0x8 0xa
>> [599303.881791] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1]
>> [599303.886292] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
>> [599303.886298] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:DVI-D-1] disconnected
>> [599303.886304] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1]
>> [599303.886811] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
>> [599303.886815] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:14:DP-1] disconnected
>> [599303.886820] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2]
>> [599303.891350] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
>> [599303.891357] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:DVI-D-2] disconnected
>> [599303.891362] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2]
>> [599303.891569] [drm:cdv_dp_detect], DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
>> [599303.891876] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.892082] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.892085] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.892391] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.892595] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.892598] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.892904] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.893109] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.893112] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.893417] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.893622] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.893625] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.893944] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.894151] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.894154] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.894460] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.894665] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.894669] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.894975] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.895180] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.895183] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.895489] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.895694] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.895697] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.896002] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.896207] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.896210] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.896515] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.896720] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599303.896723] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599303.896741] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:DP-2] probed modes :
>> [599303.896745] [drm:drm_mode_debug_printmodeline], Modeline 27:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
>> [599303.896752] [drm:drm_mode_debug_printmodeline], Modeline 25:"800x600" 60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
>> [599303.896759] [drm:drm_mode_debug_printmodeline], Modeline 24:"800x600" 56 36000 800 824 896 1024 600 601 603 625 0x40 0x5
>> [599303.896766] [drm:drm_mode_debug_printmodeline], Modeline 26:"848x480" 60 33750 848 864 976 1088 480 486 494 517 0x40 0x5
>> [599303.896773] [drm:drm_mode_debug_printmodeline], Modeline 23:"640x480" 60 25175 640 656 752 800 480 489 492 525 0x40 0xa
>> [599303.896780] [drm:drm_setup_crtcs],
>> [599303.896785] [drm:drm_enable_connectors], connector 7 enabled? no
>> [599303.896789] [drm:drm_enable_connectors], connector 9 enabled? yes
>> [599303.896792] [drm:drm_enable_connectors], connector 12 enabled? no
>> [599303.896796] [drm:drm_enable_connectors], connector 14 enabled? no
>> [599303.896800] [drm:drm_enable_connectors], connector 18 enabled? no
>> [599303.896803] [drm:drm_enable_connectors], connector 20 enabled? yes
>> [599303.896807] [drm:drm_target_preferred], looking for cmdline mode on connector 9
>> [599303.896811] [drm:drm_target_preferred], looking for preferred mode on connector 9
>> [599303.896815] [drm:drm_target_preferred], found mode 1920x1080
>> [599303.896818] [drm:drm_target_preferred], looking for cmdline mode on connector 20
>> [599303.896821] [drm:drm_target_preferred], looking for preferred mode on connector 20
>> [599303.896825] [drm:drm_target_preferred], found mode 1024x768
>> [599303.896828] [drm:drm_setup_crtcs], picking CRTCs for 4096x4096 config
>> [599303.896836] [drm:drm_setup_crtcs], desired mode 1920x1080 set on crtc 4
>> [599303.896841] [drm:drm_setup_crtcs], desired mode 1024x768 set on crtc 3
>> [599303.896862] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0
>> [599546.148642] [drm:drm_helper_hpd_irq_event], [CONNECTOR:7:VGA-1] status updated from disconnected to connected
>> [599546.153261] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIB
>> [599546.153270] [drm:drm_helper_hpd_irq_event], [CONNECTOR:12:DVI-D-1] status updated from disconnected to disconnected
>> [599546.153779] [drm:cdv_intel_dp_aux_ch], dp_aux_ch timeout status 0x51440064
>> [599546.153783] [drm:drm_helper_hpd_irq_event], [CONNECTOR:14:DP-1] status updated from disconnected to disconnected
>> [599546.158258] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter intel drm HDMIC
>> [599546.158264] [drm:drm_helper_hpd_irq_event], [CONNECTOR:18:DVI-D-2] status updated from disconnected to disconnected
>> [599546.158471] [drm:cdv_dp_detect], DPCD: Rev=11 LN_Rate=a LN_CNT=82 LN_DOWNSP=41
>> [599546.158780] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.158987] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.158991] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599546.159297] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.159502] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.159505] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599546.159810] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.160015] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.160018] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599546.160324] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.160528] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>> [599546.160531] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return -121
>> [599546.160843] [drm:cdv_intel_dp_i2c_aux_ch], aux_i2c nack
>>
>> This is 3.10.29, monitor is connected to VGA connector.
>>
>> Thank you!
>>
>> /mjt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

