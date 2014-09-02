Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaIBOEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:04:06 -0400
Received: from mx8.pku.edu.cn ([162.105.129.171]:60256 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbaIBOEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:04:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.323
Date: Tue, 2 Sep 2014 22:03:48 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <1418547425.30923.1409666628661.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140831235115.GA6248@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Status_of_'unicore32'_a?=
 =?utf-8?Q?rchitecture_in_Linux_kernel?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply.

----- Guenter Roeck <linux@roeck-us.net> 写道：
> Status of 'unicore32' architecture in Linux kernel
> --------------------------------------------------
> 
> The idea was to create a working kernel and initramfs for the ongoing Linux
> kernel test project. This summary describes the result of this effort.
> 
> Overall, conclusion is that the architecture would need some work
> (both in qemu and the kernel itself) to make it testable with qemu.

Great. And there's a lot of work to do for unicore32.

> 
> Guenter
> 
> ---------------------
> Toolchain used was from [1]. I did not attempt to build my own toolchain.
> 
> Configuration:
> 
> make ARCH=unicore32 defconfig && make ARCH=unicore32
> 
> This configuration currently fails to build in the upstream kernel.
> A patch to fix the problem has been submitted and is pending upstream
> integration [2]. With this patch merged, the 'defconfig' image can
> be built.

Thanks. I'll apply it in my repo.

> 
> ----------------
> qemu
> 
> Attempts to load the unicore32:defconfig image with qemu failed.
> 
> Research points to [3], which includes a working unicore32 linux kernel
> in its linux repository [4], in branch unicore32-working. This branch
> includes a working unicore32 qemu configuration. It also includes
> a critical patch which is not available in the upstream kernel.

Yes. And these patches need to be reviewed and reconsidered.
I'll try to do that in this month.

> 
> unicore32: Add ocd console and qemu-defconfig to support qemu simulator
> 	This patch adds a primitive OCD console to communicate with qemu.
> 	The same code is already used for early console support.

Do you mean there's the same/similar code in QEMU.

> 
> With this patch added, and with qemu_defconfig as provided by the same patch,
> it is possible to build and load a unicore32 image in qemu using the following
> qemu command line.
> 
> qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
> 
> Caveats:
> - The use of -nographic instead of -curses causes a qemu crash
Yes, since qemu curses code was modified to meet the simple OCD console requirement.

> - The qemu emulation only accepts a built-in initramfs.
Yes, github version only support built-in initramfs.
NFS+LFS could be also supported, and puv3-pci sim should be added at first.

> - The only working image is arch/unicore32/boot/zImage.
>   All other variants, arch/unicore32/boot/Image and vmlinux, cause a crash.
>   The same (or a similar) crash is also seen if I don't provide a built-in
>   kernel command line and try to load zImage.
Sorry for that. That should be fixed.

> - There is no networking. There is another patch in the github linux
>   respository [4] which is not available upstream. The driver was submitted
>   for integration back in 2011 [5] but it was never accepted or merged.
Yes, exactly.
Thanks Guenter.

> 
> ------------------------
> [1] http://mprc.pku.edu.cn/~guanxuetao/linux/
> [2] https://lkml.org/lkml/2014/8/31/86
> [3] https://github.com/gxt
> [4] git://github.com/gxt/linux.git
> [5] https://lkml.org/lkml/2011/5/27/17

