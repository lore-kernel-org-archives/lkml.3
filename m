Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaICAJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 20:09:45 -0400
Received: from mx13.pku.edu.cn ([162.105.129.176]:37262 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753687AbaICAJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 20:09:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -307.429
Date: Wed, 3 Sep 2014 08:09:28 +0800 (CST)
From: =?gbk?B?WHVldGFvIEd1YW4g?= <gxt@pku.edu.cn>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <717685015.32253.1409702968099.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20140902155856.GA16029@roeck-us.net>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_Re:_=E5=9B=9E=E5=A4=8D=EF=BC=9A_Sta?=
 =?utf-8?Q?tus_of_'unicore3?= =?utf-8?Q?2'_architecture_in_Linux_kernel?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [162.105.129.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[...]
> > 
> > > 
> > > unicore32: Add ocd console and qemu-defconfig to support qemu simulator
> > > 	This patch adds a primitive OCD console to communicate with qemu.
> > > 	The same code is already used for early console support.
> > 
> > Do you mean there's the same/similar code in QEMU.
> > 
> No, I mean that the ocd functions in the linux kernel (such as ocd_putc) are
> used by both earlyprintk and the ocd console code.
Yes. By the way, it's only for qemu and fpga debug.

> 
> > > 
> > > With this patch added, and with qemu_defconfig as provided by the same patch,
> > > it is possible to build and load a unicore32 image in qemu using the following
> > > qemu command line.
> > > 
> > > qemu-system-unicore32 -curses -M puv3 -m 512 -kernel arch/unicore32/boot/zImage
> > > 
> > > Caveats:
> > > - The use of -nographic instead of -curses causes a qemu crash
> > Yes, since qemu curses code was modified to meet the simple OCD console requirement.
> > 
> The lack of support for -nographic is a problem for scripted testing.
> The issue is that we have to interpret console output for scripted testing,
> and having to go through curses makes that a bit difficult.
> 
> Wonder if '-nographic' can be modeled as '-curses' with no available terminal
> configuration. At least in theory that should work, but executing the above
> command with TERM=dumb yields no output. Wonder how difficult it would be to
> change that.

I see. I'll try to make -nographic work anyway.

> 
> > > - The qemu emulation only accepts a built-in initramfs.
> > Yes, github version only support built-in initramfs.
> > NFS+LFS could be also supported, and puv3-pci sim should be added at first.
> > 
> > > - The only working image is arch/unicore32/boot/zImage.
> > >   All other variants, arch/unicore32/boot/Image and vmlinux, cause a crash.
> > >   The same (or a similar) crash is also seen if I don't provide a built-in
> > >   kernel command line and try to load zImage.
> > Sorry for that. That should be fixed.
> > 
> > > - There is no networking. There is another patch in the github linux
> > >   respository [4] which is not available upstream. The driver was submitted
> > >   for integration back in 2011 [5] but it was never accepted or merged.
> > Yes, exactly.
> 
> Too bad. Not exactly necessary for our current scope of testing, but it would be
> nice to be able to test networking.
I'll review and submit networking code again. Or, maybe pci-nic function, to support qemu as well. 

> 
> > Thanks Guenter.
> > 
> You are welcome. Thanks for the feedback.
> 
> Guenter

Thanks.

Xuetao
