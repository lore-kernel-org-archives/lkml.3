Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab3JYMN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:13:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34336 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3JYMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:13:54 -0400
Date: Fri, 25 Oct 2013 13:13:45 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12-rc6 nouveau oops
Message-ID: <20131025121345.GA2815@kernel.dk>
References: <20131024132734.GB2634@kernel.dk>
 <CAPM=9tzThUmwO1Pw6PvtUvM7ywDzWGSF23wCEVS=wMa3PVNEPw@mail.gmail.com>
 <CAPM=9ty+xi=1DFWWy8zzS870TTe7Hny948LoPS_pmDAzMGrqtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9ty+xi=1DFWWy8zzS870TTe7Hny948LoPS_pmDAzMGrqtQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25 2013, Dave Airlie wrote:
> On Fri, Oct 25, 2013 at 8:59 AM, Dave Airlie <airlied@gmail.com> wrote:
> >> Booting 3.12-rc6 on my macbook quickly freezes after logging in to X. I
> >> was able to capture this oops. It's 100% consistent. 3.11 works
> >> perfectly fine, as did previous kernels.
> >
> > Can you boot with nouveau.runpm=0 and see if it boots and survives
> > suspend/resume.

It does!

> Oh also a complete dmesg so we can see the DCB table.

Below.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.12.0-rc6+ (axboe@lenny) (gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-2ubuntu4) ) #68 SMP PREEMPT Fri Oct 25 13:07:23 BST 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.12 root=/dev/sda6 video=efifb i915.modeset=1 i915.i915_enable_rc6=3 i915.lvds_channel_mode=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 drm.vblankoffdelay=1 i915.i915_enable_ppgtt=0 nouveau.runpm=0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000a0000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x000000008ad13fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad14000-0x000000008ad52fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008ad53000-0x000000008ad68fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ad69000-0x000000008ad8efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008ad8f000-0x000000008ae3afff] usable
[    0.000000] BIOS-e820: [mem 0x000000008ae3b000-0x000000008ae8efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008ae8f000-0x000000008aecdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000008aece000-0x000000008aefefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008aeff000-0x000000008af91fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008af92000-0x000000008affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008afff000-0x000000008affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000008b000000-0x000000008f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e00f8000-0x00000000e00f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe70000-0x00000000ffe9ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000026f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v1.10 by Apple
[    0.000000] efi:  ACPI=0x8ad8e000  ACPI 2.0=0x8ad8e014  SMBIOS=0x8ad1b000 
[    0.000000] efi: mem00: type=7, attr=0x80000000000000f, range=[0x0000000000000000-0x000000000008e000) (0MB)
[    0.000000] efi: mem01: type=0, attr=0x80000000000000f, range=[0x000000000008e000-0x0000000000090000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0x80000000000000f, range=[0x0000000000090000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem03: type=2, attr=0xf, range=[0x0000000000100000-0x0000000001310000) (18MB)
[    0.000000] efi: mem04: type=7, attr=0xf, range=[0x0000000001310000-0x0000000020000000) (492MB)
[    0.000000] efi: mem05: type=0, attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
[    0.000000] efi: mem06: type=7, attr=0xf, range=[0x0000000020200000-0x0000000036006000) (350MB)
[    0.000000] efi: mem07: type=2, attr=0xf, range=[0x0000000036006000-0x0000000036ffb000) (15MB)
[    0.000000] efi: mem08: type=7, attr=0xf, range=[0x0000000036ffb000-0x0000000040004000) (144MB)
[    0.000000] efi: mem09: type=0, attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
[    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000040005000-0x00000000655bf000) (597MB)
[    0.000000] efi: mem11: type=2, attr=0xf, range=[0x00000000655bf000-0x000000008721a000) (540MB)
[    0.000000] efi: mem12: type=1, attr=0xf, range=[0x000000008721a000-0x00000000872d0000) (0MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x00000000872d0000-0x00000000872d1000) (0MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x00000000872d1000-0x0000000087383000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x0000000087383000-0x0000000087386000) (0MB)
[    0.000000] efi: mem16: type=2, attr=0xf, range=[0x0000000087386000-0x0000000087387000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x0000000087387000-0x0000000087389000) (0MB)
[    0.000000] efi: mem18: type=2, attr=0xf, range=[0x0000000087389000-0x00000000873d7000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x00000000873d7000-0x00000000873d9000) (0MB)
[    0.000000] efi: mem20: type=2, attr=0xf, range=[0x00000000873d9000-0x000000008740c000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x000000008740c000-0x0000000087d24000) (9MB)
[    0.000000] efi: mem22: type=2, attr=0xf, range=[0x0000000087d24000-0x0000000087d4b000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x0000000087d4b000-0x0000000087d7d000) (0MB)
[    0.000000] efi: mem24: type=1, attr=0xf, range=[0x0000000087d7d000-0x0000000087d9a000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x0000000087d9a000-0x0000000087d9f000) (0MB)
[    0.000000] efi: mem26: type=2, attr=0xf, range=[0x0000000087d9f000-0x0000000087da2000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x0000000087da2000-0x0000000087dae000) (0MB)
[    0.000000] efi: mem28: type=2, attr=0xf, range=[0x0000000087dae000-0x0000000087db4000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x0000000087db4000-0x0000000087dc5000) (0MB)
[    0.000000] efi: mem30: type=2, attr=0xf, range=[0x0000000087dc5000-0x0000000087dc8000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x0000000087dc8000-0x0000000087dc9000) (0MB)
[    0.000000] efi: mem32: type=2, attr=0xf, range=[0x0000000087dc9000-0x0000000087dcf000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x0000000087dcf000-0x0000000089546000) (23MB)
[    0.000000] efi: mem34: type=2, attr=0xf, range=[0x0000000089546000-0x0000000089547000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x0000000089547000-0x0000000089562000) (0MB)
[    0.000000] efi: mem36: type=3, attr=0xf, range=[0x0000000089562000-0x000000008956b000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x000000008956b000-0x0000000089580000) (0MB)
[    0.000000] efi: mem38: type=2, attr=0xf, range=[0x0000000089580000-0x0000000089581000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x0000000089581000-0x0000000089587000) (0MB)
[    0.000000] efi: mem40: type=3, attr=0xf, range=[0x0000000089587000-0x0000000089589000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x0000000089589000-0x0000000089590000) (0MB)
[    0.000000] efi: mem42: type=3, attr=0xf, range=[0x0000000089590000-0x0000000089598000) (0MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x0000000089598000-0x000000008959c000) (0MB)
[    0.000000] efi: mem44: type=3, attr=0xf, range=[0x000000008959c000-0x000000008959d000) (0MB)
[    0.000000] efi: mem45: type=4, attr=0xf, range=[0x000000008959d000-0x000000008959e000) (0MB)
[    0.000000] efi: mem46: type=2, attr=0xf, range=[0x000000008959e000-0x000000008959f000) (0MB)
[    0.000000] efi: mem47: type=4, attr=0xf, range=[0x000000008959f000-0x00000000895a2000) (0MB)
[    0.000000] efi: mem48: type=3, attr=0xf, range=[0x00000000895a2000-0x00000000895a7000) (0MB)
[    0.000000] efi: mem49: type=4, attr=0xf, range=[0x00000000895a7000-0x00000000895be000) (0MB)
[    0.000000] efi: mem50: type=3, attr=0xf, range=[0x00000000895be000-0x00000000895c2000) (0MB)
[    0.000000] efi: mem51: type=4, attr=0xf, range=[0x00000000895c2000-0x00000000895c6000) (0MB)
[    0.000000] efi: mem52: type=2, attr=0xf, range=[0x00000000895c6000-0x00000000895c7000) (0MB)
[    0.000000] efi: mem53: type=4, attr=0xf, range=[0x00000000895c7000-0x00000000895c8000) (0MB)
[    0.000000] efi: mem54: type=3, attr=0xf, range=[0x00000000895c8000-0x00000000895c9000) (0MB)
[    0.000000] efi: mem55: type=4, attr=0xf, range=[0x00000000895c9000-0x00000000895cb000) (0MB)
[    0.000000] efi: mem56: type=3, attr=0xf, range=[0x00000000895cb000-0x00000000895d5000) (0MB)
[    0.000000] efi: mem57: type=4, attr=0xf, range=[0x00000000895d5000-0x00000000895d6000) (0MB)
[    0.000000] efi: mem58: type=3, attr=0xf, range=[0x00000000895d6000-0x00000000895d7000) (0MB)
[    0.000000] efi: mem59: type=4, attr=0xf, range=[0x00000000895d7000-0x00000000895db000) (0MB)
[    0.000000] efi: mem60: type=3, attr=0xf, range=[0x00000000895db000-0x00000000895dd000) (0MB)
[    0.000000] efi: mem61: type=4, attr=0xf, range=[0x00000000895dd000-0x00000000895f7000) (0MB)
[    0.000000] efi: mem62: type=3, attr=0xf, range=[0x00000000895f7000-0x0000000089633000) (0MB)
[    0.000000] efi: mem63: type=4, attr=0xf, range=[0x0000000089633000-0x0000000089649000) (0MB)
[    0.000000] efi: mem64: type=3, attr=0xf, range=[0x0000000089649000-0x000000008964c000) (0MB)
[    0.000000] efi: mem65: type=2, attr=0xf, range=[0x000000008964c000-0x000000008964d000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x000000008964d000-0x0000000089684000) (0MB)
[    0.000000] efi: mem67: type=3, attr=0xf, range=[0x0000000089684000-0x0000000089692000) (0MB)
[    0.000000] efi: mem68: type=4, attr=0xf, range=[0x0000000089692000-0x0000000089696000) (0MB)
[    0.000000] efi: mem69: type=3, attr=0xf, range=[0x0000000089696000-0x00000000896aa000) (0MB)
[    0.000000] efi: mem70: type=4, attr=0xf, range=[0x00000000896aa000-0x00000000896af000) (0MB)
[    0.000000] efi: mem71: type=3, attr=0xf, range=[0x00000000896af000-0x00000000896b0000) (0MB)
[    0.000000] efi: mem72: type=4, attr=0xf, range=[0x00000000896b0000-0x00000000896b2000) (0MB)
[    0.000000] efi: mem73: type=2, attr=0xf, range=[0x00000000896b2000-0x00000000896b3000) (0MB)
[    0.000000] efi: mem74: type=4, attr=0xf, range=[0x00000000896b3000-0x00000000896b8000) (0MB)
[    0.000000] efi: mem75: type=3, attr=0xf, range=[0x00000000896b8000-0x00000000896ba000) (0MB)
[    0.000000] efi: mem76: type=4, attr=0xf, range=[0x00000000896ba000-0x00000000896be000) (0MB)
[    0.000000] efi: mem77: type=3, attr=0xf, range=[0x00000000896be000-0x00000000896d8000) (0MB)
[    0.000000] efi: mem78: type=4, attr=0xf, range=[0x00000000896d8000-0x00000000896da000) (0MB)
[    0.000000] efi: mem79: type=2, attr=0xf, range=[0x00000000896da000-0x00000000896db000) (0MB)
[    0.000000] efi: mem80: type=4, attr=0xf, range=[0x00000000896db000-0x00000000896dc000) (0MB)
[    0.000000] efi: mem81: type=3, attr=0xf, range=[0x00000000896dc000-0x00000000896dd000) (0MB)
[    0.000000] efi: mem82: type=4, attr=0xf, range=[0x00000000896dd000-0x00000000896de000) (0MB)
[    0.000000] efi: mem83: type=3, attr=0xf, range=[0x00000000896de000-0x00000000896df000) (0MB)
[    0.000000] efi: mem84: type=4, attr=0xf, range=[0x00000000896df000-0x00000000896e0000) (0MB)
[    0.000000] efi: mem85: type=2, attr=0xf, range=[0x00000000896e0000-0x00000000896e1000) (0MB)
[    0.000000] efi: mem86: type=4, attr=0xf, range=[0x00000000896e1000-0x00000000896e2000) (0MB)
[    0.000000] efi: mem87: type=3, attr=0xf, range=[0x00000000896e2000-0x00000000896e3000) (0MB)
[    0.000000] efi: mem88: type=4, attr=0xf, range=[0x00000000896e3000-0x00000000896e4000) (0MB)
[    0.000000] efi: mem89: type=3, attr=0xf, range=[0x00000000896e4000-0x00000000896e9000) (0MB)
[    0.000000] efi: mem90: type=4, attr=0xf, range=[0x00000000896e9000-0x00000000896ec000) (0MB)
[    0.000000] efi: mem91: type=3, attr=0xf, range=[0x00000000896ec000-0x00000000896ed000) (0MB)
[    0.000000] efi: mem92: type=2, attr=0xf, range=[0x00000000896ed000-0x00000000896ee000) (0MB)
[    0.000000] efi: mem93: type=4, attr=0xf, range=[0x00000000896ee000-0x00000000896ef000) (0MB)
[    0.000000] efi: mem94: type=3, attr=0xf, range=[0x00000000896ef000-0x00000000896f0000) (0MB)
[    0.000000] efi: mem95: type=4, attr=0xf, range=[0x00000000896f0000-0x00000000896f1000) (0MB)
[    0.000000] efi: mem96: type=3, attr=0xf, range=[0x00000000896f1000-0x00000000896f3000) (0MB)
[    0.000000] efi: mem97: type=4, attr=0xf, range=[0x00000000896f3000-0x00000000896f6000) (0MB)
[    0.000000] efi: mem98: type=3, attr=0xf, range=[0x00000000896f6000-0x00000000896f7000) (0MB)
[    0.000000] efi: mem99: type=4, attr=0xf, range=[0x00000000896f7000-0x00000000896f8000) (0MB)
[    0.000000] efi: mem100: type=2, attr=0xf, range=[0x00000000896f8000-0x00000000896f9000) (0MB)
[    0.000000] efi: mem101: type=4, attr=0xf, range=[0x00000000896f9000-0x00000000896fa000) (0MB)
[    0.000000] efi: mem102: type=3, attr=0xf, range=[0x00000000896fa000-0x00000000896fb000) (0MB)
[    0.000000] efi: mem103: type=4, attr=0xf, range=[0x00000000896fb000-0x00000000896fc000) (0MB)
[    0.000000] efi: mem104: type=3, attr=0xf, range=[0x00000000896fc000-0x000000008970a000) (0MB)
[    0.000000] efi: mem105: type=4, attr=0xf, range=[0x000000008970a000-0x000000008970c000) (0MB)
[    0.000000] efi: mem106: type=3, attr=0xf, range=[0x000000008970c000-0x0000000089714000) (0MB)
[    0.000000] efi: mem107: type=4, attr=0xf, range=[0x0000000089714000-0x0000000089718000) (0MB)
[    0.000000] efi: mem108: type=3, attr=0xf, range=[0x0000000089718000-0x000000008971e000) (0MB)
[    0.000000] efi: mem109: type=4, attr=0xf, range=[0x000000008971e000-0x0000000089722000) (0MB)
[    0.000000] efi: mem110: type=2, attr=0xf, range=[0x0000000089722000-0x0000000089723000) (0MB)
[    0.000000] efi: mem111: type=4, attr=0xf, range=[0x0000000089723000-0x000000008972a000) (0MB)
[    0.000000] efi: mem112: type=3, attr=0xf, range=[0x000000008972a000-0x000000008972f000) (0MB)
[    0.000000] efi: mem113: type=4, attr=0xf, range=[0x000000008972f000-0x0000000089738000) (0MB)
[    0.000000] efi: mem114: type=3, attr=0xf, range=[0x0000000089738000-0x0000000089751000) (0MB)
[    0.000000] efi: mem115: type=4, attr=0xf, range=[0x0000000089751000-0x0000000089753000) (0MB)
[    0.000000] efi: mem116: type=3, attr=0xf, range=[0x0000000089753000-0x0000000089761000) (0MB)
[    0.000000] efi: mem117: type=4, attr=0xf, range=[0x0000000089761000-0x0000000089762000) (0MB)
[    0.000000] efi: mem118: type=3, attr=0xf, range=[0x0000000089762000-0x0000000089765000) (0MB)
[    0.000000] efi: mem119: type=4, attr=0xf, range=[0x0000000089765000-0x0000000089768000) (0MB)
[    0.000000] efi: mem120: type=3, attr=0xf, range=[0x0000000089768000-0x0000000089777000) (0MB)
[    0.000000] efi: mem121: type=4, attr=0xf, range=[0x0000000089777000-0x0000000089778000) (0MB)
[    0.000000] efi: mem122: type=3, attr=0xf, range=[0x0000000089778000-0x000000008977c000) (0MB)
[    0.000000] efi: mem123: type=2, attr=0xf, range=[0x000000008977c000-0x000000008977d000) (0MB)
[    0.000000] efi: mem124: type=4, attr=0xf, range=[0x000000008977d000-0x0000000089782000) (0MB)
[    0.000000] efi: mem125: type=3, attr=0xf, range=[0x0000000089782000-0x0000000089786000) (0MB)
[    0.000000] efi: mem126: type=4, attr=0xf, range=[0x0000000089786000-0x000000008978b000) (0MB)
[    0.000000] efi: mem127: type=2, attr=0xf, range=[0x000000008978b000-0x000000008978c000) (0MB)
[    0.000000] efi: mem128: type=4, attr=0xf, range=[0x000000008978c000-0x000000008978e000) (0MB)
[    0.000000] efi: mem129: type=3, attr=0xf, range=[0x000000008978e000-0x000000008978f000) (0MB)
[    0.000000] efi: mem130: type=4, attr=0xf, range=[0x000000008978f000-0x0000000089790000) (0MB)
[    0.000000] efi: mem131: type=3, attr=0xf, range=[0x0000000089790000-0x0000000089792000) (0MB)
[    0.000000] efi: mem132: type=4, attr=0xf, range=[0x0000000089792000-0x0000000089794000) (0MB)
[    0.000000] efi: mem133: type=3, attr=0xf, range=[0x0000000089794000-0x0000000089796000) (0MB)
[    0.000000] efi: mem134: type=2, attr=0xf, range=[0x0000000089796000-0x0000000089797000) (0MB)
[    0.000000] efi: mem135: type=4, attr=0xf, range=[0x0000000089797000-0x000000008979a000) (0MB)
[    0.000000] efi: mem136: type=3, attr=0xf, range=[0x000000008979a000-0x00000000897aa000) (0MB)
[    0.000000] efi: mem137: type=4, attr=0xf, range=[0x00000000897aa000-0x00000000897ae000) (0MB)
[    0.000000] efi: mem138: type=3, attr=0xf, range=[0x00000000897ae000-0x00000000897b7000) (0MB)
[    0.000000] efi: mem139: type=4, attr=0xf, range=[0x00000000897b7000-0x00000000897ba000) (0MB)
[    0.000000] efi: mem140: type=3, attr=0xf, range=[0x00000000897ba000-0x00000000897bb000) (0MB)
[    0.000000] efi: mem141: type=4, attr=0xf, range=[0x00000000897bb000-0x00000000897bd000) (0MB)
[    0.000000] efi: mem142: type=2, attr=0xf, range=[0x00000000897bd000-0x00000000897be000) (0MB)
[    0.000000] efi: mem143: type=4, attr=0xf, range=[0x00000000897be000-0x00000000897bf000) (0MB)
[    0.000000] efi: mem144: type=3, attr=0xf, range=[0x00000000897bf000-0x00000000897ce000) (0MB)
[    0.000000] efi: mem145: type=4, attr=0xf, range=[0x00000000897ce000-0x00000000897cf000) (0MB)
[    0.000000] efi: mem146: type=3, attr=0xf, range=[0x00000000897cf000-0x00000000897dc000) (0MB)
[    0.000000] efi: mem147: type=4, attr=0xf, range=[0x00000000897dc000-0x00000000897dd000) (0MB)
[    0.000000] efi: mem148: type=3, attr=0xf, range=[0x00000000897dd000-0x00000000897ed000) (0MB)
[    0.000000] efi: mem149: type=4, attr=0xf, range=[0x00000000897ed000-0x00000000897f0000) (0MB)
[    0.000000] efi: mem150: type=2, attr=0xf, range=[0x00000000897f0000-0x00000000897f1000) (0MB)
[    0.000000] efi: mem151: type=4, attr=0xf, range=[0x00000000897f1000-0x00000000897f2000) (0MB)
[    0.000000] efi: mem152: type=3, attr=0xf, range=[0x00000000897f2000-0x00000000897f8000) (0MB)
[    0.000000] efi: mem153: type=4, attr=0xf, range=[0x00000000897f8000-0x00000000897f9000) (0MB)
[    0.000000] efi: mem154: type=3, attr=0xf, range=[0x00000000897f9000-0x00000000897fa000) (0MB)
[    0.000000] efi: mem155: type=4, attr=0xf, range=[0x00000000897fa000-0x00000000897fd000) (0MB)
[    0.000000] efi: mem156: type=3, attr=0xf, range=[0x00000000897fd000-0x00000000897fe000) (0MB)
[    0.000000] efi: mem157: type=4, attr=0xf, range=[0x00000000897fe000-0x00000000897ff000) (0MB)
[    0.000000] efi: mem158: type=2, attr=0xf, range=[0x00000000897ff000-0x0000000089800000) (0MB)
[    0.000000] efi: mem159: type=4, attr=0xf, range=[0x0000000089800000-0x0000000089802000) (0MB)
[    0.000000] efi: mem160: type=3, attr=0xf, range=[0x0000000089802000-0x0000000089804000) (0MB)
[    0.000000] efi: mem161: type=4, attr=0xf, range=[0x0000000089804000-0x0000000089807000) (0MB)
[    0.000000] efi: mem162: type=2, attr=0xf, range=[0x0000000089807000-0x0000000089808000) (0MB)
[    0.000000] efi: mem163: type=3, attr=0xf, range=[0x0000000089808000-0x0000000089809000) (0MB)
[    0.000000] efi: mem164: type=4, attr=0xf, range=[0x0000000089809000-0x000000008980d000) (0MB)
[    0.000000] efi: mem165: type=3, attr=0xf, range=[0x000000008980d000-0x0000000089810000) (0MB)
[    0.000000] efi: mem166: type=4, attr=0xf, range=[0x0000000089810000-0x0000000089811000) (0MB)
[    0.000000] efi: mem167: type=3, attr=0xf, range=[0x0000000089811000-0x000000008981c000) (0MB)
[    0.000000] efi: mem168: type=4, attr=0xf, range=[0x000000008981c000-0x000000008981e000) (0MB)
[    0.000000] efi: mem169: type=3, attr=0xf, range=[0x000000008981e000-0x0000000089820000) (0MB)
[    0.000000] efi: mem170: type=4, attr=0xf, range=[0x0000000089820000-0x0000000089823000) (0MB)
[    0.000000] efi: mem171: type=2, attr=0xf, range=[0x0000000089823000-0x0000000089824000) (0MB)
[    0.000000] efi: mem172: type=4, attr=0xf, range=[0x0000000089824000-0x0000000089825000) (0MB)
[    0.000000] efi: mem173: type=3, attr=0xf, range=[0x0000000089825000-0x0000000089826000) (0MB)
[    0.000000] efi: mem174: type=4, attr=0xf, range=[0x0000000089826000-0x000000008982a000) (0MB)
[    0.000000] efi: mem175: type=3, attr=0xf, range=[0x000000008982a000-0x000000008982b000) (0MB)
[    0.000000] efi: mem176: type=4, attr=0xf, range=[0x000000008982b000-0x0000000089832000) (0MB)
[    0.000000] efi: mem177: type=3, attr=0xf, range=[0x0000000089832000-0x0000000089834000) (0MB)
[    0.000000] efi: mem178: type=4, attr=0xf, range=[0x0000000089834000-0x000000008983b000) (0MB)
[    0.000000] efi: mem179: type=3, attr=0xf, range=[0x000000008983b000-0x000000008983c000) (0MB)
[    0.000000] efi: mem180: type=2, attr=0xf, range=[0x000000008983c000-0x000000008983d000) (0MB)
[    0.000000] efi: mem181: type=4, attr=0xf, range=[0x000000008983d000-0x000000008983e000) (0MB)
[    0.000000] efi: mem182: type=3, attr=0xf, range=[0x000000008983e000-0x000000008983f000) (0MB)
[    0.000000] efi: mem183: type=4, attr=0xf, range=[0x000000008983f000-0x000000008985c000) (0MB)
[    0.000000] efi: mem184: type=3, attr=0xf, range=[0x000000008985c000-0x0000000089861000) (0MB)
[    0.000000] efi: mem185: type=4, attr=0xf, range=[0x0000000089861000-0x00000000898c6000) (0MB)
[    0.000000] efi: mem186: type=2, attr=0xf, range=[0x00000000898c6000-0x00000000898c7000) (0MB)
[    0.000000] efi: mem187: type=4, attr=0xf, range=[0x00000000898c7000-0x00000000898c8000) (0MB)
[    0.000000] efi: mem188: type=3, attr=0xf, range=[0x00000000898c8000-0x00000000898db000) (0MB)
[    0.000000] efi: mem189: type=4, attr=0xf, range=[0x00000000898db000-0x0000000089921000) (0MB)
[    0.000000] efi: mem190: type=3, attr=0xf, range=[0x0000000089921000-0x0000000089938000) (0MB)
[    0.000000] efi: mem191: type=4, attr=0xf, range=[0x0000000089938000-0x0000000089953000) (0MB)
[    0.000000] efi: mem192: type=3, attr=0xf, range=[0x0000000089953000-0x0000000089958000) (0MB)
[    0.000000] efi: mem193: type=4, attr=0xf, range=[0x0000000089958000-0x0000000089959000) (0MB)
[    0.000000] efi: mem194: type=2, attr=0xf, range=[0x0000000089959000-0x000000008995a000) (0MB)
[    0.000000] efi: mem195: type=4, attr=0xf, range=[0x000000008995a000-0x0000000089960000) (0MB)
[    0.000000] efi: mem196: type=3, attr=0xf, range=[0x0000000089960000-0x0000000089961000) (0MB)
[    0.000000] efi: mem197: type=4, attr=0xf, range=[0x0000000089961000-0x0000000089963000) (0MB)
[    0.000000] efi: mem198: type=3, attr=0xf, range=[0x0000000089963000-0x0000000089964000) (0MB)
[    0.000000] efi: mem199: type=4, attr=0xf, range=[0x0000000089964000-0x0000000089965000) (0MB)
[    0.000000] efi: mem200: type=3, attr=0xf, range=[0x0000000089965000-0x0000000089968000) (0MB)
[    0.000000] efi: mem201: type=4, attr=0xf, range=[0x0000000089968000-0x000000008997e000) (0MB)
[    0.000000] efi: mem202: type=3, attr=0xf, range=[0x000000008997e000-0x00000000899a1000) (0MB)
[    0.000000] efi: mem203: type=4, attr=0xf, range=[0x00000000899a1000-0x00000000899a2000) (0MB)
[    0.000000] efi: mem204: type=2, attr=0xf, range=[0x00000000899a2000-0x00000000899a3000) (0MB)
[    0.000000] efi: mem205: type=4, attr=0xf, range=[0x00000000899a3000-0x00000000899a4000) (0MB)
[    0.000000] efi: mem206: type=3, attr=0xf, range=[0x00000000899a4000-0x00000000899a6000) (0MB)
[    0.000000] efi: mem207: type=4, attr=0xf, range=[0x00000000899a6000-0x00000000899a7000) (0MB)
[    0.000000] efi: mem208: type=3, attr=0xf, range=[0x00000000899a7000-0x00000000899aa000) (0MB)
[    0.000000] efi: mem209: type=2, attr=0xf, range=[0x00000000899aa000-0x00000000899ab000) (0MB)
[    0.000000] efi: mem210: type=4, attr=0xf, range=[0x00000000899ab000-0x0000000089dcc000) (4MB)
[    0.000000] efi: mem211: type=3, attr=0xf, range=[0x0000000089dcc000-0x0000000089dd6000) (0MB)
[    0.000000] efi: mem212: type=4, attr=0xf, range=[0x0000000089dd6000-0x0000000089e60000) (0MB)
[    0.000000] efi: mem213: type=3, attr=0xf, range=[0x0000000089e60000-0x0000000089e63000) (0MB)
[    0.000000] efi: mem214: type=4, attr=0xf, range=[0x0000000089e63000-0x0000000089e65000) (0MB)
[    0.000000] efi: mem215: type=2, attr=0xf, range=[0x0000000089e65000-0x0000000089e66000) (0MB)
[    0.000000] efi: mem216: type=4, attr=0xf, range=[0x0000000089e66000-0x0000000089e67000) (0MB)
[    0.000000] efi: mem217: type=3, attr=0xf, range=[0x0000000089e67000-0x0000000089e6c000) (0MB)
[    0.000000] efi: mem218: type=4, attr=0xf, range=[0x0000000089e6c000-0x0000000089e6d000) (0MB)
[    0.000000] efi: mem219: type=3, attr=0xf, range=[0x0000000089e6d000-0x0000000089e70000) (0MB)
[    0.000000] efi: mem220: type=4, attr=0xf, range=[0x0000000089e70000-0x0000000089e72000) (0MB)
[    0.000000] efi: mem221: type=3, attr=0xf, range=[0x0000000089e72000-0x0000000089e73000) (0MB)
[    0.000000] efi: mem222: type=4, attr=0xf, range=[0x0000000089e73000-0x0000000089e75000) (0MB)
[    0.000000] efi: mem223: type=3, attr=0xf, range=[0x0000000089e75000-0x0000000089e76000) (0MB)
[    0.000000] efi: mem224: type=4, attr=0xf, range=[0x0000000089e76000-0x000000008a355000) (4MB)
[    0.000000] efi: mem225: type=2, attr=0xf, range=[0x000000008a355000-0x000000008a356000) (0MB)
[    0.000000] efi: mem226: type=4, attr=0xf, range=[0x000000008a356000-0x000000008a440000) (0MB)
[    0.000000] efi: mem227: type=2, attr=0xf, range=[0x000000008a440000-0x000000008a441000) (0MB)
[    0.000000] efi: mem228: type=4, attr=0xf, range=[0x000000008a441000-0x000000008acfa000) (8MB)
[    0.000000] efi: mem229: type=2, attr=0xf, range=[0x000000008acfa000-0x000000008acfb000) (0MB)
[    0.000000] efi: mem230: type=4, attr=0xf, range=[0x000000008acfb000-0x000000008ad03000) (0MB)
[    0.000000] efi: mem231: type=7, attr=0xf, range=[0x000000008ad03000-0x000000008ad14000) (0MB)
[    0.000000] efi: mem232: type=10, attr=0xf, range=[0x000000008ad14000-0x000000008ad53000) (0MB)
[    0.000000] efi: mem233: type=7, attr=0xf, range=[0x000000008ad53000-0x000000008ad69000) (0MB)
[    0.000000] efi: mem234: type=9, attr=0xf, range=[0x000000008ad69000-0x000000008ad8f000) (0MB)
[    0.000000] efi: mem235: type=7, attr=0xf, range=[0x000000008ad8f000-0x000000008ae3b000) (0MB)
[    0.000000] efi: mem236: type=6, attr=0x800000000000000f, range=[0x000000008ae3b000-0x000000008ae8f000) (0MB)
[    0.000000] efi: mem237: type=7, attr=0xf, range=[0x000000008ae8f000-0x000000008aece000) (0MB)
[    0.000000] efi: mem238: type=5, attr=0x800000000000000f, range=[0x000000008aece000-0x000000008aeff000) (0MB)
[    0.000000] efi: mem239: type=7, attr=0xf, range=[0x000000008aeff000-0x000000008af87000) (0MB)
[    0.000000] efi: mem240: type=2, attr=0xf, range=[0x000000008af87000-0x000000008af92000) (0MB)
[    0.000000] efi: mem241: type=0, attr=0xf, range=[0x000000008af92000-0x000000008afff000) (0MB)
[    0.000000] efi: mem242: type=2, attr=0xf, range=[0x000000008afff000-0x000000008b000000) (0MB)
[    0.000000] efi: mem243: type=7, attr=0xf, range=[0x0000000100000000-0x000000026f600000) (5878MB)
[    0.000000] efi: mem244: type=0, attr=0x8000000000000000, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem245: type=0, attr=0x8000000000000000, range=[0x000000008b000000-0x000000008fa00000) (74MB)
[    0.000000] efi: mem246: type=11, attr=0x8000000000000000, range=[0x00000000e00f8000-0x00000000e00f9000) (0MB)
[    0.000000] efi: mem247: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem248: type=11, attr=0x8000000000000000, range=[0x00000000ffe70000-0x00000000ffea0000) (0MB)
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Apple Inc. MacBookPro10,1/Mac-C3EC7CD22292981F, BIOS MBP101.88Z.00EE.B03.1212211437 12/21/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x26f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 0A0000000 mask FE0000000 uncachable
[    0.000000]   2 base 090000000 mask FF0000000 uncachable
[    0.000000]   3 base 08C000000 mask FFC000000 uncachable
[    0.000000]   4 base 08B000000 mask FFF000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8b000 max_arch_pfn = 0x400000000
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01f1f000, 0x01f1ffff] PGTABLE
[    0.000000] BRK [0x01f20000, 0x01f20fff] PGTABLE
[    0.000000] BRK [0x01f21000, 0x01f21fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x26f400000-0x26f5fffff]
[    0.000000]  [mem 0x26f400000-0x26f5fffff] page 2M
[    0.000000] BRK [0x01f22000, 0x01f22fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x26c000000-0x26f3fffff]
[    0.000000]  [mem 0x26c000000-0x26f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x26bffffff]
[    0.000000]  [mem 0x200000000-0x26bffffff] page 2M
[    0.000000] BRK [0x01f23000, 0x01f23fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01f24000, 0x01f24fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0x8ad13fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0x8abfffff] page 2M
[    0.000000]  [mem 0x8ac00000-0x8ad13fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ad53000-0x8ad68fff]
[    0.000000]  [mem 0x8ad53000-0x8ad68fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ad8f000-0x8ae3afff]
[    0.000000]  [mem 0x8ad8f000-0x8ae3afff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8ae8f000-0x8aecdfff]
[    0.000000]  [mem 0x8ae8f000-0x8aecdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8aeff000-0x8af91fff]
[    0.000000]  [mem 0x8aeff000-0x8af91fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x8afff000-0x8affffff]
[    0.000000]  [mem 0x8afff000-0x8affffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x36006000-0x36ffafff]
[    0.000000] ACPI: RSDP 000000008ad8e014 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000008ad8e1c0 000B4 (v01 APPLE   Apple00 00000000      01000013)
[    0.000000] ACPI: FACP 000000008ad8c000 000F4 (v04 APPLE   Apple00 00000000 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000008ad82000 04D5C (v01 APPLE  MacBookP 00100001 INTL 20100915)
[    0.000000] ACPI: FACS 000000008ad1e000 00040
[    0.000000] ACPI: HPET 000000008ad8b000 00038 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000008ad8a000 000BC (v02 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000008ad88000 00030 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000008ad87000 00053 (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000008ad7f000 0053A (v01 APPLE  SataAhci 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad7e000 00024 (v01 APPLE   SmcDppt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad79000 00D3E (v01 APPLE    UsbPpt 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad77000 00159 (v02 APPLE     IGHda 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad75000 00032 (v01 APPLE    SsdtS3 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad73000 015EB (v02 APPLE  SsdtIGPU 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6e000 019AA (v01 APPLE  TbtPEG11 00001000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6d000 00657 (v01  PmRef  Cpu0Ist 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6c000 00B3D (v01  PmRef    CpuPm 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6b000 00315 (v01  PmRef  Cpu0Tst 00003000 INTL 20100915)
[    0.000000] ACPI: SSDT 000000008ad6a000 0037A (v01  PmRef    ApTst 00003000 INTL 20100915)
[    0.000000] ACPI: DMAR 000000008ad69000 00088 (v01 APPLE      IVB  00000001 AAPL 00000001)
[    0.000000] ACPI: MCFG 000000008ad89000 0003C (v01 APPLE   Apple00 00000001 Loki 0000005F)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00089fffff] PMD -> [ffff880266c00000-ffff88026ddfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x26f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0008dfff]
[    0.000000]   node   0: [mem 0x00090000-0x0009ffff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0x8ad13fff]
[    0.000000]   node   0: [mem 0x8ad53000-0x8ad68fff]
[    0.000000]   node   0: [mem 0x8ad8f000-0x8ae3afff]
[    0.000000]   node   0: [mem 0x8ae8f000-0x8aecdfff]
[    0.000000]   node   0: [mem 0x8aeff000-0x8af91fff]
[    0.000000]   node   0: [mem 0x8afff000-0x8affffff]
[    0.000000]   node   0: [mem 0x100000000-0x26f5fffff]
[    0.000000] On node 0 totalpages: 2073157
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 25 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7717 pages used for memmap
[    0.000000]   DMA32 zone: 564392 pages, LIFO batch:31
[    0.000000]   Normal zone: 20573 pages used for memmap
[    0.000000]   Normal zone: 1504768 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x8fa00000-0xe00f7fff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88026f200000 s81024 r8192 d21376 u262144
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2044786
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.12 root=/dev/sda6 video=efifb i915.modeset=1 i915.i915_enable_rc6=3 i915.lvds_channel_mode=1 i915.i915_enable_fbc=1 i915.lvds_downclock=1 drm.vblankoffdelay=1 i915.i915_enable_ppgtt=0 nouveau.runpm=0
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 8006644K/8292628K available (6923K kernel code, 825K rwdata, 2920K rodata, 1080K init, 1260K bss, 285984K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.010000] tsc: Detected 2394.503 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4789.00 BogoMIPS (lpj=23945030)
[    0.000009] pid_max: default: 32768 minimum: 301
[    0.000033] init_memory_mapping: [mem 0x8ae3b000-0x8ae8efff]
[    0.000037]  [mem 0x8ae3b000-0x8ae8efff] page 4k
[    0.000046] init_memory_mapping: [mem 0x8aece000-0x8aefefff]
[    0.000049]  [mem 0x8aece000-0x8aefefff] page 4k
[    0.000084] init_memory_mapping: [mem 0x8b000000-0x8f9fffff]
[    0.000088]  [mem 0x8b000000-0x8f9fffff] page 2M
[    0.024278] Security Framework initialized
[    0.024312] Mount-cache hash table entries: 256
[    0.024453] Initializing cgroup subsys devices
[    0.024458] Initializing cgroup subsys freezer
[    0.024461] Initializing cgroup subsys net_cls
[    0.024482] CPU: Physical Processor ID: 0
[    0.024485] CPU: Processor Core ID: 0
[    0.024858] mce: CPU supports 9 MCE banks
[    0.024872] CPU0: Thermal monitoring enabled (TM1)
[    0.024884] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.024884] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.024884] tlb_flushall_shift: 1
[    0.025009] Freeing SMP alternatives memory: 20K (ffffffff81dde000 - ffffffff81de3000)
[    0.025015] ACPI: Core revision 20130725
[    0.031373] ACPI: All ACPI Tables successfully acquired
[    0.033619] ftrace: allocating 24997 entries in 98 pages
[    0.044968] dmar: Host address width 36
[    0.044972] dmar: DRHD base: 0x000000fed90000 flags: 0x0
[    0.044980] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c0000020e60262 ecap f0101a
[    0.044984] dmar: DRHD base: 0x000000fed91000 flags: 0x1
[    0.044990] dmar: IOMMU 1: reg_base_addr fed91000 ver 1:0 cap c9008020660262 ecap f0105a
[    0.044994] dmar: RMRR base: 0x0000008b800000 end: 0x0000008f9fffff
[    0.045070] IOAPIC id 0 under DRHD base  0xfed91000 IOMMU 1
[    0.045073] HPET id 0 under DRHD base 0xfed91000
[    0.045076] [Firmware Bug]: ioapic 2 has no mapping iommu, interrupt remapping will be disabled
[    0.045079] Not enable interrupt remapping
[    0.045081] Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.
[    0.045545] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.145637] smpboot: CPU0: Intel(R) Core(TM) i7-3635QM CPU @ 2.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.145647] TSC deadline timer enabled
[    0.145655] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.145665] ... version:                3
[    0.145667] ... bit width:              48
[    0.145669] ... generic registers:      4
[    0.145671] ... value mask:             0000ffffffffffff
[    0.145674] ... max period:             0000ffffffffffff
[    0.145676] ... fixed-purpose events:   3
[    0.145679] ... event mask:             000000070000000f
[    0.205804] smpboot: Booting Node   0, Processors  #   1 #   2 #   3 #   4 #   5 #   6 #   7 OK
[    0.399685] Brought up 8 CPUs
[    0.399692] smpboot: Total of 8 processors activated (38312.04 BogoMIPS)
[    0.406083] devtmpfs: initialized
[    0.406272] PM: Registering ACPI NVS region [mem 0x8ad14000-0x8ad52fff] (258048 bytes)
[    0.406976] xor: automatically using best checksumming function:
[    0.506058]    avx       : 16859.600 MB/sec
[    0.506062] pinctrl core: initialized pinctrl subsystem
[    0.506120] NET: Registered protocol family 16
[    0.506204] cpuidle: using governor ladder
[    0.506207] cpuidle: using governor menu
[    0.506241] ACPI: bus type PCI registered
[    0.506289] PCI: MMCONFIG for domain 0000 [bus 00-9b] at [mem 0xe0000000-0xe9bfffff] (base 0xe0000000)
[    0.506294] PCI: not using MMCONFIG
[    0.506297] PCI: Using configuration type 1 for base access
[    0.507165] bio: create slab <bio-0> at 0
[    0.676217] raid6: sse2x1    6501 MB/s
[    0.846377] raid6: sse2x2    8125 MB/s
[    1.016529] raid6: sse2x4    9560 MB/s
[    1.016532] raid6: using algorithm sse2x4 (9560 MB/s)
[    1.016534] raid6: using ssse3x2 recovery algorithm
[    1.016577] ACPI: Added _OSI(Module Device)
[    1.016580] ACPI: Added _OSI(Processor Device)
[    1.016582] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.016585] ACPI: Added _OSI(Processor Aggregator Device)
[    1.017849] ACPI: EC: EC description table is found, configuring boot EC
[    1.022246] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    3.019094] ACPI: SSDT 000000008ad19190 008AD (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    3.019426] ACPI: Dynamic OEM Table Load:
[    3.019429] ACPI: SSDT           (null) 008AD (v01  PmRef  Cpu0Cst 00003001 INTL 20100915)
[    3.048920] ACPI: SSDT 000000008ad1a710 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    3.049290] ACPI: Dynamic OEM Table Load:
[    3.049293] ACPI: SSDT           (null) 003A4 (v01  PmRef    ApIst 00003000 INTL 20100915)
[    3.082406] ACPI: SSDT 000000008ad18d90 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    3.082734] ACPI: Dynamic OEM Table Load:
[    3.082737] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20100915)
[    3.123449] ACPI: Interpreter enabled
[    3.123458] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130725/hwxface-571)
[    3.123466] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130725/hwxface-571)
[    3.123479] ACPI: (supports S0 S3 S5)
[    3.123481] ACPI: Using IOAPIC for interrupt routing
[    3.123500] PCI: MMCONFIG for domain 0000 [bus 00-9b] at [mem 0xe0000000-0xe9bfffff] (base 0xe0000000)
[    3.123886] PCI: MMCONFIG at [mem 0xe0000000-0xe9bfffff] reserved in ACPI motherboard resources
[    3.144263] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    3.144417] ACPI: No dock devices found.
[    3.152908] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.153012] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    3.153104] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    3.153297] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-9b] only partially covers this bridge
[    3.153348] PCI host bridge to bus 0000:00
[    3.153352] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.153356] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    3.153359] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    3.153362] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    3.153366] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    3.153369] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    3.153373] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    3.153376] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    3.153380] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    3.153383] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    3.153387] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    3.153390] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    3.153394] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    3.153397] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    3.153401] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    3.153404] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    3.153408] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    3.153412] pci_bus 0000:00: root bus resource [mem 0x8fa00000-0xfeafffff]
[    3.153415] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    3.153425] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    3.153499] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    3.153529] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    3.153560] pci 0000:00:01.0: System wakeup disabled by ACPI
[    3.153601] pci 0000:00:01.1: [8086:0155] type 01 class 0x060400
[    3.153679] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    3.153719] pci 0000:00:01.1: System wakeup disabled by ACPI
[    3.153755] pci 0000:00:01.2: [8086:0159] type 01 class 0x060400
[    3.153826] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
[    3.153866] pci 0000:00:01.2: System wakeup disabled by ACPI
[    3.153899] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    3.153909] pci 0000:00:02.0: reg 0x10: [mem 0xc1400000-0xc17fffff 64bit]
[    3.153915] pci 0000:00:02.0: reg 0x18: [mem 0xb0000000-0xbfffffff 64bit pref]
[    3.153919] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    3.154005] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    3.154026] pci 0000:00:14.0: reg 0x10: [mem 0xc1c00000-0xc1c0ffff 64bit]
[    3.154088] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    3.154119] pci 0000:00:14.0: System wakeup disabled by ACPI
[    3.154156] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    3.154180] pci 0000:00:16.0: reg 0x10: [mem 0xc1c17100-0xc1c1710f 64bit]
[    3.154257] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    3.154329] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    3.154351] pci 0000:00:1a.0: reg 0x10: [mem 0xc1c16c00-0xc1c16fff]
[    3.154441] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    3.154476] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    3.154510] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    3.154524] pci 0000:00:1b.0: reg 0x10: [mem 0xc1c10000-0xc1c13fff 64bit]
[    3.154582] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    3.154618] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    3.154652] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    3.154782] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    3.154828] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    3.154866] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    3.154994] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    3.155040] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    3.155084] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    3.155106] pci 0000:00:1d.0: reg 0x10: [mem 0xc1c16800-0xc1c16bff]
[    3.155196] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    3.155231] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    3.155266] pci 0000:00:1f.0: [8086:1e57] type 00 class 0x060100
[    3.155426] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    3.155445] pci 0000:00:1f.2: reg 0x10: [io  0x3098-0x309f]
[    3.155454] pci 0000:00:1f.2: reg 0x14: [io  0x30bc-0x30bf]
[    3.155462] pci 0000:00:1f.2: reg 0x18: [io  0x3090-0x3097]
[    3.155470] pci 0000:00:1f.2: reg 0x1c: [io  0x30b8-0x30bb]
[    3.155478] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    3.155487] pci 0000:00:1f.2: reg 0x24: [mem 0xc1c16000-0xc1c167ff]
[    3.155533] pci 0000:00:1f.2: PME# supported from D3hot
[    3.155587] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    3.155601] pci 0000:00:1f.3: reg 0x10: [mem 0xc1c17000-0xc1c170ff 64bit]
[    3.155617] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    3.155726] pci 0000:01:00.0: [10de:0fd5] type 00 class 0x030000
[    3.155737] pci 0000:01:00.0: reg 0x10: [mem 0xc0000000-0xc0ffffff]
[    3.155748] pci 0000:01:00.0: reg 0x14: [mem 0x90000000-0x9fffffff 64bit pref]
[    3.155759] pci 0000:01:00.0: reg 0x1c: [mem 0xa0000000-0xa1ffffff 64bit pref]
[    3.155767] pci 0000:01:00.0: reg 0x24: [io  0x2000-0x207f]
[    3.155775] pci 0000:01:00.0: reg 0x30: [mem 0xc1000000-0xc107ffff pref]
[    3.155828] pci 0000:01:00.0: System wakeup disabled by ACPI
[    3.155869] pci 0000:01:00.1: [10de:0e1b] type 00 class 0x040300
[    3.155878] pci 0000:01:00.1: reg 0x10: [mem 0xc1080000-0xc1083fff]
[    4.169861] pci 0000:00:01.0: ASPM: Could not configure common clock
[    4.169898] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.169902] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    4.169904] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc10fffff]
[    4.169908] pci 0000:00:01.0:   bridge window [mem 0x90000000-0xa1ffffff 64bit pref]
[    4.169973] pci 0000:00:01.1: PCI bridge to [bus 05-9b]
[    4.169979] pci 0000:00:01.1:   bridge window [io  0x4000-0x6fff]
[    4.169982] pci 0000:00:01.1:   bridge window [mem 0xc1d00000-0xcdffffff]
[    4.169988] pci 0000:00:01.1:   bridge window [mem 0xce000000-0xd9ffffff 64bit pref]
[    4.170048] pci 0000:00:01.2: PCI bridge to [bus 02]
[    4.170056] pci 0000:00:01.2:   bridge window [mem 0xc1b00000-0xc1bfffff]
[    4.170219] pci 0000:03:00.0: [14e4:16a3] type 00 class 0x020000
[    4.170253] pci 0000:03:00.0: reg 0x10: [mem 0xc1800000-0xc180ffff 64bit pref]
[    4.170278] pci 0000:03:00.0: reg 0x18: [mem 0xc1810000-0xc181ffff 64bit pref]
[    4.170319] pci 0000:03:00.0: reg 0x30: [mem 0xfffff800-0xffffffff pref]
[    4.170429] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    4.170573] pci 0000:03:00.1: [14e4:16bc] type 00 class 0x080501
[    4.170606] pci 0000:03:00.1: reg 0x10: [mem 0xc1820000-0xc182ffff 64bit pref]
[    4.170769] pci 0000:03:00.1: PME# supported from D0 D3hot D3cold
[    4.170818] pci 0000:03:00.1: System wakeup disabled by ACPI
[    4.190001] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    4.190010] pci 0000:00:1c.0:   bridge window [mem 0xc1a00000-0xc1afffff]
[    4.190019] pci 0000:00:1c.0:   bridge window [mem 0xc1800000-0xc18fffff 64bit pref]
[    4.190156] pci 0000:04:00.0: [14e4:4331] type 00 class 0x028000
[    4.190181] pci 0000:04:00.0: reg 0x10: [mem 0xc1900000-0xc1903fff 64bit]
[    4.190312] pci 0000:04:00.0: supports D1 D2
[    4.190314] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    4.190358] pci 0000:04:00.0: System wakeup disabled by ACPI
[    4.209976] pci 0000:00:1c.1: PCI bridge to [bus 04]
[    4.209986] pci 0000:00:1c.1:   bridge window [mem 0xc1900000-0xc19fffff]
[    4.210104] pci_bus 0000:00: on NUMA node 0
[    4.210543] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    4.210605] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    4.210662] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    4.210717] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    4.210774] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    4.210830] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    4.210887] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    4.210944] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    4.212233] ACPI: Enabled 3 GPEs in block 00 to 3F
[    4.212242] ACPI: \_SB_.PCI0: notify handler is installed
[    4.212293] Found 1 acpi root devices
[    4.212316] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    4.212374] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    4.212389] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    4.212392] vgaarb: loaded
[    4.212394] vgaarb: bridge control possible 0000:01:00.0
[    4.212397] vgaarb: no bridge control possible 0000:00:02.0
[    4.212473] SCSI subsystem initialized
[    4.212482] libata version 3.00 loaded.
[    4.212496] ACPI: bus type USB registered
[    4.212511] usbcore: registered new interface driver usbfs
[    4.212520] usbcore: registered new interface driver hub
[    4.212546] usbcore: registered new device driver usb
[    4.212598] wmi: Mapper loaded
[    4.212600] PCI: Using ACPI for IRQ routing
[    4.217147] PCI: pci_cache_line_size set to 64 bytes
[    4.217348] e820: reserve RAM buffer [mem 0x0008e000-0x0008ffff]
[    4.217350] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    4.217351] e820: reserve RAM buffer [mem 0x8ad14000-0x8bffffff]
[    4.217353] e820: reserve RAM buffer [mem 0x8ad69000-0x8bffffff]
[    4.217355] e820: reserve RAM buffer [mem 0x8ae3b000-0x8bffffff]
[    4.217357] e820: reserve RAM buffer [mem 0x8aece000-0x8bffffff]
[    4.217358] e820: reserve RAM buffer [mem 0x8af92000-0x8bffffff]
[    4.217360] e820: reserve RAM buffer [mem 0x8b000000-0x8bffffff]
[    4.217361] e820: reserve RAM buffer [mem 0x26f600000-0x26fffffff]
[    4.217432] NetLabel: Initializing
[    4.217435] NetLabel:  domain hash size = 128
[    4.217437] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.217447] NetLabel:  unlabeled traffic allowed by default
[    4.217513] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    4.217520] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    4.220550] Switched to clocksource hpet
[    4.224366] pnp: PnP ACPI init
[    4.224380] ACPI: bus type PNP registered
[    4.224487] pnp 00:00: [dma 4]
[    4.224508] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    4.224527] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    4.224644] system 00:02: [mem 0xfed00000-0xfed003ff] has been reserved
[    4.224649] system 00:02: Plug and Play ACPI device, IDs PNP0103 PNP0c01 (active)
[    4.224678] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    4.224709] system 00:04: [io  0x1000-0x100f] has been reserved
[    4.224713] system 00:04: [io  0x0400-0x047f] could not be reserved
[    4.224717] system 00:04: [io  0x0500-0x057f] has been reserved
[    4.224721] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.224740] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.224769] pnp 00:06: Plug and Play ACPI device, IDs APP0001 (active)
[    4.224825] pnp 00:07: Plug and Play ACPI device, IDs APP000b (active)
[    4.224950] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    4.224954] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    4.224958] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    4.224962] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    4.224966] system 00:08: [mem 0xe0000000-0xefffffff] could not be reserved
[    4.224970] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    4.224973] system 00:08: [mem 0xfed90000-0xfed93fff] could not be reserved
[    4.224977] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    4.224981] system 00:08: [mem 0xff000000-0xffffffff] could not be reserved
[    4.224985] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    4.224989] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    4.227144] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    4.227149] system 00:09: [mem 0x40000000-0x401fffff] could not be reserved
[    4.227153] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    4.227161] pnp: PnP ACPI: found 10 devices
[    4.227163] ACPI: bus type PNP unregistered
[    4.233618] pci 0000:03:00.0: no compatible bridge window for [mem 0xfffff800-0xffffffff pref]
[    4.233671] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.233676] pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
[    4.233681] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xc10fffff]
[    4.233685] pci 0000:00:01.0:   bridge window [mem 0x90000000-0xa1ffffff 64bit pref]
[    4.233691] pci 0000:00:01.1: PCI bridge to [bus 05-9b]
[    4.233695] pci 0000:00:01.1:   bridge window [io  0x4000-0x6fff]
[    4.233701] pci 0000:00:01.1:   bridge window [mem 0xc1d00000-0xcdffffff]
[    4.233707] pci 0000:00:01.1:   bridge window [mem 0xce000000-0xd9ffffff 64bit pref]
[    4.233715] pci 0000:00:01.2: PCI bridge to [bus 02]
[    4.233721] pci 0000:00:01.2:   bridge window [mem 0xc1b00000-0xc1bfffff]
[    4.233733] pci 0000:03:00.0: BAR 6: assigned [mem 0xc1830000-0xc18307ff pref]
[    4.233738] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    4.233749] pci 0000:00:1c.0:   bridge window [mem 0xc1a00000-0xc1afffff]
[    4.233756] pci 0000:00:1c.0:   bridge window [mem 0xc1800000-0xc18fffff 64bit pref]
[    4.233767] pci 0000:00:1c.1: PCI bridge to [bus 04]
[    4.233775] pci 0000:00:1c.1:   bridge window [mem 0xc1900000-0xc19fffff]
[    4.233790] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.233791] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.233793] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.233795] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    4.233796] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    4.233798] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    4.233799] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    4.233801] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    4.233803] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    4.233804] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    4.233806] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    4.233807] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    4.233809] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    4.233810] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    4.233812] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    4.233813] pci_bus 0000:00: resource 19 [mem 0x000f0000-0x000fffff]
[    4.233815] pci_bus 0000:00: resource 20 [mem 0x8fa00000-0xfeafffff]
[    4.233816] pci_bus 0000:00: resource 21 [mem 0xfed40000-0xfed44fff]
[    4.233818] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    4.233820] pci_bus 0000:01: resource 1 [mem 0xc0000000-0xc10fffff]
[    4.233821] pci_bus 0000:01: resource 2 [mem 0x90000000-0xa1ffffff 64bit pref]
[    4.233823] pci_bus 0000:05: resource 0 [io  0x4000-0x6fff]
[    4.233825] pci_bus 0000:05: resource 1 [mem 0xc1d00000-0xcdffffff]
[    4.233826] pci_bus 0000:05: resource 2 [mem 0xce000000-0xd9ffffff 64bit pref]
[    4.233828] pci_bus 0000:02: resource 1 [mem 0xc1b00000-0xc1bfffff]
[    4.233830] pci_bus 0000:03: resource 1 [mem 0xc1a00000-0xc1afffff]
[    4.233831] pci_bus 0000:03: resource 2 [mem 0xc1800000-0xc18fffff 64bit pref]
[    4.233833] pci_bus 0000:04: resource 1 [mem 0xc1900000-0xc19fffff]
[    4.233923] NET: Registered protocol family 2
[    4.234085] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.234211] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.234337] TCP: Hash tables configured (established 65536 bind 65536)
[    4.234353] TCP: reno registered
[    4.234357] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    4.234376] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    4.234473] NET: Registered protocol family 1
[    4.234490] pci 0000:00:02.0: Boot video device
[    4.234501] pci 0000:00:14.0: enabling device (0000 -> 0002)
[    4.234567] pci 0000:00:14.0: can't derive routing for PCI INT A
[    4.234570] pci 0000:00:14.0: PCI INT A: no GSI
[    4.234670] pci 0000:00:14.0: can't derive routing for PCI INT A
[    4.235037] PCI: CLS 256 bytes, default 64
[    4.235070] Unpacking initramfs...
[    4.506040] Freeing initrd memory: 16340K (ffff880036006000 - ffff880036ffb000)
[    4.506106] DMAR: No ATSR found
[    4.506136] IOMMU 0 0xfed90000: using Queued invalidation
[    4.506140] IOMMU 1 0xfed91000: using Queued invalidation
[    4.506144] IOMMU: Setting RMRR:
[    4.506156] IOMMU: Setting identity map for device 0000:00:02.0 [0x8b800000 - 0x8f9fffff]
[    4.506534] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    4.506544] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[    4.506843] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[    4.509522] Scanning for low memory corruption every 60 seconds
[    4.539053] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.539622] bio: create slab <bio-1> at 1
[    4.539804] Btrfs loaded
[    4.539810] msgmni has been set to 15911
[    4.540067] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    4.540072] io scheduler noop registered
[    4.540074] io scheduler deadline registered
[    4.540101] io scheduler cfq registered (default)
[    4.540243] pcieport 0000:00:01.0: irq 42 for MSI/MSI-X
[    4.540369] pcieport 0000:00:01.1: irq 43 for MSI/MSI-X
[    4.540432] pcieport 0000:00:01.2: enabling device (0000 -> 0002)
[    4.540514] pcieport 0000:00:01.2: irq 44 for MSI/MSI-X
[    4.540664] pcieport 0000:00:1c.0: irq 45 for MSI/MSI-X
[    4.540838] pcieport 0000:00:1c.1: irq 46 for MSI/MSI-X
[    4.540940] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    4.540944] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    4.540947] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    4.540952] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    4.540968] pcieport 0000:00:01.1: Signaling PME through PCIe PME interrupt
[    4.540974] pcie_pme 0000:00:01.1:pcie01: service driver pcie_pme loaded
[    4.540990] pcieport 0000:00:01.2: Signaling PME through PCIe PME interrupt
[    4.540996] pcie_pme 0000:00:01.2:pcie01: service driver pcie_pme loaded
[    4.541020] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    4.541024] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    4.541027] pci 0000:03:00.1: Signaling PME through PCIe PME interrupt
[    4.541037] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    4.541058] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    4.541061] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    4.541071] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    4.541081] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.541102] efifb: probing for efifb
[    4.543978] efifb: framebuffer at 0xb0000000, mapped to 0xffffc90009d00000, using 20736k, total 20736k
[    4.543983] efifb: mode is 2880x1800x32, linelength=11776, pages=1
[    4.543985] efifb: scrolling: redraw
[    4.543988] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    4.553878] Console: switching to colour frame buffer device 360x112
[    4.563389] fb0: EFI VGA frame buffer device
[    4.563411] intel_idle: MWAIT substates: 0x21120
[    4.563412] intel_idle: v0.4 model 0x3A
[    4.563413] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.563636] ACPI: AC Adapter [ADP1] (off-line)
[    4.563732] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    4.563776] ACPI: Lid Switch [LID0]
[    4.563815] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    4.563846] ACPI: Power Button [PWRB]
[    4.563883] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    4.563912] ACPI: Sleep Button [SLPB]
[    4.563950] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    4.563978] ACPI: Power Button [PWRF]
[    4.564030] ACPI: Requesting acpi_cpufreq
[    4.566295] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    4.568247] Linux agpgart interface v0.103
[    4.568285] [drm] Initialized drm 1.1.0 20060810
[    4.569196] [drm] Memory usable by graphics device = 2048M
[    4.569219] checking generic (b0000000 1440000) vs hw (b0000000 10000000)
[    4.569220] fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver
[    4.569255] Console: switching to colour dummy device 80x25
[    4.569361] i915 0000:00:02.0: setting latency timer to 64
[    4.606081] i915 0000:00:02.0: irq 47 for MSI/MSI-X
[    4.606087] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.606091] [drm] Driver supports precise vblank timestamp query.
[    4.606099] i915 0000:00:02.0: Invalid ROM contents
[    4.606102] [drm] failed to find VBIOS tables
[    4.606186] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=none
[    4.651597] parse error at position 4 in video mode 'efifb'
[    4.651603] parse error at position 4 in video mode 'efifb'
[    4.651647] ACPI: Battery Slot [BAT0] (battery present)
[    4.731004] [drm] GMBUS [i915 gmbus vga] timed out, falling back to bit banging on pin 2
[    4.777464] fbcon: inteldrmfb (fb0) is primary device
[    5.501652] tsc: Refined TSC clocksource calibration: 2394.560 MHz
[    6.032295] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    6.502566] Switched to clocksource tsc
[    6.920060] Console: switching to colour frame buffer device 360x112
[    6.936893] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    6.936934] i915 0000:00:02.0: registered panic notifier
[    6.937177] [Firmware Bug]: ACPI(GFX0) defines _DOD but not _DOS
[    6.938517] acpi device:03: registered as cooling_device8
[    6.938561] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[    6.938644] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/LNXVIDEO:00/input/input4
[    6.993881] acpi device:21: registered as cooling_device9
[    6.994086] ACPI: Video Device [IGPU] (multi-head: yes  rom: no  post: no)
[    6.994171] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
[    6.994246] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    6.994320] ACPI Warning: \_SB_.PCI0.IGPU._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130725/nsarguments-95)
[    6.994422] ACPI Warning: \_SB_.PCI0.IGPU._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
[    6.994521] ACPI Warning: \_SB_.PCI0.P0P2.GFX0._DSM: Argument #4 type mismatch - Found [Integer], ACPI requires [Package] (20130725/nsarguments-95)
[    6.994618] ACPI Warning: \_SB_.PCI0.P0P2.GFX0._DSM: Argument #4 type mismatch - Found [Buffer], ACPI requires [Package] (20130725/nsarguments-95)
[    6.994741] nouveau 0000:01:00.0: enabling device (0006 -> 0007)
[    6.995193] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e7150a2
[    6.995235] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
[    6.995289] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
[    6.998261] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    7.085299] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    7.085342] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
[    7.085563] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    7.085604] nouveau  [   VBIOS][0000:01:00.0] version 80.07.26.04.01
[    7.086206] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
[    7.086245] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
[    7.086285] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    7.117923] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
[    7.117976] nouveau  [  PTHERM][0000:01:00.0] fan management: disabled
[    7.118029] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    7.152816] [TTM] Zone  kernel: Available graphics memory: 4073432 kiB
[    7.152860] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    7.152901] [TTM] Initializing pool allocator
[    7.152934] [TTM] Initializing DMA pool allocator
[    7.152973] nouveau  [     DRM] VRAM: 1024 MiB
[    7.153004] nouveau  [     DRM] GART: 1048576 MiB
[    7.153039] nouveau  [     DRM] TMDS table version 2.0
[    7.153078] nouveau  [     DRM] DCB version 4.0
[    7.153111] nouveau  [     DRM] DCB outp 00: 048101b6 0f230010
[    7.153151] nouveau  [     DRM] DCB outp 01: 018212d6 0f220020
[    7.153190] nouveau  [     DRM] DCB outp 02: 01021212 00020020
[    7.153229] nouveau  [     DRM] DCB outp 03: 088324c6 0f220010
[    7.153268] nouveau  [     DRM] DCB outp 04: 08032402 00020010
[    7.153307] nouveau  [     DRM] DCB outp 05: 02843862 00020010
[    7.153346] nouveau  [     DRM] DCB conn 00: 00020047
[    7.153386] nouveau  [     DRM] DCB conn 01: 02208146
[    7.153434] nouveau  [     DRM] DCB conn 02: 01104246
[    7.153482] nouveau  [     DRM] DCB conn 03: 00410361
[    7.155079] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    7.155122] [drm] No driver support for vblank timestamp query.
[    7.155162] nouveau  [     DRM] ACPI backlight interface available, not registering our own
[    7.155243] nouveau W[     DRM] voltage table 0x50 unknown
[    7.155284] nouveau  [     DRM] 4 available performance level(s)
[    7.155326] nouveau  [     DRM] 1: core 209MHz shader 419MHz memory 405MHz voltage 520mV
[    7.155378] nouveau  [     DRM] 2: core 390MHz shader 780MHz memory 1080MHz voltage 610mV
[    7.155430] nouveau  [     DRM] 3: core 1000MHz shader 2000MHz memory 1080MHz voltage 630mV
[    7.155482] nouveau  [     DRM] 4: core 1254MHz shader 2508MHz memory 1080MHz voltage 630mV
[    7.155533] nouveau  [     DRM] c:
[    7.167235] nouveau  [     DRM] MM: using COPY for buffer copies
[    7.167280] parse error at position 4 in video mode 'efifb'
[    7.167317] parse error at position 4 in video mode 'efifb'
[    7.167353] parse error at position 4 in video mode 'efifb'
[    7.167390] parse error at position 4 in video mode 'efifb'
[    7.201313] nouveau 0000:01:00.0: No connectors reported connected with modes
[    7.201359] [drm] Cannot find any crtc or sizes - going 1024x768
[    7.233400] nouveau  [     DRM] allocated 1024x768 fb: 0x80000, bo ffff88026277ac00
[    7.233489] nouveau 0000:01:00.0: fb1: nouveaufb frame buffer device
[    7.233532] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 1
[    7.233709] ahci 0000:00:1f.2: version 3.0
[    7.233834] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    7.233897] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1 impl SATA mode
[    7.233950] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    7.234005] ahci 0000:00:1f.2: setting latency timer to 64
[    7.234557] scsi0 : ahci
[    7.234697] scsi1 : ahci
[    7.234795] scsi2 : ahci
[    7.234893] scsi3 : ahci
[    7.234991] scsi4 : ahci
[    7.235085] scsi5 : ahci
[    7.235148] ata1: SATA max UDMA/133 abar m2048@0xc1c16000 port 0xc1c16100 irq 48
[    7.235196] ata2: DUMMY
[    7.235216] ata3: DUMMY
[    7.238672] ata4: DUMMY
[    7.242141] ata5: DUMMY
[    7.244855] ata6: DUMMY
[    7.247682] libphy: Fixed MDIO Bus: probed
[    7.250454] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    7.593434] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    7.595988] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    7.598177] ata1.00: ATA-8: APPLE SSD SM256E, CXM09A1Q, max UDMA/133
[    7.600301] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    7.602669] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    7.604928] ata1.00: configured for UDMA/133
[    7.607229] scsi 0:0:0:0: Direct-Access     ATA      APPLE SSD SM256E CXM0 PQ: 0 ANSI: 5
[    7.609540] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.609564] sd 0:0:0:0: [sda] 490234752 512-byte logical blocks: (251 GB/233 GiB)
[    7.609565] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    7.609601] sd 0:0:0:0: [sda] Write Protect is off
[    7.609603] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.609614] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.622190]  sda: sda1 sda2 sda3 sda4 sda5 sda6 sda7 sda8
[    7.625127] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.354323] i8042: No controller found
[    8.356647] mousedev: PS/2 mouse device common for all mice
[    8.359219] rtc_cmos 00:05: RTC can wake from S4
[    8.361544] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    8.363776] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    8.365995] Intel P-state driver initializing.
[    8.368204] Intel pstate controlling: cpu 0
[    8.370399] Intel pstate controlling: cpu 1
[    8.372584] Intel pstate controlling: cpu 2
[    8.374752] Intel pstate controlling: cpu 3
[    8.376911] Intel pstate controlling: cpu 4
[    8.379054] Intel pstate controlling: cpu 5
[    8.381195] Intel pstate controlling: cpu 6
[    8.383320] Intel pstate controlling: cpu 7
[    8.385446] EFI Variables Facility v0.08 2004-May-17
[    8.500853] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[    8.500938] TCP: cubic registered
[    8.505204] NET: Registered protocol family 10
[    8.507018] NET: Registered protocol family 17
[    8.508712] Key type dns_resolver registered
[    8.510566] registered taskstats version 1
[    8.512768] rtc_cmos 00:05: setting system clock to 2013-10-25 12:08:27 UTC (1382702907)
[    8.514754] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    8.516510] EDD information not available.
[    8.518808] Freeing unused kernel memory: 1080K (ffffffff81cd0000 - ffffffff81dde000)
[    8.520533] Write protecting the kernel read-only data: 12288k
[    8.524362] Freeing unused kernel memory: 1256K (ffff8800016c6000 - ffff880001800000)
[    8.527873] Freeing unused kernel memory: 1176K (ffff880001ada000 - ffff880001c00000)
[    8.539879] udevd[106]: starting version 175
[    8.543132] nbd: registered device at major 43
[    8.582402] btrfs: device fsid 155031fa-2d06-4dc0-91bf-eaaf7ea778fb devid 1 transid 166620 /dev/sda6
[    8.582475] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    8.582476] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    8.582503] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    8.582506] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    8.582510] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    8.582626] xhci_hcd 0000:00:14.0: cache line size of 256 is not supported
[    8.582647] xhci_hcd 0000:00:14.0: irq 49 for MSI/MSI-X
[    8.582801] hub 1-0:1.0: USB hub found
[    8.582812] hub 1-0:1.0: 4 ports detected
[    8.582961] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    8.582963] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    8.583058] hub 2-0:1.0: USB hub found
[    8.583068] hub 2-0:1.0: 4 ports detected
[    8.609225] sdhci: Secure Digital Host Controller Interface driver
[    8.609437] btrfs: device fsid 2eaa6f0b-87ef-4642-94ae-ead227633648 devid 1 transid 255446 /dev/sda7
[    8.613014] sdhci: Copyright(c) Pierre Ossman
[    8.615255] sdhci-pci 0000:03:00.1: SDHCI controller found [14e4:16bc] (rev 10)
[    8.617301] sdhci-pci 0000:03:00.1: enabling device (0000 -> 0002)
[    8.617496] mmc0: SDHCI controller on PCI [0000:03:00.1] using ADMA
[    8.624980] btrfs: device fsid 155031fa-2d06-4dc0-91bf-eaaf7ea778fb devid 1 transid 166620 /dev/sda6
[    8.643452] Btrfs detected SSD devices, enabling SSD mode
[    8.758696] init: ureadahead main process (291) terminated with status 5
[    8.819904] Adding 4093744k swap on /dev/sda8.  Priority:-1 extents:1 across:4093744k SS
[    9.385918] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[    9.390906] btrfs: device fsid 2eaa6f0b-87ef-4642-94ae-ead227633648 devid 1 transid 255446 /dev/sda7
[    9.450891] Btrfs detected SSD devices, enabling SSD mode
[    9.502448] RPC: Registered named UNIX socket transport module.
[    9.502451] RPC: Registered udp transport module.
[    9.502452] RPC: Registered tcp transport module.
[    9.502452] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    9.535400] udevd[438]: starting version 175
[    9.565343] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    9.673550] init: avahi-cups-reload main process (566) terminated with status 1
[    9.674654] Bluetooth: Core ver 2.16
[    9.674671] NET: Registered protocol family 31
[    9.674673] Bluetooth: HCI device and connection manager initialized
[    9.674680] Bluetooth: HCI socket layer initialized
[    9.674682] Bluetooth: L2CAP socket layer initialized
[    9.674690] Bluetooth: SCO socket layer initialized
[    9.676713] apple_gmux: Found gmux version 3.2.19 [indexed]
[    9.678201] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.681230] ehci-pci: EHCI PCI platform driver
[    9.681368] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    9.681382] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    9.681389] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    9.681407] ehci-pci 0000:00:1a.0: debug port 2
[    9.685353] ehci-pci 0000:00:1a.0: cache line size of 256 is not supported
[    9.685374] ehci-pci 0000:00:1a.0: irq 23, io mem 0xc1c16c00
[    9.705236] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    9.705483] hub 3-0:1.0: USB hub found
[    9.705490] hub 3-0:1.0: 2 ports detected
[    9.705700] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    9.705705] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    9.705708] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 4
[    9.705724] ehci-pci 0000:00:1d.0: debug port 2
[    9.709648] ehci-pci 0000:00:1d.0: cache line size of 256 is not supported
[    9.709666] ehci-pci 0000:00:1d.0: irq 22, io mem 0xc1c16800
[    9.725247] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    9.725418] hub 4-0:1.0: USB hub found
[    9.725427] hub 4-0:1.0: 2 ports detected
[    9.725805] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    9.726100] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
[    9.740971] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    9.756044] applesmc: key=493 fan=2 temp=44 index=43 acc=0 lux=2 kbd=1
[    9.767382] snd_hda_intel 0000:01:00.1: enabling device (0000 -> 0002)
[    9.767450] hda_intel: Disabling MSI
[    9.767456] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[    9.838063] init: failsafe main process (726) killed by TERM signal
[    9.855434] vga_switcheroo: enabled
[   10.025529] usb 3-1: new high-speed USB device number 2 using ehci-pci
[   10.176245] hub 3-1:1.0: USB hub found
[   10.176331] hub 3-1:1.0: 6 ports detected
[   10.295743] usb 4-1: new high-speed USB device number 2 using ehci-pci
[   10.446609] hub 4-1:1.0: USB hub found
[   10.446704] hub 4-1:1.0: 8 ports detected
[   10.526008] usb 3-1.1: new high-speed USB device number 3 using ehci-pci
[   10.586187] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input7
[   10.586295] input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input8
[   10.736322] usb 4-1.8: new high-speed USB device number 3 using ehci-pci
[   10.833230] hda-intel 0000:01:00.1: Disabling via VGA-switcheroo
[   10.847051] hub 4-1.8:1.0: USB hub found
[   10.847147] hub 4-1.8:1.0: 2 ports detected
[   10.967090] VGA switcheroo: switched nouveau off
[   10.969314] nouveau  [     DRM] suspending display...
[   10.969341] nouveau  [     DRM] unpinning framebuffer(s)...
[   10.969419] nouveau  [     DRM] evicting buffers...
[   10.971640] nouveau  [     DRM] waiting for kernel channels to go idle...
[   10.971655] nouveau  [     DRM] suspending client object trees...
[   10.977175] nouveau  [     DRM] suspending kernel object tree...
[   11.126538] usb 4-1.8.1: new full-speed USB device number 4 using ehci-pci
[   11.239149] hub 4-1.8.1:1.0: USB hub found
[   11.239231] hub 4-1.8.1:1.0: 3 ports detected
[   11.316694] usb 4-1.8.2: new full-speed USB device number 5 using ehci-pci
[   11.443396] input: bcm5974 as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.2/4-1.8.2:1.2/input/input9
[   11.443482] usbcore: registered new interface driver bcm5974
[   11.446364] hidraw: raw HID events driver (C) Jiri Kosina
[   11.455718] usbcore: registered new interface driver usbhid
[   11.455720] usbhid: USB HID core driver
[   11.463233] input: Apple Inc. Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.2/4-1.8.2:1.0/input/input10
[   11.463328] apple 0003:05AC:0262.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-1.8.2/input0
[   11.516863] usb 4-1.8.1.1: new full-speed USB device number 6 using ehci-pci
[   11.552935] apple 0003:05AC:0262.0002: hidraw1: USB HID v1.11 Device [Apple Inc. Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-1.8.2/input1
[   11.707023] usb 4-1.8.1.2: new full-speed USB device number 7 using ehci-pci
[   11.897162] usb 4-1.8.1.3: new full-speed USB device number 8 using ehci-pci
[   12.018675] input: HID 05ac:820a as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.1/4-1.8.1.1/4-1.8.1.1:1.0/input/input11
[   12.018762] hid-generic 0003:05AC:820A.0003: input,hidraw2: USB HID v1.11 Keyboard [HID 05ac:820a] on usb-0000:00:1d.0-1.8.1.1/input0
[   12.018832] input: HID 05ac:820b as /devices/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.8/4-1.8.1/4-1.8.1.2/4-1.8.1.2:1.0/input/input12
[   12.018941] hid-generic 0003:05AC:820B.0004: input,hidraw3: USB HID v1.11 Mouse [HID 05ac:820b] on usb-0000:00:1d.0-1.8.1.2/input0
[   12.026813] usbcore: registered new interface driver btusb
[   12.148020] usb 4-1.8.1.1: USB disconnect, device number 6
[   12.448025] usb 4-1.8.1.2: USB disconnect, device number 7
[   12.471515] init: plymouth-stop pre-start process (1835) terminated with status 1
[   18.625956] fuse init (API version 7.22)
[   18.952340] nouveau E[     I2C][0000:01:00.0] AUXCH(3): begin idle timeout 0xffffffff
[   18.954386] nouveau E[     I2C][0000:01:00.0] AUXCH(2): begin idle timeout 0xffffffff
[   18.957351] nouveau E[     I2C][0000:01:00.0] AUXCH(1): begin idle timeout 0xffffffff

-- 
Jens Axboe

