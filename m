Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaK0WUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:20:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:58535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaK0WUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:20:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,472,1413270000"; 
   d="scan'208";a="644730351"
Date: Thu, 27 Nov 2014 14:20:34 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: grant.likely@linaro.org, kbuild-all@01.org, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Hirokazu Takata <takata@linux-m32r.org>
Subject: Re: [PATCH V2 2/2] m32r: Add missing big-endian I/O accessors
Message-ID: <20141127222034.GB16647@wfg-t540p.sh.intel.com>
References: <1417112193-14400-1-git-send-email-cernekee@gmail.com>
 <1417112193-14400-2-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417112193-14400-2-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CC to Hirokazu.

> Side note for Fengguang: both with and without my patches, m32r modules
> fail to link using the make.cross script on Ubuntu 14.10:
 
Yes, the memory_start/memory_end link errors are really old m32r
specific errors. The config file that can trigger this error is
m32r-m32104ut_defconfig.

>   CC      init/version.o
>   LD      init/built-in.o
>   KSYM    .tmp_kallsyms1.o
>   KSYM    .tmp_kallsyms2.o
>   LD      vmlinux
>   SYSMAP  System.map
>   Building modules, stage 2.
>   OBJCOPY arch/m32r/boot/compressed/vmlinux.bin
>   MODPOST 96 modules
>   GZIP    arch/m32r/boot/compressed/vmlinux.bin.gz
> ERROR: "memory_start" [fs/udf/udf.ko] undefined!
> ERROR: "memory_end" [fs/udf/udf.ko] undefined!
> ERROR: "memory_end" [drivers/scsi/sg.ko] undefined!
> ERROR: "memory_start" [drivers/scsi/sg.ko] undefined!
> ERROR: "memory_end" [drivers/i2c/i2c-dev.ko] undefined!
> ERROR: "memory_start" [drivers/i2c/i2c-dev.ko] undefined!
> scripts/Makefile.modpost:90: recipe for target '__modpost' failed
> make[1]: *** [__modpost] Error 1
> Makefile:1098: recipe for target 'modules' failed
> make: *** [modules] Error 2
> make: *** Waiting for unfinished jobs....
>   LD      arch/m32r/boot/compressed/piggy.o
> /usr/local/gcc-4.9.0-nolibc/m32r-linux/bin/m32r-linux-ld: target elf32-m32r not found
> arch/m32r/boot/compressed/Makefile:51: recipe for target 'arch/m32r/boot/compressed/piggy.o' failed
> make[2]: *** [arch/m32r/boot/compressed/piggy.o] Error 1
> arch/m32r/boot/Makefile:18: recipe for target 'arch/m32r/boot/compressed/vmlinux' failed
> make[1]: *** [arch/m32r/boot/compressed/vmlinux] Error 2
> arch/m32r/Makefile:53: recipe for target 'zImage' failed
> make: *** [zImage] Error 2

Thanks,
Fengguang
