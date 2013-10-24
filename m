Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3JXGUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:20:47 -0400
Received: from mail.blinkeye.ch ([78.46.102.7]:55609 "EHLO mail.blinkeye.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab3JXGUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:20:43 -0400
X-Greylist: delayed 644 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 02:20:42 EDT
Message-ID: <5268B9B1.10609@blinkeye.ch>
Date: Thu, 24 Oct 2013 08:09:53 +0200
From: Reto Glauser <linux@blinkeye.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130911 Thunderbird/17.0.9
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Wakko Warner <wakko@animx.eu.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: Intel Haswell kernel warning (3.11.2)
References: <20130928185023.GA21672@animx.eu.org> <20130929141734.GA8370@animx.eu.org> <20130929145839.GA5490@pd.tnic> <20130929151220.GL26592@phenom.ffwll.local>
In-Reply-To: <20130929151220.GL26592@phenom.ffwll.local>
Content-Type: multipart/mixed;
 boundary="------------080500020904020308040302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080500020904020308040302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/29/2013 05:12 PM, Daniel Vetter wrote:
> Please boot with drm.debug=0xe, reproduce the WARN and then attach the
> full dmesg.
> 

This is a segfault on kernel 3.11.3. There's no X started yet, but one
s2ram cycle.

Attached is the complete dmesg with drm.debug=0xe or on
http://pastebin.com/raw.php?i=dqh0RjVG .

The surrounding messages:

[   39.192856] ACPI: Low-level resume complete
[   39.192887] PM: Restoring platform NVS memory
[   39.193638] Enabling non-boot CPUs ...
[   39.193720] smpboot: Booting Node 0 Processor 1 APIC 0x2
[   39.207712] CPU1 is up
[   39.207755] smpboot: Booting Node 0 Processor 2 APIC 0x4
[   39.221845] CPU2 is up
[   39.221893] smpboot: Booting Node 0 Processor 3 APIC 0x6
[   39.235974] CPU3 is up
[   39.236021] smpboot: Booting Node 0 Processor 4 APIC 0x1
[   39.250015] CPU4 is up
[   39.250065] smpboot: Booting Node 0 Processor 5 APIC 0x3
[   39.264142] CPU5 is up
[   39.264203] smpboot: Booting Node 0 Processor 6 APIC 0x5
[   39.278323] CPU6 is up
[   39.278378] smpboot: Booting Node 0 Processor 7 APIC 0x7
[   39.292438] CPU7 is up
[   39.299252] ACPI: Waking up from system sleep state S3
[   39.332134] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[   39.343112] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[   39.365174] PM: noirq resume of devices complete after 65.731 msecs
[   39.365234] PM: early resume of devices complete after 0.046 msecs
[   39.365246] i915 0000:00:02.0: setting latency timer to 64
[   39.365251] e1000e 0000:00:19.0: System wakeup disabled by ACPI
[   39.365257] e1000e 0000:00:19.0: setting latency timer to 64
[   39.365265] ahci 0000:00:1f.2: setting latency timer to 64
[   39.365290] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   39.365304] ehci-pci 0000:00:1a.0: setting latency timer to 64
[   39.365310] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off,
defaulting to EHCI.
[   39.365310] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0
speeds.
[   39.365331] ehci-pci 0000:00:1d.0: setting latency timer to 64
[   39.365336] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off,
defaulting to EHCI.
[   39.365336] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0
speeds.
[   39.366127] [drm:i915_redisable_vga], Something enabled VGA plane,
disabling it
[   39.366442] [drm:intel_opregion_setup], graphic opregion physical
addr: 0xccafc018
[   39.366449] [drm:intel_opregion_setup], Public ACPI methods supported
[   39.366449] [drm:intel_opregion_setup], SWSCI supported
[   39.366449] [drm:intel_opregion_setup], ASLE supported
[   39.404149] [drm:init_status_page], render ring hws offset: 0x00000000
[   39.406086] [drm:init_pipe_control], render ring pipe control offset:
0x00021000
[   39.406098] [drm:init_status_page], bsd ring hws offset: 0x00022000
[   39.406239] [drm:init_status_page], blitter ring hws offset: 0x00043000
[   39.406368] [drm:init_status_page], video enhancement ring hws
offset: 0x00064000
[   39.406572] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers
for port A in DP mode
[   39.406583] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers
for port B in DP mode
[   39.406594] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers
for port C in DP mode
[   39.406605] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers
for port D in DP mode
[   39.406617] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers
for port E in FDI mode
[   39.406662] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state
readout: disabled
[   39.406665] [drm:intel_modeset_readout_hw_state], [CRTC:5] hw state
readout: disabled
[   39.406668] [drm:intel_modeset_readout_hw_state], [CRTC:7] hw state
readout: disabled
[   39.406673] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10]
hw state readout: disabled, pipe=0
[   39.406677] [drm:intel_modeset_readout_hw_state],
[ENCODER:11:TMDS-11] hw state readout: disabled, pipe=0
[   39.406680] [drm:intel_modeset_readout_hw_state],
[ENCODER:16:TMDS-16] hw state readout: disabled, pipe=0
[   39.406682] [drm:intel_modeset_readout_hw_state],
[ENCODER:19:TMDS-19] hw state readout: disabled, pipe=0
[   39.406686] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1]
hw state readout: disabled
[   39.406690] [drm:intel_modeset_readout_hw_state], [CONNECTOR:12:DP-1]
hw state readout: disabled
[   39.406693] [drm:intel_modeset_readout_hw_state],
[CONNECTOR:15:HDMI-A-1] hw state readout: disabled
[   39.406696] [drm:intel_modeset_readout_hw_state], [CONNECTOR:17:DP-2]
hw state readout: disabled
[   39.406699] [drm:intel_modeset_readout_hw_state],
[CONNECTOR:18:HDMI-A-2] hw state readout: disabled
[   39.406701] [drm:intel_modeset_readout_hw_state], [CONNECTOR:20:DP-3]
hw state readout: disabled
[   39.406704] [drm:intel_modeset_readout_hw_state],
[CONNECTOR:21:HDMI-A-3] hw state readout: disabled
[   39.406708] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state]
config for pipe A
[   39.406710] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   39.406713] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406716] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0,
gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406718] [drm:intel_dump_pipe_config], requested mode:
[   39.406723] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406724] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406728] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406732] [drm:intel_dump_pipe_config], gmch pfit: control:
0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   39.406734] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000,
size: 0x00000000
[   39.406735] [drm:intel_dump_pipe_config], ips: 0
[   39.406739] [drm:intel_dump_pipe_config], [CRTC:5][setup_hw_state]
config for pipe B
[   39.406740] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   39.406742] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406745] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0,
gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406747] [drm:intel_dump_pipe_config], requested mode:
[   39.406750] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406752] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406756] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406758] [drm:intel_dump_pipe_config], gmch pfit: control:
0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   39.406760] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000,
size: 0x00000000
[   39.406762] [drm:intel_dump_pipe_config], ips: 0
[   39.406765] [drm:intel_dump_pipe_config], [CRTC:7][setup_hw_state]
config for pipe C
[   39.406766] [drm:intel_dump_pipe_config], cpu_transcoder: C
[   39.406768] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406771] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0,
gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406773] [drm:intel_dump_pipe_config], requested mode:
[   39.406776] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406778] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406781] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0
0 0 0 0 0 0 0x0 0x0
[   39.406784] [drm:intel_dump_pipe_config], gmch pfit: control:
0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   39.406786] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000,
size: 0x00000000
[   39.406787] [drm:intel_dump_pipe_config], ips: 0
[   39.406791] [drm:intel_modeset_affected_pipes], set mode pipe masks:
modeset: 1, prepare: 1, disable: 0
[   39.406796] [drm:connected_sink_compute_bpp], [CONNECTOR:15:HDMI-A-1]
checking for sink bpp constrains
[   39.406799] [drm:intel_hdmi_compute_config], picking bpc to 8 for
HDMI output
[   39.406801] [drm:intel_hdmi_compute_config], forcing pipe bpc to 24
for HDMI
[   39.406804] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp:
24, dithering: 0
[   39.406807] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config
for pipe A
[   39.406808] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   39.406810] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   39.406813] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0,
gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406815] [drm:intel_dump_pipe_config], requested mode:
[   39.406820] [drm:drm_mode_debug_printmodeline], Modeline
0:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.406821] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406825] [drm:drm_mode_debug_printmodeline], Modeline
0:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.406828] [drm:intel_dump_pipe_config], gmch pfit: control:
0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   39.406830] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000,
size: 0x00000000
[   39.406832] [drm:intel_dump_pipe_config], ips: 0
[   39.406838] [drm:intel_ddi_put_crtc_pll], Disabling WRPLL 1
[   39.406839] ------------[ cut here ]------------
[   39.406861] WARNING: CPU: 1 PID: 1591 at
drivers/gpu/drm/i915/intel_ddi.c:383 intel_ddi_put_crtc_pll+0x272/0x280
[i915]()
[   39.406869] Modules linked in: e1000e i915 ptp ehci_pci ehci_hcd
i2c_i801 pps_core
[   39.406873] CPU: 1 PID: 1591 Comm: kworker/u16:21 Not tainted
3.11.3-gentoo #1
[   39.406875] Hardware name: ASUS All Series/Z87-PRO, BIOS 0801 04/19/2013
[   39.406883] Workqueue: events_unbound async_run_entry_fn
[   39.406887]  0000000000000009 ffff8807fa6119f0 ffffffff817e25b6
0000000000000000
[   39.406891]  ffff8807fa611a28 ffffffff8103f223 ffff8807fb5b0000
ffff8807fe726000
[   39.406894]  0000000000025990 0000000000000000 ffff8807fb72a000
ffff8807fa611a38
[   39.406895] Call Trace:
[   39.406903]  [<ffffffff817e25b6>] dump_stack+0x45/0x56
[   39.406909]  [<ffffffff8103f223>] warn_slowpath_common+0x73/0x90
[   39.406914]  [<ffffffff8103f2f5>] warn_slowpath_null+0x15/0x20
[   39.406927]  [<ffffffffa006bb42>] intel_ddi_put_crtc_pll+0x272/0x280
[i915]
[   39.406938]  [<ffffffffa006bb94>] intel_ddi_pll_mode_set+0x44/0x8a0
[i915]
[   39.406943]  [<ffffffff814ef03c>] ? drm_vblank_get+0x6c/0x2c0
[   39.406952]  [<ffffffffa0039cd7>] ? i915_read32+0x57/0xd0 [i915]
[   39.406967]  [<ffffffffa006088a>] haswell_crtc_mode_set+0x3a/0x320 [i915]
[   39.406996]  [<ffffffffa0061a60>] __intel_set_mode+0x5b0/0x12f0 [i915]
[   39.407010]  [<ffffffffa00671a5>]
intel_modeset_setup_hw_state+0x755/0xa40 [i915]
[   39.407018]  [<ffffffff817e4a2d>] ? mutex_lock+0xd/0x2a
[   39.407026]  [<ffffffffa0039247>] __i915_drm_thaw+0x117/0x1b0 [i915]
[   39.407034]  [<ffffffffa003966a>] i915_resume+0x6a/0xb0 [i915]
[   39.407042]  [<ffffffffa00396c1>] i915_pm_resume+0x11/0x20 [i915]
[   39.407049]  [<ffffffff8144e1ff>] pci_pm_resume+0x5f/0xb0
[   39.407054]  [<ffffffff8144e1a0>] ? pci_pm_restore+0xb0/0xb0
[   39.407061]  [<ffffffff8153c679>] dpm_run_callback.isra.12+0x19/0x50
[   39.407066]  [<ffffffff8153c73e>] device_resume+0x8e/0x130
[   39.407071]  [<ffffffff8153c7f8>] async_resume+0x18/0x40
[   39.407075]  [<ffffffff810617c2>] async_run_entry_fn+0x32/0x130
[   39.407083]  [<ffffffff81054c36>] process_one_work+0x146/0x3d0
[   39.407088]  [<ffffffff81055809>] worker_thread+0x119/0x390
[   39.407093]  [<ffffffff810556f0>] ? manage_workers.isra.24+0x2a0/0x2a0
[   39.407098]  [<ffffffff8105b42b>] kthread+0xbb/0xc0
[   39.407102]  [<ffffffff8105b370>] ? kthread_create_on_node+0x110/0x110
[   39.407107]  [<ffffffff817e8a6c>] ret_from_fork+0x7c/0xb0
[   39.407111]  [<ffffffff8105b370>] ? kthread_create_on_node+0x110/0x110
[   39.407114] ---[ end trace 13d5f7e465dbce0f ]---
[   39.407117] [drm:intel_ddi_pll_mode_set], Using WRPLL 1 on pipe A
[   39.409796] [drm:intel_ddi_calculate_wrpll], WRPLL: 154000000Hz
refresh rate with p=6, n2=53 r2=31
[   39.409835] [drm:ironlake_update_plane], Writing base 000A1000
00000000 0 0 7680
[   39.409850] [drm:intel_crtc_mode_set], [ENCODER:11:TMDS-11] set
[MODE:0:1920x1200]
[   39.409853] [drm:intel_ddi_mode_set], Preparing DDI mode on port B,
pipe A
[   39.461955] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.513873] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.515875] [drm:intel_modeset_affected_pipes], set mode pipe masks:
modeset: 2, prepare: 2, disable: 0
[   39.515880] [drm:connected_sink_compute_bpp], [CONNECTOR:17:DP-2]
checking for sink bpp constrains
[   39.515885] [drm:intel_dp_compute_config], DP link computation with
max lane count 4 max bw 0a pixel clock 193250KHz
[   39.515895] [drm:intel_dp_compute_config], DP link bw 06 lane count 4
clock 162000 bpp 24
[   39.515898] [drm:intel_dp_compute_config], DP link bw required 463800
available 518400
[   39.515901] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp:
24, dithering: 0
[   39.515904] [drm:intel_dump_pipe_config], [CRTC:5][modeset] config
for pipe B
[   39.515906] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   39.515908] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   39.515911] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0,
gmch_m: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.515913] [drm:intel_dump_pipe_config], requested mode:
[   39.515918] [drm:drm_mode_debug_printmodeline], Modeline
0:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   39.515920] [drm:intel_dump_pipe_config], adjusted mode:
[   39.515925] [drm:drm_mode_debug_printmodeline], Modeline
0:"1920x1200" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   39.515927] [drm:intel_dump_pipe_config], gmch pfit: control:
0x00000000, ratios: 0x00000000, lvds border: 0x00000000
[   39.515929] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000,
size: 0x00000000
[   39.515931] [drm:intel_dump_pipe_config], ips: 0
[   39.515956] [drm:ironlake_update_plane], Writing base 000A1000
00000000 0 0 7680
[   39.515968] [drm:intel_crtc_mode_set], [ENCODER:16:TMDS-16] set
[MODE:0:1920x1200]
[   39.515971] [drm:intel_ddi_mode_set], Preparing DDI mode on port C,
pipe B
[   39.515973] [drm:intel_ddi_mode_set], DP audio on pipe B on DDI
[   39.515974] [drm:intel_ddi_mode_set], DP audio: write eld information
[   39.515979] [drm:intel_write_eld], ELD on [CONNECTOR:17:DP-2],
[ENCODER:16:TMDS-16]
[   39.515981] [drm:haswell_write_eld], HDMI: Haswell Audio initialize....
[   39.515983] [drm:haswell_write_eld], HDMI audio: enable codec
[   39.567784] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.567790] [drm:haswell_write_eld], HDMI audio: pin eld vld
status=0x      40
[   39.567795] [drm:haswell_write_eld], HDMI audio: eld vld status=0x
   50
