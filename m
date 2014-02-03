Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaBCJK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:10:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:54530 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaBCJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:10:57 -0500
MIME-Version: 1.0
Date: Mon, 3 Feb 2014 14:40:57 +0530
Message-ID: <CAJ8eaTy28xjiQpGsdNLdpSsHzHVPSUimdcp=Pxn4L1YLNkq0SQ@mail.gmail.com>
Subject: Issue Float point in ARM WARNING: "__aeabi_d2iz"
From: naveen yadav <yad.naveen@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We are using ARM SOC  cortex A15. we are running 3.10.x kernel. I am
using gcc 4.6



I need floating  point in kernel module. So when I build I got warning
WARNING: "__aeabi_d2iz"   [/home/test/tt/hello.ko] undefined!
WARNING: "__aeabi_dmul"  [/home/test/tt/hello.ko] undefined!
WARNING: "__aeabi_dsub"  [/home/test/tt/hello.ko] undefined!
WARNING: "__aeabi_ddiv"  [/home/test/tt/hello.ko] undefined!
WARNING: "__aeabi_f2d"  [/home/test/tt/hello.ko] undefined!

static int __init hello_init(void)
{
   float a=3.14;
   float b=3.1222;
   b=7.2/a ;
    printk(KERN_INFO "Hello world! %f\n",a/b);
    return 0;    // Non-zero return means that the module couldn't be loaded.
}
static void __exit hello_cleanup(void)
{
    printk(KERN_INFO "Cleaning up module.\n");
}

module_init(hello_init);
module_exit(hello_cleanup);


So I change in my Linux kernel make file.

arch/arm/Makefile

I remove -msoft-float .
-KBUILD_CFLAGS  +=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y)
$(call cc-option,-mshort-load-bytes,$(call
cc-option,-malignment-traps,)) -msoft-float -Uarm
-KBUILD_AFLAGS  +=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y)
-include asm/unified.h -msoft-float
+KBUILD_CFLAGS  +=$(CFLAGS_ABI) $(CFLAGS_ISA) $(arch-y) $(tune-y)
$(call cc-option,-mshort-load-bytes,$(call
cc-option,-malignment-traps,))  -Uarm
+KBUILD_AFLAGS  +=$(CFLAGS_ABI) $(AFLAGS_ISA) $(arch-y) $(tune-y)
-include asm/unified.h


I run my module and it work well.
So my question is .
1. Is it correct way ?
2. will it effect my performance in normal scenario ?
3. how can I check more stability?

Regards.
