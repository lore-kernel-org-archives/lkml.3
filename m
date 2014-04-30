Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaD3BOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:14:54 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:47076 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaD3BOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:14:49 -0400
Message-ID: <53604E82.1040407@gmail.com>
Date: Wed, 30 Apr 2014 09:14:42 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] unicore32: About toolchain issues and source code.
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Excuse me, I did not find our unicore32 toolchains source code (I got
binary to cross-compile Linux kernel), could you provide more related
information for it, thanks.

And I find 2 unicore32 toolchains issues, please help check.

 - Gas issue:

      AS      firmware/keyspan/usa18x.fw.gen.o
    firmware/keyspan/usa18x.fw.gen.S: Assembler messages:
    firmware/keyspan/usa18x.fw.gen.S:11: Error: junk at end of line, first unrecognized character is `,'
    make[1]: *** [firmware/keyspan/usa18x.fw.gen.o] Error 1
    make: *** [firmware] Error 2
    
    it is about statement ".section .builtin_fw,"a",@progbits".
    
     - The statement is correct and standard.
    
     - Use "aM" instead of "a", can pass compiling, but shouldn't do it.
    
     - Remove "@progbits", can pass compiling, but shouldn't do it.
  
  - Compiler issue:
 
      CC [M]  drivers/media/dvb-frontends/tda10048.o
    drivers/media/dvb-frontends/tda10048.c: In function ‘tda10048_set_wref’:
    drivers/media/dvb-frontends/tda10048.c:367: internal compiler error: in simplify_const_unary_operation, at simplify-rtx.c:1278
    Please submit a full bug report,
    with preprocessed source if appropriate.
    See <http://gcc.gnu.org/bugs.html> for instructions.
    make[3]: *** [drivers/media/dvb-frontends/tda10048.o] Error 1
    make[2]: *** [drivers/media/dvb-frontends] Error 2
    make[1]: *** [drivers/media] Error 2
    make: *** [drivers] Error 2

  - Toolchain information:

    root@gchen:/upstream/toolchain/binutils/gas# /upstream/toolchain/unicore32/pi3dian14-beyondmind/prebuilt/linux-x86/toolchain/uc4-1.0-beta-hard-RHELAS4/bin/unicore32-linux-gcc -v
    Using built-in specs.
    Target: unicore32-linux
    Configured with: /home/ghb/trunk/gcc-4.4.2/configure --target=unicore32-linux --prefix=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4 --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c,c++,fortran --disable-multilib --disable-libstdcxx-pch --with-headers=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4/unicore32-linux/include --with-pkgversion=UC4_1.0-beta_20100415
    Thread model: posix
    gcc version 4.4.2 (UC4_1.0-beta_20100415) 
    root@gchen:/upstream/toolchain/binutils/gas# /upstream/toolchain/unicore32/pi3dian14-beyondmind/prebuilt/linux-x86/toolchain/uc4-1.0-beta-hard-RHELAS4/bin/unicore32-linux-as -v
    GNU assembler version 2.19.1 (unicore32-linux) using BFD version (GNU Binutils) 2.19.1


Next, I shall continue for unicore32 allmodconfig (hope I can finish
within 2014-05-31). And we may find other toolchain issues during cross
compiling (I shall report and try to solve them, after get source code).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
