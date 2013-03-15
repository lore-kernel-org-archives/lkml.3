Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3COCvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:51:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40366 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3COCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:51:08 -0400
X-Spam-Score: -100.8
Message-ID: <51428C81.6000204@asianux.com>
Date: Fri, 15 Mar 2013 10:50:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "paulus@samba.org" <paulus@samba.org>, mikey@neuling.org,
        matt@ozlabs.org, imunsie@au1.ibm.com
CC: linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  do next-* tree support powerpc POWER7 with allmodconfig ?

  I met an issue, can we bear it (or I need additional trying) ?


Compiling:
  make V=1 EXTRA_CFLAGS=-W ARCH=powerpc allmodconfig
    set cpu type POWER7 in menuconfig.
    set cross-compiler in menuconfig.
      under Fedora 16 x86_64 laptop
      /usr/bin/powerpc64-linux-gnu-gcc -v
        gcc version 4.7.1 20120606 (Red Hat 4.7.1-0.1.20120606) (GCC)

Issue:
  error:
    /android/public-kernel/linux-next/arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
    /android/public-kernel/linux-next/arch/powerpc/kernel/exceptions-64s.S:1304: Error: attempt to move .org backwards

  command:
    powerpc64-linux-gnu-gcc -m64 -Wp,-MD,arch/powerpc/kernel/.head_64.o.d  -nostdinc -isystem /usr/lib/gcc/powerpc64-linux-gnu/4.7.1/include -I/android/public-kernel/linux-next/arch/powerpc/include -Iarch/powerpc/include/generated  -I/android/public-kernel/linux-next/include -Iinclude -I/android/public-kernel/linux-next/arch/powerpc/include/uapi -Iarch/powerpc/include/generated/uapi -I/android/public-kernel/linux-next/include/uapi -Iinclude/generated/uapi -include /android/public-kernel/linux-next/include/linux/kconfig.h -D__KERNEL__  -I/android/public-kernel/linux-next/arch/powerpc -Iarch/powerpc -D__ASSEMBLY__  -I/android/public-kernel/linux-next/arch/powerpc -Iarch/powerpc -Wa,-maltivec -gdwarf-2   -c -o arch/powerpc/kernel/head_64.o /android/public-kernel/linux-next/arch/powerpc/kernel/head_64.S

  (head_64.S includes exceptions-64.S)


  thanks.

-- 
Chen Gang

Asianux Corporation