[   39.567798] [drm:haswell_write_eld], HDMI audio: audio conf: 0x  70fa60
[   39.567802] [drm:haswell_write_eld], ELD on pipe B
[   39.567805] [drm:haswell_write_eld], ELD: DisplayPort detected
[   39.567812] [drm:haswell_write_eld], port num:0
[   39.567814] [drm:haswell_write_eld], ELD size 9
[   39.570850] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.575688] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.576902] usb 2-1.3: reset high-speed USB device number 3 using
ehci-pci
[   39.579733] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.585734] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.585745] [drm:intel_dp_set_signal_levels], Using signal levels
00000000
[   39.588711] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.591827] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.591836] [drm:intel_dp_set_signal_levels], Using signal levels
00000000
[   39.594808] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.597921] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.602645] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.648648] [drm:intel_modeset_affected_pipes], set mode pipe masks:
modeset: 0, prepare: 0, disable: 0
[   39.648660] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]
[   39.648664] [drm:intel_connector_check_state], [CONNECTOR:17:DP-2]
[   39.648669] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   39.648673] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[   39.648676] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   39.648679] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[   39.648681] [drm:check_crtc_state], [CRTC:3]
[   39.648688] [drm:check_crtc_state], [CRTC:5]
[   39.648694] [drm:check_crtc_state], [CRTC:7]
[   39.648700] [drm:intel_crt_reset], pch crt adpa set to 0xf40000
[   39.648707] [drm:intel_resume_hotplug], running encoder hotplug functions
[   39.651653] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.656519] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.660525] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.661588] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug
detect cycle: adpa=0xf40000
[   39.669626] ata8: SATA link down (SStatus 0 SControl 300)
[   39.669661] ata7: SATA link down (SStatus 0 SControl 300)
[   39.671616] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug
adpa=0xf40000, result 0
[   39.671619] [drm:intel_crt_detect], CRT not detected via hotplug
[   39.671634] ata5: SATA link down (SStatus 0 SControl 300)
[   39.671656] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   39.671814] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr:
0050 r(1)
[   39.671818] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus vga
[   39.671820] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed,
retry using GPIO bit-banging
[   39.671823] [drm:intel_gmbus_force_bit], enabling bit-banging on i915
gmbus vga. force bit now 1
[   39.672153] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus vga
[   39.672156] [drm:intel_gmbus_force_bit], disabling bit-banging on
i915 gmbus vga. force bit now 0
[   39.672158] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50
[no valid EDID found]
[   39.672163] [drm:drm_helper_hpd_irq_event], [CONNECTOR:9:VGA-1]
status updated from unknown to disconnected
[   39.672971] ata2.00: configured for UDMA/133
[   39.673038] sd 1:0:0:0: [sdb] Starting disk
[   39.675109] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.675585] ata6: SATA link down (SStatus 0 SControl 300)
[   39.675608] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   39.677386] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
(20130517/psargs-359)
[   39.677399] ACPI Error: Method parse/execution failed
[\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND
(20130517/psparse-536)
[   39.679505] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.679566] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   39.683483] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.684555] [drm:drm_helper_hpd_irq_event], [CONNECTOR:12:DP-1]
status updated from unknown to disconnected
[   39.697243] [drm:drm_helper_hpd_irq_event], [CONNECTOR:15:HDMI-A-1]
status updated from unknown to connected
[   39.697249] [drm:drm_helper_hpd_irq_event], [CONNECTOR:17:DP-2]
status updated from unknown to disconnected
[   39.697419] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr:
0050 r(1)
[   39.697422] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus dpc
[   39.697427] [drm:drm_helper_hpd_irq_event], [CONNECTOR:18:HDMI-A-2]
status updated from unknown to disconnected
[   39.697433] [drm:drm_helper_hpd_irq_event], [CONNECTOR:20:DP-3]
status updated from unknown to disconnected
[   39.697592] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr:
0050 r(1)
[   39.697595] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus dpd
[   39.697600] [drm:drm_helper_hpd_irq_event], [CONNECTOR:21:HDMI-A-3]
status updated from unknown to disconnected
[   39.697631] [drm:drm_fb_helper_hotplug_event],
[   39.697636] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:9:VGA-1]
[   39.697642] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug
adpa=0xf40000, result 0
[   39.697645] [drm:intel_crt_detect], CRT not detected via hotplug
[   39.697813] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr:
0050 r(1)
[   39.697816] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus vga
[   39.697818] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed,
retry using GPIO bit-banging
[   39.697820] [drm:intel_gmbus_force_bit], enabling bit-banging on i915
gmbus vga. force bit now 1
[   39.698149] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus vga
[   39.698151] [drm:intel_gmbus_force_bit], disabling bit-banging on
i915 gmbus vga. force bit now 0
[   39.698153] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50
[no valid EDID found]
[   39.698156] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:9:VGA-1] disconnected
[   39.698160] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:DP-1]
[   39.701085] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.705437] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.709434] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a
[   39.710507] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:12:DP-1] disconnected
[   39.710511] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:HDMI-A-1]
[   39.714802] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND
(20130517/psargs-359)
[   39.714815] ACPI Error: Method parse/execution failed
[\_SB_.PCI0.SAT0.SPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND
(20130517/psparse-536)
[   39.714828] ata3.00: configured for UDMA/100
[   39.734520] usb 2-1.4: reset full-speed USB device number 4 using
ehci-pci
[   39.735896] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   39.735916] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:15:HDMI-A-1] probed modes :
[   39.735925] [drm:drm_mode_debug_printmodeline], Modeline
23:"1920x1200" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.735933] [drm:drm_mode_debug_printmodeline], Modeline
24:"1920x1080" 60 172780 1920 2040 2248 2576 1080 1081 1084 1118 0x0 0x6
[   39.735940] [drm:drm_mode_debug_printmodeline], Modeline
29:"1600x1200" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   39.735947] [drm:drm_mode_debug_printmodeline], Modeline
30:"1680x1050" 60 119000 1680 1728 1760 1840 1050 1053 1059 1080 0x40 0x9
[   39.735954] [drm:drm_mode_debug_printmodeline], Modeline
27:"1280x1024" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   39.735962] [drm:drm_mode_debug_printmodeline], Modeline
28:"1440x900" 60 88750 1440 1488 1520 1600 900 903 909 926 0x40 0x9
[   39.735970] [drm:drm_mode_debug_printmodeline], Modeline
26:"1280x960" 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   39.735977] [drm:drm_mode_debug_printmodeline], Modeline
25:"1280x720" 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   39.735984] [drm:drm_mode_debug_printmodeline], Modeline
33:"1024x768" 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   39.735991] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600"
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   39.735998] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480"
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   39.736003] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:17:DP-2]
[   39.736010] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:17:DP-2] disconnected
[   39.736024] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:18:HDMI-A-2]
[   39.736192] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr:
0050 r(1)
[   39.736196] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus dpc
[   39.736200] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:18:HDMI-A-2] disconnected
[   39.736204] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:20:DP-3]
[   39.736209] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:20:DP-3] disconnected
[   39.736213] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:21:HDMI-A-3]
[   39.736372] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr:
0050 r(1)
[   39.736375] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent
adapter i915 gmbus dpd
[   39.736379] [drm:drm_helper_probe_single_connector_modes],
[CONNECTOR:21:HDMI-A-3] disconnected
[   39.736382] [drm:drm_setup_crtcs],
[   39.736386] [drm:drm_enable_connectors], connector 9 enabled? no
[   39.736390] [drm:drm_enable_connectors], connector 12 enabled? no
[   39.736393] [drm:drm_enable_connectors], connector 15 enabled? yes
[   39.736396] [drm:drm_enable_connectors], connector 17 enabled? no
[   39.736399] [drm:drm_enable_connectors], connector 18 enabled? no
[   39.736402] [drm:drm_enable_connectors], connector 20 enabled? no
[   39.736405] [drm:drm_enable_connectors], connector 21 enabled? no
[   39.736408] [drm:drm_target_preferred], looking for cmdline mode on
connector 15
[   39.736411] [drm:drm_target_preferred], found mode 1920x1200
[   39.736415] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[   39.736421] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc 3
[   39.736429] [drm:intel_crtc_set_config], [CRTC:3] [FB:56]
#connectors=1 (x y) (0 0)
[   39.736436] [drm:intel_modeset_stage_output_state],
[CONNECTOR:15:HDMI-A-1] to [CRTC:3]
[   39.736440] [drm:intel_modeset_stage_output_state],
[CONNECTOR:17:DP-2] to [CRTC:5]
[   39.736445] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[   39.736450] [drm:intel_modeset_stage_output_state],
[CONNECTOR:17:DP-2] to [NOCRTC]
[   39.736461] [drm:intel_modeset_stage_output_state], encoder changed,
full mode switch
[   39.736466] [drm:intel_modeset_stage_output_state],
[CONNECTOR:15:HDMI-A-1] to [CRTC:3]
[   39.736469] [drm:intel_modeset_stage_output_state], crtc changed,
full mode switch
[   39.736480] [drm:intel_modeset_affected_pipes], set mode pipe masks:
modeset: 0, prepare: 0, disable: 2
[   39.764504] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]
[   39.764509] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   39.764512] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[   39.764515] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   39.764518] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[   39.764520] [drm:check_crtc_state], [CRTC:3]
[   39.764527] [drm:check_crtc_state], [CRTC:5]
[   39.764529] [drm:check_crtc_state], [CRTC:7]
[   39.764534] [drm:intel_crtc_set_config], [CRTC:7] [NOFB]
[   39.764539] [drm:intel_modeset_stage_output_state],
[CONNECTOR:15:HDMI-A-1] to [CRTC:3]
[   39.767552] [drm:intel_crtc_set_config], [CRTC:3] [FB:56]
#connectors=1 (x y) (0 0)
[   39.767557] [drm:intel_modeset_stage_output_state],
[CONNECTOR:15:HDMI-A-1] to [CRTC:3]

--------------080500020904020308040302
Content-Type: text/plain; charset=ISO-8859-1;
 name="dmesg_3.11.3-gentoo_2013-10-24"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg_3.11.3-gentoo_2013-10-24"

[    0.275028] ACPI: No dock devices found.
[    0.280030] ACPI: Power Resource [FN00] (off)
[    0.280154] ACPI: Power Resource [FN01] (off)
[    0.280277] ACPI: Power Resource [FN02] (off)
[    0.280403] ACPI: Power Resource [FN03] (off)
[    0.280527] ACPI: Power Resource [FN04] (off)
[    0.281106] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.281324] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.281541] acpi PNP0A08:00: ACPI _OSC control (0x18) granted
[    0.281918] PCI host bridge to bus 0000:00
[    0.282002] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.282087] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.282172] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.282258] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.282344] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3=
fff]
[    0.282433] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7=
fff]
[    0.282519] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000db=
fff]
[    0.282606] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000df=
fff]
[    0.282693] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3=
fff]
[    0.282779] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7=
fff]
[    0.282866] pci_bus 0000:00: root bus resource [mem 0xdf200000-0xfeaff=
fff]
[    0.282957] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.283011] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.283031] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.283064] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.283167] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.283174] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64b=
it]
[    0.283179] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64b=
it pref]
[    0.283182] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.283230] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.283235] pci 0000:00:03.0: reg 0x10: [mem 0xf0634000-0xf0637fff 64b=
it]
[    0.283300] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.283314] pci 0000:00:14.0: reg 0x10: [mem 0xf0620000-0xf062ffff 64b=
it]
[    0.283360] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.283389] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.283493] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.283507] pci 0000:00:16.0: reg 0x10: [mem 0xf063f000-0xf063f00f 64b=
it]
[    0.283557] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.283608] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    0.283620] pci 0000:00:19.0: reg 0x10: [mem 0xf0600000-0xf061ffff]
[    0.283626] pci 0000:00:19.0: reg 0x14: [mem 0xf063d000-0xf063dfff]
[    0.283632] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.283678] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.283708] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.283811] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.283827] pci 0000:00:1a.0: reg 0x10: [mem 0xf063c000-0xf063c3ff]
[    0.283899] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.283938] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.284041] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.284051] pci 0000:00:1b.0: reg 0x10: [mem 0xf0630000-0xf0633fff 64b=
it]
[    0.284101] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.284131] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.284230] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.284279] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.284310] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.284408] pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
[    0.284458] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.284490] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.284591] pci 0000:00:1c.5: [8086:8c1a] type 01 class 0x060400
[    0.284641] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.284672] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.284777] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.284793] pci 0000:00:1d.0: reg 0x10: [mem 0xf063b000-0xf063b3ff]
[    0.284864] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.284903] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.285007] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
[    0.285132] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.285143] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.285148] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.285153] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.285158] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.285164] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.285169] pci 0000:00:1f.2: reg 0x24: [mem 0xf063a000-0xf063a7ff]
[    0.285196] pci 0000:00:1f.2: PME# supported from D3hot
[    0.285236] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.285247] pci 0000:00:1f.3: reg 0x10: [mem 0xf0639000-0xf06390ff 64b=
it]
[    0.285262] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.285326] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.285460] acpiphp: Slot [1] registered
[    0.285546] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.285686] pci 0000:03:00.0: [168c:0034] type 00 class 0x028000
[    0.285705] pci 0000:03:00.0: reg 0x10: [mem 0xf0500000-0xf057ffff 64b=
it]
[    0.285751] pci 0000:03:00.0: reg 0x30: [mem 0xf0580000-0xf058ffff pre=
f]
[    0.285798] pci 0000:03:00.0: supports D1 D2
[    0.285799] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.285817] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.287551] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.287637] pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fff=
ff]
[    0.287694] pci 0000:04:00.0: [1b21:0612] type 00 class 0x010601
[    0.287707] pci 0000:04:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.287716] pci 0000:04:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.287725] pci 0000:04:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.287734] pci 0000:04:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.287744] pci 0000:04:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.287753] pci 0000:04:00.0: reg 0x24: [mem 0xf0400000-0xf04001ff]
[    0.287820] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.289548] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    0.289633] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.289635] pci 0000:00:1c.5:   bridge window [mem 0xf0400000-0xf04fff=
ff]
[    0.290049] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 =
14 15)
[    0.290517] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 *4 5 6 7 10 11 12 =
14 15)
[    0.290986] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 *6 7 10 11 12 =
14 15)
[    0.291452] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 1=
4 *15)
[    0.291920] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12 =
14 15)
[    0.292385] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *10 11 12 =
14 15)
[    0.292852] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 =
14 15)
[    0.293318] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *=
14 15)
[    0.294002] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.294147] ACPI: \_SB_.PCI0: notify handler is installed
[    0.294186] Found 1 acpi root devices
[    0.294214] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.294349] vgaarb: loaded
[    0.294429] vgaarb: bridge control possible 0000:00:02.0
[    0.294583] SCSI subsystem initialized
[    0.294667] ACPI: bus type ATA registered
[    0.294769] libata version 3.00 loaded.
[    0.294777] ACPI: bus type USB registered
[    0.294868] usbcore: registered new interface driver usbfs
[    0.294956] usbcore: registered new interface driver hub
[    0.295051] usbcore: registered new device driver usb
[    0.295188] Advanced Linux Sound Architecture Driver Initialized.
[    0.295274] PCI: Using ACPI for IRQ routing
[    0.296456] PCI: pci_cache_line_size set to 64 bytes
[    0.296486] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.296487] e820: reserve RAM buffer [mem 0xb934c000-0xbbffffff]
[    0.296488] e820: reserve RAM buffer [mem 0xb9799000-0xbbffffff]
[    0.296489] e820: reserve RAM buffer [mem 0xcc748000-0xcfffffff]
[    0.296490] e820: reserve RAM buffer [mem 0xce000000-0xcfffffff]
[    0.296490] e820: reserve RAM buffer [mem 0x81fe00000-0x81fffffff]
[    0.296550] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.296902] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.298997] Switched to clocksource hpet
[    0.299129] FS-Cache: Loaded
[    0.299229] CacheFiles: Loaded
[    0.300040] pnp: PnP ACPI init
[    0.300123] ACPI: bus type PNP registered
[    0.300235] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserve=
d
[    0.300322] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.300329] pnp 00:01: [dma 4]
[    0.300334] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)=

[    0.300344] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)=

