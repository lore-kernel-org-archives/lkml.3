Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaAKMTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 07:19:32 -0500
Received: from nautica.notk.org ([91.121.71.147]:37029 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbaAKMTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 07:19:30 -0500
Date: Sat, 11 Jan 2014 13:19:14 +0100
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Randy Dunlap <rdunlap@infradead.org>, Wakko Warner <wakko@animx.eu.org>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [V9fs-developer] Unable to load modules from 9p filesystem with
 kmod 16
Message-ID: <20140111121914.GA12907@nautica>
References: <20140110023543.GA6131@animx.eu.org>
 <20140110230303.GA19369@animx.eu.org>
 <52D097DB.3020101@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D097DB.3020101@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Randy Dunlap wrote on Fri, Jan 10, 2014 :
> [adding Cc:s]

Thanks for the extra Cc.

> On 01/10/2014 03:03 PM, Wakko Warner wrote:
> > Wakko Warner wrote:
> >> Kernel 3.12.7 from kernel.org
> >> With kmod-16, I'm unable to load any modules on my guest kvm machines.
> >> The vm is booted via direct kernel boot.  The modules are located on the
> >> host and is passed to the guest via the fsdev.
> >>
> >> I have a mountpoint on the guest filesystem located at /kernel.  It is
> >> mounted like this:
> >> kernel /kernel 9p rw,sync,dirsync,relatime,trans=virtio,version=9p2000.L 0 0
> >>
> >> /boot, /lib/modules, and /lib/firmware are tmpfs filesystems like this:
> >> kboot /boot tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
> >> kfirmware /lib/firmware tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
> >> kmodules /lib/modules tmpfs rw,relatime,size=0k,nr_inodes=8 0 0
> >>
> >> /lib/modules/$(uname -r) is a symlink to /kernel/lib/modules/$(uname -r)
> >>
> >> When trying to load any module, I get 
> >> Error: could not insert module /lib/modules/3.12.7/kernel/crypto/af_alg.ko:
> >> Invalid module format
> >>
> >> This module was just one I picked at random, all modules fail the same way.
> >> Strace shows this:
> >> open("/lib/modules/3.12.7/kernel/crypto/af_alg.ko", O_RDONLY|O_CLOEXEC) = 3
> >> fstat(3, {st_mode=S_IFREG|0644, st_size=13822, ...}) = 0
> >> mmap(NULL, 13822, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f199aebd000
> >> syscall_313(0x3, 0x7f199aaa2de0, 0, 0x3, 0, 0x7f199b7b2010, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) = -1 (errno 8)
> >> munmap(0x7f199aebd000, 13822)           = 0
> >> close(3)                                = 0

I didn't look at the patch very closely because the mail apparently
never reached v9fs-developer (although it looks in copy), but I got
pointed out this patch recently:
http://www.spinics.net/lists/linux-virtualization/msg21716.html

Which quotes "This patch enables 9p-virtio to correctly handle this
case. This not only enables us to load Linux kernel modules off virtfs,"

Perhaps would it be what you need to support this syscall_313?

Good luck,
-- 
Dominique Martinet
