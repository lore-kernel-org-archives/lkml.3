Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaHaXvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:51:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46595 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaHaXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:51:20 -0400
Date: Sun, 31 Aug 2014 16:51:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Status of 'unicore32' architecture in Linux kernel
Message-ID: <20140831235115.GA6248@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Status of 'unicore32' architecture in Linux kernel
--------------------------------------------------

The idea was to create a working kernel and initramfs for the ongoing Linux
kernel test project. This summary describes the result of this effort.

Overall, conclusion is that the architecture would need some work
(both in qemu and the kernel itself) to make it testable with qemu.

Guenter

---------------------
Toolchain used was from [1]. I did not attempt to build my own toolchain.

Configuration:

make ARCH=unicore32 defconfig && make ARCH=unicore32

This configuration currently fails to build in the upstream kernel.
A patch to fix the problem has been submitted and is pending upstream
integration [2]. With this patch merged, the 'defconfig' image can
be built.

----------------
qemu

Attempts to load the unicore32:defconfig image with qemu failed.

Research points to [3], which includes a working unicore32 linux kernel
in its linux repository [4], in branch unicore32-working. This branch
includes a working unicore32 qemu configuration. It also includes
a critical patch which is not available in the upstream kernel.

unicore32: Add ocd console and qemu-defconfig to support qemu simulator
	This patch adds a primitive OCD console to communicate with qemu.
	The same code is already used for early console support.

With this patch added, and with qemu_defconfig as provided by the same patch,
it is possible to build and load a unicore32 image in qemu using the following
qemu command line.

qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage

Caveats:
- The use of -nographic instead of -curses causes a qemu crash
- The qemu emulation only accepts a built-in initramfs.
- The only working image is arch/unicore32/boot/zImage.
  All other variants, arch/unicore32/boot/Image and vmlinux, cause a crash.
  The same (or a similar) crash is also seen if I don't provide a built-in
  kernel command line and try to load zImage.
- There is no networking. There is another patch in the github linux
  respository [4] which is not available upstream. The driver was submitted
  for integration back in 2011 [5] but it was never accepted or merged.

------------------------
[1] http://mprc.pku.edu.cn/~guanxuetao/linux/
[2] https://lkml.org/lkml/2014/8/31/86
[3] https://github.com/gxt
[4] git://github.com/gxt/linux.git
[5] https://lkml.org/lkml/2011/5/27/17
