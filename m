Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaAMBJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 20:09:35 -0500
Received: from gate.crashing.org ([63.228.1.57]:37227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaAMBJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 20:09:33 -0500
Message-ID: <1389575361.4672.115.camel@pasglop>
Subject: Re: powerpc32 broken by ef1313deafb7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Date: Mon, 13 Jan 2014 12:09:21 +1100
In-Reply-To: <1389572866.1176.19@driftwood>
References: <1389572866.1176.19@driftwood>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-12 at 18:27 -0600, Rob Landley wrote:
> Using the attached config, toolchain from  
> http://landley.net/aboriginal/bin/cross-compiler-powerpc.tar.bz2 but  
> presumably any 32 bit powerpc one should work, building ala make  
> ARCH=powerpc CROSS_COMPILE=powerpc-
> 
>    CC      arch/powerpc/lib/xor_vmx.o
> In file included from include/linux/thread_info.h:10,
>                   from include/linux/preempt.h:9,
>                   from arch/powerpc/lib/xor_vmx.c:22:
> include/linux/types.h:29: error: both 'unsigned' and '_Bool' in  
> declaration specifiers
> cc1: warnings being treated as errors
> include/linux/types.h:29: warning: useless type name in empty  
> declaration
> In file included from include/linux/kernel.h:11,
>                   from include/asm-generic/bug.h:13,
>                   from  
> /home/landley/linux/linux/arch/powerpc/include/asm/bug.h:127,
>                   from include/linux/bug.h:4,
>                   from include/linux/thread_info.h:11,
>                   from include/linux/preempt.h:9,
>                   from arch/powerpc/lib/xor_vmx.c:22:
> 
> And then pages more errors. The commit before that one didn't do that.

Your attached config has ...

CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"

So it's probably not what you wanted :-)

I'm not sure what the problem you see is because I've definitely run all
of these versions through my usual set of test configs without any
trouble, including a bunch of 32-bit ones.

Cheers,
Ben.

> Rob