[    0.300396] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.300464] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.300549] system 00:04: [io  0xffff] has been reserved
[    0.300634] system 00:04: [io  0xffff] has been reserved
[    0.300718] system 00:04: [io  0xffff] has been reserved
[    0.300802] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.300887] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.300973] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.301063] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.301148] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.301234] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.301319] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.301333] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.301356] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.301441] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c=
02 (active)
[    0.301486] system 00:07: [io  0x0290-0x029f] has been reserved
[    0.301571] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.301594] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    0.301680] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.301690] pnp 00:09: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    0.301954] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserve=
d
[    0.302044] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserve=
d
[    0.302130] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserve=
d
[    0.302217] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserve=
d
[    0.302303] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserve=
d
[    0.302389] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserve=
d
[    0.302476] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserve=
d
[    0.302562] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserve=
d
[    0.302649] system 00:0a: [mem 0xff000000-0xffffffff] has been reserve=
d
[    0.302736] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be res=
erved
[    0.302823] system 00:0a: [mem 0xf7fef000-0xf7feffff] has been reserve=
d
[    0.302909] system 00:0a: [mem 0xf7ff0000-0xf7ff0fff] has been reserve=
d
[    0.302998] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.303163] pnp: PnP ACPI: found 11 devices
[    0.303246] ACPI: bus type PNP unregistered
[    0.307848] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bu=
s 02] add_size 1000
[    0.307849] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
 64bit pref] to [bus 02] add_size 200000
[    0.307850] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff=
] to [bus 02] add_size 200000
[    0.307862] pci 0000:00:1c.0: res[8]=3D[mem 0x00100000-0x000fffff] get=
_res_add_size add_size 200000
[    0.307863] pci 0000:00:1c.0: res[9]=3D[mem 0x00100000-0x000fffff 64bi=
t pref] get_res_add_size add_size 200000
[    0.307864] pci 0000:00:1c.0: res[7]=3D[io  0x1000-0x0fff] get_res_add=
_size add_size 1000
[    0.307866] pci 0000:00:1c.0: BAR 8: assigned [mem 0xdf200000-0xdf3fff=
ff]
[    0.307953] pci 0000:00:1c.0: BAR 9: assigned [mem 0xdf400000-0xdf5fff=
ff 64bit pref]
[    0.308090] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.308176] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.308262] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.308346] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.308434] pci 0000:00:1c.0:   bridge window [mem 0xdf200000-0xdf3fff=
ff]
[    0.308521] pci 0000:00:1c.0:   bridge window [mem 0xdf400000-0xdf5fff=
ff 64bit pref]
[    0.308658] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.308743] pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fff=
ff]
[    0.308834] pci 0000:00:1c.5: PCI bridge to [bus 04]
[    0.308918] pci 0000:00:1c.5:   bridge window [io  0xe000-0xefff]
[    0.309008] pci 0000:00:1c.5:   bridge window [mem 0xf0400000-0xf04fff=
ff]
[    0.309242] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.309243] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.309244] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.309245] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.309245] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.309246] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.309247] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.309248] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.309249] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.309250] pci_bus 0000:00: resource 13 [mem 0xdf200000-0xfeafffff]
[    0.309251] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.309252] pci_bus 0000:02: resource 1 [mem 0xdf200000-0xdf3fffff]
[    0.309253] pci_bus 0000:02: resource 2 [mem 0xdf400000-0xdf5fffff 64b=
it pref]
[    0.309253] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
[    0.309254] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.309255] pci_bus 0000:04: resource 1 [mem 0xf0400000-0xf04fffff]
[    0.309317] NET: Registered protocol family 2
[    0.309660] TCP established hash table entries: 262144 (order: 10, 419=
4304 bytes)
[    0.310134] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s)
[    0.310305] TCP: Hash tables configured (established 262144 bind 65536=
)
[    0.310399] TCP: reno registered
[    0.310500] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.310650] UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes=
)
[    0.310845] NET: Registered protocol family 1
[    0.311007] RPC: Registered named UNIX socket transport module.
[    0.311092] RPC: Registered udp transport module.
[    0.311175] RPC: Registered tcp transport module.
[    0.311257] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.311347] pci 0000:00:02.0: Boot video device
[    0.311406] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off, defau=
lting to EHCI.
[    0.311540] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0 spe=
eds.
[    0.341980] PCI: CLS 64 bytes, default 64
[    0.345744] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.345832] software IO TLB [mem 0xc8748000-0xcc748000] (64MB) mapped =
at [ffff8800c8748000-ffff8800cc747fff]
[    0.347204] bounce pool size: 64 pages
[    0.347287] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.347873] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.348058] NTFS driver 2.1.30 [Flags: R/W].
[    0.348196] fuse init (API version 7.22)
[    0.348343] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    0.349268] SGI XFS with security attributes, large block/inode number=
s, no debug enabled
[    0.349653] NILFS version 2 loaded
[    0.349809] bio: create slab <bio-1> at 1
[    0.350004] Btrfs loaded
[    0.350086] msgmni has been set to 32768
[    0.350435] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 253)
[    0.350569] io scheduler noop registered
[    0.350650] io scheduler deadline registered
[    0.350748] io scheduler cfq registered (default)
[    0.352266] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.352366] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.352457] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[    0.356830] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.357158] Linux agpgart interface v0.103
[    0.357246] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    0.357382] Hangcheck: Using getrawmonotonic().
[    0.357489] intel_idle: MWAIT substates: 0x42120
[    0.357490] intel_idle: v0.4 model 0x3C
[    0.357490] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.357535] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    0.357671] ACPI: Power Button [PWRB]
[    0.357767] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    0.357901] ACPI: Power Button [PWRF]
[    0.358018] ACPI: Fan [FAN0] (off)
[    0.358109] ACPI: Fan [FAN1] (off)
[    0.358200] ACPI: Fan [FAN2] (off)
[    0.358289] ACPI: Fan [FAN3] (off)
[    0.358380] ACPI: Fan [FAN4] (off)
[    0.358489] ACPI: Requesting acpi_cpufreq
[    0.358867] thermal LNXTHERM:00: registered as thermal_zone0
[    0.358961] ACPI: Thermal Zone [TZ00] (28 C)
[    0.359175] thermal LNXTHERM:01: registered as thermal_zone1
[    0.359259] ACPI: Thermal Zone [TZ01] (30 C)
[    0.359363] [drm] Initialized drm 1.1.0 20060810
[    0.359454] usbcore: registered new interface driver udl
[    0.360055] brd: module loaded
[    0.360378] loop: module loaded
[    0.360477] Uniform Multi-Platform E-IDE driver
[    0.360578] ide-gd driver 1.18
[    0.360660] ide-cd driver 5.00
[    0.360776] ahci 0000:00:1f.2: version 3.0
[    0.360838] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.370908] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps =
0x3f impl SATA mode
[    0.371044] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part =
ems apst=20
[    0.371179] ahci 0000:00:1f.2: setting latency timer to 64
[    0.381004] scsi0 : ahci
[    0.381134] scsi1 : ahci
[    0.381239] scsi2 : ahci
[    0.381346] scsi3 : ahci
[    0.381450] scsi4 : ahci
[    0.381557] scsi5 : ahci
[    0.381686] ata1: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
100 irq 41
[    0.381820] ata2: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
180 irq 41
[    0.381957] ata3: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
200 irq 41
[    0.382090] ata4: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
280 irq 41
[    0.382224] ata5: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
300 irq 41
[    0.382357] ata6: SATA max UDMA/133 abar m2048@0xf063a000 port 0xf063a=
380 irq 41
[    0.382554] ahci 0000:04:00.0: irq 42 for MSI/MSI-X
[    0.382581] ahci: SSS flag set, parallel bus scan disabled
[    0.382708] ahci 0000:04:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps =
0x3 impl SATA mode
[    0.382843] ahci 0000:04:00.0: flags: 64bit ncq sntf stag led clo pmp =
pio slum part ccc=20
[    0.383087] scsi6 : ahci
[    0.383194] scsi7 : ahci
[    0.383288] ata7: SATA max UDMA/133 abar m512@0xf0400000 port 0xf04001=
00 irq 42
[    0.383423] ata8: SATA max UDMA/133 abar m512@0xf0400000 port 0xf04001=
80 irq 42
[    0.383601] tun: Universal TUN/TAP device driver, 1.6
[    0.383685] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.383785] VMware vmxnet3 virtual NIC driver - version 1.1.30.0-k-NAP=
I
[    0.383895] usbcore: registered new interface driver usb-storage
[    0.383994] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    0.386339] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.386425] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.386546] mousedev: PS/2 mouse device common for all mice
[    0.386688] I2O subsystem v1.325
[    0.386769] i2o: max drivers =3D 8
[    0.386900] I2O ProcFS OSM v1.316
[    0.386992] rtc_cmos 00:05: RTC can wake from S4
[    0.387157] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.387262] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvr=
am, hpet irqs
[    0.387398] i2c /dev entries driver
[    0.387537] applesmc: supported laptop not found!
[    0.387620] applesmc: driver init failed (ret=3D-19)!
[    0.387835] pc87360: PC8736x not detected, module not inserted
[    0.388010] md: raid0 personality registered for level 0
[    0.388094] md: raid1 personality registered for level 1
[    0.388265] cpuidle: using governor ladder
[    0.388461] cpuidle: using governor menu
[    0.388549] sdhci: Secure Digital Host Controller Interface driver
[    0.388634] sdhci: Copyright(c) Pierre Ossman
[    0.388722] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    0.388806] wbsd: Copyright(c) Pierre Ossman
[    0.388905] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0=
400
[    0.389000] usbcore: registered new interface driver vub300
[    0.389162] usbcore: registered new interface driver ushc
[    0.389246] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.389336] hidraw: raw HID events driver (C) Jiri Kosina
[    0.389491] usbcore: registered new interface driver usbhid
[    0.389575] usbhid: USB HID core driver
[    0.389727] ashmem: initialized
[    0.389828] logger: created 256K log 'log_main'
[    0.389936] logger: created 256K log 'log_events'
[    0.390039] logger: created 256K log 'log_radio'
[    0.390140] logger: created 256K log 'log_system'
[    0.390226] hdaps: supported laptop not found!
[    0.390309] hdaps: driver init failed (ret=3D-19)!
[    0.390507] Netfilter messages via NETLINK v0.30.
[    0.390597] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.390735] ctnetlink v0.93: registering with nfnetlink.
[    0.390820] NF_TPROXY: Transparent proxy support initialized, version =
4.1.0
[    0.390913] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[    0.391021] ipip: IPv4 over IPv4 tunneling driver
[    0.391176] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.391282] arp_tables: (C) 2002 David S. Miller
[    0.391372] TCP: cubic registered
[    0.391454] NET: Registered protocol family 17
[    0.391560] Bridge firewalling registered
[    0.391644] Ebtables v2.0 registered
[    0.391733] 8021q: 802.1Q VLAN Support v1.8
[    0.686420] ata5: SATA link down (SStatus 0 SControl 300)
[    0.686519] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.686620] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.686718] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.686816] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.686914] ata6: SATA link down (SStatus 0 SControl 300)
[    0.687153] ata2.00: ATA-9: SAMSUNG SSD 830 Series, CXM03B1Q, max UDMA=
/133
[    0.687245] ata2.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    0.687416] ata7: SATA link down (SStatus 0 SControl 300)
[    0.687451] ata1.00: ATA-9: Samsung SSD 840 PRO Series, DXM05B0Q, max =
UDMA/133
[    0.687452] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/=
32), AA
[    0.687690] ata2.00: configured for UDMA/133
[    0.687876] ata1.00: configured for UDMA/133
[    0.688387] ata4.00: HPA detected: current 1953523055, native 19535251=
68
[    0.688476] ata4.00: ATA-8: ST31000340AS, SD15, max UDMA/133
[    0.688564] ata4.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 31=
/32)
[    0.688691] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND =
(20130517/psargs-359)
[    0.688916] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0=
=2ESPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND (20130517/psparse-536=
)
[    0.689182] ata3.00: ATAPI: Optiarc DVD RW AD-7241S, 1.03, max UDMA/10=
0
[    0.690807] ata4.00: configured for UDMA/133
[    0.691170] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND =
(20130517/psargs-359)
[    0.691399] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0=
=2ESPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND (20130517/psparse-536=
)
[    0.691662] ata3.00: configured for UDMA/100
[    1.345352] tsc: Refined TSC clocksource calibration: 3501.307 MHz
[    2.343850] Switched to clocksource tsc
[    3.370170] floppy0: no floppy controllers found
[    3.370387] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  =
DXM0 PQ: 0 ANSI: 5
[    3.370599] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.370616] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 =
GB/238 GiB)
[    3.370753] sd 0:0:0:0: [sda] Write Protect is off
[    3.370754] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.370795] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    3.371129] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SSD 830  =
CXM0 PQ: 0 ANSI: 5
[    3.371343] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.371358] sd 1:0:0:0: [sdb] 250069680 512-byte logical blocks: (128 =
GB/119 GiB)
[    3.371471] sd 1:0:0:0: [sdb] Write Protect is off
[    3.371472] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.371516] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    3.371795]  sda: sda1 sda2
[    3.372198] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.372794]  sdb: sdb1
[    3.372961] scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7241S  =
1.03 PQ: 0 ANSI: 5
[    3.373121] sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.375064] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form=
2 cdda tray
[    3.375200] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.375343] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    3.375389] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    3.375554] scsi 3:0:0:0: Direct-Access     ATA      ST31000340AS     =
SD15 PQ: 0 ANSI: 5
[    3.375753] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.375766] sd 3:0:0:0: [sdc] 1953523055 512-byte logical blocks: (1.0=
0 TB/931 GiB)
[    3.375844] sd 3:0:0:0: [sdc] Write Protect is off
[    3.375845] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.375878] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    3.438492]  sdc: sdc1 sdc2 < sdc5 sdc6 sdc7 sdc8 >
[    3.439020] sd 3:0:0:0: [sdc] Attached SCSI disk
[    3.681674] ata8: SATA link down (SStatus 0 SControl 300)
[    3.681806] registered taskstats version 1
[    3.682212] rtc_cmos 00:05: setting system clock to 2013-10-24 05:22:1=
7 UTC (1382592137)
[    3.683261] ALSA device list:
[    3.683341]   No soundcards found.
[    3.683435] md: Waiting for all devices to be available before autodet=
ect
[    3.683521] md: If you don't use raid, use raid=3Dnoautodetect
[    3.683669] md: Autodetecting RAID arrays.
[    3.724220] md: Scanned 3 and added 3 devices.
[    3.724304] md: autorun ...
[    3.724384] md: considering sdc8 ...
[    3.724467] md:  adding sdc8 ...
[    3.724548] md: sdc7 has different UUID to sdc8
[    3.724634] md: sdc6 has different UUID to sdc8
[    3.724793] md: created md127
[    3.724876] md: bind<sdc8>
[    3.724961] md: running: <sdc8>
[    3.725286] md/raid1:md127: active with 1 out of 2 mirrors
[    3.725380] md127: detected capacity change from 0 to 695924359168
[    3.725469] md: considering sdc7 ...
[    3.725551] md:  adding sdc7 ...
[    3.725637] md: sdc6 has different UUID to sdc7
[    3.725785] md: created md123
[    3.725867] md: bind<sdc7>
[    3.725950] md: running: <sdc7>
[    3.726252] md/raid1:md123: active with 1 out of 2 mirrors
[    3.726344] md123: detected capacity change from 0 to 150004301824
[    3.726440] md: considering sdc6 ...
[    3.726521] md:  adding sdc6 ...
[    3.726650] md: created md122
[    3.726729] md: bind<sdc6>
[    3.726811] md: running: <sdc6>
[    3.727046] md/raid1:md122: active with 1 out of 2 mirrors
[    3.727138] md122: detected capacity change from 0 to 150004301824
[    3.727226] md: ... autorun DONE.
[    3.729041] EXT3-fs (sda2): error: couldn't mount because of unsupport=
ed optional features (240)
[    3.729781] EXT2-fs (sda2): error: couldn't mount because of unsupport=
ed optional features (244)
[    3.733781] EXT4-fs (sda2): INFO: recovery required on readonly filesy=
stem
[    3.733868] EXT4-fs (sda2): write access will be enabled during recove=
ry
[    3.798193] EXT4-fs (sda2): orphan cleanup on readonly fs
[    3.798304] EXT4-fs (sda2): 5 orphan inodes deleted
[    3.798387] EXT4-fs (sda2): recovery complete
[    3.806432] EXT4-fs (sda2): mounted filesystem with ordered data mode.=
 Opts: (null)
