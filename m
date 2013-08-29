Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3H2KEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:04:48 -0400
Received: from ares07.inai.de ([5.9.24.206]:39367 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065Ab3H2KEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:04:46 -0400
Date: Thu, 29 Aug 2013 12:04:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: fixdep ought to be compiled with -D_FILE_OFFSET_BITS
Message-ID: <alpine.LSU.2.10.9.1308291200240.15586@nerf07.vanv.qr>
User-Agent: Alpine 2.10.9 (LSU 9 2013-05-29)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because fixdep is compiled without -D_FILE_OFFSET_BITS=64,
a 32-bit fixdep (in a chroot build root, for example) may fail to run
on a 64-bit host system if any file has an inode larger than 2^32,
which can easily happen (in my case, on xfs):


[ares07:~/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-obj]
$ make silentoldconfig -C $PWD/../linux-3.10 O=$PWD V=1

make: Entering directory `/home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10'
make -C /home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-obj \
KBUILD_SRC=/home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10 \
KBUILD_EXTMOD="" -f /home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10/Makefile \
silentoldconfig
make -f /home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10/scripts/Makefile.build obj=scripts/basic
  gcc -Wp,-MD,scripts/basic/.fixdep.d -Iscripts/basic -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -o scripts/basic/fixdep /home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10/scripts/basic/fixdep.c  
fixdep: error fstat'ing depfile: scripts/basic/.fixdep.d: Value too large for defined data type
make[2]: *** [scripts/basic/fixdep] Error 2
make[1]: *** [scripts_basic] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/home/abuild/rpmbuild/BUILD/kernel-pae-3.10.9~jng20/linux-3.10'
