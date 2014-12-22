Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaLVJFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:05:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52059 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbaLVJFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:05:48 -0500
Date: Mon, 22 Dec 2014 10:05:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: general protection fault on 3.19.0-rc1 / amd64 SMP
 anon_vma_interval_tree_remove (?)
Message-ID: <20141222090545.GA21163@pd.tnic>
References: <6624c5997d630f90ef4243b18d3504910c3e653d@webmail.internode.on.net>
 <54978AFC.7080104@internode.on.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54978AFC.7080104@internode.on.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 01:37:40PM +1030, Arthur Marsh wrote:
> 
> I just hit this rebooting an x86-64 3.19.0-rc1 kernel on a 4 core AMD
> cpu when the machine was starting check the filesystems:
> 
> [   22.427652] general protection fault: 0000 [#1] PREEMPT SMP
> [   22.431822] Modules linked in: max6650 fuse parport_pc ppdev lp parport
> snd_hda_codec_hdmi ir_mce_kbd_decoder ir_lirc_codec ir_sharp_decoder
> ir_jvc_decoder ir_xmp_decoder ir_sanyo_decoder lirc_dev ir_sony_decoder
> ir_rc5_decoder ir_rc6_decoder ir_nec_decoder snd_hda_codec_realtek fc0012
> snd_hda_codec_generic dvb_usb_rtl28xxu rtl2830 rtl2832 snd_hda_intel
> snd_hda_controller i2c_mux dvb_usb_v2 kvm_amd dvb_core kvm snd_hda_codec
> rc_core snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_timer radeon snd
> soundcore ttm drm_kms_helper drm i2c_algo_bit psmouse pcspkr serio_raw evdev
> k10temp acpi_cpufreq sp5100_tco processor asus_atk0110 i2c_piix4 button
> thermal_sys wmi ext4 mbcache crc16 jbd2 sg sr_mod cdrom sd_mod ata_generic
> uas usb_storage ohci_pci ahci pata_atiixp libahci libata r8169 mii ehci_pci
> scsi_mod
> [   22.447067]  ohci_hcd ehci_hcd usbcore usb_common
> [   22.452140] CPU: 2 PID: 449 Comm: udevd Not tainted 3.19.0-rc1 #1422
> [   22.457351] Hardware name: System manufacturer System Product Name/M3A78
> PRO, BIOS 1701    01/27/2011
> [   22.462707] task: ffff8800cba60450 ti: ffff88022e21c000 task.ti:
> ffff88022e21c000
> [   22.468111] RIP: 0010:[<ffffffff8115ec00>]  [<ffffffff8115ec00>] anon_vma_interval_tree_remove+0x1f0/0x250
> [   22.473677] RSP: 0018:ffff88022e21fd28  EFLAGS: 00010246
> [   22.479257] RAX: ffff88022e1f87a1 RBX: ffff88022e258540 RCX: 0000000000000000
> [   22.484914] RDX: 09be26aa0000000b RSI: ffff8800ca746f88 RDI: ffff88022e258540

  1c:   48 85 c0                test   %rax,%rax
  1f:   0f 85 43 ff ff ff       jne    0xffffffffffffff68
  25:   eb 9e                   jmp    0xffffffffffffffc5
  27:   48 8b 47 20             mov    0x20(%rdi),%rax
  2b:*  48 89 02                mov    %rax,(%rdx)              <-- trapping instruction
  2e:   48 83 e0 fc             and    $0xfffffffffffffffc,%rax
  32:   74 4c                   je     0x80

and %rdx has some non-canonical value causing the #GP.

...

> I haven't hit one of these errors for a while and this has only
> happened the once with this kernel. If anyone wants more details I'm
> happy to supply them.

Does that mean that you've hit similar corruptions in the past too? If
so, do they all look the same or are wildly different, i.e. stack trace
and RIP points at different functions and they happen during different
moments of the system lifetime?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