[    3.806573] VFS: Mounted root (ext4 filesystem) readonly on device 8:2=
=2E
[    3.809043] devtmpfs: mounted
[    3.809240] Freeing unused kernel memory: 932K (ffffffff81afe000 - fff=
fffff81be7000)
[    4.148402] systemd-udevd[266]: starting version 204
[    4.203298] pps_core: LinuxPPS API ver. 1 registered
[    4.203300] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    4.203495] ACPI Warning: 0x000000000000f040-0x000000000000f05f System=
IO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130517/utaddress-251)
[    4.203499] ACPI: If an ACPI driver is available for this device, you =
should use it instead of the native driver
[    4.203592] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    4.203869] ehci-pci: EHCI PCI platform driver
[    4.203903] PTP clock support registered
[    4.203938] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    4.203943] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    4.203947] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bu=
s number 1
[    4.203955] ehci-pci 0000:00:1a.0: debug port 2
[    4.207838] ehci-pci 0000:00:1a.0: cache line size of 64 is not suppor=
ted
[    4.207850] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf063c000
[    4.213807] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    4.213817] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.213818] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.213819] usb usb1: Product: EHCI Host Controller
[    4.213820] usb usb1: Manufacturer: Linux 3.11.3-gentoo ehci_hcd
[    4.213821] usb usb1: SerialNumber: 0000:00:1a.0
[    4.213889] hub 1-0:1.0: USB hub found
[    4.213892] hub 1-0:1.0: 2 ports detected
[    4.214034] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    4.214038] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    4.214042] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bu=
s number 2
[    4.214051] ehci-pci 0000:00:1d.0: debug port 2
[    4.214481] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.214482] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    4.217954] ehci-pci 0000:00:1d.0: cache line size of 64 is not suppor=
ted
[    4.217966] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf063b000
[    4.223789] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    4.223800] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.223801] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    4.223803] usb usb2: Product: EHCI Host Controller
[    4.223804] usb usb2: Manufacturer: Linux 3.11.3-gentoo ehci_hcd
[    4.223805] usb usb2: SerialNumber: 0000:00:1d.0
[    4.223875] hub 2-0:1.0: USB hub found
[    4.223876] hub 2-0:1.0: 2 ports detected
[    4.224090] [drm:i915_dump_device_info], i915 device info: gen=3D7, pc=
iid=3D0x0412 flags=3Dneed_gfx_hws,is_haswell,has_force_wake,has_hotplug,h=
as_bsd_ring,has_blt_ring,has_vebox_ring,has_llc,has_ddi,has_fpga_dbg,
[    4.224387] [drm] Memory usable by graphics device =3D 2048M
[    4.224389] [drm:i915_gem_gtt_init], GMADR size =3D 256M
[    4.224389] [drm:i915_gem_gtt_init], GTT stolen size =3D 256M
[    4.224392] i915 0000:00:02.0: setting latency timer to 64
[    4.240429] [drm:intel_detect_pch], Found LynxPoint PCH
[    4.240550] [drm:intel_opregion_setup], graphic opregion physical addr=
: 0xccafc018
[    4.240554] [drm:intel_opregion_setup], Public ACPI methods supported
[    4.240555] [drm:intel_opregion_setup], SWSCI supported
[    4.240555] [drm:intel_opregion_setup], ASLE supported
[    4.240587] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    4.240592] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
=2E
[    4.240593] [drm] Driver supports precise vblank timestamp query.
[    4.240594] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    4.240595] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT HASW=
ELL        d
[    4.240596] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_=
support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_cloc=
k_mode 0 fdi_rx_polarity_inverted 0
[    4.240597] [drm:parse_general_definitions], crt_ddc_bus_pin: 2
[    4.240599] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT t=
ables:
[    4.240600] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" =
0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    4.240601] [drm:parse_lfp_panel_data], VBT initial LVDS value 300
[    4.240602] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS=
 VBT tables:
[    4.240603] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200"=
 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    4.240604] [drm:parse_sdvo_device_mapping], No SDVO device info is fo=
und in VBT
[    4.240608] [drm:intel_dsm_pci_probe], no _DSM method for intel device=

[    4.240610] [drm:i915_gem_init_stolen], found 268435456 bytes of stole=
n memory at cf200000
[    4.240632] [drm:intel_modeset_init], 3 display pipes available.
[    4.240639] [drm:intel_ddi_pll_init], CDCLK running at 540000KHz
[    4.240640] [drm:intel_shared_dpll_init], 0 shared PLLs initialized
[    4.240642] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecode=
s=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
[    4.240959] [drm:intel_dp_init_connector], Adding DP connector on port=
 B
[    4.240979] [drm:intel_dp_i2c_init], i2c_init DPDDC-B
[    4.243816] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.243820] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.244037]  md122: unknown partition table
[    4.246275]  md123: unknown partition table
[    4.246625] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.246629] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.246667] [drm:intel_dp_init_connector], Adding DP connector on port=
 C
[    4.246677] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    4.246884] [drm:intel_dp_i2c_aux_ch], aux_i2c nack
[    4.247088] [drm:intel_dp_i2c_aux_ch], aux_i2c nack
[    4.247125] [drm:intel_dp_init_connector], Adding DP connector on port=
 D
[    4.247132] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    4.248606]  md127: unknown partition table
[    4.249946] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.249949] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.252760] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.252764] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    4.322658] [drm:i915_gem_setup_global_gtt], clearing unused GTT space=
: [0, 7fdff000]
[    4.323703] [drm:init_status_page], render ring hws offset: 0x00000000=

[    4.325692] [drm:init_pipe_control], render ring pipe control offset: =
0x00021000
[    4.325700] [drm:init_status_page], bsd ring hws offset: 0x00022000
[    4.325748] [drm:init_status_page], blitter ring hws offset: 0x0004300=
0
[    4.325792] [drm:init_status_page], video enhancement ring hws offset:=
 0x00064000
[    4.325860] [drm:create_default_context], Default HW context loaded
[    4.325860] [drm:i915_gem_context_init], HW context support initialize=
d
[    4.325879] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port A in DP mode
[    4.325886] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port B in DP mode
[    4.325893] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port C in DP mode
[    4.325899] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port D in DP mode
[    4.325906] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port E in FDI mode
[    4.325938] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state re=
adout: enabled
[    4.325940] [drm:intel_modeset_readout_hw_state], [CRTC:5] hw state re=
adout: disabled
[    4.325941] [drm:intel_modeset_readout_hw_state], [CRTC:7] hw state re=
adout: disabled
[    4.325942] [drm:intel_ddi_get_crtc_pll], Pipe A connected to port C u=
sing clock 0x00000000
[    4.325944] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] =
hw state readout: disabled, pipe=3D0
[    4.325945] [drm:intel_modeset_readout_hw_state], [ENCODER:11:TMDS-11]=
 hw state readout: disabled, pipe=3D0
[    4.325947] [drm:intel_modeset_readout_hw_state], [ENCODER:16:TMDS-16]=
 hw state readout: enabled, pipe=3D0
[    4.325948] [drm:intel_modeset_readout_hw_state], [ENCODER:19:TMDS-19]=
 hw state readout: disabled, pipe=3D0
[    4.325949] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] =
hw state readout: disabled
[    4.325950] [drm:intel_modeset_readout_hw_state], [CONNECTOR:12:DP-1] =
hw state readout: disabled
[    4.325951] [drm:intel_modeset_readout_hw_state], [CONNECTOR:15:HDMI-A=
-1] hw state readout: disabled
[    4.325952] [drm:intel_modeset_readout_hw_state], [CONNECTOR:17:DP-2] =
hw state readout: enabled
[    4.325954] [drm:intel_modeset_readout_hw_state], [CONNECTOR:18:HDMI-A=
-2] hw state readout: disabled
[    4.325955] [drm:intel_modeset_readout_hw_state], [CONNECTOR:20:DP-3] =
hw state readout: disabled
[    4.325956] [drm:intel_modeset_readout_hw_state], [CONNECTOR:21:HDMI-A=
-3] hw state readout: disabled
[    4.325957] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] con=
fig for pipe A
[    4.325958] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    4.325959] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    4.325960] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    4.325961] [drm:intel_dump_pipe_config], requested mode:
[    4.325962] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 720 =
0 0 0 400 0 0 0 0x0 0x0
[    4.325963] [drm:intel_dump_pipe_config], adjusted mode:
[    4.325964] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x5
[    4.325965] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[    4.325966] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x028001e0
[    4.325966] [drm:intel_dump_pipe_config], ips: 0
[    4.325968] [drm:intel_dump_pipe_config], [CRTC:5][setup_hw_state] con=
fig for pipe B
[    4.325968] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    4.325969] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    4.325970] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    4.325971] [drm:intel_dump_pipe_config], requested mode:
[    4.325971] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.325972] [drm:intel_dump_pipe_config], adjusted mode:
[    4.325973] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.325974] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[    4.325975] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[    4.325975] [drm:intel_dump_pipe_config], ips: 0
[    4.325976] [drm:intel_dump_pipe_config], [CRTC:7][setup_hw_state] con=
fig for pipe C
[    4.325977] [drm:intel_dump_pipe_config], cpu_transcoder: C
[    4.325978] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[    4.325978] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    4.325979] [drm:intel_dump_pipe_config], requested mode:
[    4.325980] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.325981] [drm:intel_dump_pipe_config], adjusted mode:
[    4.325981] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.325982] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[    4.325983] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[    4.325984] [drm:intel_dump_pipe_config], ips: 0
[    4.325986] [drm:intel_connector_check_state], [CONNECTOR:17:DP-2]
[    4.325987] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    4.325988] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[    4.325989] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[    4.325990] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[    4.325991] [drm:check_crtc_state], [CRTC:3]
[    4.325994] [drm:check_crtc_state], [CRTC:5]
[    4.325995] [drm:check_crtc_state], [CRTC:7]
[    4.325999] [drm:intel_crt_reset], pch crt adpa set to 0xf40000
[    4.326005] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector VGA-1 1920x1200@60Hz
[    4.326006] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector DP-1 1920x1200@60Hz
[    4.326007] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector HDMI-A-1 1920x1200@60Hz
[    4.326008] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector DP-2 1920x1200@60Hz
[    4.326009] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector HDMI-A-2 1920x1200@60Hz
[    4.326010] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector DP-3 1920x1200@60Hz
[    4.326011] [drm:drm_fb_helper_parse_command_line], cmdline mode for c=
onnector HDMI-A-3 1920x1200@60Hz
[    4.326013] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1]
[    4.326015] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug d=
etect cycle: adpa=3D0xf40000
[    4.335626] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug =
adpa=3D0xf40000, result 0
[    4.335628] [drm:intel_crt_detect], CRT not detected via hotplug
[    4.335779] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 005=
0 r(1)
[    4.335781] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[    4.335782] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retr=
y using GPIO bit-banging
[    4.335783] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 =
gmbus vga. force bit now 1
[    4.336101] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[    4.336102] [drm:intel_gmbus_force_bit], disabling bit-banging on i915=
 gmbus vga. force bit now 0
[    4.336103] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 =
[no valid EDID found]
[    4.336104] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1] disconnected
[    4.336105] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1]
[    4.338980] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.343483] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.347455] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[    4.348589] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1] disconnected
[    4.348591] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1]
[    4.373771] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[    4.373776] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1] probed modes :
[    4.373777] [drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1200=
" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    4.373779] [drm:drm_mode_debug_printmodeline], Modeline 24:"1920x1080=
" 60 172780 1920 2040 2248 2576 1080 1081 1084 1118 0x0 0x6
[    4.373781] [drm:drm_mode_debug_printmodeline], Modeline 29:"1600x1200=
" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    4.373782] [drm:drm_mode_debug_printmodeline], Modeline 30:"1680x1050=
" 60 119000 1680 1728 1760 1840 1050 1053 1059 1080 0x40 0x9
[    4.373784] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024=
" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    4.373786] [drm:drm_mode_debug_printmodeline], Modeline 28:"1440x900"=
 60 88750 1440 1488 1520 1600 900 903 909 926 0x40 0x9
[    4.373788] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x960"=
 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[    4.373790] [drm:drm_mode_debug_printmodeline], Modeline 25:"1280x720"=
 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[    4.373791] [drm:drm_mode_debug_printmodeline], Modeline 33:"1024x768"=
 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    4.373793] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" =
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    4.373795] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" =
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    4.373797] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2]
[    4.374083] [drm:intel_dp_get_dpcd], DPCD: 12 14 e4 01 01 01 01 81 00 =
00 00 00 00 00 00
[    4.375459] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.375640] [drm:intel_dp_probe_oui], Sink OUI: 0080e1
[    4.375820] [drm:intel_dp_probe_oui], Branch OUI: 0080e1
[    4.376905] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.408294] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.439621] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.439624] [drm:drm_detect_monitor_audio], Monitor has basic audio su=
pport
[    4.440715] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.472225] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.502494] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[    4.502535] [drm:drm_edid_to_eld], ELD monitor DELL U3014
[    4.502536] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
[    4.502554] [drm:drm_mode_debug_printmodeline], Modeline 59:"1440x480i=
" 0 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x101a
[    4.502556] [drm:drm_mode_prune_invalid], Not using 1440x480i mode 3
[    4.502557] [drm:drm_mode_debug_printmodeline], Modeline 60:"1440x576i=
" 0 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x101a
[    4.502559] [drm:drm_mode_prune_invalid], Not using 1440x576i mode 3
[    4.502560] [drm:drm_mode_debug_printmodeline], Modeline 79:"1440x480i=
" 60 27027 1440 1478 1602 1716 480 488 494 525 0x40 0x101a
[    4.502562] [drm:drm_mode_prune_invalid], Not using 1440x480i mode 3
[    4.502566] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2] probed modes :
[    4.502567] [drm:drm_mode_debug_printmodeline], Modeline 35:"2560x1600=
" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
[    4.502569] [drm:drm_mode_debug_printmodeline], Modeline 42:"1920x1200=
" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[    4.502570] [drm:drm_mode_debug_printmodeline], Modeline 36:"1920x1080=
" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
[    4.502572] [drm:drm_mode_debug_printmodeline], Modeline 70:"1920x1080=
" 60 148352 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
[    4.502574] [drm:drm_mode_debug_printmodeline], Modeline 37:"1920x1080=
i" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
[    4.502576] [drm:drm_mode_debug_printmodeline], Modeline 71:"1920x1080=
i" 60 74176 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
[    4.502578] [drm:drm_mode_debug_printmodeline], Modeline 68:"1920x1080=
" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
[    4.502579] [drm:drm_mode_debug_printmodeline], Modeline 67:"1920x1080=
i" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
[    4.502581] [drm:drm_mode_debug_printmodeline], Modeline 69:"1920x1080=
" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
[    4.502583] [drm:drm_mode_debug_printmodeline], Modeline 82:"1920x1080=
" 24 74176 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
[    4.502585] [drm:drm_mode_debug_printmodeline], Modeline 44:"1600x1200=
" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[    4.502586] [drm:drm_mode_debug_printmodeline], Modeline 41:"1680x1050=
" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[    4.502588] [drm:drm_mode_debug_printmodeline], Modeline 50:"1280x1024=
" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[    4.502590] [drm:drm_mode_debug_printmodeline], Modeline 45:"1280x1024=
" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[    4.502592] [drm:drm_mode_debug_printmodeline], Modeline 40:"1280x800"=
 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[    4.502593] [drm:drm_mode_debug_printmodeline], Modeline 43:"1152x864"=
 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[    4.502595] [drm:drm_mode_debug_printmodeline], Modeline 38:"1280x720"=
 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[    4.502597] [drm:drm_mode_debug_printmodeline], Modeline 72:"1280x720"=
 60 74176 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[    4.502599] [drm:drm_mode_debug_printmodeline], Modeline 66:"1280x720"=
 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
