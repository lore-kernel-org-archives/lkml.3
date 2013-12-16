Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3LPTdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:33:51 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50640 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3LPTdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:33:50 -0500
Date: Mon, 16 Dec 2013 11:33:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Stefan Beller <stefanbeller@googlemail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Subject: Re: 3.13-rc4 doesn't compile
Message-ID: <20131216193346.GA5916@roeck-us.net>
References: <52AF2103.60802@googlemail.com>
 <52AF2375.5060706@googlemail.com>
 <20131216161959.GB4931@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131216161959.GB4931@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 05:19:59PM +0100, Borislav Petkov wrote:
> Add people to Cc.
> 
> On Mon, Dec 16, 2013 at 04:59:49PM +0100, Stefan Beller wrote:
> > Forgot to add:
> > 
> > 	$ git describe
> > v3.13-rc4
> > 
> > 	$ make deb-pkg
> >   CHK     include/config/kernel.release
> > make KBUILD_SRC=
> > make[3]: Nothing to be done for `all'.
> >   CHK     include/config/kernel.release
> >   CHK     include/generated/uapi/linux/version.h
> > make[3]: Nothing to be done for `relocs'.
> >   CHK     include/generated/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/generated/compile.h
> >   PASYMS  arch/x86/realmode/rm/pasyms.h
> >   LDS     arch/x86/realmode/rm/realmode.lds
> >   LD      arch/x86/realmode/rm/realmode.elf
> >   RELOCS  arch/x86/realmode/rm/realmode.relocs
> >   OBJCOPY arch/x86/realmode/rm/realmode.bin
> >   AS      arch/x86/realmode/rmpiggy.o
> >   LD      arch/x86/realmode/built-in.o
> >   VDSOSYM arch/x86/vdso/vdso-syms.lds
> >   VDSOSYM arch/x86/vdso/vdsox32-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
> >   VDSOSYM arch/x86/vdso/vdso32-syms.lds
> >   LD      arch/x86/vdso/built-in.o
> >   LD      arch/x86/built-in.o
> >   CC [M]  drivers/regulator/s2mps11.o
> > drivers/regulator/s2mps11.c: In function ‘s2mps11_pmic_probe’:
> > drivers/regulator/s2mps11.c:441:23: error: ‘struct sec_pmic_dev’ has no
> > member named ‘regmap’
> >   config.regmap = iodev->regmap;
> >                        ^
> > make[4]: *** [drivers/regulator/s2mps11.o] Error 1
> > make[4]: Target `__build' not remade because of errors.
> > make[3]: *** [drivers/regulator] Error 2
> > make[3]: Target `__build' not remade because of errors.
> > make[2]: *** [drivers] Error 2
> > make[2]: Target `_all' not remade because of errors.
> > make[1]: *** [deb-pkg] Error 2
> > make: *** [deb-pkg] Error 2
> > 

This problem is seen with 
	arm:allmodconfig
	i386:allmodconfig
	i386:allyesconfig
	x86_64:allyesconfig

Guenter
