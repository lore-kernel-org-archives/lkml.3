Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaGPXki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:40:38 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61445 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaGPXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:40:34 -0400
Message-ID: <53C70D6F.8050209@schaman.hu>
Date: Thu, 17 Jul 2014 00:40:31 +0100
From: Zoltan Kiss <zoltan.kiss@schaman.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>
CC: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: "[drm:intel_dp_start_link_train] *ERROR* too many full retries, give
 up" and others on an ASUS UX32A
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an ASUS UX32A laptop, which have troubles booting up with an 
external HDMI display. The BIOS boot screen appears on the external 
display, and the internal one stays blank during the whole boot. After 
login I can make it work again if I turn it off and on, e.g. with 
Ubuntu's display setting tool, or with the following commands:

xrandr --output eDP1 --off
xrandr --output eDP1 --auto
xrandr --output eDP1 --right-of HDMI1

If I don't do it and the displays going to sleep mode, I can't wake it 
up again, unless I restart the machine (but I can switch to console with 
Ctrl+Alt+Fx). I've tried it with various different kernels, from default 
3.2 (I'm using Ubuntu 12.04) to 3.13 (the backport from Trusty). I've 
tried to search Google for a solution, but none of the relevant tips 
worked for me. I guess this should be a BIOS problem, as it doesn't turn 
the display on at the first place. Is there a better solution for this 
problem than running the above mentioned command during login?
Some excerpts from kern.log after a recent boot: ( I can send the whole 
logs, but I don't want to spam the list with 100k)

Jul 16 22:12:21 kernel: [    1.560021] [drm] Initialized drm 1.1.0 20060810
Jul 16 22:12:21 kernel: [    1.582925] [drm] Memory usable by graphics 
device = 2048M
Jul 16 22:12:21 kernel: [    1.582931] fb: conflicting fb hw usage 
inteldrmfb vs VESA VGA - removing generic driver
Jul 16 22:12:21 kernel: [    1.666837] [drm] Supports vblank timestamp 
caching Rev 2 (21.10.2013).
Jul 16 22:12:21 kernel: [    1.666838] [drm] Driver supports precise 
vblank timestamp query.
Jul 16 22:12:21 kernel: [    1.671238] [drm:intel_dp_i2c_aux_ch] *ERROR* 
too many retries, giving up
Jul 16 22:12:21 kernel: [    1.954512] fbcon: inteldrmfb (fb0) is 
primary device
Jul 16 22:12:21 kernel: [    2.124724] [drm:intel_dp_start_link_train] 
*ERROR* too many full retries, give up
Jul 16 22:12:21 kernel: [    3.305125] 
[drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
Jul 16 22:12:21 kernel: [    3.660395] [drm:cpt_verify_modeset] *ERROR* 
mode set failed: pipe A stuck
Jul 16 22:12:21 kernel: [    3.856571] [drm] Enabling RC6 states: RC6 
on, RC6p on, RC6pp off
Jul 16 22:12:21 kernel: [    3.880588] i915 0000:00:02.0: fb0: 
inteldrmfb frame buffer device
Jul 16 22:12:21 kernel: [    3.892846] [drm] Initialized i915 1.6.0 
20080730 for 0000:00:02.0 on minor 0
Jul 16 22:12:22 kernel: [    5.080210] ACPI Warning: 
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region 
\GPIS 1 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080218] ACPI Warning: 
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region 
\PMIO 2 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080223] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Jul 16 22:12:22 kernel: [    5.080229] ACPI Warning: 
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region 
\GPIO 1 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080233] ACPI Warning: 
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region 
\GP01 2 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080236] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Jul 16 22:12:22 kernel: [    5.080238] ACPI Warning: 
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region 
\GPIO 1 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080242] ACPI Warning: 
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region 
\GP01 2 (20131115/utaddress-251)
Jul 16 22:12:22 kernel: [    5.080245] ACPI: If an ACPI driver is 
available for this device, you should use it instead of the native driver
Jul 16 22:12:42 kernel: [   25.002527] WARNING: CPU: 1 PID: 1513 at 
/build/buildd/linux-lts-trusty-3.13.0/drivers/gpu/drm/i915/intel_display.c:851 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]()
Jul 16 22:12:42 kernel: [   25.002529] Modules linked in: xts gf128mul 
pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) dm_crypt 
xt_hl ip6t_rt arc4 nf_conntrack_ipv6 iwldvm nf_defrag_ipv6 ipt_REJECT 
mac80211 xt_LOG uvcvideo snd_hda_codec_hdmi xt_limit videobuf2_core 
rts5139(C) snd_hda_codec_realtek xt_tcpudp videodev xt_addrtype 
videobuf2_vmalloc snd_hda_intel iwlwifi snd_hda_codec videobuf2_memops 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state snd_hwdep joydev snd_pcm 
cfg80211 ip6table_filter btusb ip6_tables snd_seq_midi snd_rawmidi 
nf_conntrack_netbios_ns snd_seq_midi_event nf_conntrack_broadcast 
nf_nat_ftp nf_nat snd_seq nf_conntrack_ftp nf_conntrack asus_nb_wmi 
snd_timer asus_wmi iptable_filter snd_seq_device sparse_keymap ip_tables 
x_tables snd soundcore snd_page_alloc lpc_ich mei_me psmouse mei bnep 
serio_raw rfcomm bluetooth parport_pc mac_hid ppdev nls_utf8 cifs 
fscache binfmt_misc lp parport hid_generic usbhid hid wmi i915 
drm_kms_helper ahci libahci drm i2c_algo_bit video
Jul 16 22:12:42 kernel: [   25.002607]  [<ffffffffa00cf44b>] 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]
Jul 16 22:12:42 kernel: [   25.002621]  [<ffffffffa00cf521>] 
intel_disable_pipe+0xc1/0xd0 [i915]
Jul 16 22:12:42 kernel: [   25.002647]  [<ffffffffa00d47e6>] 
intel_crtc_update_dpms+0x76/0xb0 [i915]
Jul 16 22:12:42 kernel: [   25.002659]  [<ffffffffa00d7031>] 
intel_connector_dpms+0x61/0x70 [i915]
Jul 16 22:12:42 kernel: [   25.002672]  [<ffffffffa0021f64>] 
drm_mode_connector_set_obj_prop+0xa4/0xb0 [drm]
Jul 16 22:12:42 kernel: [   25.002683]  [<ffffffffa002803a>] 
drm_mode_obj_set_property_ioctl+0x13a/0x210 [drm]
Jul 16 22:12:42 kernel: [   25.002693]  [<ffffffffa0027b29>] ? 
drm_mode_getproperty_ioctl+0x149/0x340 [drm]
Jul 16 22:12:42 kernel: [   25.002703]  [<ffffffffa0028140>] 
drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
Jul 16 22:12:42 kernel: [   25.002711]  [<ffffffffa0016e3a>] 
drm_ioctl+0x4da/0x600 [drm]
Jul 16 22:12:42 kernel: [   25.002721]  [<ffffffffa0028110>] ? 
drm_mode_obj_set_property_ioctl+0x210/0x210 [drm]
Jul 16 22:12:42 kernel: [   25.596306] [drm:intel_dp_start_link_train] 
*ERROR* too many full retries, give up
Jul 16 22:12:43 kernel: [   26.780943] 
[drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
Jul 16 22:12:44 kernel: [   27.136288] [drm:cpt_verify_modeset] *ERROR* 
mode set failed: pipe A stuck
Jul 16 22:13:19 kernel: [   62.345860] WARNING: CPU: 1 PID: 1513 at 
/build/buildd/linux-lts-trusty-3.13.0/drivers/gpu/drm/i915/intel_display.c:851 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]()
Jul 16 22:13:19 kernel: [   62.345863] Modules linked in: xts gf128mul 
pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) dm_crypt 
xt_hl ip6t_rt arc4 nf_conntrack_ipv6 iwldvm nf_defrag_ipv6 ipt_REJECT 
mac80211 xt_LOG uvcvideo snd_hda_codec_hdmi xt_limit videobuf2_core 
rts5139(C) snd_hda_codec_realtek xt_tcpudp videodev xt_addrtype 
videobuf2_vmalloc snd_hda_intel iwlwifi snd_hda_codec videobuf2_memops 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state snd_hwdep joydev snd_pcm 
cfg80211 ip6table_filter btusb ip6_tables snd_seq_midi snd_rawmidi 
nf_conntrack_netbios_ns snd_seq_midi_event nf_conntrack_broadcast 
nf_nat_ftp nf_nat snd_seq nf_conntrack_ftp nf_conntrack asus_nb_wmi 
snd_timer asus_wmi iptable_filter snd_seq_device sparse_keymap ip_tables 
x_tables snd soundcore snd_page_alloc lpc_ich mei_me psmouse mei bnep 
serio_raw rfcomm bluetooth parport_pc mac_hid ppdev nls_utf8 cifs 
fscache binfmt_misc lp parport hid_generic usbhid hid wmi i915 
drm_kms_helper ahci libahci drm i2c_algo_bit video
Jul 16 22:13:19 kernel: [   62.345939]  [<ffffffffa00cf44b>] 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]
Jul 16 22:13:19 kernel: [   62.345953]  [<ffffffffa00cf521>] 
intel_disable_pipe+0xc1/0xd0 [i915]
Jul 16 22:13:19 kernel: [   62.345977]  [<ffffffffa00d47e6>] 
intel_crtc_update_dpms+0x76/0xb0 [i915]
Jul 16 22:13:19 kernel: [   62.345990]  [<ffffffffa00d7031>] 
intel_connector_dpms+0x61/0x70 [i915]
Jul 16 22:13:19 kernel: [   62.346002]  [<ffffffffa0021f64>] 
drm_mode_connector_set_obj_prop+0xa4/0xb0 [drm]
Jul 16 22:13:19 kernel: [   62.346013]  [<ffffffffa002803a>] 
drm_mode_obj_set_property_ioctl+0x13a/0x210 [drm]
Jul 16 22:13:19 kernel: [   62.346024]  [<ffffffffa0027b29>] ? 
drm_mode_getproperty_ioctl+0x149/0x340 [drm]
Jul 16 22:13:19 kernel: [   62.346035]  [<ffffffffa0028140>] 
drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
Jul 16 22:13:19 kernel: [   62.346043]  [<ffffffffa0016e3a>] 
drm_ioctl+0x4da/0x600 [drm]
Jul 16 22:13:19 kernel: [   62.346053]  [<ffffffffa0028110>] ? 
drm_mode_obj_set_property_ioctl+0x210/0x210 [drm]
Jul 16 22:13:20 kernel: [   63.692266] [drm:intel_dp_start_link_train] 
*ERROR* too many full retries, give up
Jul 16 22:13:21 kernel: [   64.876920] 
[drm:intel_dp_complete_link_train] *ERROR* failed to train DP, aborting
Jul 16 22:13:22 kernel: [   65.232161] [drm:cpt_verify_modeset] *ERROR* 
mode set failed: pipe A stuck
Jul 16 22:13:35 kernel: [   78.880273] WARNING: CPU: 0 PID: 1513 at 
/build/buildd/linux-lts-trusty-3.13.0/drivers/gpu/drm/i915/intel_display.c:851 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]()
Jul 16 22:13:35 kernel: [   78.880281] Modules linked in: des_generic 
md4 ctr ccm xts gf128mul pci_stub vboxpci(OF) vboxnetadp(OF) 
vboxnetflt(OF) vboxdrv(OF) dm_crypt xt_hl ip6t_rt arc4 nf_conntrack_ipv6 
iwldvm nf_defrag_ipv6 ipt_REJECT mac80211 xt_LOG uvcvideo 
snd_hda_codec_hdmi xt_limit videobuf2_core rts5139(C) 
snd_hda_codec_realtek xt_tcpudp videodev xt_addrtype videobuf2_vmalloc 
snd_hda_intel iwlwifi snd_hda_codec videobuf2_memops nf_conntrack_ipv4 
nf_defrag_ipv4 xt_state snd_hwdep joydev snd_pcm cfg80211 
ip6table_filter btusb ip6_tables snd_seq_midi snd_rawmidi 
nf_conntrack_netbios_ns snd_seq_midi_event nf_conntrack_broadcast 
nf_nat_ftp nf_nat snd_seq nf_conntrack_ftp nf_conntrack asus_nb_wmi 
snd_timer asus_wmi iptable_filter snd_seq_device sparse_keymap ip_tables 
x_tables snd soundcore snd_page_alloc lpc_ich mei_me psmouse mei bnep 
serio_raw rfcomm bluetooth parport_pc mac_hid ppdev nls_utf8 cifs 
fscache binfmt_misc lp parport hid_generic usbhid hid wmi i915 
drm_kms_helper ahci libahci drm i2c_algo
Jul 16 22:13:35 kernel: [   78.880545]  [<ffffffffa00cf44b>] 
intel_wait_for_pipe_off+0x1db/0x1f0 [i915]
Jul 16 22:13:35 kernel: [   78.880586]  [<ffffffffa00cf521>] 
intel_disable_pipe+0xc1/0xd0 [i915]
Jul 16 22:13:35 kernel: [   78.880669]  [<ffffffffa00d47e6>] 
intel_crtc_update_dpms+0x76/0xb0 [i915]
Jul 16 22:13:35 kernel: [   78.880712]  [<ffffffffa00d7031>] 
intel_connector_dpms+0x61/0x70 [i915]
Jul 16 22:13:35 kernel: [   78.880751]  [<ffffffffa0021f64>] 
drm_mode_connector_set_obj_prop+0xa4/0xb0 [drm]
Jul 16 22:13:35 kernel: [   78.880790]  [<ffffffffa002803a>] 
drm_mode_obj_set_property_ioctl+0x13a/0x210 [drm]
Jul 16 22:13:35 kernel: [   78.880825]  [<ffffffffa0027b29>] ? 
drm_mode_getproperty_ioctl+0x149/0x340 [drm]
Jul 16 22:13:35 kernel: [   78.880861]  [<ffffffffa0028140>] 
drm_mode_connector_property_set_ioctl+0x30/0x40 [drm]
Jul 16 22:13:35 kernel: [   78.880890]  [<ffffffffa0016e3a>] 
drm_ioctl+0x4da/0x600 [drm]
Jul 16 22:13:35 kernel: [   78.880924]  [<ffffffffa0028110>] ? 
drm_mode_obj_set_property_ioctl+0x210/0x210 [drm]
Jul 16 22:13:42 kernel: [   85.374181] [drm:intel_dp_start_link_train] 
*ERROR* too many full retries, give up