[    4.502600] [drm:drm_mode_debug_printmodeline], Modeline 51:"1024x768"=
 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[    4.502602] [drm:drm_mode_debug_printmodeline], Modeline 52:"1024x768"=
 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[    4.502604] [drm:drm_mode_debug_printmodeline], Modeline 53:"800x600" =
75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[    4.502606] [drm:drm_mode_debug_printmodeline], Modeline 46:"800x600" =
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[    4.502607] [drm:drm_mode_debug_printmodeline], Modeline 63:"720x576" =
50 27000 720 732 796 864 576 581 586 625 0x40 0xa
[    4.502609] [drm:drm_mode_debug_printmodeline], Modeline 39:"720x480" =
60 27030 720 736 798 858 480 489 495 525 0x40 0xa
[    4.502611] [drm:drm_mode_debug_printmodeline], Modeline 77:"720x480" =
60 27027 720 736 798 858 480 489 495 525 0x40 0xa
[    4.502613] [drm:drm_mode_debug_printmodeline], Modeline 57:"720x480" =
60 27000 720 736 798 858 480 489 495 525 0x40 0xa
[    4.502614] [drm:drm_mode_debug_printmodeline], Modeline 47:"640x480" =
75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[    4.502616] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" =
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[    4.502618] [drm:drm_mode_debug_printmodeline], Modeline 61:"640x480" =
60 25175 640 656 752 800 480 490 492 525 0x40 0xa
[    4.502619] [drm:drm_mode_debug_printmodeline], Modeline 49:"720x400" =
70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[    4.502622] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2]
[    4.502773] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 005=
0 r(1)
[    4.502775] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpc
[    4.502776] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2] disconnected
[    4.502777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3]
[    4.502779] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3] disconnected
[    4.502780] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3]
[    4.502928] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 005=
0 r(1)
[    4.502929] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpd
[    4.502930] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3] disconnected
[    4.502931] [drm:drm_setup_crtcs],=20
[    4.502932] [drm:drm_enable_connectors], connector 9 enabled? no
[    4.502933] [drm:drm_enable_connectors], connector 12 enabled? no
[    4.502934] [drm:drm_enable_connectors], connector 15 enabled? yes
[    4.502936] [drm:drm_enable_connectors], connector 17 enabled? yes
[    4.502936] [drm:drm_enable_connectors], connector 18 enabled? no
[    4.502937] [drm:drm_enable_connectors], connector 20 enabled? no
[    4.502938] [drm:drm_enable_connectors], connector 21 enabled? no
[    4.502939] [drm:drm_target_preferred], looking for cmdline mode on co=
nnector 15
[    4.502941] [drm:drm_target_preferred], found mode 1920x1200
[    4.502946] [drm:drm_target_preferred], looking for cmdline mode on co=
nnector 17
[    4.502947] [drm:drm_target_preferred], found mode 1920x1200
[    4.502948] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    4.502953] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc =
3
[    4.502954] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc =
5
[    4.502956] [drm:i915_gem_object_create_stolen], creating stolen objec=
t: size=3D8ca000
[    4.502958] [drm:i915_pages_create_for_stolen], offset=3D0x0, size=3D9=
216000
[    4.504082] [drm:intelfb_create], allocated 1920x1200 fb: 0x000a1000, =
bo ffff8807fda4be40
[    4.504115] fbcon: inteldrmfb (fb0) is primary device
[    4.505018] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.505019] [drm:intel_set_config_compute_mode_changes], crtc has no f=
b, full mode set
[    4.505020] [drm:intel_set_config_compute_mode_changes], modes are dif=
ferent, full mode set
[    4.505021] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.505023] [drm:drm_mode_debug_printmodeline], Modeline 54:"1920x1200=
" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    4.505023] [drm:intel_modeset_stage_output_state], encoder changed, f=
ull mode switch
[    4.505024] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [NOCRTC]
[    4.505025] [drm:intel_modeset_stage_output_state], encoder changed, f=
ull mode switch
[    4.505026] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.505026] [drm:intel_modeset_stage_output_state], crtc changed, full=
 mode switch
[    4.505027] [drm:intel_modeset_stage_output_state], crtc changed, full=
 mode switch
[    4.505028] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 1, prepare: 1, disable: 0
[    4.505030] [drm:connected_sink_compute_bpp], [CONNECTOR:15:HDMI-A-1] =
checking for sink bpp constrains
[    4.505031] [drm:intel_hdmi_compute_config], picking bpc to 8 for HDMI=
 output
[    4.505032] [drm:intel_hdmi_compute_config], forcing pipe bpc to 24 fo=
r HDMI
[    4.505033] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: =
24, dithering: 0
[    4.505034] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for=
 pipe A
[    4.505034] [drm:intel_dump_pipe_config], cpu_transcoder: A
[    4.505035] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    4.505036] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    4.505036] [drm:intel_dump_pipe_config], requested mode:
[    4.505038] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    4.505038] [drm:intel_dump_pipe_config], adjusted mode:
[    4.505040] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[    4.505041] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[    4.505041] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[    4.505042] [drm:intel_dump_pipe_config], ips: 0
[    4.516338] usb 1-1: new high-speed USB device number 2 using ehci-pci=

[    4.518345] [drm:intel_ddi_pll_mode_set], Using WRPLL 1 on pipe A
[    4.518891] [drm:intel_ddi_calculate_wrpll], WRPLL: 154000000Hz refres=
h rate with p=3D6, n2=3D53 r2=3D31
[    4.518920] [drm:ironlake_update_plane], Writing base 000A1000 0000000=
0 0 0 7680
[    4.518924] [drm:intel_crtc_mode_set], [ENCODER:11:TMDS-11] set [MODE:=
0:1920x1200]
[    4.518924] [drm:intel_ddi_mode_set], Preparing DDI mode on port B, pi=
pe A
[    4.570279] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    4.623205] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    4.625170] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]=

[    4.625172] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    4.625174] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[    4.625175] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[    4.625176] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[    4.625177] [drm:check_crtc_state], [CRTC:3]
[    4.625180] [drm:check_crtc_state], [CRTC:5]
[    4.625181] [drm:check_crtc_state], [CRTC:7]
[    4.625184] [drm:intel_crtc_set_config], [CRTC:5] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.625185] [drm:intel_set_config_compute_mode_changes], crtc has no f=
b, full mode set
[    4.625186] [drm:intel_set_config_compute_mode_changes], modes are dif=
ferent, full mode set
[    4.625187] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[    4.625189] [drm:drm_mode_debug_printmodeline], Modeline 55:"1920x1200=
" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[    4.625189] [drm:intel_modeset_stage_output_state], encoder changed, f=
ull mode switch
[    4.625190] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.625191] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.625191] [drm:intel_modeset_stage_output_state], crtc changed, full=
 mode switch
[    4.625192] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 2, prepare: 2, disable: 0
[    4.625194] [drm:connected_sink_compute_bpp], [CONNECTOR:17:DP-2] chec=
king for sink bpp constrains
[    4.625195] [drm:intel_dp_compute_config], DP link computation with ma=
x lane count 4 max bw 0a pixel clock 193250KHz
[    4.625197] [drm:intel_dp_compute_config], DP link bw 06 lane count 4 =
clock 162000 bpp 24
[    4.625198] [drm:intel_dp_compute_config], DP link bw required 463800 =
available 518400
[    4.625199] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: =
24, dithering: 0
[    4.625199] [drm:intel_dump_pipe_config], [CRTC:5][modeset] config for=
 pipe B
[    4.625200] [drm:intel_dump_pipe_config], cpu_transcoder: B
[    4.625200] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[    4.625201] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[    4.625202] [drm:intel_dump_pipe_config], requested mode:
[    4.625203] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[    4.625203] [drm:intel_dump_pipe_config], adjusted mode:
[    4.625204] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[    4.625205] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[    4.625205] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[    4.625206] [drm:intel_dump_pipe_config], ips: 0
[    4.625217] [drm:ironlake_update_plane], Writing base 000A1000 0000000=
0 0 0 7680
[    4.625222] [drm:intel_crtc_mode_set], [ENCODER:16:TMDS-16] set [MODE:=
0:1920x1200]
[    4.625223] [drm:intel_ddi_mode_set], Preparing DDI mode on port C, pi=
pe B
[    4.625223] [drm:intel_ddi_mode_set], DP audio on pipe B on DDI
[    4.625223] [drm:intel_ddi_mode_set], DP audio: write eld information
[    4.625224] [drm:intel_write_eld], ELD on [CONNECTOR:17:DP-2], [ENCODE=
R:16:TMDS-16]
[    4.625225] [drm:haswell_write_eld], HDMI: Haswell Audio initialize...=
=2E
[    4.625225] [drm:haswell_write_eld], HDMI audio: enable codec
[    4.632478] usb 1-1: New USB device found, idVendor=3D8087, idProduct=3D=
8008
[    4.632478] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    4.632615] hub 1-1:1.0: USB hub found
[    4.632722] hub 1-1:1.0: 6 ports detected
[    4.677091] [drm:ironlake_wait_for_vblank], vblank wait timed out
[    4.677092] [drm:haswell_write_eld], HDMI audio: pin eld vld status=3D=
0x      40
[    4.677093] [drm:haswell_write_eld], HDMI audio: eld vld status=3D0x  =
    50
[    4.677094] [drm:haswell_write_eld], HDMI audio: audio conf: 0x  70fa6=
0
[    4.677095] [drm:haswell_write_eld], ELD on pipe B
[    4.677095] [drm:haswell_write_eld], ELD: DisplayPort detected
[    4.677098] [drm:haswell_write_eld], port num:0
[    4.677098] [drm:haswell_write_eld], ELD size 9
[    4.678147] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[    4.679394] [drm:intel_dp_start_link_train], clock recovery OK
[    4.679394] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[    4.682072] [drm:intel_dp_complete_link_train], Channel EQ done. DP Tr=
aining successful
[    4.724010] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]=

[    4.724011] [drm:intel_connector_check_state], [CONNECTOR:17:DP-2]
[    4.724013] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[    4.724014] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[    4.724015] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[    4.724016] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[    4.724017] [drm:check_crtc_state], [CRTC:3]
[    4.724019] [drm:check_crtc_state], [CRTC:5]
[    4.724022] [drm:check_crtc_state], [CRTC:7]
[    4.724023] [drm:intel_crtc_set_config], [CRTC:7] [NOFB]
[    4.724025] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.724025] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.724045] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.724046] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.724046] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.724047] [drm:intel_crtc_set_config], [CRTC:5] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.724048] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.724048] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.727433] Console: switching to colour frame buffer device 240x75
[    4.727446] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.727447] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.727448] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.727448] [drm:intel_crtc_set_config], [CRTC:5] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    4.727449] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    4.727449] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    4.730830] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    4.730831] i915 0000:00:02.0: registered panic notifier
[    4.735011] usb 2-1: new high-speed USB device number 2 using ehci-pci=

[    4.737045] [drm:asle_set_backlight], bclp =3D 0x80000002
[    4.737048] [drm:intel_panel_get_max_backlight], max backlight PWM =3D=
 0
[    4.737088] [drm:asle_set_backlight], bclp =3D 0x800000ff
[    4.737089] [drm:intel_panel_get_max_backlight], max backlight PWM =3D=
 0
[    4.737120] acpi device:59: registered as cooling_device13
[    4.737138] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post:=
 no)
[    4.737157] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08=
:00/LNXVIDEO:00/input/input2
[    4.737191] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on =
minor 0
[    4.737274] e1000e 0000:00:19.0: setting latency timer to 64
[    4.737314] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) =
set to dynamic conservative mode
[    4.737325] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    4.850120] usb 2-1: New USB device found, idVendor=3D8087, idProduct=3D=
8000
[    4.850123] usb 2-1: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    4.850258] hub 2-1:1.0: USB hub found
[    4.850367] hub 2-1:1.0: 8 ports detected
[    4.887536] e1000e 0000:00:19.0 eth0: registered PHC clock
[    4.887538] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 7=
4:d0:2b:9c:94:20
[    4.887539] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connec=
tion
[    4.887563] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF=
-0FF
[    4.896759] systemd-udevd[286]: renamed network interface eth0 to eno1=

[    5.124456] usb 2-1.3: new high-speed USB device number 3 using ehci-p=
ci
[    5.211318] usb 2-1.3: New USB device found, idVendor=3D174c, idProduc=
t=3D2074
[    5.211321] usb 2-1.3: New USB device strings: Mfr=3D2, Product=3D3, S=
erialNumber=3D1
[    5.211323] usb 2-1.3: Product: ASM107x
[    5.211325] usb 2-1.3: Manufacturer: Asmedia
[    5.211326] usb 2-1.3: SerialNumber: 00000000A001
[    5.211594] hub 2-1.3:1.0: USB hub found
[    5.211815] hub 2-1.3:1.0: 4 ports detected
[    5.285199] usb 2-1.4: new full-speed USB device number 4 using ehci-p=
ci
[    5.371687] usb 2-1.4: string descriptor 0 read error: -22
[    5.371691] usb 2-1.4: New USB device found, idVendor=3D0b05, idProduc=
t=3D17d0
[    5.371693] usb 2-1.4: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    5.444946] usb 2-1.7: new high-speed USB device number 5 using ehci-p=
ci
[    5.533682] usb 2-1.7: New USB device found, idVendor=3D05e3, idProduc=
t=3D0723
[    5.533685] usb 2-1.7: New USB device strings: Mfr=3D3, Product=3D4, S=
erialNumber=3D0
[    5.533687] usb 2-1.7: Product: USB Storage
[    5.533688] usb 2-1.7: Manufacturer: Generic=20
[    5.534322] usb-storage 2-1.7:1.0: USB Mass Storage device detected
[    5.534380] usb-storage 2-1.7:1.0: Quirks match for vid 05e3 pid 0723:=
 8000
