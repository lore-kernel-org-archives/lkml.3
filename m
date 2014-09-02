Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaIBP7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:59:02 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45438 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaIBP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:59:00 -0400
Date: Tue, 2 Sep 2014 08:58:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Xuetao Guan <gxt@pku.edu.cn>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: =?utf-8?B?5Zue5aSN?= =?utf-8?B?77ya?= Status of 'unicore32'
 architecture in Linux kernel
Message-ID: <20140902155856.GA16029@roeck-us.net>
References: <20140831235115.GA6248@roeck-us.net>
 <1418547425.30923.1409666628661.JavaMail.root@bj-mail03.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418547425.30923.1409666628661.JavaMail.root@bj-mail03.pku.edu.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 10:03:48PM +0800, Xuetao Guan  wrote:
> Sorry for late reply.
> 
> ----- Guenter Roeck <linux@roeck-us.net> 写道：
> > Status of 'unicore32' architecture in Linux kernel
> > --------------------------------------------------
> > 
> > The idea was to create a working kernel and initramfs for the ongoing Linux
> > kernel test project. This summary describes the result of this effort.
> > 
> > Overall, conclusion is that the architecture would need some work
> > (both in qemu and the kernel itself) to make it testable with qemu.
> 
> Great. And there's a lot of work to do for unicore32.
> 
> > 
> > Guenter
> > 
> > ---------------------
> > Toolchain used was from [1]. I did not attempt to build my own toolchain.
> > 
> > Configuration:
> > 
> > make ARCH=unicore32 defconfig && make ARCH=unicore32
> > 
> > This configuration currently fails to build in the upstream kernel.
> > A patch to fix the problem has been submitted and is pending upstream
> > integration [2]. With this patch merged, the 'defconfig' image can
> > be built.
> 
> Thanks. I'll apply it in my repo.
> 
Linus already accepted the patch upstream after I sent it to him directly,
so this problem has been solved by now.

> > 
> > ----------------
> > qemu
> > 
> > Attempts to load the unicore32:defconfig image with qemu failed.
> > 
> > Research points to [3], which includes a working unicore32 linux kernel
> > in its linux repository [4], in branch unicore32-working. This branch
> > includes a working unicore32 qemu configuration. It also includes
> > a critical patch which is not available in the upstream kernel.
> 
> Yes. And these patches need to be reviewed and reconsidered.
> I'll try to do that in this month.
> 
> > 
> > unicore32: Add ocd console and qemu-defconfig to support qemu simulator
> > 	This patch adds a primitive OCD console to communicate with qemu.
> > 	The same code is already used for early console support.
> 
> Do you mean there's the same/similar code in QEMU.
> 
No, I mean that the ocd functions in the linux kernel (such as ocd_putc) are
used by both earlyprintk and the ocd console code.

> > 
> > With this patch added, and with qemu_defconfig as provided by the same patch,
> > it is possible to build and load a unicore32 image in qemu using the following
> > qemu command line.
> > 
> > qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
> > 
> > Caveats:
> > - The use of -nographic instead of -curses causes a qemu crash
> Yes, since qemu curses code was modified to meet the simple OCD console requirement.
> 
The lack of support for -nographic is a problem for scripted testing.
The issue is that we have to interpret console output for scripted testing,
and having to go through curses makes that a bit difficult.

Wonder if '-nographic' can be modeled as '-curses' with no available terminal
configuration. At least in theory that should work, but executing the above
command with TERM=dumb yields no output. Wonder how difficult it would be to
change that.

> > - The qemu emulation only accepts a built-in initramfs.
> Yes, github version only support built-in initramfs.
> NFS+LFS could be also supported, and puv3-pci sim should be added at first.
> 
> > - The only working image is arch/unicore32/boot/zImage.
> >   All other variants, arch/unicore32/boot/Image and vmlinux, cause a crash.
> >   The same (or a similar) crash is also seen if I don't provide a built-in
> >   kernel command line and try to load zImage.
> Sorry for that. That should be fixed.
> 
> > - There is no networking. There is another patch in the github linux
> >   respository [4] which is not available upstream. The driver was submitted
> >   for integration back in 2011 [5] but it was never accepted or merged.
> Yes, exactly.

Too bad. Not exactly necessary for our current scope of testing, but it would be
nice to be able to test networking.

> Thanks Guenter.
> 
You are welcome. Thanks for the feedback.

Guenter
