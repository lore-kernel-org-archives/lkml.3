Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaL3OXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:23:05 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:42604 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaL3OXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:23:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
References: <alpine.LNX.2.00.1412301427430.31609@pobox.suse.cz>
Date: Tue, 30 Dec 2014 16:23:01 +0200
Message-ID: <CANUX_P0=wJiKrR4cUgEN=LO+eQ2byprz0K9m9QxzJc+kf4+_bA@mail.gmail.com>
Subject: Re: iwlwifi-driver card doesn't work with 3.19-rc2+
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 3:33 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> Hi,
>
> I just booted current Linus' tree (5faa0154fe33) on my x200s thinkpad, and
> wifi doesn't work. iwconfig is telling me that wlan0 interface has no
> wireless extensions.
>

So why do you used them?
They have been deprecated for a couple of years now. You should be
using nl80211 based tools such as iw.

> Previous kernel that is known to work on this machine is 3.18-rc5. I can
> do a bisect if needed, but wanted to ask in case this is a known problem.
>

3.19 is the first kernel that actually removed the wireless extensions.

> Please find the relevant part of dmesg below. The card in question is
> this:
>
> 03:00.0 Network controller [0280]: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection [8086:4237]
>         Subsystem: Intel Corporation WiFi Link 5100 AGN [8086:1211]
>         Flags: bus master, fast devsel, latency 0, IRQ 29
>         Memory at f2500000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [e0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Device Serial Number 00-22-fa-ff-ff-34-b0-4c
>         Kernel driver in use: iwlwifi
>         Kernel modules: iwlwifi
>
>
>
> === snip ===
> [    6.357092] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [    6.358637] Copyright(c) 2003- 2014 Intel Corporation
> [    6.387473] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1 build 33692 op_mode iwldvm
> [    6.399552] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1f:16:15:7a:65
> [    6.401162] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
> [    6.402751] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: 1008FF-0FF
> [    6.404838] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt
> [    6.407182] ACPI Warning: SystemIO range 0x0000000000001028-0x000000000000102f conflicts with OpRegion 0x0000000000001000-0x000000000000107f (\_SB_.PCI0.LPC_.PMIO) (20141107/utaddress-258)
> [    6.410662] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    6.412580] ACPI Warning: SystemIO range 0x00000000000011b0-0x00000000000011bf conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20141107/utaddress-258)
> [    6.416296] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    6.418145] ACPI Warning: SystemIO range 0x0000000000001180-0x00000000000011af conflicts with OpRegion 0x0000000000001180-0x00000000000011ff (\_SB_.PCI0.LPC_.LPIO) (20141107/utaddress-258)
> [    6.422111] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [    6.424214] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [    6.432054] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
> [    6.440414] microcode: CPU0 sig=0x10676, pf=0x80, revision=0x60c
> [    6.444012] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
> [    6.451926] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
> [    6.479540] thinkpad_acpi: ThinkPad ACPI Extras v0.25
> [    6.481632] thinkpad_acpi: http://ibm-acpi.sf.net/
> [    6.483636] thinkpad_acpi: ThinkPad BIOS 6DET38WW (2.02 ), EC 7XHT21WW-1.03
> [    6.485724] thinkpad_acpi: Lenovo ThinkPad X200s, model 7470BN2
> [    6.513239] microcode: CPU1 sig=0x10676, pf=0x80, revision=0x60c
> [    6.516007] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
> [    6.525254] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [    6.557365] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
> [    6.561203] thinkpad_acpi: radio switch found; radios are enabled
> [    6.563537] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
> [    6.565722] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
> [    6.582468] thinkpad_acpi: rfkill switch tpacpi_bluetooth_sw: radio is blocked
> [    6.613516] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one
> [    6.628357] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input8
> [    6.830228] sound hdaudioC0D0: CX20561 (Hermosa): BIOS auto-probing.
> [    6.835254] sound hdaudioC0D0: autoconfig: line_outs=1 (0x1a/0x0/0x0/0x0/0x0) type:speaker
> [    6.837530] sound hdaudioC0D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [    6.839860] sound hdaudioC0D0:    hp_outs=2 (0x19/0x16/0x0/0x0/0x0)
> [    6.842102] sound hdaudioC0D0:    mono: mono_out=0x0
> [    6.844365] sound hdaudioC0D0:    dig-out=0x1c/0x0
> [    6.846498] sound hdaudioC0D0:    inputs:
> [    6.848629] sound hdaudioC0D0:      Mic=0x18
> [    6.850637] sound hdaudioC0D0:      Internal Mic=0x1d
> [    6.850639] sound hdaudioC0D0:      Dock Mic=0x17
> [    6.855780] sound hdaudioC0D0: Enable sync_write for stable communication
> [    6.887289] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card0/hdaudioC0D0/input9
> [    6.895980] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [    6.899740] input: HDA Intel Dock Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
> [    6.910154] input: HDA Intel Dock Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
> [    6.919309] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input13
> [    6.935484] Adding 2104476k swap on /dev/sda1.  Priority:-1 extents:1 across:2104476k SS
> [    6.959360] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [    6.961480] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [    6.963595] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [    6.965638] iwlwifi 0000:03:00.0: Detected Intel(R) WiFi Link 5100 AGN, REV=0x54
> [    6.968106] iwlwifi 0000:03:00.0: L1 Disabled - LTR Disabled
> [    7.020451] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [    7.034582] iTCO_vendor_support: vendor-support=0
> [    7.037422] cfg80211: World regulatory domain updated:
> [    7.039411] cfg80211:  DFS Master region: unset
> [    7.039440] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
> [    7.043249] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.045119] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.046891] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.048649] cfg80211:   (5170000 KHz - 5250000 KHz @ 160000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.050432] cfg80211:   (5250000 KHz - 5330000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [    7.052058] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
> [    7.053637] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
> [    7.055220] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
> === snip ===
>
> --
> Jiri Kosina
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
