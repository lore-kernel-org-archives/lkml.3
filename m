Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaFWM16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:27:58 -0400
Received: from helcar.apana.org.au ([209.40.204.226]:51837 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaFWM14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:27:56 -0400
Date: Mon, 23 Jun 2014 20:27:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <20140623122747.GA21213@gondor.apana.org.au>
References: <20140623114942.6a937466@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140623114942.6a937466@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen:

On Mon, Jun 23, 2014 at 11:49:42AM +1000, Stephen Rothwell wrote:
> 
> After merging the crypto tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> 
> drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c:47:31: fatal error: adf_accel_devices.h: No such file or directory
>  #include <adf_accel_devices.h>
>                                ^
> drivers/crypto/qat/qat_dh895xcc/adf_isr.c:54:31: fatal error: adf_accel_devices.h: No such file or directory
>  #include <adf_accel_devices.h>
>                                ^
> drivers/crypto/qat/qat_dh895xcc/adf_drv.c:60:31: fatal error: adf_accel_devices.h: No such file or directory
>  #include <adf_accel_devices.h>
>                                ^
> 
> Caused by commit 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc
> accelerator").
> 
> I have used the crypto tree from next-20140620 for today.

That's weird as it built correctly here.  This looks like a
make/gcc issue as the missing header file is meant to be found
with an additional -I.

Could you do a make V=1 for me and show me what the gcc command-line
looks like?

FWIW mine is:

  gcc -Wp,-MD,drivers/crypto/qat/qat_dh895xcc/.adf_dh895xcc_hw_data.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-linux-gnu/4.7/include -I./arch/x86/include -Iarch/x86/include/generated  -Iinclude -I./arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -m64 -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387 -march=core2 -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fno-delete-null-pointer-checks -O2 -Wframe-larger-than=1024 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -DCC_HAVE_ASM_GOTO -I/home/gondost/herbert/src/build/kernel/test-64/drivers/crypto/qat/qat_common  -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(adf_dh895xcc_hw_data)"  -D"KBUILD_MODNAME=KBUILD_STR(qat_dh895xcc)" -c -o drivers/crypto/qat/qat_dh895xcc/.tmp_adf_dh895xcc_hw_data.o drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c

Note the -I for qat_common which is where that header file is.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
