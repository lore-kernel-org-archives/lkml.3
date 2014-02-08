Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaBHD5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:57:54 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48904 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaBHD5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:57:53 -0500
MIME-Version: 1.0
In-Reply-To: <52F5A6EE.7020000@roeck-us.net>
References: <52F5A6EE.7020000@roeck-us.net>
Date: Sat, 8 Feb 2014 11:57:52 +0800
Message-ID: <CAAhV-H7GbarXPb2uye1jiH+caAL4vWTVBeGY77Yf0tvdpGJtiA@mail.gmail.com>
Subject: Re: Commit 597ce1723 (MIPS: Support for 64-bit FP with O32 binaries)
 causing qemu hang with mips64 kernels
From: Huacai Chen <chenhuacai@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maybe you can try this:
http://patchwork.linux-mips.org/patch/6506/
http://patchwork.linux-mips.org/patch/6507/

On Sat, Feb 8, 2014 at 11:39 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Hi all,
>
> in 3.14-rc1, my mips64 qemu test fails. The image boots and then hangs.
> Bisect points to commit 597ce1723 (MIPS: Support for 64-bit FP with O32
> binaries).
> Reverting this commit fixes the problem. Disabling MIPS_O32_FP64_SUPPORT
> in my test image does _not_ solve the problem. The qemu version does not
> seem
> to make a difference; I tested with qemu 1.6.0 and 1.7.0.
>
> Console log output is available in
> http://server.roeck-us.net:8010/builders/qemu-mips64-master/builds/34/steps/buildcommand/logs/stdio
>
> When the problem is seen, the emulation hangs as can be seen in the log,
> and the qemu process consumes 100% CPU until it is killed.
>
> qemu command line is
>
> qemu-system-mips64 -kernel vmlinux -M malta -hda
> core-image-minimal-qemumips64.ext3 \
> -vga cirrus -usb -usbdevice wacom-tablet -no-reboot -m 128 --append
> "root=/dev/hda \
> rw mem=128M console=ttyS0 console=tty" -nographic
>
> The same configuration works fine with earlier kernels. I'll be happy to
> provide
> the detailed configuration as well as the root file system for testing if
> needed.
>
> Obviously I have no idea if this is a problem with the patch or with qemu.
> If there is anything I can do to help tracking down the problem further,
> please let me know.
>
> Thanks,
> Guenter
>
