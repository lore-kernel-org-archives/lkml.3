Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917AbaDJKns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:43:48 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50894 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965718AbaDJKnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:43:45 -0400
From: Koen Kooi <koen@dominion.thruhere.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table" breaks boot on thinkpad t440s
Message-Id: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
Date: Thu, 10 Apr 2014 12:43:43 +0200
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Kees Cook <keescook@chromium.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After updating from 3.14-rc7 to a recent git the kernel fails to boot on my thinkpad t440s and displays:

	Failed to get file info size
	Failed to alloc highmem for files

After a morning of running git bisect and rebooting, the bad commit seems to be:

	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table

It doesn't revert cleanly, so I can't test current git without it to see if that fixes it or not. I'm using gummiboot as bootloader:

Boot Loader Binaries:
          ESP: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca15
         File: └─/EFI/gummiboot/gummibootx64.efi (gummiboot 44)
         File: └─/EFI/Boot/BOOTX64.EFI (gummiboot 44)

Boot Loader Entries in EFI Variables:
        Title: Linux Boot Manager
           ID: 0x0016
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/b7b4fad3-3d19-40fd-b341-0ec7f2152b81
         File: └─/EFI/gummiboot/gummibootx64.efi

        Title: Linux Boot Manager
           ID: 0x0015
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca15
         File: └─/EFI/gummiboot/gummibootx64.efi

        Title: Fedora
           ID: 0x0014
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/47cab2d9-0641-476c-bc74-166b122fca15
         File: └─/EFI/fedora/shim.efi

        Title: Windows Boot Manager
           ID: 0x0013
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/56dff960-86b5-4846-89d3-fed0620f471a
         File: └─/EFI/Microsoft/Boot/bootmgfw.efi

thanks,

Koen

Bisect log:

git bisect start
# good: [dcb99fd9b08cfe1afe426af4d8d3cbc429190f15] Linux 3.14-rc7
git bisect good dcb99fd9b08cfe1afe426af4d8d3cbc429190f15
# bad: [39de65aa2c3eee901db020a4f1396998e09602a3] Merge branch 'i2c/for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect bad 39de65aa2c3eee901db020a4f1396998e09602a3
# bad: [ec0159503ae74aeb834e78366bdf4b9663ca1129] hwmon: (k10temp) Add support for AMD F16 M30h processor
git bisect bad ec0159503ae74aeb834e78366bdf4b9663ca1129
# bad: [675c354a95d5375153b8bb80a0448cab916c7991] Merge tag 'char-misc-3.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc
git bisect bad 675c354a95d5375153b8bb80a0448cab916c7991
# bad: [3786075b5ebc8c4eaefd9e3ebf72883934fb64b3] Merge tag 'regulator-v3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
git bisect bad 3786075b5ebc8c4eaefd9e3ebf72883934fb64b3
# bad: [1ce235faa8fefa4eb7199cad890944c1d2ba1b3e] Merge tag 'arm64-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect bad 1ce235faa8fefa4eb7199cad890944c1d2ba1b3e
# good: [8c292f11744297dfb3a69f4a0bccbe4a6417b50d] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 8c292f11744297dfb3a69f4a0bccbe4a6417b50d
# bad: [e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0] Merge branch 'x86-kaslr-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
# good: [971eae7c99212dd67b425a603f1fe3b763359907] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 971eae7c99212dd67b425a603f1fe3b763359907
# bad: [204b0a1a4b92612c957a042df1a3be0e9cc79391] x86, efi: Abstract x86 efi_early calls
git bisect bad 204b0a1a4b92612c957a042df1a3be0e9cc79391
# bad: [3db4cafdfd05717dc939780134e53023a3c1f15f] x86/boot: Fix non-EFI build
git bisect bad 3db4cafdfd05717dc939780134e53023a3c1f15f
# bad: [0154416a71c2a84c3746c8dd8ed25287e36934d3] x86/efi: Add early thunk code to go from 64-bit to 32-bit
git bisect bad 0154416a71c2a84c3746c8dd8ed25287e36934d3
# good: [426e34cc4f6094cefe4f3175764cdf583128e7cd] x86/mm/pageattr: Always dump the right page table in an oops
git bisect good 426e34cc4f6094cefe4f3175764cdf583128e7cd
# good: [677703cef0a148ba07d37ced649ad25b1cda2f78] efi: Add separate 32-bit/64-bit definitions
git bisect good 677703cef0a148ba07d37ced649ad25b1cda2f78

Build command line:

cp defconfig-3.13 .config ; yes '' | make oldconfig ; make bzImage -j4 && sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-3.14 && sudo reboot