[    5.534438] scsi8 : usb-storage 2-1.7:1.0
[    5.614803] usb 2-1.3.2: new high-speed USB device number 6 using ehci=
-pci
[    5.707265] usb 2-1.3.2: New USB device found, idVendor=3D0451, idProd=
uct=3D8043
[    5.707268] usb 2-1.3.2: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D1
[    5.707270] usb 2-1.3.2: SerialNumber: 07030849BFB9
[    5.707431] hub 2-1.3.2:1.0: USB hub found
[    5.707519] hub 2-1.3.2:1.0: 3 ports detected
[    5.710512] [drm:intel_enable_rc6], Haswell: only RC6 available
[    5.710520] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    5.710536] [drm:gen6_enable_rps], Overclocking supported. Max: 1200MH=
z, Overclock max: 1300MHz
[    5.980085] usb 2-1.3.2.1: new full-speed USB device number 7 using eh=
ci-pci
[    6.068943] usb 2-1.3.2.1: New USB device found, idVendor=3D046d, idPr=
oduct=3Dc068
[    6.068945] usb 2-1.3.2.1: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
[    6.068946] usb 2-1.3.2.1: Product: G500
[    6.068947] usb 2-1.3.2.1: Manufacturer: Logitech
[    6.068948] usb 2-1.3.2.1: SerialNumber: 143DD65CE20018
[    6.071272] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.0/u=
sb2/2-1/2-1.3/2-1.3.2/2-1.3.2.1/2-1.3.2.1:1.0/input/input3
[    6.071335] hid-generic 0003:046D:C068.0001: input,hidraw0: USB HID v1=
=2E11 Mouse [Logitech G500] on usb-0000:00:1d.0-1.3.2.1/input0
[    6.075109] input: Logitech G500 as /devices/pci0000:00/0000:00:1d.0/u=
sb2/2-1/2-1.3/2-1.3.2/2-1.3.2.1/2-1.3.2.1:1.1/input/input4
[    6.075224] hid-generic 0003:046D:C068.0002: input,hiddev0,hidraw1: US=
B HID v1.11 Keyboard [Logitech G500] on usb-0000:00:1d.0-1.3.2.1/input1
[    6.147826] usb 2-1.3.2.2: new low-speed USB device number 8 using ehc=
i-pci
[    6.254906] usb 2-1.3.2.2: New USB device found, idVendor=3D045e, idPr=
oduct=3D00db
[    6.254908] usb 2-1.3.2.2: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
[    6.254909] usb 2-1.3.2.2: Product: Natural=C2=AE Ergonomic Keyboard 4=
000
[    6.254910] usb 2-1.3.2.2: Manufacturer: Microsoft
[    6.262602] input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000 as =
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.2/2-1.3.2.2/2-1.3.2=
=2E2:1.0/input/input5
[    6.262691] microsoft 0003:045E:00DB.0003: input,hidraw2: USB HID v1.1=
1 Keyboard [Microsoft Natural=C2=AE Ergonomic Keyboard 4000] on usb-0000:=
00:1d.0-1.3.2.2/input0
[    6.273800] input: Microsoft Natural=C2=AE Ergonomic Keyboard 4000 as =
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3.2/2-1.3.2.2/2-1.3.2=
=2E2:1.1/input/input6
[    6.273889] microsoft 0003:045E:00DB.0004: input,hidraw3: USB HID v1.1=
1 Device [Microsoft Natural=C2=AE Ergonomic Keyboard 4000] on usb-0000:00=
:1d.0-1.3.2.2/input1
[    6.346512] usb 2-1.3.2.3: new high-speed USB device number 9 using eh=
ci-pci
[    6.432117] usb 2-1.3.2.3: New USB device found, idVendor=3D0451, idPr=
oduct=3D8043
[    6.432119] usb 2-1.3.2.3: New USB device strings: Mfr=3D0, Product=3D=
0, SerialNumber=3D1
[    6.432120] usb 2-1.3.2.3: SerialNumber: 89030869BFB9
[    6.432269] hub 2-1.3.2.3:1.0: USB hub found
[    6.432368] hub 2-1.3.2.3:1.0: 3 ports detected
[    6.534471] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   =
9451 PQ: 0 ANSI: 0
[    6.534562] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    6.537461] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    6.704948] usb 2-1.3.2.3.3: new high-speed USB device number 10 using=
 ehci-pci
[    6.889154] usb 2-1.3.2.3.3: New USB device found, idVendor=3D0bda, id=
Product=3D0307
[    6.889156] usb 2-1.3.2.3.3: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
[    6.889158] usb 2-1.3.2.3.3: Product: USB3.0 Card Reader
[    6.889159] usb 2-1.3.2.3.3: Manufacturer: Realtek
[    6.889160] usb 2-1.3.2.3.3: SerialNumber: 201006010301
[    6.894161] usb-storage 2-1.3.2.3.3:1.0: USB Mass Storage device detec=
ted
[    6.894233] scsi9 : usb-storage 2-1.3.2.3.3:1.0
[    7.749145] EXT4-fs (sda2): re-mounted. Opts: (null)
[    7.809883] REISERFS (device md127): found reiserfs format "3.6" with =
standard journal
[    7.809889] REISERFS (device md127): using ordered data mode
[    7.809889] reiserfs: using flush barriers
[    7.810506] REISERFS (device md127): journal params: device md127, siz=
e 8192, journal first block 18, max trans len 1024, max batch 900, max co=
mmit age 30, max trans age 30
[    7.810707] REISERFS (device md127): checking transaction log (md127)
[    7.901190] scsi 9:0:0:0: Direct-Access     Generic- SD/MMC/MS/MSPRO  =
1.00 PQ: 0 ANSI: 4
[    7.901322] sd 9:0:0:0: Attached scsi generic sg5 type 0
[    7.906424] sd 9:0:0:0: [sde] Attached SCSI removable disk
[    7.909426] REISERFS (device md127): Using r5 hash to sort names
[    8.132596] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    8.132615] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    8.132618] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    8.132622] [drm:intel_crtc_set_config], [CRTC:5] [FB:56] #connectors=3D=
1 (x y) (0 0)
[    8.132626] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[    8.132628] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[    8.659126] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    8.759733] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   12.410460] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Co=
ntrol: Rx/Tx
[   38.166573] PM: Syncing filesystems ... done.
[   38.273817] Freezing user space processes ... (elapsed 0.001 seconds) =
done.
[   38.274955] Freezing remaining freezable tasks ... (elapsed 0.001 seco=
nds) done.
[   38.276127] Suspending console(s) (use no_console_suspend to debug)
[   38.276340] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[   38.276373] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[   38.276392] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   38.277867] sd 0:0:0:0: [sda] Stopping disk
[   38.278056] sd 1:0:0:0: [sdb] Stopping disk
[   38.291097] sd 3:0:0:0: [sdc] Stopping disk
[   38.299975] [drm:gm45_get_vblank_counter], trying to get vblank count =
for disabled pipe C
[   39.145722] PM: suspend of devices complete after 870.845 msecs
[   39.145817] PM: late suspend of devices complete after 0.094 msecs
[   39.146031] ehci-pci 0000:00:1d.0: System wakeup enabled by ACPI
[   39.156772] ehci-pci 0000:00:1a.0: System wakeup enabled by ACPI
[   39.167658] e1000e 0000:00:19.0: System wakeup enabled by ACPI
[   39.178706] PM: noirq suspend of devices complete after 32.939 msecs
[   39.179295] ACPI: Preparing to enter system sleep state S3
[   39.179597] PM: Saving platform NVS memory
[   39.182374] Disabling non-boot CPUs ...
[   39.183564] smpboot: CPU 1 is now offline
[   39.185001] smpboot: CPU 2 is now offline
[   39.186460] smpboot: CPU 3 is now offline
[   39.187784] smpboot: CPU 4 is now offline
[   39.189231] smpboot: CPU 5 is now offline
[   39.190456] smpboot: CPU 6 is now offline
[   39.191711] smpboot: CPU 7 is now offline
[   39.192856] ACPI: Low-level resume complete
[   39.192887] PM: Restoring platform NVS memory
[   39.193638] Enabling non-boot CPUs ...
[   39.193720] smpboot: Booting Node 0 Processor 1 APIC 0x2
[   39.207712] CPU1 is up
[   39.207755] smpboot: Booting Node 0 Processor 2 APIC 0x4
[   39.221845] CPU2 is up
[   39.221893] smpboot: Booting Node 0 Processor 3 APIC 0x6
[   39.235974] CPU3 is up
[   39.236021] smpboot: Booting Node 0 Processor 4 APIC 0x1
[   39.250015] CPU4 is up
[   39.250065] smpboot: Booting Node 0 Processor 5 APIC 0x3
[   39.264142] CPU5 is up
[   39.264203] smpboot: Booting Node 0 Processor 6 APIC 0x5
[   39.278323] CPU6 is up
[   39.278378] smpboot: Booting Node 0 Processor 7 APIC 0x7
[   39.292438] CPU7 is up
[   39.299252] ACPI: Waking up from system sleep state S3
[   39.332134] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[   39.343112] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[   39.365174] PM: noirq resume of devices complete after 65.731 msecs
[   39.365234] PM: early resume of devices complete after 0.046 msecs
[   39.365246] i915 0000:00:02.0: setting latency timer to 64
[   39.365251] e1000e 0000:00:19.0: System wakeup disabled by ACPI
[   39.365257] e1000e 0000:00:19.0: setting latency timer to 64
[   39.365265] ahci 0000:00:1f.2: setting latency timer to 64
[   39.365290] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[   39.365304] ehci-pci 0000:00:1a.0: setting latency timer to 64
[   39.365310] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off, defau=
lting to EHCI.
[   39.365310] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0 spe=
eds.
[   39.365331] ehci-pci 0000:00:1d.0: setting latency timer to 64
[   39.365336] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off, defau=
lting to EHCI.
[   39.365336] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0 spe=
eds.
[   39.366127] [drm:i915_redisable_vga], Something enabled VGA plane, dis=
abling it
[   39.366442] [drm:intel_opregion_setup], graphic opregion physical addr=
: 0xccafc018
[   39.366449] [drm:intel_opregion_setup], Public ACPI methods supported
[   39.366449] [drm:intel_opregion_setup], SWSCI supported
[   39.366449] [drm:intel_opregion_setup], ASLE supported
[   39.404149] [drm:init_status_page], render ring hws offset: 0x00000000=

[   39.406086] [drm:init_pipe_control], render ring pipe control offset: =
0x00021000
[   39.406098] [drm:init_status_page], bsd ring hws offset: 0x00022000
[   39.406239] [drm:init_status_page], blitter ring hws offset: 0x0004300=
0
[   39.406368] [drm:init_status_page], video enhancement ring hws offset:=
 0x00064000
[   39.406572] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port A in DP mode
[   39.406583] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port B in DP mode
[   39.406594] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port C in DP mode
[   39.406605] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port D in DP mode
[   39.406617] [drm:intel_prepare_ddi_buffers], Initializing DDI buffers =
for port E in FDI mode
[   39.406662] [drm:intel_modeset_readout_hw_state], [CRTC:3] hw state re=
adout: disabled
[   39.406665] [drm:intel_modeset_readout_hw_state], [CRTC:5] hw state re=
adout: disabled
[   39.406668] [drm:intel_modeset_readout_hw_state], [CRTC:7] hw state re=
adout: disabled
[   39.406673] [drm:intel_modeset_readout_hw_state], [ENCODER:10:DAC-10] =
hw state readout: disabled, pipe=3D0
[   39.406677] [drm:intel_modeset_readout_hw_state], [ENCODER:11:TMDS-11]=
 hw state readout: disabled, pipe=3D0
[   39.406680] [drm:intel_modeset_readout_hw_state], [ENCODER:16:TMDS-16]=
 hw state readout: disabled, pipe=3D0
[   39.406682] [drm:intel_modeset_readout_hw_state], [ENCODER:19:TMDS-19]=
 hw state readout: disabled, pipe=3D0
[   39.406686] [drm:intel_modeset_readout_hw_state], [CONNECTOR:9:VGA-1] =
hw state readout: disabled
[   39.406690] [drm:intel_modeset_readout_hw_state], [CONNECTOR:12:DP-1] =
hw state readout: disabled
[   39.406693] [drm:intel_modeset_readout_hw_state], [CONNECTOR:15:HDMI-A=
-1] hw state readout: disabled
[   39.406696] [drm:intel_modeset_readout_hw_state], [CONNECTOR:17:DP-2] =
hw state readout: disabled
[   39.406699] [drm:intel_modeset_readout_hw_state], [CONNECTOR:18:HDMI-A=
-2] hw state readout: disabled
[   39.406701] [drm:intel_modeset_readout_hw_state], [CONNECTOR:20:DP-3] =
hw state readout: disabled
[   39.406704] [drm:intel_modeset_readout_hw_state], [CONNECTOR:21:HDMI-A=
-3] hw state readout: disabled
[   39.406708] [drm:intel_dump_pipe_config], [CRTC:3][setup_hw_state] con=
fig for pipe A
[   39.406710] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   39.406713] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406716] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406718] [drm:intel_dump_pipe_config], requested mode:
[   39.406723] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406724] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406728] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406732] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   39.406734] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   39.406735] [drm:intel_dump_pipe_config], ips: 0
[   39.406739] [drm:intel_dump_pipe_config], [CRTC:5][setup_hw_state] con=
fig for pipe B
[   39.406740] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   39.406742] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406745] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406747] [drm:intel_dump_pipe_config], requested mode:
[   39.406750] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406752] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406756] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406758] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   39.406760] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   39.406762] [drm:intel_dump_pipe_config], ips: 0
[   39.406765] [drm:intel_dump_pipe_config], [CRTC:7][setup_hw_state] con=
fig for pipe C
[   39.406766] [drm:intel_dump_pipe_config], cpu_transcoder: C
[   39.406768] [drm:intel_dump_pipe_config], pipe bpp: 0, dithering: 0
[   39.406771] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406773] [drm:intel_dump_pipe_config], requested mode:
[   39.406776] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406778] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406781] [drm:drm_mode_debug_printmodeline], Modeline 0:"" 0 0 0 0 =
0 0 0 0 0 0 0x0 0x0
[   39.406784] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   39.406786] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   39.406787] [drm:intel_dump_pipe_config], ips: 0
[   39.406791] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 1, prepare: 1, disable: 0
[   39.406796] [drm:connected_sink_compute_bpp], [CONNECTOR:15:HDMI-A-1] =
checking for sink bpp constrains
[   39.406799] [drm:intel_hdmi_compute_config], picking bpc to 8 for HDMI=
 output
[   39.406801] [drm:intel_hdmi_compute_config], forcing pipe bpc to 24 fo=
r HDMI
[   39.406804] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: =
24, dithering: 0
[   39.406807] [drm:intel_dump_pipe_config], [CRTC:3][modeset] config for=
 pipe A
[   39.406808] [drm:intel_dump_pipe_config], cpu_transcoder: A
[   39.406810] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   39.406813] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.406815] [drm:intel_dump_pipe_config], requested mode:
[   39.406820] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.406821] [drm:intel_dump_pipe_config], adjusted mode:
[   39.406825] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.406828] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   39.406830] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   39.406832] [drm:intel_dump_pipe_config], ips: 0
[   39.406838] [drm:intel_ddi_put_crtc_pll], Disabling WRPLL 1
[   39.406839] ------------[ cut here ]------------
[   39.406861] WARNING: CPU: 1 PID: 1591 at drivers/gpu/drm/i915/intel_dd=
i.c:383 intel_ddi_put_crtc_pll+0x272/0x280 [i915]()
[   39.406869] Modules linked in: e1000e i915 ptp ehci_pci ehci_hcd i2c_i=
801 pps_core
[   39.406873] CPU: 1 PID: 1591 Comm: kworker/u16:21 Not tainted 3.11.3-g=
entoo #1
[   39.406875] Hardware name: ASUS All Series/Z87-PRO, BIOS 0801 04/19/20=
13
[   39.406883] Workqueue: events_unbound async_run_entry_fn
[   39.406887]  0000000000000009 ffff8807fa6119f0 ffffffff817e25b6 000000=
0000000000
[   39.406891]  ffff8807fa611a28 ffffffff8103f223 ffff8807fb5b0000 ffff88=
07fe726000
[   39.406894]  0000000000025990 0000000000000000 ffff8807fb72a000 ffff88=
07fa611a38
[   39.406895] Call Trace:
[   39.406903]  [<ffffffff817e25b6>] dump_stack+0x45/0x56
[   39.406909]  [<ffffffff8103f223>] warn_slowpath_common+0x73/0x90
[   39.406914]  [<ffffffff8103f2f5>] warn_slowpath_null+0x15/0x20
[   39.406927]  [<ffffffffa006bb42>] intel_ddi_put_crtc_pll+0x272/0x280 [=
i915]
[   39.406938]  [<ffffffffa006bb94>] intel_ddi_pll_mode_set+0x44/0x8a0 [i=
915]
[   39.406943]  [<ffffffff814ef03c>] ? drm_vblank_get+0x6c/0x2c0
[   39.406952]  [<ffffffffa0039cd7>] ? i915_read32+0x57/0xd0 [i915]
[   39.406967]  [<ffffffffa006088a>] haswell_crtc_mode_set+0x3a/0x320 [i9=
15]
[   39.406996]  [<ffffffffa0061a60>] __intel_set_mode+0x5b0/0x12f0 [i915]=

