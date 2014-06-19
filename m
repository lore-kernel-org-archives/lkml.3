Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbaFSTHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:07:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51294 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933059AbaFSTGx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:06:53 -0400
X-Sasl-enc: GzXC5Qd7ggEvsYznSwKvGEBs1IMxy3zSs61+Yz+zGkQg 1403204812
Date: Thu, 19 Jun 2014 12:10:51 -0700
From: Greg KH <greg@kroah.com>
To: dann frazier <dann.frazier@canonical.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: lustre virtual block device doesn't build w/
 CONFIG_ARM64_64K_PAGES=y
Message-ID: <20140619191051.GA26573@kroah.com>
References: <20140619183321.GA23200@fluid.dannf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140619183321.GA23200@fluid.dannf>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 12:33:21PM -0600, dann frazier wrote:
> With current git, lustre fails to build with CONFIG_ARM64_64K_PAGES=y
> and CONFIG_LUSTRE_LLITE_LLOOP=m:
> 
> make -f scripts/Makefile.build obj=drivers/staging/lustre/lustre/llite
>   gcc -Wp,-MD,drivers/staging/lustre/lustre/llite/.lloop.o.d  -nostdinc -isystem /usr/lib/gcc/aarch64-linux-gnu/4.8/include -I./arch/arm64/include -Iarch/arm64/include/generated  -Iinclude -I./arch/arm64/include/uapi -Iarch/arm64/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -mlittle-endian -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -mgeneral-regs-only -fno-delete-null-pointer-checks -O2 -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -g -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Idrivers/staging/lustre/include/ -Idrivers/staging/lustre/lustre/llite/../include  -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(lloop)"  -D"KBUILD_MODNAME=KBUILD_STR(llite_lloop)" -c -o drivers/staging/lustre/lustre/llite/.tmp_lloop.o drivers/staging/lustre/lustre/llite/lloop.c
> drivers/staging/lustre/lustre/llite/lloop.c: In function ‘loop_set_fd’:
> drivers/staging/lustre/lustre/llite/lloop.c:523:78: error: duplicate case value
>   CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
>                                                                               ^
> drivers/staging/lustre/lustre/llite/lloop.c:523:18: error: previously used here
>   CLASSERT(PAGE_CACHE_SIZE < (1 << (sizeof(unsigned short) * 8)));
>                   ^

Looks like lustre can't handle 64K page sizes, so it refuses to build :(

I sugest turning this code off, you really don't want to be running it
anyway...

greg k-h
