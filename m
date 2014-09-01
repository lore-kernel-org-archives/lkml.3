Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaIADzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:55:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51468 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaIADzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:55:17 -0400
Message-ID: <5403EF50.3080706@gmail.com>
Date: Mon, 01 Sep 2014 12:00:16 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, Grant Likely <grant.likely@linaro.org>
Subject: Re: Status of 'unicore32' architecture in Linux kernel
References: <20140831235115.GA6248@roeck-us.net>
In-Reply-To: <20140831235115.GA6248@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Firstly, what you have done encourage me, thanks.

On 9/1/14 7:51, Guenter Roeck wrote:
> Status of 'unicore32' architecture in Linux kernel
> --------------------------------------------------
> 
> The idea was to create a working kernel and initramfs for the ongoing Linux
> kernel test project. This summary describes the result of this effort.
> 
> Overall, conclusion is that the architecture would need some work
> (both in qemu and the kernel itself) to make it testable with qemu.
> 
> Guenter
> 
> ---------------------
> Toolchain used was from [1]. I did not attempt to build my own toolchain.
> 

I also use it, but for me, hope we can use an open source toolchain for
it, in the future. If possible, I will be glad to join for it (develop
open source unicore32 gcc cross compiler with other related members).

> Configuration:
> 
> make ARCH=unicore32 defconfig && make ARCH=unicore32
> 
> This configuration currently fails to build in the upstream kernel.
> A patch to fix the problem has been submitted and is pending upstream
> integration [2]. With this patch merged, the 'defconfig' image can
> be built.
> 

Thank you for what you have done.

> ----------------
> qemu
> 
> Attempts to load the unicore32:defconfig image with qemu failed.
> 
> Research points to [3], which includes a working unicore32 linux kernel
> in its linux repository [4], in branch unicore32-working. This branch
> includes a working unicore32 qemu configuration. It also includes
> a critical patch which is not available in the upstream kernel.
> 
> unicore32: Add ocd console and qemu-defconfig to support qemu simulator
> 	This patch adds a primitive OCD console to communicate with qemu.
> 	The same code is already used for early console support.
> 
> With this patch added, and with qemu_defconfig as provided by the same patch,
> it is possible to build and load a unicore32 image in qemu using the following
> qemu command line.
> 
> qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
> 

For me, hope they also can be merged into upstream main line, next.

> Caveats:
> - The use of -nographic instead of -curses causes a qemu crash
> - The qemu emulation only accepts a built-in initramfs.
> - The only working image is arch/unicore32/boot/zImage.
>   All other variants, arch/unicore32/boot/Image and vmlinux, cause a crash.
>   The same (or a similar) crash is also seen if I don't provide a built-in
>   kernel command line and try to load zImage.
> - There is no networking. There is another patch in the github linux
>   respository [4] which is not available upstream. The driver was submitted
>   for integration back in 2011 [5] but it was never accepted or merged.
> 

For me, suggest also Cc to qemu-devel@nongnu.org, and gxt is the related
maintainer for qemu unicore32, too.

In the future (maybe several months later), I am glad to try to analyze
these caveats (but excuse me, at present, I have no enough time resource
on it).


> [1] http://mprc.pku.edu.cn/~guanxuetao/linux/
> [2] https://lkml.org/lkml/2014/8/31/86
> [3] https://github.com/gxt
> [4] git://github.com/gxt/linux.git
> [5] https://lkml.org/lkml/2011/5/27/17
> 

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
