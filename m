Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbaGANbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:31:43 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63088 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaGANbi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:31:38 -0400
From: "Kelvin Gonzalez" <kelvin.gonzalezvivas@gmail.com>
To: "=?iso-8859-1?Q?'J=F6rg_R=F6del'?=" <joro@8bytes.org>
Cc: "'Borislav Petkov'" <bp@alien8.de>, <linux-kernel@vger.kernel.org>
References: <!&!AAAAAAAAAAAYAAAAAAAAANg+Q8tI5MNHj6qGz8No2F8igQAAEAAAANPhKY0kKNJJiL8MIUQYNFkBAAAAAA==@gmail.com> <20140629093818.GA5427@pd.tnic> <20140630081340.GB26537@8bytes.org>
In-Reply-To: <20140630081340.GB26537@8bytes.org>
Subject: RE: Desktop PC freezes after showing many times the lines "AMD-Vi: Completion-Wait loop timed out" and "BUG: soft lockup - CPU#2 stuck for 23s!"
Date: Tue, 1 Jul 2014 15:30:59 +0200
Message-ID: <006a01cf9530$b3117bb0$19347310$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQImZUBB/HHS1PUORL1gz4tV/6ipjwHaSS9lAn9mSL+ause/8A==
Content-Language: es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Joerg and Borislav,

There is no BIOS Update available for this Mother Board. It has the most
recent from Jan 2014. And I didn't find any option available in the BIOS
Menu to disable the IOMMU.

I tried yesterday a fresh install passing the 'amd_iommu=off' to the kernel
and everything is working fine. No delays/hangs, etc. The workaround works
just perfect.

Again thank you very much for your help! 

Kind regards,
Kelvin González


-----Original Message-----
From: Jörg Rödel [mailto:joro@8bytes.org] 
Sent: lunes, 30 de junio de 2014 10:14
To: Kelvin Gonzalez
Cc: Borislav Petkov; linux-kernel@vger.kernel.org
Subject: Re: Desktop PC freezes after showing many times the lines "AMD-Vi:
Completion-Wait loop timed out" and "BUG: soft lockup - CPU#2 stuck for
23s!"

Hey Kevin,

most likely the BIOS is buggy and does not setup the IOMMU hardware
correctly so that it can't be used reliably in Linux. You can try to
update the BIOS the the latest version and see if it fixes the issue, if
not you should disable the IOMMU in the BIOS to get rid of the problem.

Or you pass 'amd_iommu=off' on the kernel command-line to disable the
AMD IOMMU driver in the Linux kernel.


	Joerg