[   39.407010]  [<ffffffffa00671a5>] intel_modeset_setup_hw_state+0x755/0=
xa40 [i915]
[   39.407018]  [<ffffffff817e4a2d>] ? mutex_lock+0xd/0x2a
[   39.407026]  [<ffffffffa0039247>] __i915_drm_thaw+0x117/0x1b0 [i915]
[   39.407034]  [<ffffffffa003966a>] i915_resume+0x6a/0xb0 [i915]
[   39.407042]  [<ffffffffa00396c1>] i915_pm_resume+0x11/0x20 [i915]
[   39.407049]  [<ffffffff8144e1ff>] pci_pm_resume+0x5f/0xb0
[   39.407054]  [<ffffffff8144e1a0>] ? pci_pm_restore+0xb0/0xb0
[   39.407061]  [<ffffffff8153c679>] dpm_run_callback.isra.12+0x19/0x50
[   39.407066]  [<ffffffff8153c73e>] device_resume+0x8e/0x130
[   39.407071]  [<ffffffff8153c7f8>] async_resume+0x18/0x40
[   39.407075]  [<ffffffff810617c2>] async_run_entry_fn+0x32/0x130
[   39.407083]  [<ffffffff81054c36>] process_one_work+0x146/0x3d0
[   39.407088]  [<ffffffff81055809>] worker_thread+0x119/0x390
[   39.407093]  [<ffffffff810556f0>] ? manage_workers.isra.24+0x2a0/0x2a0=

[   39.407098]  [<ffffffff8105b42b>] kthread+0xbb/0xc0
[   39.407102]  [<ffffffff8105b370>] ? kthread_create_on_node+0x110/0x110=

[   39.407107]  [<ffffffff817e8a6c>] ret_from_fork+0x7c/0xb0
[   39.407111]  [<ffffffff8105b370>] ? kthread_create_on_node+0x110/0x110=

[   39.407114] ---[ end trace 13d5f7e465dbce0f ]---
[   39.407117] [drm:intel_ddi_pll_mode_set], Using WRPLL 1 on pipe A
[   39.409796] [drm:intel_ddi_calculate_wrpll], WRPLL: 154000000Hz refres=
h rate with p=3D6, n2=3D53 r2=3D31
[   39.409835] [drm:ironlake_update_plane], Writing base 000A1000 0000000=
0 0 0 7680
[   39.409850] [drm:intel_crtc_mode_set], [ENCODER:11:TMDS-11] set [MODE:=
0:1920x1200]
[   39.409853] [drm:intel_ddi_mode_set], Preparing DDI mode on port B, pi=
pe A
[   39.461955] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.513873] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.515875] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 2, prepare: 2, disable: 0
[   39.515880] [drm:connected_sink_compute_bpp], [CONNECTOR:17:DP-2] chec=
king for sink bpp constrains
[   39.515885] [drm:intel_dp_compute_config], DP link computation with ma=
x lane count 4 max bw 0a pixel clock 193250KHz
[   39.515895] [drm:intel_dp_compute_config], DP link bw 06 lane count 4 =
clock 162000 bpp 24
[   39.515898] [drm:intel_dp_compute_config], DP link bw required 463800 =
available 518400
[   39.515901] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: =
24, dithering: 0
[   39.515904] [drm:intel_dump_pipe_config], [CRTC:5][modeset] config for=
 pipe B
[   39.515906] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   39.515908] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   39.515911] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   39.515913] [drm:intel_dump_pipe_config], requested mode:
[   39.515918] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   39.515920] [drm:intel_dump_pipe_config], adjusted mode:
[   39.515925] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   39.515927] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   39.515929] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   39.515931] [drm:intel_dump_pipe_config], ips: 0
[   39.515956] [drm:ironlake_update_plane], Writing base 000A1000 0000000=
0 0 0 7680
[   39.515968] [drm:intel_crtc_mode_set], [ENCODER:16:TMDS-16] set [MODE:=
0:1920x1200]
[   39.515971] [drm:intel_ddi_mode_set], Preparing DDI mode on port C, pi=
pe B
[   39.515973] [drm:intel_ddi_mode_set], DP audio on pipe B on DDI
[   39.515974] [drm:intel_ddi_mode_set], DP audio: write eld information
[   39.515979] [drm:intel_write_eld], ELD on [CONNECTOR:17:DP-2], [ENCODE=
R:16:TMDS-16]
[   39.515981] [drm:haswell_write_eld], HDMI: Haswell Audio initialize...=
=2E
[   39.515983] [drm:haswell_write_eld], HDMI audio: enable codec
[   39.567784] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   39.567790] [drm:haswell_write_eld], HDMI audio: pin eld vld status=3D=
0x      40
[   39.567795] [drm:haswell_write_eld], HDMI audio: eld vld status=3D0x  =
    50
[   39.567798] [drm:haswell_write_eld], HDMI audio: audio conf: 0x  70fa6=
0
[   39.567802] [drm:haswell_write_eld], ELD on pipe B
[   39.567805] [drm:haswell_write_eld], ELD: DisplayPort detected
[   39.567812] [drm:haswell_write_eld], port num:0
[   39.567814] [drm:haswell_write_eld], ELD size 9
[   39.570850] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.575688] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.576902] usb 2-1.3: reset high-speed USB device number 3 using ehci=
-pci
[   39.579733] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.585734] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.585745] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[   39.588711] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.591827] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.591836] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[   39.594808] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.597921] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.602645] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.648648] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 0, prepare: 0, disable: 0
[   39.648660] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]=

[   39.648664] [drm:intel_connector_check_state], [CONNECTOR:17:DP-2]
[   39.648669] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   39.648673] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[   39.648676] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   39.648679] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[   39.648681] [drm:check_crtc_state], [CRTC:3]
[   39.648688] [drm:check_crtc_state], [CRTC:5]
[   39.648694] [drm:check_crtc_state], [CRTC:7]
[   39.648700] [drm:intel_crt_reset], pch crt adpa set to 0xf40000
[   39.648707] [drm:intel_resume_hotplug], running encoder hotplug functi=
ons
[   39.651653] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.656519] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.660525] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.661588] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug d=
etect cycle: adpa=3D0xf40000
[   39.669626] ata8: SATA link down (SStatus 0 SControl 300)
[   39.669661] ata7: SATA link down (SStatus 0 SControl 300)
[   39.671616] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug =
adpa=3D0xf40000, result 0
[   39.671619] [drm:intel_crt_detect], CRT not detected via hotplug
[   39.671634] ata5: SATA link down (SStatus 0 SControl 300)
[   39.671656] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   39.671814] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 005=
0 r(1)
[   39.671818] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   39.671820] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retr=
y using GPIO bit-banging
[   39.671823] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 =
gmbus vga. force bit now 1
[   39.672153] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   39.672156] [drm:intel_gmbus_force_bit], disabling bit-banging on i915=
 gmbus vga. force bit now 0
[   39.672158] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 =
[no valid EDID found]
[   39.672163] [drm:drm_helper_hpd_irq_event], [CONNECTOR:9:VGA-1] status=
 updated from unknown to disconnected
[   39.672971] ata2.00: configured for UDMA/133
[   39.673038] sd 1:0:0:0: [sdb] Starting disk
[   39.675109] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.675585] ata6: SATA link down (SStatus 0 SControl 300)
[   39.675608] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   39.677386] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND =
(20130517/psargs-359)
[   39.677399] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0=
=2ESPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND (20130517/psparse-536=
)
[   39.679505] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.679566] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   39.683483] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.684555] [drm:drm_helper_hpd_irq_event], [CONNECTOR:12:DP-1] status=
 updated from unknown to disconnected
[   39.697243] [drm:drm_helper_hpd_irq_event], [CONNECTOR:15:HDMI-A-1] st=
atus updated from unknown to connected
[   39.697249] [drm:drm_helper_hpd_irq_event], [CONNECTOR:17:DP-2] status=
 updated from unknown to disconnected
[   39.697419] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 005=
0 r(1)
[   39.697422] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpc
[   39.697427] [drm:drm_helper_hpd_irq_event], [CONNECTOR:18:HDMI-A-2] st=
atus updated from unknown to disconnected
[   39.697433] [drm:drm_helper_hpd_irq_event], [CONNECTOR:20:DP-3] status=
 updated from unknown to disconnected
[   39.697592] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 005=
0 r(1)
[   39.697595] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpd
[   39.697600] [drm:drm_helper_hpd_irq_event], [CONNECTOR:21:HDMI-A-3] st=
atus updated from unknown to disconnected
[   39.697631] [drm:drm_fb_helper_hotplug_event],=20
[   39.697636] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1]
[   39.697642] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug =
adpa=3D0xf40000, result 0
[   39.697645] [drm:intel_crt_detect], CRT not detected via hotplug
[   39.697813] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 005=
0 r(1)
[   39.697816] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   39.697818] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retr=
y using GPIO bit-banging
[   39.697820] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 =
gmbus vga. force bit now 1
[   39.698149] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   39.698151] [drm:intel_gmbus_force_bit], disabling bit-banging on i915=
 gmbus vga. force bit now 0
[   39.698153] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 =
[no valid EDID found]
[   39.698156] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1] disconnected
[   39.698160] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1]
[   39.701085] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.705437] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.709434] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   39.710507] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1] disconnected
[   39.710511] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1]
[   39.714802] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND =
(20130517/psargs-359)
[   39.714815] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0=
=2ESPT2._GTF] (Node ffff88081bd1d308), AE_NOT_FOUND (20130517/psparse-536=
)
[   39.714828] ata3.00: configured for UDMA/100
[   39.734520] usb 2-1.4: reset full-speed USB device number 4 using ehci=
-pci
[   39.735896] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   39.735916] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1] probed modes :
[   39.735925] [drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1200=
" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   39.735933] [drm:drm_mode_debug_printmodeline], Modeline 24:"1920x1080=
" 60 172780 1920 2040 2248 2576 1080 1081 1084 1118 0x0 0x6
[   39.735940] [drm:drm_mode_debug_printmodeline], Modeline 29:"1600x1200=
" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   39.735947] [drm:drm_mode_debug_printmodeline], Modeline 30:"1680x1050=
" 60 119000 1680 1728 1760 1840 1050 1053 1059 1080 0x40 0x9
[   39.735954] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024=
" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   39.735962] [drm:drm_mode_debug_printmodeline], Modeline 28:"1440x900"=
 60 88750 1440 1488 1520 1600 900 903 909 926 0x40 0x9
[   39.735970] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x960"=
 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   39.735977] [drm:drm_mode_debug_printmodeline], Modeline 25:"1280x720"=
 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   39.735984] [drm:drm_mode_debug_printmodeline], Modeline 33:"1024x768"=
 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   39.735991] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" =
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   39.735998] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" =
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   39.736003] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2]
[   39.736010] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2] disconnected
[   39.736024] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2]
[   39.736192] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 005=
0 r(1)
[   39.736196] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpc
[   39.736200] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2] disconnected
[   39.736204] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3]
[   39.736209] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3] disconnected
[   39.736213] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3]
[   39.736372] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 005=
0 r(1)
[   39.736375] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpd
[   39.736379] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3] disconnected
[   39.736382] [drm:drm_setup_crtcs],=20
[   39.736386] [drm:drm_enable_connectors], connector 9 enabled? no
[   39.736390] [drm:drm_enable_connectors], connector 12 enabled? no
[   39.736393] [drm:drm_enable_connectors], connector 15 enabled? yes
[   39.736396] [drm:drm_enable_connectors], connector 17 enabled? no
[   39.736399] [drm:drm_enable_connectors], connector 18 enabled? no
[   39.736402] [drm:drm_enable_connectors], connector 20 enabled? no
[   39.736405] [drm:drm_enable_connectors], connector 21 enabled? no
[   39.736408] [drm:drm_target_preferred], looking for cmdline mode on co=
nnector 15
[   39.736411] [drm:drm_target_preferred], found mode 1920x1200
[   39.736415] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[   39.736421] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc =
3
[   39.736429] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[   39.736436] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   39.736440] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[   39.736445] [drm:intel_crtc_set_config], [CRTC:5] [NOFB]
[   39.736450] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [NOCRTC]
[   39.736461] [drm:intel_modeset_stage_output_state], encoder changed, f=
ull mode switch
[   39.736466] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   39.736469] [drm:intel_modeset_stage_output_state], crtc changed, full=
 mode switch
[   39.736480] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 0, prepare: 0, disable: 2
[   39.764504] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]=

[   39.764509] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   39.764512] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[   39.764515] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   39.764518] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[   39.764520] [drm:check_crtc_state], [CRTC:3]
[   39.764527] [drm:check_crtc_state], [CRTC:5]
[   39.764529] [drm:check_crtc_state], [CRTC:7]
[   39.764534] [drm:intel_crtc_set_config], [CRTC:7] [NOFB]
[   39.764539] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   39.767552] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[   39.767557] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   39.782364] ata1.00: configured for UDMA/133
[   39.782461] sd 0:0:0:0: [sda] Starting disk
[   39.892256] usb 2-1.7: reset high-speed USB device number 5 using ehci=
-pci
[   40.057124] usb 2-1.3.2: reset high-speed USB device number 6 using eh=
ci-pci
[   40.075365] [drm:i915_hotplug_work_func], running encoder hotplug func=
tions
[   40.075366] [drm:i915_hotplug_work_func], Connector DP-2 (pin 5) recei=
ved hotplug event.
[   40.075367] [drm:i915_hotplug_work_func], Connector HDMI-A-2 (pin 5) r=
eceived hotplug event.
[   40.075657] [drm:intel_dp_get_dpcd], DPCD: 12 14 e4 01 01 01 01 81 00 =
00 00 00 00 00 00
[   40.077035] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.077215] [drm:intel_dp_probe_oui], Sink OUI: 0080e1
[   40.077395] [drm:intel_dp_probe_oui], Branch OUI: 0080e1
[   40.078478] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.108796] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.139028] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.139029] [drm:drm_detect_monitor_audio], Monitor has basic audio su=
pport
[   40.139030] [drm:intel_hpd_irq_event], [CONNECTOR:17:DP-2] status upda=
ted from 2 to 1
[   40.139181] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 005=
0 r(1)
[   40.139182] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpc
[   40.139183] [drm:intel_hpd_irq_event], [CONNECTOR:18:HDMI-A-2] status =
updated from 2 to 2
[   40.139189] [drm:drm_fb_helper_hotplug_event],=20
[   40.139190] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1]
[   40.139192] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug =
adpa=3D0xf40000, result 0
[   40.139193] [drm:intel_crt_detect], CRT not detected via hotplug
[   40.139349] [drm:gmbus_xfer], GMBUS [i915 gmbus vga] NAK for addr: 005=
0 r(1)
[   40.139350] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   40.139350] [drm:intel_crt_get_edid], CRT GMBUS EDID read failed, retr=
y using GPIO bit-banging
[   40.139351] [drm:intel_gmbus_force_bit], enabling bit-banging on i915 =
gmbus vga. force bit now 1
[   40.139668] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus vga
[   40.139669] [drm:intel_gmbus_force_bit], disabling bit-banging on i915=
 gmbus vga. force bit now 0
[   40.139669] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 =
[no valid EDID found]
[   40.139670] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
9:VGA-1] disconnected
[   40.139671] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1]
[   40.142542] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   40.146679] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   40.150676] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x7145004a=

[   40.151800] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
12:DP-1] disconnected
[   40.151801] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1]
[   40.177042] [drm:drm_edid_to_eld], ELD: no CEA Extension found
[   40.177046] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
15:HDMI-A-1] probed modes :
[   40.177048] [drm:drm_mode_debug_printmodeline], Modeline 23:"1920x1200=
" 60 154000 1920 1968 2000 2080 1200 1203 1209 1235 0x48 0x9
[   40.177050] [drm:drm_mode_debug_printmodeline], Modeline 24:"1920x1080=
" 60 172780 1920 2040 2248 2576 1080 1081 1084 1118 0x0 0x6
[   40.177051] [drm:drm_mode_debug_printmodeline], Modeline 29:"1600x1200=
" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   40.177053] [drm:drm_mode_debug_printmodeline], Modeline 30:"1680x1050=
" 60 119000 1680 1728 1760 1840 1050 1053 1059 1080 0x40 0x9
[   40.177055] [drm:drm_mode_debug_printmodeline], Modeline 27:"1280x1024=
" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   40.177056] [drm:drm_mode_debug_printmodeline], Modeline 28:"1440x900"=
 60 88750 1440 1488 1520 1600 900 903 909 926 0x40 0x9
