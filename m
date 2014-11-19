Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaKSSU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:20:26 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57004 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaKSSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:20:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141119181247.GE37989@dtor-ws>
References: <20141114222640.GA39748@dtor-ws>
	<CAN+gG=FaovQETa3+qQsLoBBQnbZ8Q2uoQJD6_XvAmCCvGTHT1g@mail.gmail.com>
	<CAJBHPojp7JVG6KKgrNfbC-V5ibPs-j6+BnqrSDkxvak0vNGM8w@mail.gmail.com>
	<20141119181247.GE37989@dtor-ws>
Date: Wed, 19 Nov 2014 19:20:21 +0100
Message-ID: <CAJBHPohu71BXqyZ4u74tAiP84UcQhXgto34k8NtNHPgw61WvLQ@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.18-rc4
From: Marcus Overhagen <marcus.overhagen@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Ulrik De Bie <ulrik.debie-os@e2big.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I will try reverting that, but may need until tomorrow or Friday.

Just now I made a warm reboot from rc3 to rc5 and initially scrolling
behaviour was ok,  but after about a minute it went wrong and I got
this:

[  179.705362] ------------[ cut here ]------------
[  179.705382] WARNING: CPU: 3 PID: 0 at
drivers/input/mouse/elantech.c:433
elantech_report_trackpoint.isra.5+0x199/0x1b0 [psmouse]()
[  179.705385] psmouse serio1: elantech: Unexpected trackpoint message
[  179.705387] Modules linked in: fuse ctr ccm nls_utf8 cifs
dns_resolver fscache joydev mousedev iTCO_wdt iTCO_vendor_support ecb
coretemp arc4 intel_rapl uvcvideo x86_pkg_temp_thermal iwldvm
intel_powerclamp samsung_laptop videobuf2_vmalloc videobuf2_memops
mac80211 kvm_intel videobuf2_core evdev v4l2_common btusb r8169 radeon
iwlwifi psmouse videodev mac_hid tpm_infineon kvm serio_raw bluetooth
pcspkr i2c_i801 lpc_ich rtsx_usb_ms snd_hda_codec_hdmi mii cfg80211
ttm i915 media tpm_tis rfkill ac memstick fan thermal hwmon wmi tpm
snd_hda_codec_realtek battery snd_hda_codec_generic button video
snd_hda_intel drm_kms_helper snd_hda_controller snd_hda_codec drm
snd_hwdep snd_pcm intel_gtt i2c_algo_bit snd_timer i2c_core mei_me snd
mei soundcore shpchp sch_fq_codel processor ext4 crc16 mbcache jbd2
algif_skcipher
[  179.705458]  af_alg dm_crypt dm_mod crct10dif_pclmul crc32_pclmul
crc32c_intel ghash_clmulni_intel rtsx_usb_sdmmc led_class mmc_core
rtsx_usb sd_mod aesni_intel ahci aes_x86_64 lrw gf128mul libahci atkbd
glue_helper ablk_helper libps2 cryptd libata ehci_pci xhci_pci
xhci_hcd ehci_hcd scsi_mod usbcore usb_common i8042 serio
[  179.705490] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5-marcus-1 #1
[  179.705493] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
730U3E/740U3E/NP730U3E-S05DE, BIOS P03ABW.051.130226.dg 02/26/2013
[  179.705495]  0000000000000000 f7eda65f9c13f6f4 ffff8801af383c48
ffffffff81547b54
[  179.705500]  0000000000000000 ffff8801af383ca0 ffff8801af383c88
ffffffff8106bbc1
[  179.705504]  0000000000000000 ffff8800c4489400 ffff8801a5e50d78
ffff8800c47dd400
[  179.705509] Call Trace:
[  179.705512]  <IRQ>  [<ffffffff81547b54>] dump_stack+0x4e/0x71
[  179.705523]  [<ffffffff8106bbc1>] warn_slowpath_common+0x81/0xa0
[  179.705527]  [<ffffffff8106bc35>] warn_slowpath_fmt+0x55/0x70
[  179.705536]  [<ffffffffa0748639>]
elantech_report_trackpoint.isra.5+0x199/0x1b0 [psmouse]
[  179.705543]  [<ffffffffa0748e28>] elantech_process_byte+0x6e8/0xf90 [psmouse]
[  179.705548]  [<ffffffff810a37d8>] ? enqueue_task_fair+0x128/0x5d0
[  179.705555]  [<ffffffffa073ee95>] psmouse_handle_byte+0x15/0x150 [psmouse]
[  179.705561]  [<ffffffffa073f073>] psmouse_interrupt+0xa3/0x380 [psmouse]
[  179.705571]  [<ffffffffa0000f0a>] serio_interrupt+0x4a/0xa0 [serio]
[  179.705580]  [<ffffffffa000a607>] i8042_interrupt+0x197/0x3a0 [i8042]
[  179.705585]  [<ffffffff810d50bc>] ? __hrtimer_start_range_ns+0x2fc/0x420
[  179.705591]  [<ffffffff810c3bce>] handle_irq_event_percpu+0x3e/0x1f0
[  179.705596]  [<ffffffff810c3dc1>] handle_irq_event+0x41/0x70
[  179.705601]  [<ffffffff810c6eee>] handle_edge_irq+0x9e/0x110
[  179.705607]  [<ffffffff810172b2>] handle_irq+0x22/0x40
[  179.705612]  [<ffffffff81550201>] do_IRQ+0x51/0xf0
[  179.705617]  [<ffffffff8154e1ad>] common_interrupt+0x6d/0x6d
[  179.705619]  <EOI>  [<ffffffff813fbbc5>] ? cpuidle_enter_state+0x65/0x1a0
[  179.705629]  [<ffffffff813fbbb1>] ? cpuidle_enter_state+0x51/0x1a0
[  179.705634]  [<ffffffff813fbde7>] cpuidle_enter+0x17/0x20
[  179.705638]  [<ffffffff810ac509>] cpu_startup_entry+0x3d9/0x460
[  179.705644]  [<ffffffff81044074>] start_secondary+0x1b4/0x1f0
[  179.705647] ---[ end trace c9ff680de7cfddf7 ]---
[  179.705652] psmouse serio1: elantech: PS/2 packet [
[  179.705654]  0x24 , 0xed , 0xcf , 0x46 , 0xfd , 0xf3 ]
[  179.716569] psmouse serio1: elantech: PS/2 packet [
[  179.716573]  0x24 , 0xfa , 0xe9 , 0x46 , 0xfc , 0xec ]
[  179.727776] psmouse serio1: elantech: PS/2 packet [
[  179.727780]  0x24 , 0xfd , 0xe9 , 0x46 , 0xfa , 0xdc ]
[  179.738985] psmouse serio1: elantech: PS/2 packet [
[  179.738991]  0x24 , 0xff , 0xe9 , 0x46 , 0xf7 , 0xde ]
[  179.851051] psmouse serio1: elantech: PS/2 packet [
[  179.851057]  0x20 , 0x00 , 0xfd , 0x46 , 0x00 , 0x00 ]

On Wed, Nov 19, 2014 at 7:12 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Marcus,
>
> On Wed, Nov 19, 2014 at 07:00:16PM +0100, Marcus Overhagen wrote:
>> I'm not sure if my problems are related, but anyway:
>>
>> I'm using a Samsung NP730U3E notebook that also has an elantech touchpad.
>>
>> With 3.18.0-rc3 two finger scrolling in Firefox is smoth, but with
>> 3.18.0-rc5 I have to press a
>> lot harder and usually scrolling only startes after stopping the
>> movement shortly and retrying once
>>
>> I skipped rc4.
>>
>> from RC3 dmesg:
>> [   20.507633] psmouse serio1: elantech: assuming hardware version 4
>> (with firmware version 0x675f04)
>> [   20.520740] psmouse serio1: elantech: Synaptics capabilities query
>> result 0x10, 0x15, 0x0e.
>>
>
> Can you try reverting caeb0d37fa3e387eb0dd22e5d497523c002033d1 please?
> The rest should have no effect on you.
>
> Thanks.
>
> --
> Dmitry