On Sun, Jun 29, 2014 at 11:38:18AM +0200, Borislav Petkov wrote:
> +Joerg.
> 
> Bah, iommu_queue_command seems to get stuck...
> 
> I guess you can boot with "amd_iommu=off" as a temporary workaround.
> 
> On Sun, Jun 29, 2014 at 01:59:51AM +0200, Kelvin Gonzalez wrote:
> > [1.] One line summary of the problem: 
> > Desktop PC freezes after showing many times the lines "AMD-Vi:
> > Completion-Wait loop timed out" and "BUG: soft lockup - CPU#2 stuck for
> > 23s!"
> > 
> > [2.] Full description of the problem/report: 
> > During Linux installation on a Desktop PC Medion MS-7857 the kernel was
> > hanging during boot and during the installation. 
> > 
> > I could see many times the following lines repeated very quickly in the
> > console:
> > AMD-Vi: Completion-Wait loop timed out
> > AMD-Vi: Completion-Wait loop timed out
> > AMD-Vi: Completion-Wait loop timed out
> > AMD-Vi: Completion-Wait loop timed out
> > 
> > And occasionally the following lines appeared in the system logs (dmesg
> > output):
> > 
> >    28.142168 BUG: soft lockup - CPU#2 stuck for 23s! [swapper/0:1]
> >    28.142172 Modules linked in:
> >    28.142175 CPU: 2 PID: 1 Comm: swapper/0 Not tainted
3.15.2-031502-generic
> > #201406261639
> >    28.142177 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >    28.142178 task: ffff8804296b0000 ti: ffff8804296b8000 task.ti:
> > ffff8804296b8000
> >    28.142180 RIP: 0010:[<ffffffff81383372>]  [<ffffffff81383372>]
> > delay_tsc+0x42/0x80
> >    28.142186 RSP: 0000:ffff8804296bbc68  EFLAGS: 00000246
> >    28.142187 RAX: 0000002988982cf4 RBX: 0000000000000326 RCX:
> > 0000000088982cf4
> >    28.142188 RDX: 0000000000000c4a RSI: 0000000000000246 RDI:
> > 0000000000000e50
> >    28.142189 RBP: ffff8804296bbc88 R08: 0000000000002000 R09:
> > 0000000000000000
> >    28.142190 R10: 0000000000000326 R11: 0720072007200720 R12:
> > 0000000000000026
> >    28.142191 R13: ffff8804296bbc58 R14: 0000000000000246 R15:
> > ffff8804296bbc38
> >    28.142192 FS:  0000000000000000(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >    28.142193 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >    28.142194 CR2: 0000000000000000 CR3: 0000000001c12000 CR4:
> > 00000000000407e0
> >    28.142195 Stack:
> >    28.142196  0000000000017bfe ffff8804296bbcf0 0000000000001ff0
> > ffff880429623814
> >    28.142199  ffff8804296bbc98 ffffffff813832ac ffff8804296bbcb8
> > ffffffff8162a6a5
> >    28.142201  ffff880429623800 0000000000002000 ffff8804296bbd28
> > ffffffff8162a7a7
> >    28.142203 Call Trace:
> >    28.142207  [<ffffffff813832ac>] __const_udelay+0x2c/0x30
> >    28.142210  [<ffffffff8162a6a5>] wait_on_sem+0x35/0x70
> >    28.142212  [<ffffffff8162a7a7>] iommu_queue_command_sync+0xc7/0x140
> >    28.142214  [<ffffffff8162a833>] iommu_queue_command+0x13/0x20
> >    28.142215  [<ffffffff8162e70d>] iommu_flush_all_caches+0x9d/0xf0
> >    28.142218  [<ffffffff8162eff1>] early_enable_iommus+0x61/0x160
> >    28.142221  [<ffffffff81d493a9>] ?
memblock_find_dma_reserve+0x139/0x139
> >    28.142223  [<ffffffff81d95655>] state_next+0xbf/0x201
> >    28.142225  [<ffffffff81d493a9>] ?
memblock_find_dma_reserve+0x139/0x139
> >    28.142226  [<ffffffff81d957ab>] iommu_go_to_state+0x14/0x2f
> >    28.142228  [<ffffffff81d95837>] amd_iommu_init+0x13/0xff
> >    28.142230  [<ffffffff81d3f1df>] ? load_default_modules+0x9/0xb
> >    28.142232  [<ffffffff81d493bc>] pci_iommu_init+0x13/0x3e
> >    28.142235  [<ffffffff8100217a>] do_one_initcall+0xfa/0x1b0
> >    28.142237  [<ffffffff8108f200>] ? parse_args+0xc0/0x1d0
> >    28.142239  [<ffffffff81d3ea5d>] ? do_early_param+0x87/0x87
> >    28.142241  [<ffffffff81d3f061>] do_basic_setup+0x96/0xb9
> >    28.142242  [<ffffffff81d3ea5d>] ? do_early_param+0x87/0x87
> >    28.142245  [<ffffffff81d60834>] ? sched_init_smp+0x114/0x116
> >    28.142247  [<ffffffff81d3f15d>] kernel_init_freeable+0xd9/0x152
> >    28.142250  [<ffffffff81755c40>] ? rest_init+0x80/0x80
> >    28.142252  [<ffffffff81755c4e>] kernel_init+0xe/0xf0
> >    28.142254  [<ffffffff817847bc>] ret_from_fork+0x7c/0xb0
> >    28.142256  [<ffffffff81755c40>] ? rest_init+0x80/0x80
> >    28.142257 Code: 25 64 b0 00 00 0f ae f0 66 66 90 e8 89 8b c9 ff 66 90
41
> > 89 c4 eb 11 66 90 f3 90 65 8b 1c 25 64 b0 00 00 41 39 dd 75 20 0f ae f0
<66>
> > 66 90 e8 66 8b c9 ff 66 90 89 c2 44 29 e2 44 39 f2 72 da 5b 
> >    28.145206 AMD-Vi: Completion-Wait loop timed out
> > 
> > This behavior remained after the installation of several linux
distributions
> > like: Ubuntu, Fedora, Debian and openSUSE. Finally I decided to work
with
> > Ubuntu and report a bug with them:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1280668
> > 
> > The issue remained after updating all applications and after updating
the
> > kernel with the newest upstream mainline kernel:
> > ~kernel-ppa/mainline/v3.15.2-utopic
> > 
> > The system freezes for long periods of time and makes the computer
unusable.
> > 
> > 
> > Also, I can't boot this computer normally because it freezes with a
black
> > screen. The only way to complete the installation process was passing
noapic
> > as a boot parameter. The PC still hanged but for shorter periods of time
and
> > then continued working.
> > With Ubuntu I tested installations with several versions and I found the
> > following:
> > .	Ubuntu 10.04.4 LTS (Lucid Lynx) was unable to boot the PC due to a
> > Kernel panic.
> > [0.812538] Kernel panic - not syncing : AMD-Vi : ILLEGAL_COMMAND_ERROR
while
> > resetting command buffer
> > .	Ubuntu 10.10 (Maverick Meerkat) was unable to boot the PC due to a
> > Kernel panic. But I wasn't able to capture the error.
> > .	Ubuntu 11.04 (Natty Narwhal) was unable to boot the PC due to a
> > Kernel panic. And I wasn't able to capture the error.
> > .	Ubuntu 11.10 (Oneiric Ocelot) was able to boot up and hang up for
> > more than 20 minutes. I wasn't able to work with the computer or get any
> > logs. However, the last message in console was:
> > [147.992078] AMD-Vi : Completion-Wait loop timed out
> > It seems that the problem appeared for first time in the Ubuntu release
> > 11.10 (Oneiric Ocelot), because with previous Ubuntu versions this PC
was
> > unable to boot.
> > 
> > [3.] Keywords (i.e., modules, networking, kernel):  
> > 
> > [4.] Kernel version (from /proc/version): 
> > cat /proc/version 
> > Linux version 3.15.2-031502-generic (apw@gomeisa) (gcc version 4.6.3
> > (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201406261639 SMP Thu Jun 26 20:40:28
UTC
> > 2014
> > 
> > [5.] Output of Oops.. message (if applicable) with symbolic information
> > resolved (see Documentation/oops-tracing.txt) 
> > Not sure if this is part of the oops-tracing. However, I have a complete
> > dmesg.txt file that I can send to you with all the instances that the
BUG
> > appeared. These are some examples, please see below:
> > --
> >    28.142168 BUG: soft lockup - CPU#2 stuck for 23s! [swapper/0:1]
> >    28.142172 Modules linked in:
> >    28.142175 CPU: 2 PID: 1 Comm: swapper/0 Not tainted
3.15.2-031502-generic
> > #201406261639
> >    28.142177 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >    28.142178 task: ffff8804296b0000 ti: ffff8804296b8000 task.ti:
> > ffff8804296b8000
> >    28.142180 RIP: 0010:[<ffffffff81383372>]  [<ffffffff81383372>]
> > delay_tsc+0x42/0x80
> >    28.142186 RSP: 0000:ffff8804296bbc68  EFLAGS: 00000246
> >    28.142187 RAX: 0000002988982cf4 RBX: 0000000000000326 RCX:
> > 0000000088982cf4
> >    28.142188 RDX: 0000000000000c4a RSI: 0000000000000246 RDI:
> > 0000000000000e50
> >    28.142189 RBP: ffff8804296bbc88 R08: 0000000000002000 R09:
> > 0000000000000000
> >    28.142190 R10: 0000000000000326 R11: 0720072007200720 R12:
> > 0000000000000026
> >    28.142191 R13: ffff8804296bbc58 R14: 0000000000000246 R15:
> > ffff8804296bbc38
> >    28.142192 FS:  0000000000000000(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >    28.142193 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >    28.142194 CR2: 0000000000000000 CR3: 0000000001c12000 CR4:
> > 00000000000407e0
> >    28.142195 Stack:
> >    28.142196  0000000000017bfe ffff8804296bbcf0 0000000000001ff0
> > ffff880429623814
> >    28.142199  ffff8804296bbc98 ffffffff813832ac ffff8804296bbcb8
> > ffffffff8162a6a5
> >    28.142201  ffff880429623800 0000000000002000 ffff8804296bbd28
> > ffffffff8162a7a7
> >    28.142203 Call Trace:
> >    28.142207  [<ffffffff813832ac>] __const_udelay+0x2c/0x30
> >    28.142210  [<ffffffff8162a6a5>] wait_on_sem+0x35/0x70
> >    28.142212  [<ffffffff8162a7a7>] iommu_queue_command_sync+0xc7/0x140
> >    28.142214  [<ffffffff8162a833>] iommu_queue_command+0x13/0x20
> >    28.142215  [<ffffffff8162e70d>] iommu_flush_all_caches+0x9d/0xf0
> >    28.142218  [<ffffffff8162eff1>] early_enable_iommus+0x61/0x160
> >    28.142221  [<ffffffff81d493a9>] ?
memblock_find_dma_reserve+0x139/0x139
> >    28.142223  [<ffffffff81d95655>] state_next+0xbf/0x201
> >    28.142225  [<ffffffff81d493a9>] ?
memblock_find_dma_reserve+0x139/0x139
> >    28.142226  [<ffffffff81d957ab>] iommu_go_to_state+0x14/0x2f
> >    28.142228  [<ffffffff81d95837>] amd_iommu_init+0x13/0xff
> >    28.142230  [<ffffffff81d3f1df>] ? load_default_modules+0x9/0xb
> >    28.142232  [<ffffffff81d493bc>] pci_iommu_init+0x13/0x3e
> >    28.142235  [<ffffffff8100217a>] do_one_initcall+0xfa/0x1b0
> >    28.142237  [<ffffffff8108f200>] ? parse_args+0xc0/0x1d0
> >    28.142239  [<ffffffff81d3ea5d>] ? do_early_param+0x87/0x87
> >    28.142241  [<ffffffff81d3f061>] do_basic_setup+0x96/0xb9
> >    28.142242  [<ffffffff81d3ea5d>] ? do_early_param+0x87/0x87
> >    28.142245  [<ffffffff81d60834>] ? sched_init_smp+0x114/0x116
> >    28.142247  [<ffffffff81d3f15d>] kernel_init_freeable+0xd9/0x152
> >    28.142250  [<ffffffff81755c40>] ? rest_init+0x80/0x80
> >    28.142252  [<ffffffff81755c4e>] kernel_init+0xe/0xf0
> >    28.142254  [<ffffffff817847bc>] ret_from_fork+0x7c/0xb0
> >    28.142256  [<ffffffff81755c40>] ? rest_init+0x80/0x80
> >    28.142257 Code: 25 64 b0 00 00 0f ae f0 66 66 90 e8 89 8b c9 ff 66 90
41
> > 89 c4 eb 11 66 90 f3 90 65 8b 1c 25 64 b0 00 00 41 39 dd 75 20 0f ae f0
<66>
> > 66 90 e8 66 8b c9 ff 66 90 89 c2 44 29 e2 44 39 f2 72 da 5b 
> > --
> > 220.113427 AMD-Vi: Completion-Wait loop timed out
> >   220.113448 BUG: soft lockup - CPU#2 stuck for 22s! [compiz:2039]
> >   220.113450 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   220.113495 CPU: 2 PID: 2039 Comm: compiz Not tainted
3.15.2-031502-generic
> > #201406261639
> >   220.113497 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   220.113509 task: ffff880410fbb260 ti: ffff88008357c000 task.ti:
> > ffff88008357c000
> >   220.113521 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   220.113529 RSP: 0018:ffff88008357fa90  EFLAGS: 00000283
> >   220.113530 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   220.113532 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   220.113534 RBP: ffff88008357fa98 R08: 000000000000000a R09:
> > 0000000000000000
> >   220.113535 R10: 0000000000000696 R11: 0000000000000695 R12:
> > 00000000c437f791
> >   220.113537 R13: 0000000000000e5b R14: 0000000000000046 R15:
> > 00000000000186a0
> >   220.113539 FS:  00007f52fe56b7c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   220.113541 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   220.113542 CR2: 0000000002682120 CR3: 0000000410f71000 CR4:
> > 00000000000407e0
> >   220.113544 Stack:
> >   220.113546  ffff880403ccc000 ffff88008357fae8 ffffffff8162cdeb
> > ffff88008357fae8
> >   220.113549  0000000000000283 ffff88008357fbb8 ffff880083505b00
> > ffff880428d67098
> >   220.113552  0000000000001000 ffffffff81cdc680 ffff880083505ac0
> > ffff88008357fb28
> >   220.113555 Call Trace:
> >   220.113560  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   220.113572  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   220.113579  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   220.113617  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   220.113652  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   220.113673  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   220.113685  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   220.113690  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   220.113696  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   220.113700  [<ffffffff817660d4>] ? __slab_free+0x122/0x234
> >   220.113706  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   220.113711  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   220.113731  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   220.113766  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   220.113784  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   220.113794  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   220.113804  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   220.113815  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   220.113824  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   220.113829  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   220.113838  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   220.113844  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   220.113858  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   220.113862  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   220.113866  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   220.113870  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   220.113873  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   220.113876  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   220.113878 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> >   220.219543 AMD-Vi: Completion-Wait loop timed out
> > --
> >   248.043564 AMD-Vi: Completion-Wait loop timed out
> >   248.043587 BUG: soft lockup - CPU#2 stuck for 23s! [Xorg:1119]
> >   248.043589 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   248.043662 CPU: 2 PID: 1119 Comm: Xorg Not tainted
3.15.2-031502-generic
> > #201406261639
> >   248.043665 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   248.043669 task: ffff880427313260 ti: ffff880426e08000 task.ti:
> > ffff880426e08000
> >   248.043672 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   248.043683 RSP: 0018:ffff880426e0ba90  EFLAGS: 00000283
> >   248.043687 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   248.043698 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   248.043710 RBP: ffff880426e0ba98 R08: 000000000000000a R09:
> > 0000000000000001
> >   248.043716 R10: 00000000000007ab R11: 00000000000007aa R12:
> > 00000000ce7187e8
> >   248.043720 R13: 0000000000000f46 R14: 0000000000000046 R15:
> > 00000000000186a0
> >   248.043724 FS:  00007f304c03e9c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   248.043727 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   248.043730 CR2: 00007f303f03e000 CR3: 0000000417ae3000 CR4:
> > 00000000000407e0
> >   248.043733 Stack:
> >   248.043735  ffff88040a14b000 ffff880426e0bae8 ffffffff8162cdeb
> > ffff880426e0bae8
> >   248.043751  0000000000000283 ffff880426e0bbb8 ffff88008348a4c0
> > ffff880428d67098
> >   248.043761  0000000000001000 ffffffff81cdc680 ffff88041120cb00
> > ffff880426e0bb28
> >   248.043767 Call Trace:
> >   248.043777  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   248.043802  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   248.043816  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   248.043861  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   248.043894  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   248.043904  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   248.043915  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   248.043925  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   248.043935  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   248.043942  [<ffffffff817660d4>] ? __slab_free+0x122/0x234
> >   248.043953  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   248.043964  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   248.043995  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   248.044032  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   248.044056  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   248.044072  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   248.044089  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   248.044106  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   248.044121  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   248.044129  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   248.044145  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   248.044152  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   248.044174  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   248.044180  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   248.044185  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   248.044189  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   248.044194  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   248.044199  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   248.044202 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> >   248.159446 AMD-Vi: Completion-Wait loop timed out
> > --
> > 270.000056 AMD-Vi: Completion-Wait loop timed out
> >   270.000058 ------------[ cut here ]------------
> >   270.000069 WARNING: CPU: 2 PID: 1119 at
> > /home/apw/COD/linux/drivers/iommu/amd_iommu.c:1248
> > __domain_flush_pages+0xf0/0x100()
> >   270.000072 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   270.000132 CPU: 2 PID: 1119 Comm: Xorg Not tainted
3.15.2-031502-generic
> > #201406261639
> >   270.000135 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   270.000138  00000000000004e0 ffff880426e0b998 ffffffff8176e364
> > 0000000000000007
> >   270.000144  0000000000000000 ffff880426e0b9d8 ffffffff8106ce2c
> > ffff880425524030
> >   270.000148  ffff880425524020 0000000000001000 00000000fffffffb
> > ffff880425524020
> >   270.000153 Call Trace:
> >   270.000162  [<ffffffff8176e364>] dump_stack+0x46/0x58
> >   270.000168  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
> >   270.000172  [<ffffffff8106ce7a>] warn_slowpath_null+0x1a/0x20
> >   270.000177  [<ffffffff8162be40>] __domain_flush_pages+0xf0/0x100
> >   270.000182  [<ffffffff8162cc09>] __unmap_single.isra.25+0xf9/0x120
> >   270.000186  [<ffffffff8162cdd4>] free_coherent+0x64/0xb0
> >   270.000200  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   270.000211  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   270.000254  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   270.000283  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   270.000292  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   270.000300  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   270.000309  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   270.000317  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   270.000322  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   270.000331  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   270.000339  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   270.000368  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   270.000399  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   270.000421  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   270.000435  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   270.000450  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   270.000465  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   270.000478  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   270.000484  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   270.000499  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   270.000505  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   270.000526  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   270.000532  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   270.000537  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   270.000541  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   270.000546  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   270.000551  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   270.000555 ---[ end trace 821599f0f758e751 ]---
> >   270.115643 AMD-Vi: Completion-Wait loop timed out
> >   296.011813 BUG: soft lockup - CPU#2 stuck for 22s! [Xorg:1119]
> >   296.011815 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   296.011880 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   296.011884 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   296.011887 task: ffff880427313260 ti: ffff880426e08000 task.ti:
> > ffff880426e08000
> >   296.011890 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   296.011915 RSP: 0018:ffff880426e0ba90  EFLAGS: 00000283
> >   296.011923 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   296.011926 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   296.011928 RBP: ffff880426e0ba98 R08: 000000000000000a R09:
> > 0000000000000001
> >   296.011931 R10: 0000000000000972 R11: 0000000000000971 R12:
> > 0000000017ee437d
> >   296.011933 R13: 0000000000000f46 R14: 0000000000000046 R15:
> > 00000000000186a0
> >   296.011936 FS:  00007f304c03e9c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   296.011939 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   296.011941 CR2: 00007ff740ff04e0 CR3: 0000000417ae3000 CR4:
> > 00000000000407e0
> >   296.011944 Stack:
> >   296.011946  ffff880083439000 ffff880426e0bae8 ffffffff8162cdeb
> > ffff880426e0bae8
> >   296.011951  0000000000000283 ffff880427f0d078 ffff880424c35040
> > ffff880428d67098
> >   296.011955  0000000000001000 ffffffff81cdc680 ffff880424c35b40
> > ffff880426e0bb28
> >   296.011960 Call Trace:
> >   296.011967  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   296.011980  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   296.011991  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   296.012047  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   296.012090  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   296.012099  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   296.012107  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   296.012122  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   296.012131  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   296.012141  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   296.012150  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   296.012163  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   296.012192  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   296.012224  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   296.012243  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   296.012257  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   296.012271  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   296.012286  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   296.012299  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   296.012305  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   296.012319  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   296.012325  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   296.012346  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   296.012351  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   296.012355  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   296.012360  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   296.012365  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   296.012369  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   296.012372 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> >   296.127508 AMD-Vi: Completion-Wait loop timed out
> > --
> > 324.094245 BUG: soft lockup - CPU#2 stuck for 22s! [Xorg:1119]
> >   324.094248 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   324.094299 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   324.094303 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   324.094306 task: ffff880427313260 ti: ffff880426e08000 task.ti:
> > ffff880426e08000
> >   324.094308 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   324.094314 RSP: 0018:ffff880426e0ba90  EFLAGS: 00000283
> >   324.094317 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   324.094319 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   324.094322 RBP: ffff880426e0ba98 R08: 000000000000000a R09:
> > 0000000000000001
> >   324.094324 R10: 0000000000000a98 R11: 0000000000000a97 R12:
> > 0000000043b7a8ea
> >   324.094326 R13: 0000000000000f45 R14: 0000000000000046 R15:
> > 00000000000186a0
> >   324.094329 FS:  00007f304c03e9c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   324.094332 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   324.094334 CR2: 00007ff740ff04e0 CR3: 0000000417ae3000 CR4:
> > 00000000000407e0
> >   324.094336 Stack:
> >   324.094338  ffff88041366e000 ffff880426e0bae8 ffffffff8162cdeb
> > ffff880426e0bae8
> >   324.094343  0000000000000283 ffff880427f0d078 ffff880427e45680
> > ffff880428d67098
> >   324.094348  0000000000001000 ffffffff81cdc680 ffff880427e452c0
> > ffff880426e0bb28
> >   324.094352 Call Trace:
> >   324.094358  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   324.094370  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   324.094382  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   324.094414  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   324.094443  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   324.094452  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   324.094460  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   324.094468  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   324.094477  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   324.094481  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   324.094490  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   324.094499  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   324.094527  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   324.094558  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   324.094573  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   324.094588  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   324.094602  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   324.094617  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   324.094630  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   324.094635  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   324.094650  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   324.094656  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   324.094677  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   324.094682  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   324.094686  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   324.094690  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   324.094694  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   324.094699  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   324.094701 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> > --
> >   328.928555 ------------[ cut here ]------------
> >   328.928561 WARNING: CPU: 2 PID: 1119 at
> > /home/apw/COD/linux/drivers/iommu/amd_iommu.c:1248
> > __domain_flush_pages+0xf0/0x100()
> >   328.928563 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   328.928613 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   328.928616 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   328.928618  00000000000004e0 ffff880426e0b998 ffffffff8176e364
> > 0000000000000007
> >   328.928623  0000000000000000 ffff880426e0b9d8 ffffffff8106ce2c
> > ffff880425524030
> >   328.928628  ffff880425524020 0000000000001000 00000000fffffffb
> > ffff880425524020
> >   328.928633 Call Trace:
> >   328.928639  [<ffffffff8176e364>] dump_stack+0x46/0x58
> >   328.928644  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
> >   328.928648  [<ffffffff8106ce7a>] warn_slowpath_null+0x1a/0x20
> >   328.928652  [<ffffffff8162be40>] __domain_flush_pages+0xf0/0x100
> >   328.928657  [<ffffffff8162cc09>] __unmap_single.isra.25+0xf9/0x120
> >   328.928662  [<ffffffff8162cdd4>] free_coherent+0x64/0xb0
> >   328.928673  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   328.928684  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   328.928713  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   328.928744  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   328.928753  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   328.928761  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   328.928769  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   328.928777  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   328.928781  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   328.928790  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   328.928799  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   328.928827  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   328.928858  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   328.928872  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   328.928886  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   328.928900  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   328.928915  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   328.928928  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   328.928934  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   328.928948  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   328.928954  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   328.928975  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   328.928979  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   328.928983  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   328.928987  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   328.928991  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   328.928996  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   328.928999 ---[ end trace 821599f0f758e752 ]---
> > --
> > 355.975392 BUG: soft lockup - CPU#2 stuck for 22s! [Xorg:1119]
> >   355.975395 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   355.975460 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   355.975463 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   355.975466 task: ffff880427313260 ti: ffff880426e08000 task.ti:
> > ffff880426e08000
> >   355.975469 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   355.975476 RSP: 0018:ffff880426e0ba90  EFLAGS: 00000283
> >   355.975479 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   355.975481 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   355.975484 RBP: ffff880426e0ba98 R08: 000000000000000a R09:
> > 0000000000000000
> >   355.975486 R10: 0000000000000c09 R11: 0000000000000c08 R12:
> > 00000000b4845dbd
> >   355.975488 R13: 0000000000000f46 R14: 0000000000000046 R15:
> > 00000000000186a0
> >   355.975495 FS:  00007f304c03e9c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   355.975498 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   355.975509 CR2: 00007ff740ff04e0 CR3: 0000000417ae3000 CR4:
> > 00000000000407e0
> >   355.975521 Stack:
> >   355.975532  ffff88041122e000 ffff880426e0bae8 ffffffff8162cdeb
> > ffff880426e0bae8
> >   355.975542  0000000000000283 ffff880427f0d078 ffff880412431d80
> > ffff880428d67098
> >   355.975549  0000000000001000 ffffffff81cdc680 ffff880412431f40
> > ffff880426e0bb28
> >   355.975555 Call Trace:
> >   355.975564  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   355.975586  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   355.975601  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   355.975644  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   355.975678  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   355.975688  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   355.975699  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   355.975709  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   355.975719  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   355.975726  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   355.975738  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   355.975749  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   355.975781  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   355.975817  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   355.975840  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   355.975856  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   355.975874  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   355.975891  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   355.975907  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   355.975914  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   355.975932  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   355.975940  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   355.975964  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   355.975971  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   355.975977  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   355.975983  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   355.975989  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   355.975996  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   355.976000 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> > 
> > --
> > 536.839821 ------------[ cut here ]------------
> >   536.839831 WARNING: CPU: 2 PID: 0 at
> > /home/apw/COD/linux/drivers/iommu/amd_iommu.c:1248
> > __domain_flush_pages+0xf0/0x100()
> >   536.839834 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   536.839895 CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   536.839898 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   536.839901  00000000000004e0 ffff88043ed037f0 ffffffff8176e364
> > 0000000000000007
> >   536.839906  0000000000000000 ffff88043ed03830 ffffffff8106ce2c
> > ffff88008d708030
> >   536.839911  ffff88008d708020 0000000000004000 00000000fffffffb
> > ffff88008d708020
> >   536.839917 Call Trace:
> >   536.839919  <IRQ>  [<ffffffff8176e364>] dump_stack+0x46/0x58
> >   536.839932  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
> >   536.839937  [<ffffffff8106ce7a>] warn_slowpath_null+0x1a/0x20
> >   536.839942  [<ffffffff8162be40>] __domain_flush_pages+0xf0/0x100
> >   536.839946  [<ffffffff8162cc09>] __unmap_single.isra.25+0xf9/0x120
> >   536.839951  [<ffffffff8162cc9b>] unmap_sg+0x6b/0xb0
> >   536.839957  [<ffffffff81524b96>] ata_sg_clean+0x66/0xc0
> >   536.839962  [<ffffffff8152ba8a>] ? ata_scsi_qc_complete+0x6a/0xd0
> >   536.839966  [<ffffffff81524e37>] __ata_qc_complete+0x47/0x140
> >   536.839971  [<ffffffff81524fcd>] ata_qc_complete+0x9d/0x230
> >   536.839976  [<ffffffff815251fa>] ata_qc_complete_multiple+0x9a/0xe0
> >   536.839987  [<ffffffffa00090b7>]
ahci_handle_port_interrupt+0x107/0x1a0
> > [libahci]
> >   536.839996  [<ffffffffa0009215>] ahci_interrupt+0xc5/0x120 [libahci]
> >   536.840003  [<ffffffff810ca85d>] handle_irq_event_percpu+0x5d/0x1e0
> >   536.840009  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   536.840014  [<ffffffff810caa28>] handle_irq_event+0x48/0x70
> >   536.840018  [<ffffffff810cd597>] handle_edge_irq+0x77/0x110
> >   536.840024  [<ffffffff810161a2>] handle_irq+0x22/0x40
> >   536.840030  [<ffffffff81786b9e>] do_IRQ+0x5e/0x110
> >   536.840034  [<ffffffff8177b66d>] common_interrupt+0x6d/0x6d
> >   536.840040  [<ffffffff8177b15e>] ?
_raw_spin_unlock_irqrestore+0x1e/0x50
> >   536.840044  [<ffffffff8152e02f>] ata_scsi_queuecmd+0xbf/0x2b0
> >   536.840050  [<ffffffff814fe1be>] scsi_dispatch_cmd+0xce/0x280
> >   536.840055  [<ffffffff81506b02>] scsi_request_fn+0x372/0x470
> >   536.840062  [<ffffffff81347327>] __blk_run_queue+0x37/0x50
> >   536.840066  [<ffffffff813474af>] blk_run_queue+0x2f/0x50
> >   536.840070  [<ffffffff815054d9>] scsi_run_queue+0x49/0x70
> >   536.840075  [<ffffffff815078c9>] scsi_next_command+0x29/0x40
> >   536.840079  [<ffffffff81507b52>] scsi_io_completion+0x212/0x790
> >   536.840084  [<ffffffff814fc888>] scsi_finish_command+0xc8/0x130
> >   536.840089  [<ffffffff8150786e>] scsi_softirq_done+0x13e/0x150
> >   536.840094  [<ffffffff81352fc3>] blk_done_softirq+0x83/0xa0
> >   536.840099  [<ffffffff81071fff>] __do_softirq+0xef/0x330
> >   536.840104  [<ffffffff8107254e>] irq_exit+0x11e/0x140
> >   536.840109  [<ffffffff81786ba7>] do_IRQ+0x67/0x110
> >   536.840113  [<ffffffff8177b66d>] common_interrupt+0x6d/0x6d
> >   536.840115  <EOI>  [<ffffffff8101c7b9>] ? sched_clock+0x9/0x10
> >   536.840125  [<ffffffff8160a44e>] ? cpuidle_enter_state+0x5e/0xe0
> >   536.840129  [<ffffffff8160a447>] ? cpuidle_enter_state+0x57/0xe0
> >   536.840133  [<ffffffff8160a507>] cpuidle_enter+0x17/0x20
> >   536.840138  [<ffffffff810b584d>] cpuidle_idle_call+0x10d/0x260
> >   536.840143  [<ffffffff810b5b65>] cpu_idle_loop+0x1c5/0x1e0
> >   536.840148  [<ffffffff810b5beb>] cpu_startup_entry+0x6b/0x70
> >   536.840153  [<ffffffff81046df8>] start_secondary+0xc8/0xd0
> >   536.840157 ---[ end trace 821599f0f758e753 ]---
> > 
> > --
> > 538.337039 ------------[ cut here ]------------
> >   538.337044 WARNING: CPU: 2 PID: 0 at
> > /home/apw/COD/linux/drivers/iommu/amd_iommu.c:1248
> > __domain_flush_pages+0xf0/0x100()
> >   538.337046 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   538.337094 CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   538.337096 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   538.337098  00000000000004e0 ffff88043ed037f0 ffffffff8176e364
> > 0000000000000007
> >   538.337103  0000000000000000 ffff88043ed03830 ffffffff8106ce2c
> > ffff88008d708030
> >   538.337108  ffff88008d708020 0000000000001000 00000000fffffffb
> > ffff88008d708020
> >   538.337112 Call Trace:
> >   538.337114  <IRQ>  [<ffffffff8176e364>] dump_stack+0x46/0x58
> >   538.337122  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
> >   538.337126  [<ffffffff8106ce7a>] warn_slowpath_null+0x1a/0x20
> >   538.337130  [<ffffffff8162be40>] __domain_flush_pages+0xf0/0x100
> >   538.337135  [<ffffffff8162cc09>] __unmap_single.isra.25+0xf9/0x120
> >   538.337139  [<ffffffff8162cc9b>] unmap_sg+0x6b/0xb0
> >   538.337144  [<ffffffff81524b96>] ata_sg_clean+0x66/0xc0
> >   538.337148  [<ffffffff8152ba8a>] ? ata_scsi_qc_complete+0x6a/0xd0
> >   538.337153  [<ffffffff81524e37>] __ata_qc_complete+0x47/0x140
> >   538.337157  [<ffffffff81524fcd>] ata_qc_complete+0x9d/0x230
> >   538.337162  [<ffffffff815251fa>] ata_qc_complete_multiple+0x9a/0xe0
> >   538.337171  [<ffffffffa00090b7>]
ahci_handle_port_interrupt+0x107/0x1a0
> > [libahci]
> >   538.337180  [<ffffffffa0009215>] ahci_interrupt+0xc5/0x120 [libahci]
> >   538.337186  [<ffffffff810ca85d>] handle_irq_event_percpu+0x5d/0x1e0
> >   538.337190  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   538.337195  [<ffffffff810caa28>] handle_irq_event+0x48/0x70
> >   538.337199  [<ffffffff810cd597>] handle_edge_irq+0x77/0x110
> >   538.337204  [<ffffffff810161a2>] handle_irq+0x22/0x40
> >   538.337208  [<ffffffff81786b9e>] do_IRQ+0x5e/0x110
> >   538.337212  [<ffffffff8177b66d>] common_interrupt+0x6d/0x6d
> >   538.337217  [<ffffffff8177b15e>] ?
_raw_spin_unlock_irqrestore+0x1e/0x50
> >   538.337221  [<ffffffff8152e02f>] ata_scsi_queuecmd+0xbf/0x2b0
> >   538.337226  [<ffffffff814fe1be>] scsi_dispatch_cmd+0xce/0x280
> >   538.337231  [<ffffffff81506b02>] scsi_request_fn+0x372/0x470
> >   538.337236  [<ffffffff81347327>] __blk_run_queue+0x37/0x50
> >   538.337241  [<ffffffff813474af>] blk_run_queue+0x2f/0x50
> >   538.337245  [<ffffffff815054d9>] scsi_run_queue+0x49/0x70
> >   538.337249  [<ffffffff815078c9>] scsi_next_command+0x29/0x40
> >   538.337253  [<ffffffff81507b52>] scsi_io_completion+0x212/0x790
> >   538.337258  [<ffffffff814fc888>] scsi_finish_command+0xc8/0x130
> >   538.337263  [<ffffffff8150786e>] scsi_softirq_done+0x13e/0x150
> >   538.337267  [<ffffffff81352fc3>] blk_done_softirq+0x83/0xa0
> >   538.337272  [<ffffffff81071fff>] __do_softirq+0xef/0x330
> >   538.337277  [<ffffffff8107254e>] irq_exit+0x11e/0x140
> >   538.337281  [<ffffffff81786ba7>] do_IRQ+0x67/0x110
> >   538.337285  [<ffffffff8177b66d>] common_interrupt+0x6d/0x6d
> >   538.337287  <EOI>  [<ffffffff8101c7b9>] ? sched_clock+0x9/0x10
> >   538.337296  [<ffffffff8160a44e>] ? cpuidle_enter_state+0x5e/0xe0
> >   538.337300  [<ffffffff8160a447>] ? cpuidle_enter_state+0x57/0xe0
> >   538.337304  [<ffffffff8160a507>] cpuidle_enter+0x17/0x20
> >   538.337308  [<ffffffff810b584d>] cpuidle_idle_call+0x10d/0x260
> >   538.337313  [<ffffffff810b5b65>] cpu_idle_loop+0x1c5/0x1e0
> >   538.337318  [<ffffffff810b5beb>] cpu_startup_entry+0x6b/0x70
> >   538.337322  [<ffffffff81046df8>] start_secondary+0xc8/0xd0
> >   538.337326 ---[ end trace 821599f0f758e754 ]---
> > 810.412316 ------------[ cut here ]------------
> >   810.412326 WARNING: CPU: 2 PID: 1119 at
> > /home/apw/COD/linux/drivers/iommu/amd_iommu.c:1248
> > __domain_flush_pages+0xf0/0x100()
> >   810.412328 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   810.412390 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   810.412393 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   810.412396  00000000000004e0 ffff880426e0b998 ffffffff8176e364
> > 0000000000000007
> >   810.412402  0000000000000000 ffff880426e0b9d8 ffffffff8106ce2c
> > ffff880425524030
> >   810.412406  ffff880425524020 0000000000001000 00000000fffffffb
> > ffff880425524020
> >   810.412411 Call Trace:
> >   810.412421  [<ffffffff8176e364>] dump_stack+0x46/0x58
> >   810.412426  [<ffffffff8106ce2c>] warn_slowpath_common+0x8c/0xc0
> >   810.412431  [<ffffffff8106ce7a>] warn_slowpath_null+0x1a/0x20
> >   810.412435  [<ffffffff8162be40>] __domain_flush_pages+0xf0/0x100
> >   810.412440  [<ffffffff8162cc09>] __unmap_single.isra.25+0xf9/0x120
> >   810.412445  [<ffffffff8162cdd4>] free_coherent+0x64/0xb0
> >   810.412458  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   810.412470  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   810.412514  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   810.412542  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   810.412551  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   810.412559  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   810.412567  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   810.412576  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   810.412580  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   810.412590  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   810.412598  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   810.412627  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   810.412658  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   810.412680  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   810.412694  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   810.412709  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   810.412724  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   810.412737  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   810.412744  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   810.412758  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   810.412764  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   810.412785  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   810.412791  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   810.412796  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   810.412800  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   810.412805  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   810.412810  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   810.412814 ---[ end trace 821599f0f758e755 ]---
> > 
> >   835.779425 BUG: soft lockup - CPU#2 stuck for 22s! [Xorg:1119]
> >   835.779432 Modules linked in: rfcomm bnep bluetooth 6lowpan_iphc
> > nls_iso8859_1 uas kvm_amd kvm radeon crct10dif_pclmul joydev
crc32_pclmul
> > ghash_clmulni_intel aesni_intel snd_hda_codec_realtek aes_x86_64
> > snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel lrw
> > snd_hda_controller gf128mul glue_helper snd_hda_codec ablk_helper cryptd
> > snd_hwdep snd_pcm snd_seq_midi ttm snd_seq_midi_event drm_kms_helper
> > snd_rawmidi snd_seq drm psmouse snd_seq_device serio_raw snd_timer
> > i2c_algo_bit snd parport_pc i2c_piix4 soundcore ppdev lp mac_hid k10temp
> > parport hid_generic usbhid hid ahci r8169 libahci mii
> >   835.779495 CPU: 2 PID: 1119 Comm: Xorg Tainted: G        W
> > 3.15.2-031502-generic #201406261639
> >   835.779499 Hardware name: MEDION MS-7857/MS-7857, BIOS M7857W08.203
> > 01/06/2014
> >   835.779502 task: ffff880427313260 ti: ffff880426e08000 task.ti:
> > ffff880426e08000
> >   835.779505 RIP: 0010:[<ffffffff8177b15e>]  [<ffffffff8177b15e>]
> > _raw_spin_unlock_irqrestore+0x1e/0x50
> >   835.779514 RSP: 0018:ffff880426e0ba90  EFLAGS: 00000283
> >   835.779516 RAX: 0000000000000283 RBX: 0000000000000001 RCX:
> > 0000000000000000
> >   835.779519 RDX: ffff88043ed10010 RSI: 0000000000000283 RDI:
> > 0000000000000283
> >   835.779521 RBP: ffff880426e0ba98 R08: 000000000000000a R09:
> > 0000000000000000
> >   835.779523 R10: 0000000000000e2a R11: 0000000000000e29 R12:
> > 00000000ae3a7bca
> >   835.779526 R13: 0000000000000f46 R14: 0000000000000046 R15:
> > 00000000000186a0
> >   835.779529 FS:  00007f304c03e9c0(0000) GS:ffff88043ed00000(0000)
> > knlGS:0000000000000000
> >   835.779532 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >   835.779534 CR2: 00007f303f7c9000 CR3: 0000000417ae3000 CR4:
> > 00000000000407e0
> >   835.779537 Stack:
> >   835.779539  ffff88040a363000 ffff880426e0bae8 ffffffff8162cdeb
> > ffff880426e0bae8
> >   835.779543  0000000000000283 ffff880426e0bbb8 ffff8804135e6a00
> > ffff880428d67098
> >   835.779548  0000000000001000 ffffffff81cdc680 ffff8804135e6e40
> > ffff880426e0bb28
> >   835.779553 Call Trace:
> >   835.779563  [<ffffffff8162cdeb>] free_coherent+0x7b/0xb0
> >   835.779579  [<ffffffffa017ed4f>] __ttm_dma_free_page.isra.7+0x5f/0xb0
> > [ttm]
> >   835.779593  [<ffffffffa017f635>] ttm_dma_unpopulate+0x2a5/0x330 [ttm]
> >   835.779638  [<ffffffffa02c4db0>]
> > radeon_ttm_tt_unpopulate.part.18+0xf0/0x100 [radeon]
> >   835.779668  [<ffffffffa02c4dd4>] radeon_ttm_tt_unpopulate+0x14/0x20
> > [radeon]
> >   835.779677  [<ffffffffa0176364>] ttm_tt_unpopulate+0x54/0x60 [ttm]
> >   835.779685  [<ffffffffa0176595>] ttm_tt_destroy+0x65/0x70 [ttm]
> >   835.779693  [<ffffffffa01768c3>] ttm_bo_cleanup_memtype_use+0x43/0x90
> > [ttm]
> >   835.779702  [<ffffffffa0177a3b>]
ttm_bo_cleanup_refs_or_queue+0x1bb/0x200
> > [ttm]
> >   835.779707  [<ffffffff817660a0>] ? __slab_free+0xee/0x234
> >   835.779716  [<ffffffffa0177aeb>] ttm_bo_release+0x6b/0xa0 [ttm]
> >   835.779724  [<ffffffffa0177b49>] ttm_bo_unref+0x29/0x30 [ttm]
> >   835.779753  [<ffffffffa02c5937>] radeon_bo_unref+0x47/0x80 [radeon]
> >   835.779785  [<ffffffffa02d883c>] radeon_gem_object_free+0x3c/0x40
[radeon]
> >   835.779806  [<ffffffffa00ff517>] drm_gem_object_free+0x27/0x30 [drm]
> >   835.779821  [<ffffffffa00ffa92>]
> > drm_gem_object_handle_unreference_unlocked+0xe2/0x120 [drm]
> >   835.779836  [<ffffffffa00ffc51>] drm_gem_handle_delete+0xc1/0x140
[drm]
> >   835.779851  [<ffffffffa00fff85>] drm_gem_close_ioctl+0x25/0x30 [drm]
> >   835.779864  [<ffffffffa00fddcb>] drm_ioctl+0x25b/0x580 [drm]
> >   835.779870  [<ffffffff81186e54>] ? tlb_flush_mmu_free+0x34/0x60
> >   835.779887  [<ffffffffa00fff60>] ? drm_gem_handle_create+0x50/0x50
[drm]
> >   835.779893  [<ffffffff8111cdfc>] ? acct_account_cputime+0x1c/0x20
> >   835.779915  [<ffffffffa02903fd>] radeon_drm_ioctl+0x5d/0xa0 [radeon]
> >   835.779920  [<ffffffff811e4d05>] do_vfs_ioctl+0x75/0x2c0
> >   835.779925  [<ffffffff81021ee5>] ? syscall_trace_enter+0x165/0x280
> >   835.779929  [<ffffffff811ef2b5>] ? __fget_light+0x25/0x70
> >   835.779934  [<ffffffff811e4fe1>] SyS_ioctl+0x91/0xb0
> >   835.779939  [<ffffffff81784a7f>] tracesys+0xe1/0xe6
> >   835.779942 Code: 74 ed e8 d6 6f fe ff 5d c3 0f 1f 40 00 66 66 66 66 90
55
> > 48 89 f0 48 89 e5 48 83 ec 08 66 66 66 66 90 66 83 07 02 48 89 c7 57 9d
<66>
> > 66 90 66 90 c9 c3 0f 1f 00 8b 37 f0 66 83 07 02 f6 47 02 01 
> > 
> > 
> > [6.] A small shell script or example program which triggers the problem
(if
> > possible) 
> > No need. The issue appears always just after booting the PC.
> > 
> > [7.] Environment 
> > lsb_release -rd 
> > 
> > Description:	Ubuntu 14.04 LTS
> > Release:	14.04
> > 
> > [7.1.] Software (add the output of the ver_linux script here) 
> > /usr/src/linux-headers-3.15.2-031502-generic/scripts/ver_linux
> > 
> > If some fields are empty or look unusual you may have an old version.
> > Compare to the current minimal requirements in Documentation/Changes.
> >  
> > Linux medion 3.15.2-031502-generic #201406261639 SMP Thu Jun 26 20:40:28
UTC
> > 2014 x86_64 x86_64 x86_64 GNU/Linux
> >  
> > Gnu C                  4.8
> > Gnu make               3.81
> > binutils               2.24
> > util-linux             2.20.1
> > mount                  support
> > module-init-tools      15
> > e2fsprogs              1.42.9
> > pcmciautils            018
> > PPP                    2.4.5
> > Linux C Library        2.19
> > Dynamic linker (ldd)   2.19
> > Procps                 3.3.9
> > Net-tools              1.60
> > Kbd                    1.15.5
> > Sh-utils               8.21
> > wireless-tools         30
> > Modules Loaded         btrfs raid6_pq xor ufs qnx4 hfsplus hfs minix
ntfs
> > msdos jfs xfs libcrc32c rfcomm bnep bluetooth 6lowpan_iphc nls_iso8859_1
uas
> > kvm_amd kvm radeon crct10dif_pclmul joydev crc32_pclmul
ghash_clmulni_intel
> > aesni_intel snd_hda_codec_realtek aes_x86_64 snd_hda_codec_generic
> > snd_hda_codec_hdmi snd_hda_intel lrw snd_hda_controller gf128mul
glue_helper
> > snd_hda_codec ablk_helper cryptd snd_hwdep snd_pcm snd_seq_midi ttm
> > snd_seq_midi_event drm_kms_helper snd_rawmidi snd_seq drm psmouse
> > snd_seq_device serio_raw snd_timer i2c_algo_bit snd parport_pc i2c_piix4
> > soundcore ppdev lp mac_hid k10temp parport hid_generic usbhid hid ahci
r8169
> > libahci mii
> > 
> >  [7.2.] Processor information (from /proc/cpuinfo): 
> > cat /proc/cpuinfo 
> > processor	: 0
> > vendor_id	: AuthenticAMD
> > cpu family	: 21
> > model		: 19
> > model name	: AMD A10-6700 APU with Radeon(tm) HD Graphics
> > stepping	: 1
> > microcode	: 0x6001119
> > cpu MHz		: 1800.000
> > cache size	: 2048 KB
> > physical id	: 0
> > siblings	: 4
> > core id		: 0
> > cpu cores	: 2
> > apicid		: 16
> > initial apicid	: 0
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 13
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca
> > cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
> > aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes
> > xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
> > misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce
nodeid_msr
> > tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock
> > nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
> > pfthreshold bmi1
> > bogomips	: 7386.32
> > TLB size	: 1536 4K pages
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 48 bits physical, 48 bits virtual
> > power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro
> > 
> > processor	: 1
> > vendor_id	: AuthenticAMD
> > cpu family	: 21
> > model		: 19
> > model name	: AMD A10-6700 APU with Radeon(tm) HD Graphics   
> > stepping	: 1
> > microcode	: 0x6001119
> > cpu MHz		: 1800.000
> > cache size	: 2048 KB
> > physical id	: 0
> > siblings	: 4
> > core id		: 1
> > cpu cores	: 2
> > apicid		: 17
> > initial apicid	: 1
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 13
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca
> > cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
> > aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes
> > xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
> > misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce
nodeid_msr
> > tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock
> > nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
> > pfthreshold bmi1
> > bogomips	: 7386.32
> > TLB size	: 1536 4K pages
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 48 bits physical, 48 bits virtual
> > power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro
> > 
> > processor	: 2
> > vendor_id	: AuthenticAMD
> > cpu family	: 21
> > model		: 19
> > model name	: AMD A10-6700 APU with Radeon(tm) HD Graphics   
> > stepping	: 1
> > microcode	: 0x6001119
> > cpu MHz		: 1800.000
> > cache size	: 2048 KB
> > physical id	: 0
> > siblings	: 4
> > core id		: 2
> > cpu cores	: 2
> > apicid		: 18
> > initial apicid	: 2
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 13
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca
> > cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
> > aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes
> > xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
> > misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce
nodeid_msr
> > tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock
> > nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
> > pfthreshold bmi1
> > bogomips	: 7386.32
> > TLB size	: 1536 4K pages
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 48 bits physical, 48 bits virtual
> > power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro
> > 
> > processor	: 3
> > vendor_id	: AuthenticAMD
> > cpu family	: 21
> > model		: 19
> > model name	: AMD A10-6700 APU with Radeon(tm) HD Graphics   
> > stepping	: 1
> > microcode	: 0x6001119
> > cpu MHz		: 1800.000
> > cache size	: 2048 KB
> > physical id	: 0
> > siblings	: 4
> > core id		: 3
> > cpu cores	: 2
> > apicid		: 19
> > initial apicid	: 3
> > fpu		: yes
> > fpu_exception	: yes
> > cpuid level	: 13
> > wp		: yes
> > flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
pge mca
> > cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
> > pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc extd_apicid
> > aperfmperf pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 popcnt aes
> > xsave avx f16c lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a
> > misalignsse 3dnowprefetch osvw ibs xop skinit wdt lwp fma4 tce
nodeid_msr
> > tbm topoext perfctr_core perfctr_nb arat cpb hw_pstate npt lbrv svm_lock
> > nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter
> > pfthreshold bmi1
> > bogomips	: 7386.32
> > TLB size	: 1536 4K pages
> > clflush size	: 64
> > cache_alignment	: 64
> > address sizes	: 48 bits physical, 48 bits virtual
> > power management: ts ttp tm 100mhzsteps hwpstate cpb eff_freq_ro
> > 
> > 
> > [7.3.] Module information (from /proc/modules): 
> > cat /proc/modules 
> > 
> > btrfs 920292 0 - Live 0xffffffffa06f7000
> > raid6_pq 97812 1 btrfs, Live 0xffffffffa06de000
> > xor 21411 1 btrfs, Live 0xffffffffa0650000
> > ufs 75385 0 - Live 0xffffffffa06ad000
> > qnx4 13394 0 - Live 0xffffffffa0434000
> > hfsplus 107832 0 - Live 0xffffffffa0691000
> > hfs 54819 0 - Live 0xffffffffa0641000
> > minix 36454 0 - Live 0xffffffffa0443000
> > ntfs 97736 0 - Live 0xffffffffa0628000
> > msdos 17332 0 - Live 0xffffffffa043d000
> > jfs 186915 0 - Live 0xffffffffa0662000
> > xfs 930289 0 - Live 0xffffffffa0543000
> > libcrc32c 12644 1 xfs, Live 0xffffffffa021e000
> > rfcomm 75078 0 - Live 0xffffffffa0420000
> > bnep 19884 2 - Live 0xffffffffa0286000
> > bluetooth 461775 10 rfcomm,bnep, Live 0xffffffffa04d1000
> > 6lowpan_iphc 18968 1 bluetooth, Live 0xffffffffa041a000
> > nls_iso8859_1 12713 1 - Live 0xffffffffa01e2000
> > uas 27672 0 - Live 0xffffffffa04c9000
> > kvm_amd 60778 0 - Live 0xffffffffa06ce000
> > kvm 463855 1 kvm_amd, Live 0xffffffffa0456000
> > radeon 1606394 3 - Live 0xffffffffa0290000
> > crct10dif_pclmul 14268 0 - Live 0xffffffffa01c2000
> > joydev 17587 0 - Live 0xffffffffa020c000
> > crc32_pclmul 13180 0 - Live 0xffffffffa0223000
> > ghash_clmulni_intel 13230 0 - Live 0xffffffffa01d6000
> > aesni_intel 152648 0 - Live 0xffffffffa025f000
> > snd_hda_codec_realtek 72575 1 - Live 0xffffffffa024c000
> > aes_x86_64 17131 1 aesni_intel, Live 0xffffffffa019e000
> > snd_hda_codec_generic 70087 1 snd_hda_codec_realtek, Live
0xffffffffa0239000
> > snd_hda_codec_hdmi 48290 1 - Live 0xffffffffa022c000
> > snd_hda_intel 30608 5 - Live 0xffffffffa0215000
> > lrw 13323 1 aesni_intel, Live 0xffffffffa0199000
> > snd_hda_controller 35518 1 snd_hda_intel, Live 0xffffffffa01cc000
> > gf128mul 14951 1 lrw, Live 0xffffffffa01c7000
> > glue_helper 14095 1 aesni_intel, Live 0xffffffffa0194000
> > snd_hda_codec 144671 5
> >
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel
> > ,snd_hda_controller, Live 0xffffffffa01e7000
> > ablk_helper 13597 1 aesni_intel, Live 0xffffffffa01dd000
> > cryptd 20531 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
> > 0xffffffffa018d000
> > snd_hwdep 13613 1 snd_hda_codec, Live 0xffffffffa00cb000
> > snd_pcm 113863 4
> > snd_hda_codec_hdmi,snd_hda_intel,snd_hda_controller,snd_hda_codec, Live
> > 0xffffffffa01a5000
> > snd_seq_midi 13564 0 - Live 0xffffffffa00f4000
> > ttm 90341 1 radeon, Live 0xffffffffa0175000
> > snd_seq_midi_event 14899 1 snd_seq_midi, Live 0xffffffffa00c6000
> > drm_kms_helper 59729 1 radeon, Live 0xffffffffa0147000
> > snd_rawmidi 30865 1 snd_seq_midi, Live 0xffffffffa0159000
> > snd_seq 67636 2 snd_seq_midi,snd_seq_midi_event, Live 0xffffffffa0163000
> > drm 310655 6 radeon,ttm,drm_kms_helper, Live 0xffffffffa00fa000
> > psmouse 113095 0 - Live 0xffffffffa00d3000
> > snd_seq_device 14497 3 snd_seq_midi,snd_rawmidi,snd_seq, Live
> > 0xffffffffa00c1000
> > serio_raw 13483 0 - Live 0xffffffffa009f000
> > snd_timer 30118 2 snd_pcm,snd_seq, Live 0xffffffffa00b8000
> > i2c_algo_bit 13564 1 radeon, Live 0xffffffffa009a000
> > snd 74235 21
> >
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_codec_hdmi,snd_hda_intel
> >
,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_time
> > r, Live 0xffffffffa00a4000
> > parport_pc 32906 0 - Live 0xffffffffa0088000
> > i2c_piix4 22310 0 - Live 0xffffffffa0093000
> > soundcore 12680 2 snd_hda_codec,snd, Live 0xffffffffa007d000
> > ppdev 17711 0 - Live 0xffffffffa0059000
> > lp 17799 0 - Live 0xffffffffa0082000
> > mac_hid 13275 0 - Live 0xffffffffa0028000
> > k10temp 13191 0 - Live 0xffffffffa0038000
> > parport 42481 3 parport_pc,ppdev,lp, Live 0xffffffffa006e000
> > hid_generic 12559 0 - Live 0xffffffffa0010000
> > usbhid 53121 0 - Live 0xffffffffa0060000
> > hid 106436 2 hid_generic,usbhid, Live 0xffffffffa003e000
> > ahci 30167 3 - Live 0xffffffffa002f000
> > r8169 73316 0 - Live 0xffffffffa0015000
> > libahci 32191 1 ahci, Live 0xffffffffa0007000
> > mii 13981 1 r8169, Live 0xffffffffa0000000
> > 
> > [7.4.] Loaded driver and hardware information (/proc/ioports,
/proc/iomem) 
> > cat /proc/ioports 
> > 0000-03af : PCI Bus 0000:00
> >   0000-001f : dma1
> >   0020-0021 : pic1
> >   0040-0043 : timer0
> >   0050-0053 : timer1
> >   0060-0060 : keyboard
> >   0064-0064 : keyboard
> >   0070-0071 : rtc0
> >   0080-008f : dma page reg
> >   00a0-00a1 : pic2
> >   00c0-00df : dma2
> >   00f0-00ff : fpu
> > 03b0-03df : PCI Bus 0000:00
> > 03e0-0cf7 : PCI Bus 0000:00
> >   040b-040b : pnp 00:03
> >   04d0-04d1 : pnp 00:03
> >     04d0-04d1 : pnp 00:09
> >   04d6-04d6 : pnp 00:03
> >   0800-0803 : ACPI PM1a_EVT_BLK
> >   0804-0805 : ACPI PM1a_CNT_BLK
> >   0808-080b : ACPI PM_TMR
> >   0810-0815 : ACPI CPU throttle
> >   0820-0827 : ACPI GPE0_BLK
> >   0900-090f : pnp 00:03
> >   0910-091f : pnp 00:03
> >   0a00-0a0f : pnp 00:04
> >   0a10-0a1f : pnp 00:04
> >   0b00-0b07 : piix4_smbus
> >   0b20-0b3f : pnp 00:03
> >     0b20-0b27 : piix4_smbus
> >   0c00-0c01 : pnp 00:03
> >   0c14-0c14 : pnp 00:03
> >   0c50-0c51 : pnp 00:03
> >   0c52-0c52 : pnp 00:03
> >   0c6c-0c6c : pnp 00:03
> >   0c6f-0c6f : pnp 00:03
> >   0cd0-0cd1 : pnp 00:03
> >   0cd2-0cd3 : pnp 00:03
> >   0cd4-0cd5 : pnp 00:03
> >   0cd6-0cd7 : pnp 00:03
> >   0cd8-0cdf : pnp 00:03
> > 0cf8-0cff : PCI conf1
> > 0d00-ffff : PCI Bus 0000:00
> >   d000-dfff : PCI Bus 0000:02
> >     d000-d0ff : 0000:02:00.0
> >       d000-d0ff : r8169
> >   e000-efff : PCI Bus 0000:01
> >     e000-e0ff : 0000:01:00.0
> >   f000-f00f : 0000:00:11.0
> >     f000-f00f : ahci
> >   f010-f013 : 0000:00:11.0
> >     f010-f013 : ahci
> >   f020-f027 : 0000:00:11.0
> >     f020-f027 : ahci
> >   f030-f033 : 0000:00:11.0
> >     f030-f033 : ahci
> >   f040-f047 : 0000:00:11.0
> >     f040-f047 : ahci
> >   fe00-fefe : pnp 00:03
> > 
> > --
> > 
> > cat /proc/iomem 
> > 00000000-00000fff : reserved
> > 00001000-0009ffff : System RAM
> > 000a0000-000bffff : PCI Bus 0000:00
> > 000c0000-000dffff : PCI Bus 0000:00
> > 000f0000-000fffff : System ROM
> > 00100000-8e277fff : System RAM
> >   01000000-01789058 : Kernel code
> >   01789059-01d265bf : Kernel data
> >   01e84000-01febfff : Kernel bss
> > 8e278000-8e556fff : reserved
> > 8e557000-8e572fff : ACPI Tables
> > 8e573000-8e8d4fff : ACPI Non-volatile Storage
> > 8e8d5000-8ee04fff : reserved
> > 8ee05000-8ee3dfff : reserved
> > 8ee3e000-8ee3efff : System RAM
> > 8ee3f000-8f044fff : ACPI Non-volatile Storage
> > 8f045000-8f481fff : System RAM
> > 8f482000-8f7f2fff : reserved
> > 8f7f3000-8f7fffff : System RAM
> > 8f800000-8fffffff : RAM buffer
> > 90000000-bfffffff : pnp 00:01
> > c0000000-ffffffff : PCI Bus 0000:00
> >   c0000000-cfffffff : PCI Bus 0000:01
> >     c0000000-cfffffff : 0000:01:00.0
> >   d0000000-d00fffff : PCI Bus 0000:02
> >     d0000000-d0003fff : 0000:02:00.0
> >       d0000000-d0003fff : r8169
> >     d0004000-d0004fff : 0000:02:00.0
> >       d0004000-d0004fff : r8169
> >   e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
> >     e0000000-efffffff : pnp 00:00
> >   fea00000-feafffff : PCI Bus 0000:01
> >     fea00000-fea3ffff : 0000:01:00.0
> >     fea40000-fea5ffff : 0000:01:00.0
> >     fea60000-fea63fff : 0000:01:00.1
> >       fea60000-fea63fff : ICH HD audio
> >   feb00000-feb03fff : 0000:00:14.2
> >     feb00000-feb03fff : ICH HD audio
> >   feb04000-feb05fff : 0000:00:10.1
> >     feb04000-feb05fff : xhci_hcd
> >   feb06000-feb07fff : 0000:00:10.0
> >     feb06000-feb07fff : xhci_hcd
> >   feb08000-feb08fff : 0000:00:14.5
> >     feb08000-feb08fff : ohci_hcd
> >   feb09000-feb090ff : 0000:00:13.2
> >     feb09000-feb090ff : ehci_hcd
> >   feb0a000-feb0afff : 0000:00:13.0
> >     feb0a000-feb0afff : ohci_hcd
> >   feb0b000-feb0b0ff : 0000:00:12.2
> >     feb0b000-feb0b0ff : ehci_hcd
> >   feb0c000-feb0cfff : 0000:00:12.0
> >     feb0c000-feb0cfff : ohci_hcd
> >   feb0d000-feb0d7ff : 0000:00:11.0
> >     feb0d000-feb0d7ff : ahci
> >   feb80000-febfffff : amd_iommu
> >   fec00000-fec00fff : reserved
> >     fec00000-fec00fff : pnp 00:03
> >   fec10000-fec10fff : reserved
> >     fec10000-fec10fff : pnp 00:03
> >   fed00000-fed00fff : reserved
> >     fed00000-fed00fff : pnp 00:03
> >       fed00000-fed003ff : HPET 0
> >   fed61000-fed70fff : pnp 00:03
> >   fed80000-fed8ffff : reserved
> >     fed80000-fed8ffff : pnp 00:03
> >   fee00000-fee00fff : Local APIC
> >     fee00000-fee00fff : pnp 00:03
> >   ff000000-ffffffff : reserved
> >     ff000000-ffffffff : pnp 00:03
> > 100001000-43effffff : System RAM
> > 43f000000-43fffffff : RAM buffer
> > 
> > 
> > [7.5.] PCI information ('lspci -vvv' as root) 
> > sudo lspci -vvv 
> > 
> > 00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Root Complex
> > 	Subsystem: Advanced Micro Devices, Inc. [AMD] Family 15h (Models
> > 10h-1fh) Processor Root Complex
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0
> > 
> > 00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Family 15h (Models
> > 10h-1fh) I/O Memory Management Unit
> > 	Subsystem: Advanced Micro Devices, Inc. [AMD] Family 15h (Models
> > 10h-1fh) I/O Memory Management Unit
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Interrupt: pin A routed to IRQ 16
> > 	Capabilities: [40] Secure device <?>
> > 	Capabilities: [54] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0f00c  Data: 4141
> > 	Capabilities: [64] HyperTransport: MSI Mapping Enable+ Fixed+
> > 
> > 00:02.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Root Port (prog-if 00 [Normal decode])
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> > 	I/O behind bridge: 0000e000-0000efff
> > 	Memory behind bridge: fea00000-feafffff
> > 	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
> > 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort+ <SERR- <PERR-
> > 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> > 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
> > 		DevCap:	MaxPayload 256 bytes, PhantFunc 0
> > 			ExtTag+ RBE+
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 256 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > TransPend-
> > 		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit
> > Latency L0s <64ns, L1 <1us
> > 			ClockPM- Surprise- LLActRep+ BwNot+
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> > DLActive+ BWMgmt+ ABWMgmt-
> > 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
> > Surprise-
> > 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> > 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
> > HPIrq- LinkChg-
> > 			Control: AttnInd Unknown, PwrInd Unknown, Power-
> > Interlock-
> > 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> > Interlock-
> > 			Changed: MRL- PresDet- LinkState-
> > 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
> > CRSVisible-
> > 		RootCap: CRSVisible-
> > 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> > 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
> > OBFF Not Supported ARIFwd-
> > 		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-,
> > LTR-, OBFF Disabled ARIFwd-
> > 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> > SpeedDis-
> > 			 Transmit Margin: Normal Operating Range,
> > EnterModifiedCompliance- ComplianceSOS-
> > 			 Compliance De-emphasis: -6dB
> > 		LnkSta2: Current De-emphasis Level: -6dB,
> > EqualizationComplete-, EqualizationPhase1-
> > 			 EqualizationPhase2-, EqualizationPhase3-,
> > LinkEqualizationRequest-
> > 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0f00c  Data: 4151
> > 	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD]
> > Device 1234
> > 	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
> > 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> > Len=010 <?>
> > 	Kernel driver in use: pcieport
> > 
> > 00:07.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Root Port (prog-if 00 [Normal decode])
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> > 	I/O behind bridge: 0000d000-0000dfff
> > 	Memory behind bridge: fff00000-000fffff
> > 	Prefetchable memory behind bridge: 00000000d0000000-00000000d00fffff
> > 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort+ <SERR- <PERR-
> > 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> > 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [58] Express (v2) Root Port (Slot+), MSI 00
> > 		DevCap:	MaxPayload 256 bytes, PhantFunc 0
> > 			ExtTag+ RBE+
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > TransPend-
> > 		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Exit
> > Latency L0s <64ns, L1 <1us
> > 			ClockPM- Surprise- LLActRep+ BwNot+
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive+ BWMgmt+ ABWMgmt-
> > 		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
> > Surprise-
> > 			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
> > 		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
> > HPIrq- LinkChg-
> > 			Control: AttnInd Unknown, PwrInd Unknown, Power-
> > Interlock-
> > 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> > Interlock-
> > 			Changed: MRL- PresDet- LinkState-
> > 		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+
> > CRSVisible-
> > 		RootCap: CRSVisible-
> > 		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> > 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
> > OBFF Not Supported ARIFwd-
> > 		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis-,
> > LTR-, OBFF Disabled ARIFwd-
> > 		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance-
> > SpeedDis-
> > 			 Transmit Margin: Normal Operating Range,
> > EnterModifiedCompliance- ComplianceSOS-
> > 			 Compliance De-emphasis: -6dB
> > 		LnkSta2: Current De-emphasis Level: -3.5dB,
> > EqualizationComplete-, EqualizationPhase1-
> > 			 EqualizationPhase2-, EqualizationPhase3-,
> > LinkEqualizationRequest-
> > 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0f00c  Data: 4161
> > 	Capabilities: [b0] Subsystem: Advanced Micro Devices, Inc. [AMD]
> > Device 1234
> > 	Capabilities: [b8] HyperTransport: MSI Mapping Enable+ Fixed+
> > 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> > Len=010 <?>
> > 	Kernel driver in use: pcieport
> > 
> > 00:10.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
> > Controller (rev 09) (prog-if 30 [XHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 11
> > 	Region 0: Memory at feb06000 (64-bit, non-prefetchable) [size=8K]
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
> > 		Address: 0000000000000000  Data: 0000
> > 	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
> > 		Vector table: BAR=0 offset=00001000
> > 		PBA: BAR=0 offset=00001080
> > 	Capabilities: [a0] Express (v2) Root Complex Integrated Endpoint,
> > MSI 00
> > 		DevCap:	MaxPayload 128 bytes, PhantFunc 0
> > 			ExtTag- RBE+
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> > TransPend-
> > 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+,
> > LTR+, OBFF Not Supported
> > 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> > 	Capabilities: [100 v1] Latency Tolerance Reporting
> > 		Max snoop latency: 0ns
> > 		Max no snoop latency: 0ns
> > 	Kernel driver in use: xhci_hcd
> > 
> > 00:10.1 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB XHCI
> > Controller (rev 09) (prog-if 30 [XHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin B routed to IRQ 10
> > 	Region 0: Memory at feb04000 (64-bit, non-prefetchable) [size=8K]
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [70] MSI: Enable- Count=1/8 Maskable- 64bit+
> > 		Address: 0000000000000000  Data: 0000
> > 	Capabilities: [90] MSI-X: Enable+ Count=8 Masked-
> > 		Vector table: BAR=0 offset=00001000
> > 		PBA: BAR=0 offset=00001080
> > 	Capabilities: [a0] Express (v2) Root Complex Integrated Endpoint,
> > MSI 00
> > 		DevCap:	MaxPayload 128 bytes, PhantFunc 0
> > 			ExtTag- RBE+
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> > TransPend-
> > 		DevCap2: Completion Timeout: Not Supported, TimeoutDis+,
> > LTR+, OBFF Not Supported
> > 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> > 	Kernel driver in use: xhci_hcd
> > 
> > 00:11.0 SATA controller: Advanced Micro Devices, Inc. [AMD] FCH SATA
> > Controller [AHCI mode] (rev 40) (prog-if 01 [AHCI 1.0])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32
> > 	Interrupt: pin A routed to IRQ 30
> > 	Region 0: I/O ports at f040 [size=8]
> > 	Region 1: I/O ports at f030 [size=4]
> > 	Region 2: I/O ports at f020 [size=8]
> > 	Region 3: I/O ports at f010 [size=4]
> > 	Region 4: I/O ports at f000 [size=16]
> > 	Region 5: Memory at feb0d000 (32-bit, non-prefetchable) [size=2K]
> > 	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable- 64bit+
> > 		Address: 00000000fee0300c  Data: 4162
> > 	Capabilities: [70] SATA HBA v1.0 InCfgSpace
> > 	Kernel driver in use: ahci
> > 
> > 00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
> > Controller (rev 11) (prog-if 10 [OHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 11
> > 	Region 0: Memory at feb0c000 (32-bit, non-prefetchable) [size=4K]
> > 	Kernel driver in use: ohci-pci
> > 
> > 00:12.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
> > Controller (rev 11) (prog-if 20 [EHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin B routed to IRQ 10
> > 	Region 0: Memory at feb0b000 (32-bit, non-prefetchable) [size=256]
> > 	Capabilities: [c0] Power Management version 2
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 		Bridge: PM- B3+
> > 	Capabilities: [e4] Debug port: BAR=1 offset=00e0
> > 	Kernel driver in use: ehci-pci
> > 
> > 00:13.0 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
> > Controller (rev 11) (prog-if 10 [OHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 11
> > 	Region 0: Memory at feb0a000 (32-bit, non-prefetchable) [size=4K]
> > 	Kernel driver in use: ohci-pci
> > 
> > 00:13.2 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB EHCI
> > Controller (rev 11) (prog-if 20 [EHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin B routed to IRQ 10
> > 	Region 0: Memory at feb09000 (32-bit, non-prefetchable) [size=256]
> > 	Capabilities: [c0] Power Management version 2
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 		Bridge: PM- B3+
> > 	Capabilities: [e4] Debug port: BAR=1 offset=00e0
> > 	Kernel driver in use: ehci-pci
> > 
> > 00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller
(rev
> > 16)
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Kernel driver in use: piix4_smbus
> > 
> > 00:14.2 Audio device: Advanced Micro Devices, Inc. [AMD] FCH Azalia
> > Controller (rev 01)
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 11
> > 	Region 0: Memory at feb00000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: [50] Power Management version 2
> > 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Kernel driver in use: snd_hda_intel
> > 
> > 00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge
(rev
> > 11)
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0
> > 
> > 00:14.4 PCI bridge: Advanced Micro Devices, Inc. [AMD] FCH PCI Bridge
(rev
> > 40) (prog-if 01 [Subtractive decode])
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 64
> > 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
> > 	I/O behind bridge: 0000f000-00000fff
> > 	Memory behind bridge: fff00000-000fffff
> > 	Prefetchable memory behind bridge: fff00000-000fffff
> > 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort+ <SERR- <PERR-
> > 	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
> > 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > 
> > 00:14.5 USB controller: Advanced Micro Devices, Inc. [AMD] FCH USB OHCI
> > Controller (rev 11) (prog-if 10 [OHCI])
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 32, Cache Line Size: 64 bytes
> > 	Interrupt: pin C routed to IRQ 11
> > 	Region 0: Memory at feb08000 (32-bit, non-prefetchable) [size=4K]
> > 	Kernel driver in use: ohci-pci
> > 
> > 00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 0
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 1
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 2
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 3
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Capabilities: [f0] Secure device <?>
> > 	Kernel driver in use: k10temp
> > 
> > 00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 4
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Family 15h
(Models
> > 10h-1fh) Processor Function 5
> > 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx-
> > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 
> > 01:00.0 VGA compatible controller: Advanced Micro Devices, Inc.
[AMD/ATI]
> > Oland [Radeon HD 8570 / R7 240 OEM] (prog-if 00 [VGA controller])
> > 	Subsystem: Elitegroup Computer Systems Device 0031
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 32
> > 	Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
> > 	Region 2: Memory at fea00000 (64-bit, non-prefetchable) [size=256K]
> > 	Region 4: I/O ports at e000 [size=256]
> > 	Expansion ROM at fea40000 [disabled] [size=128K]
> > 	Capabilities: [48] Vendor Specific Information: Len=08 <?>
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > PME(D0-,D1+,D2+,D3hot+,D3cold-)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
> > 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us,
> > L1 unlimited
> > 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 256 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
> > TransPend-
> > 		LnkCap:	Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Exit
> > Latency L0s <64ns, L1 <1us
> > 			ClockPM- Surprise- LLActRep- BwNot-
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> > DLActive- BWMgmt- ABWMgmt-
> > 		DevCap2: Completion Timeout: Not Supported, TimeoutDis-,
> > LTR-, OBFF Not Supported
> > 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> > 		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance-
> > SpeedDis-
> > 			 Transmit Margin: Normal Operating Range,
> > EnterModifiedCompliance- ComplianceSOS-
> > 			 Compliance De-emphasis: -6dB
> > 		LnkSta2: Current De-emphasis Level: -6dB,
> > EqualizationComplete-, EqualizationPhase1-
> > 			 EqualizationPhase2-, EqualizationPhase3-,
> > LinkEqualizationRequest-
> > 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0f00c  Data: 4182
> > 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> > Len=010 <?>
> > 	Capabilities: [150 v2] Advanced Error Reporting
> > 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> > 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> > 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> > ChkEn-
> > 	Capabilities: [270 v1] #19
> > 	Kernel driver in use: radeon
> > 
> > 01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cape
> > Verde/Pitcairn HDMI Audio [Radeon HD 7700/7800 Series]
> > 	Subsystem: Elitegroup Computer Systems Device aab0
> > 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin B routed to IRQ 31
> > 	Region 0: Memory at fea60000 (64-bit, non-prefetchable) [size=16K]
> > 	Capabilities: [48] Vendor Specific Information: Len=08 <?>
> > 	Capabilities: [50] Power Management version 3
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > 		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
> > 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us,
> > L1 unlimited
> > 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > 			MaxPayload 256 bytes, MaxReadReq 512 bytes
> > 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr-
> > TransPend-
> > 		LnkCap:	Port #0, Speed 8GT/s, Width x8, ASPM L0s L1, Exit
> > Latency L0s <64ns, L1 <1us
> > 			ClockPM- Surprise- LLActRep- BwNot-
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 5GT/s, Width x8, TrErr- Train- SlotClk+
> > DLActive- BWMgmt- ABWMgmt-
> > 		DevCap2: Completion Timeout: Not Supported, TimeoutDis-,
> > LTR-, OBFF Not Supported
> > 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> > 		LnkSta2: Current De-emphasis Level: -6dB,
> > EqualizationComplete-, EqualizationPhase1-
> > 			 EqualizationPhase2-, EqualizationPhase3-,
> > LinkEqualizationRequest-
> > 	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0f00c  Data: 4172
> > 	Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1
> > Len=010 <?>
> > 	Capabilities: [150 v2] Advanced Error Reporting
> > 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> > 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> > 		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> > ChkEn-
> > 	Kernel driver in use: snd_hda_intel
> > 
> > 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> > 	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7857
> > 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > Stepping- SERR- FastB2B- DisINTx+
> > 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > 	Latency: 0, Cache Line Size: 64 bytes
> > 	Interrupt: pin A routed to IRQ 29
> > 	Region 0: I/O ports at d000 [size=256]
> > 	Region 2: Memory at d0004000 (64-bit, prefetchable) [size=4K]
> > 	Region 4: Memory at d0000000 (64-bit, prefetchable) [size=16K]
> > 	Capabilities: [40] Power Management version 3
> > 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
> > 	Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
> > 		Address: 00000000fee0100c  Data: 4152
> > 	Capabilities: [70] Express (v2) Endpoint, MSI 01
> > 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> > <512ns, L1 <64us
> > 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> > 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> > 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> > 			MaxPayload 128 bytes, MaxReadReq 4096 bytes
> > 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+
> > TransPend-
> > 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit
> > Latency L0s unlimited, L1 <64us
> > 			ClockPM+ Surprise- LLActRep- BwNot-
> > 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- CommClk+
> > 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive- BWMgmt- ABWMgmt-
> > 		DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-,
> > OBFF Not Supported
> > 		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-,
> > LTR-, OBFF Disabled
> > 		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
> > SpeedDis-
> > 			 Transmit Margin: Normal Operating Range,
> > EnterModifiedCompliance- ComplianceSOS-
> > 			 Compliance De-emphasis: -6dB
> > 		LnkSta2: Current De-emphasis Level: -6dB,
> > EqualizationComplete-, EqualizationPhase1-
> > 			 EqualizationPhase2-, EqualizationPhase3-,
> > LinkEqualizationRequest-
> > 	Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
> > 		Vector table: BAR=4 offset=00000000
> > 		PBA: BAR=4 offset=00000800
> > 	Capabilities: [d0] Vital Product Data
> > 		No end tag found
> > 	Capabilities: [100 v1] Advanced Error Reporting
> > 		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
> > 		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
> > 		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
> > 		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr+
> > 		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout-
> > NonFatalErr-
> > 		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+
> > ChkEn-
> > 	Capabilities: [140 v1] Virtual Channel
> > 		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
> > 		Arb:	Fixed- WRR32- WRR64- WRR128-
> > 		Ctrl:	ArbSelect=Fixed
> > 		Status:	InProgress-
> > 		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
> > 			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128-
> > WRR256-
> > 			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
> > 			Status:	NegoPending- InProgress-
> > 	Capabilities: [160 v1] Device Serial Number 3e-00-00-00-68-4c-e0-00
> > 	Kernel driver in use: r8169
> > 
> > [7.6.] SCSI information (from /proc/scsi/scsi) 
> > cat /proc/scsi/scsi 
> > 
> > Attached devices:
> > Host: scsi0 Channel: 00 Id: 00 Lun: 00
> >   Vendor: ATA      Model: ST1000DM003-1CH1 Rev: CC47
> >   Type:   Direct-Access                    ANSI  SCSI revision: 05
> > Host: scsi1 Channel: 00 Id: 00 Lun: 00
> >   Vendor: TSSTcorp Model: CDDVDW SH-216DB  Rev: MD00
> >   Type:   CD-ROM                           ANSI  SCSI revision: 05
> > Host: scsi2 Channel: 00 Id: 00 Lun: 00
> >   Vendor: ATA      Model: TOSHIBA DT01ABA1 Rev: MU2O
> >   Type:   Direct-Access                    ANSI  SCSI revision: 05
> > Host: scsi6 Channel: 00 Id: 00 Lun: 00
> >   Vendor: Seagate  Model: Expansion Desk   Rev: 070B
> >   Type:   Direct-Access                    ANSI  SCSI revision: 06
> > Host: scsi7 Channel: 00 Id: 00 Lun: 00
> >   Vendor: Seagate  Model: Expansion Desk   Rev: 0711
> >   Type:   Direct-Access                    ANSI  SCSI revision: 06
> > Host: scsi8 Channel: 00 Id: 00 Lun: 00
> >   Vendor: Seagate  Model: Expansion Desk   Rev: 0711
> >   Type:   Direct-Access                    ANSI  SCSI revision: 06
> > 
> > 
> > [7.7.] Other information that might be relevant to the problem (please
look
> > in /proc and include all information that you think to be relevant): 
> > ls /proc 
> > 
> > 1
> > 10
> > 1014
> > 1018
> > 1023
> > 1024
> > 1027
> > 1063
> > 1075
> > 1088
> > 1094
> > 11
> > 1108
> > 1119
> > 1157
> > 1172
> > 12
> > 1298
> > 13
> > 1345
> > 1394
> > 14
> > 1411
> > 147
> > 148
> > 14868
> > 14869
> > 14875
> > 14880
> > 14882
> > 14884
> > 149
> > 14930
> > 14933
> > 15
> > 150
> > 15009
> > 151
> > 152
> > 153
> > 154
> > 155
> > 156
> > 157
> > 158
> > 16
> > 17
> > 1716
> > 1719
> > 175
> > 176
> > 1788
> > 1792
> > 18
> > 1809
> > 1820
> > 183
> > 1834
> > 1838
> > 184
> > 1841
> > 1842
> > 1844
> > 185
> > 1850
> > 1851
> > 1856
> > 1860
> > 1862
> > 1867
> > 1870
> > 1895
> > 1896
> > 19
> > 1917
> > 1921
> > 1944
> > 1948
> > 1949
> > 1951
> > 1958
> > 1961
> > 1966
> > 1967
> > 1987
> > 2
> > 20
> > 2010
> > 2016
> > 2018
> > 2039
> > 2099
> > 21
> > 2102
> > 2106
> > 2109
> > 2121
> > 2127
> > 2130
> > 2134
> > 2149
> > 21502
> > 21503
> > 21505
> > 21511
> > 21512
> > 21513
> > 21514
> > 21515
> > 21516
> > 2153
> > 21535
> > 2158
> > 2165
> > 2184
> > 22
> > 2216
> > 2229
> > 2231
> > 2239
> > 2255
> > 2257
> > 2267
> > 2285
> > 23
> > 2318
> > 23181
> > 23217
> > 23218
> > 23468
> > 2349
> > 2357
> > 2358
> > 24
> > 2405
> > 2406
> > 2415
> > 2428
> > 2429
> > 2434
> > 2454
> > 2479
> > 25
> > 2543
> > 26
> > 2605
> > 27
> > 2718
> > 2765
> > 2766
> > 2767
> > 28
> > 29
> > 3
> > 30
> > 31
> > 33
> > 34
> > 35
> > 36
> > 37
> > 371
> > 38
> > 3847
> > 39
> > 3916
> > 40
> > 41
> > 410
> > 416
> > 42
> > 43
> > 44
> > 45
> > 4589
> > 4591
> > 46
> > 47
> > 48
> > 49
> > 5
> > 51
> > 52
> > 531
> > 534
> > 54
> > 55
> > 56
> > 569
> > 570
> > 571
> > 572
> > 573
> > 574
> > 62
> > 67
> > 680
> > 681
> > 7
> > 716
> > 72
> > 73
> > 74
> > 740
> > 759
> > 76
> > 778
> > 779
> > 784
> > 8
> > 806
> > 809
> > 814
> > 821
> > 9
> > 928
> > 95
> > 96
> > 972
> > acpi
> > asound
> > buddyinfo
> > bus
> > cgroups
> > cmdline
> > consoles
> > cpuinfo
> > crypto
> > devices
> > diskstats
> > dma
> > driver
> > execdomains
> > fb
> > filesystems
> > fs
> > interrupts
> > iomem
> > ioports
> > ipmi
> > irq
> > kallsyms
> > kcore
> > key-users
> > kmsg
> > kpagecount
> > kpageflags
> > latency_stats
> > loadavg
> > locks
> > mdstat
> > meminfo
> > misc
> > modules
> > mounts
> > mtrr
> > net
> > pagetypeinfo
> > partitions
> > sched_debug
> > schedstat
> > scsi
> > self
> > slabinfo
> > softirqs
> > stat
> > swaps
> > sys
> > sysrq-trigger
> > sysvipc
> > timer_list
> > timer_stats
> > tty
> > uptime
> > version
> > vmallocinfo
> > vmstat
> > zoneinfo
> > 
> > 
> > 
> > [X.] Other notes, patches, fixes, workarounds: 
> > Link to your Launchpad bug report:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1280668
> > 
> > If you need anything else let me know.
> > 
> > Thanks for your help!
> > 
> > Regards,
> > Kelvin Gonzalez Vivas
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --


