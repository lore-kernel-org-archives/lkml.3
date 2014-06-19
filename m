Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbaFSSn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:43:27 -0400
Received: from complete.lackof.org ([198.49.126.79]:50064 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934237AbaFSSn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:43:26 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2014 14:43:26 EDT
Date: Thu, 19 Jun 2014 12:33:21 -0600
From: dann frazier <dann.frazier@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: lustre virtual block device doesn't build w/ CONFIG_ARM64_64K_PAGES=y
Message-ID: <20140619183321.GA23200@fluid.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With current git, lustre fails to build with CONFIG_ARM64_64K_PAGES=y
and CONFIG_LUSTRE_LLITE_LLOOP=m:

make -f scripts/Makefile.build obj=drivers/staging/lustre/lustre/llite
  gcc -Wp,-MD,drivers/staging/lustre/lustre/llite/.lloop.o.d  -nostdinc -isystem /usr/lib/gcc/aarch64-linux-gnu/4.8/include -I./arch/arm64/include -Iarch/arm64/include/generated  -Iinclude -I./arch/arm64/include/uapi -Iarch/arm64/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -mgeneral-regs-only -fno-delete-null-pointer-checks -O2 -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Idrivers/staging/lustre/include/ -Idrivers/staging/lustre/lustre/llite/../include  -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(lloop)"  -D"KBUILD_MODNAME=KBUILD_STR(llite_lloop)" -c -o drivers/staging/lustre/lustre/llite/.tmp_lloop.o drivers/staging/lustre/lustre/llite/lloop.c
drivers/staging/lustre/lustre/llite/lloop.c: In function ‘loop_set_fd’:
drivers/staging/lustre/lustre/llite/lloop.c:523:78: error: duplicate case value
  CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
                                                                              ^
drivers/staging/lustre/lustre/llite/lloop.c:523:18: error: previously used here
  CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
                  ^
scripts/Makefile.build:257: recipe for target 'drivers/staging/lustre/lustre/llite/lloop.o' failed
make[5]: *** [drivers/staging/lustre/lustre/llite/lloop.o] Error 1
scripts/Makefile.build:404: recipe for target 'drivers/staging/lustre/lustre/llite' failed
make[4]: *** [drivers/staging/lustre/lustre/llite] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/staging/lustre/lustre' failed
make[3]: *** [drivers/staging/lustre/lustre] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/staging/lustre' failed
make[2]: *** [drivers/staging/lustre] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/staging' failed
make[1]: *** [drivers/staging] Error 2
Makefile:893: recipe for target 'drivers' failed
make: *** [drivers] Error 2
