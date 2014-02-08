Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaBHDj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:39:27 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55924 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaBHDj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:39:26 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F5A6EE.7020000@roeck-us.net>
Date: Fri, 07 Feb 2014 19:39:26 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux MIPS Mailing List <linux-mips@linux-mips.org>
CC: Paul Burton <paul.burton@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Commit 597ce1723 (MIPS: Support for 64-bit FP with O32 binaries)
 causing qemu hang with mips64 kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

in 3.14-rc1, my mips64 qemu test fails. The image boots and then hangs.
Bisect points to commit 597ce1723 (MIPS: Support for 64-bit FP with O32 binaries).
Reverting this commit fixes the problem. Disabling MIPS_O32_FP64_SUPPORT
in my test image does _not_ solve the problem. The qemu version does not seem
to make a difference; I tested with qemu 1.6.0 and 1.7.0.

Console log output is available in
http://server.roeck-us.net:8010/builders/qemu-mips64-master/builds/34/steps/buildcommand/logs/stdio

When the problem is seen, the emulation hangs as can be seen in the log,
and the qemu process consumes 100% CPU until it is killed.

qemu command line is

qemu-system-mips64 -kernel vmlinux -M malta -hda core-image-minimal-qemumips64.ext3 \
-vga cirrus -usb -usbdevice wacom-tablet -no-reboot -m 128 --append "root=/dev/hda \
rw mem=128M console=ttyS0 console=tty" -nographic

The same configuration works fine with earlier kernels. I'll be happy to provide
the detailed configuration as well as the root file system for testing if needed.

Obviously I have no idea if this is a problem with the patch or with qemu.
If there is anything I can do to help tracking down the problem further,
please let me know.

Thanks,
Guenter