[   40.177058] [drm:drm_mode_debug_printmodeline], Modeline 26:"1280x960"=
 60 108000 1280 1376 1488 1800 960 961 964 1000 0x40 0x5
[   40.177059] [drm:drm_mode_debug_printmodeline], Modeline 25:"1280x720"=
 60 74440 1280 1336 1472 1664 720 721 724 746 0x0 0x6
[   40.177061] [drm:drm_mode_debug_printmodeline], Modeline 33:"1024x768"=
 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   40.177062] [drm:drm_mode_debug_printmodeline], Modeline 31:"800x600" =
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   40.177064] [drm:drm_mode_debug_printmodeline], Modeline 32:"640x480" =
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   40.177065] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2]
[   40.177340] [drm:intel_dp_get_dpcd], DPCD: 12 14 e4 01 01 01 01 81 00 =
00 00 00 00 00 00
[   40.178709] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.178888] [drm:intel_dp_probe_oui], Sink OUI: 0080e1
[   40.179069] [drm:intel_dp_probe_oui], Branch OUI: 0080e1
[   40.180149] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.210444] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.240679] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.240680] [drm:drm_detect_monitor_audio], Monitor has basic audio su=
pport
[   40.241761] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.272019] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.303527] [drm:i2c_algo_dp_aux_xfer], dp_aux_xfer return 2
[   40.303694] [drm:drm_edid_to_eld], ELD monitor DELL U3014
[   40.303698] [drm:drm_edid_to_eld], ELD size 9, SAD count 1
[   40.303786] [drm:drm_mode_debug_printmodeline], Modeline 36:"2560x1600=
" 60 268500 2560 2608 2640 2720 1600 1603 1609 1646 0x48 0x9
[   40.303789] [drm:drm_mode_prune_invalid], Not using 2560x1600 mode 12
[   40.303797] [drm:drm_mode_debug_printmodeline], Modeline 61:"1440x480i=
" 0 27000 1440 1478 1602 1716 480 488 494 525 0x40 0x101a
[   40.303800] [drm:drm_mode_prune_invalid], Not using 1440x480i mode 3
[   40.303808] [drm:drm_mode_debug_printmodeline], Modeline 62:"1440x576i=
" 0 27000 1440 1464 1590 1728 576 580 586 625 0x40 0x101a
[   40.303811] [drm:drm_mode_prune_invalid], Not using 1440x576i mode 3
[   40.303819] [drm:drm_mode_debug_printmodeline], Modeline 81:"1440x480i=
" 60 27027 1440 1478 1602 1716 480 488 494 525 0x40 0x101a
[   40.303822] [drm:drm_mode_prune_invalid], Not using 1440x480i mode 3
[   40.303836] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
17:DP-2] probed modes :
[   40.303843] [drm:drm_mode_debug_printmodeline], Modeline 43:"1920x1200=
" 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   40.303851] [drm:drm_mode_debug_printmodeline], Modeline 37:"1920x1080=
" 60 148500 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
[   40.303858] [drm:drm_mode_debug_printmodeline], Modeline 72:"1920x1080=
" 60 148352 1920 2008 2052 2200 1080 1084 1089 1125 0x40 0x5
[   40.303865] [drm:drm_mode_debug_printmodeline], Modeline 38:"1920x1080=
i" 60 74250 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
[   40.303872] [drm:drm_mode_debug_printmodeline], Modeline 73:"1920x1080=
i" 60 74176 1920 2008 2052 2200 1080 1084 1094 1125 0x40 0x15
[   40.303879] [drm:drm_mode_debug_printmodeline], Modeline 70:"1920x1080=
" 50 148500 1920 2448 2492 2640 1080 1084 1089 1125 0x40 0x5
[   40.303887] [drm:drm_mode_debug_printmodeline], Modeline 69:"1920x1080=
i" 50 74250 1920 2448 2492 2640 1080 1084 1094 1125 0x40 0x15
[   40.303894] [drm:drm_mode_debug_printmodeline], Modeline 71:"1920x1080=
" 24 74250 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
[   40.303901] [drm:drm_mode_debug_printmodeline], Modeline 84:"1920x1080=
" 24 74176 1920 2558 2602 2750 1080 1084 1089 1125 0x40 0x5
[   40.303908] [drm:drm_mode_debug_printmodeline], Modeline 45:"1600x1200=
" 60 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x40 0x5
[   40.303915] [drm:drm_mode_debug_printmodeline], Modeline 42:"1680x1050=
" 60 146250 1680 1784 1960 2240 1050 1053 1059 1089 0x40 0x6
[   40.303923] [drm:drm_mode_debug_printmodeline], Modeline 51:"1280x1024=
" 75 135000 1280 1296 1440 1688 1024 1025 1028 1066 0x40 0x5
[   40.303930] [drm:drm_mode_debug_printmodeline], Modeline 46:"1280x1024=
" 60 108000 1280 1328 1440 1688 1024 1025 1028 1066 0x40 0x5
[   40.303937] [drm:drm_mode_debug_printmodeline], Modeline 41:"1280x800"=
 60 83500 1280 1352 1480 1680 800 803 809 831 0x40 0x9
[   40.303944] [drm:drm_mode_debug_printmodeline], Modeline 44:"1152x864"=
 75 108000 1152 1216 1344 1600 864 865 868 900 0x40 0x5
[   40.303951] [drm:drm_mode_debug_printmodeline], Modeline 39:"1280x720"=
 60 74250 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   40.303959] [drm:drm_mode_debug_printmodeline], Modeline 74:"1280x720"=
 60 74176 1280 1390 1430 1650 720 725 730 750 0x40 0x5
[   40.303966] [drm:drm_mode_debug_printmodeline], Modeline 68:"1280x720"=
 50 74250 1280 1720 1760 1980 720 725 730 750 0x40 0x5
[   40.303973] [drm:drm_mode_debug_printmodeline], Modeline 52:"1024x768"=
 75 78800 1024 1040 1136 1312 768 769 772 800 0x40 0x5
[   40.303980] [drm:drm_mode_debug_printmodeline], Modeline 53:"1024x768"=
 60 65000 1024 1048 1184 1344 768 771 777 806 0x40 0xa
[   40.303987] [drm:drm_mode_debug_printmodeline], Modeline 54:"800x600" =
75 49500 800 816 896 1056 600 601 604 625 0x40 0x5
[   40.303994] [drm:drm_mode_debug_printmodeline], Modeline 47:"800x600" =
60 40000 800 840 968 1056 600 601 605 628 0x40 0x5
[   40.304001] [drm:drm_mode_debug_printmodeline], Modeline 65:"720x576" =
50 27000 720 732 796 864 576 581 586 625 0x40 0xa
[   40.304008] [drm:drm_mode_debug_printmodeline], Modeline 40:"720x480" =
60 27030 720 736 798 858 480 489 495 525 0x40 0xa
[   40.304015] [drm:drm_mode_debug_printmodeline], Modeline 79:"720x480" =
60 27027 720 736 798 858 480 489 495 525 0x40 0xa
[   40.304023] [drm:drm_mode_debug_printmodeline], Modeline 59:"720x480" =
60 27000 720 736 798 858 480 489 495 525 0x40 0xa
[   40.304030] [drm:drm_mode_debug_printmodeline], Modeline 48:"640x480" =
75 31500 640 656 720 840 480 481 484 500 0x40 0xa
[   40.304037] [drm:drm_mode_debug_printmodeline], Modeline 49:"640x480" =
60 25200 640 656 752 800 480 490 492 525 0x40 0xa
[   40.304044] [drm:drm_mode_debug_printmodeline], Modeline 63:"640x480" =
60 25175 640 656 752 800 480 490 492 525 0x40 0xa
[   40.304051] [drm:drm_mode_debug_printmodeline], Modeline 50:"720x400" =
70 28320 720 738 846 900 400 412 414 449 0x40 0x6
[   40.304055] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2]
[   40.304221] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 005=
0 r(1)
[   40.304225] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpc
[   40.304229] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
18:HDMI-A-2] disconnected
[   40.304233] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3]
[   40.304238] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
20:DP-3] disconnected
[   40.304242] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3]
[   40.304402] [drm:gmbus_xfer], GMBUS [i915 gmbus dpd] NAK for addr: 005=
0 r(1)
[   40.304405] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent ad=
apter i915 gmbus dpd
[   40.304409] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:=
21:HDMI-A-3] disconnected
[   40.304412] [drm:drm_setup_crtcs],=20
[   40.304416] [drm:drm_enable_connectors], connector 9 enabled? no
[   40.304420] [drm:drm_enable_connectors], connector 12 enabled? no
[   40.304423] [drm:drm_enable_connectors], connector 15 enabled? yes
[   40.304426] [drm:drm_enable_connectors], connector 17 enabled? yes
[   40.304429] [drm:drm_enable_connectors], connector 18 enabled? no
[   40.304432] [drm:drm_enable_connectors], connector 20 enabled? no
[   40.304435] [drm:drm_enable_connectors], connector 21 enabled? no
[   40.304438] [drm:drm_target_preferred], looking for cmdline mode on co=
nnector 15
[   40.304441] [drm:drm_target_preferred], found mode 1920x1200
[   40.304444] [drm:drm_target_preferred], looking for cmdline mode on co=
nnector 17
[   40.304447] [drm:drm_target_preferred], found mode 1920x1200
[   40.304451] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[   40.304464] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc =
3
[   40.304468] [drm:drm_setup_crtcs], desired mode 1920x1200 set on crtc =
5
[   40.304474] [drm:intel_crtc_set_config], [CRTC:3] [FB:56] #connectors=3D=
1 (x y) (0 0)
[   40.304481] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   40.304487] [drm:intel_crtc_set_config], [CRTC:5] [FB:56] #connectors=3D=
1 (x y) (0 0)
[   40.304490] [drm:intel_set_config_compute_mode_changes], crtc has no f=
b, full mode set
[   40.304494] [drm:intel_modeset_stage_output_state], encoder changed, f=
ull mode switch
[   40.304498] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   40.304502] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[   40.304505] [drm:intel_modeset_stage_output_state], crtc changed, full=
 mode switch
[   40.304510] [drm:intel_modeset_affected_pipes], set mode pipe masks: m=
odeset: 2, prepare: 2, disable: 0
[   40.304516] [drm:connected_sink_compute_bpp], [CONNECTOR:17:DP-2] chec=
king for sink bpp constrains
[   40.304520] [drm:intel_dp_compute_config], DP link computation with ma=
x lane count 4 max bw 0a pixel clock 193250KHz
[   40.304531] [drm:intel_dp_compute_config], DP link bw 06 lane count 4 =
clock 162000 bpp 24
[   40.304534] [drm:intel_dp_compute_config], DP link bw required 463800 =
available 518400
[   40.304539] [drm:intel_modeset_pipe_config], plane bpp: 24, pipe bpp: =
24, dithering: 0
[   40.304543] [drm:intel_dump_pipe_config], [CRTC:5][modeset] config for=
 pipe B
[   40.304546] [drm:intel_dump_pipe_config], cpu_transcoder: B
[   40.304549] [drm:intel_dump_pipe_config], pipe bpp: 24, dithering: 0
[   40.304554] [drm:intel_dump_pipe_config], fdi/pch: 0, lanes: 0, gmch_m=
: 0, gmch_n: 0, link_m: 0, link_n: 0, tu: 0
[   40.304564] [drm:intel_dump_pipe_config], requested mode:
[   40.304572] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   40.304574] [drm:intel_dump_pipe_config], adjusted mode:
[   40.304582] [drm:drm_mode_debug_printmodeline], Modeline 0:"1920x1200"=
 60 193250 1920 2056 2256 2592 1200 1203 1209 1245 0x40 0x6
[   40.304586] [drm:intel_dump_pipe_config], gmch pfit: control: 0x000000=
00, ratios: 0x00000000, lvds border: 0x00000000
[   40.304589] [drm:intel_dump_pipe_config], pch pfit: pos: 0x00000000, s=
ize: 0x00000000
[   40.304592] [drm:intel_dump_pipe_config], ips: 0
[   40.304624] [drm:ironlake_update_plane], Writing base 000A1000 0000000=
0 0 0 7680
[   40.304639] [drm:intel_crtc_mode_set], [ENCODER:16:TMDS-16] set [MODE:=
0:1920x1200]
[   40.304643] [drm:intel_ddi_mode_set], Preparing DDI mode on port C, pi=
pe B
[   40.304645] [drm:intel_ddi_mode_set], DP audio on pipe B on DDI
[   40.304648] [drm:intel_ddi_mode_set], DP audio: write eld information
[   40.304654] [drm:intel_write_eld], ELD on [CONNECTOR:17:DP-2], [ENCODE=
R:16:TMDS-16]
[   40.304656] [drm:haswell_write_eld], HDMI: Haswell Audio initialize...=
=2E
[   40.304659] [drm:haswell_write_eld], HDMI audio: enable codec
[   40.356519] [drm:ironlake_wait_for_vblank], vblank wait timed out
[   40.356523] [drm:haswell_write_eld], HDMI audio: pin eld vld status=3D=
0x      40
[   40.356526] [drm:haswell_write_eld], HDMI audio: eld vld status=3D0x  =
    50
[   40.356528] [drm:haswell_write_eld], HDMI audio: audio conf: 0x2080000=
0
[   40.356530] [drm:haswell_write_eld], ELD on pipe B
[   40.356532] [drm:haswell_write_eld], ELD: DisplayPort detected
[   40.357633] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[   40.358954] [drm:intel_dp_start_link_train], clock recovery OK
[   40.358957] [drm:intel_dp_set_signal_levels], Using signal levels 0000=
0000
[   40.362487] [drm:intel_dp_complete_link_train], Channel EQ done. DP Tr=
aining successful
[   40.414436] [drm:intel_connector_check_state], [CONNECTOR:15:HDMI-A-1]=

[   40.414440] [drm:intel_connector_check_state], [CONNECTOR:17:DP-2]
[   40.414446] [drm:check_encoder_state], [ENCODER:10:DAC-10]
[   40.414449] [drm:check_encoder_state], [ENCODER:11:TMDS-11]
[   40.414452] [drm:check_encoder_state], [ENCODER:16:TMDS-16]
[   40.414455] [drm:check_encoder_state], [ENCODER:19:TMDS-19]
[   40.414458] [drm:check_crtc_state], [CRTC:3]
[   40.414464] [drm:check_crtc_state], [CRTC:5]
[   40.414470] [drm:check_crtc_state], [CRTC:7]
[   40.414475] [drm:intel_crtc_set_config], [CRTC:7] [NOFB]
[   40.414480] [drm:intel_modeset_stage_output_state], [CONNECTOR:15:HDMI=
-A-1] to [CRTC:3]
[   40.414483] [drm:intel_modeset_stage_output_state], [CONNECTOR:17:DP-2=
] to [CRTC:5]
[   40.424584] usb 2-1.3.2.1: reset full-speed USB device number 7 using =
ehci-pci
[   40.665063] [drm:intel_enable_rc6], Haswell: only RC6 available
[   40.665065] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   40.667036] [drm:gen6_enable_rps], Overclocking supported. Max: 1200MH=
z, Overclock max: 1300MHz
[   40.761052] usb 2-1.3.2.2: reset low-speed USB device number 8 using e=
hci-pci
[   41.102510] usb 2-1.3.2.3: reset high-speed USB device number 9 using =
ehci-pci
[   41.462929] usb 2-1.3.2.3.3: reset high-speed USB device number 10 usi=
ng ehci-pci
[   42.479772] e1000e: eno1 NIC Link is Up 1000 Mbps Full Duplex, Flow Co=
ntrol: Rx/Tx
[   44.718673] ata4: link is slow to respond, please be patient (ready=3D=
0)
[   48.130344] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   48.151280] ata4.00: configured for UDMA/133
[   48.151405] sd 3:0:0:0: [sdc] Starting disk
[   48.183748] PM: resume of devices complete after 8832.368 msecs
[   48.340881] Restarting tasks ... done.
[   48.341645] video LNXVIDEO:00: Restoring backlight state

--------------080500020904020308040302--

