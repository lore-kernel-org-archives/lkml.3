Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822Ab3AOGdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:33:14 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:49000 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3AOGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:33:13 -0500
Message-ID: <A37E4C0191C84499B7AC26844632EDAE@VIU9IM6TKCWEEDX>
From: "zhaoyilong" <registcn@gmail.com>
To: "linux -kernel" <linux-kernel@vger.kernel.org>
Subject: [head.S] opening DEBUG ,kernel crashed
Date: Tue, 15 Jan 2013 14:32:28 +0800
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
X-RFC2646: Format=Flowed; Original
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I open the macro DEBUG in the front of  file
arch/arm/boot/decompressed/head.S,the kernel runs and stops at"Uncompressing
Linux... done, booting the kernel."
CONFIG_DEBUG_ICEDCC is closed by default, so I am sure  the code runs tothe
following branch:
...........
...........
...........
.macro kputc,val
mov r0, \val
bl putc
.endm

.macro kphex,val,len
mov r0, \val
mov r1, #\len
bl phex
.endm

.macro debug_reloc_start
#ifdef DEBUG
kputc #'\n'
kphex r6, 8 /* processor id */
kputc #':'
kphex r7, 8 /* architecture id */
...........
...........
...........

Problem is happened in a context like this:

    I have a board use cpu S5PV210,and an ok kernel provide by the factory
anda  kernel download from kernel.org which carshed after printing "starting
kernel..." to dnw.
    To debug this,I want to test the macro kputc provided in this file¡ª¡ª
using ok kernel.
I add a line "kputc #'a' " after the tag ".text", then make error says
"undefined reference to `putc' ",it seems that compiler cant find "putc"
used in
the definition of macro ¡°kputc¡±.
    This is an ok kernel,so I cant say the serial port is not open¡ª¡ªcan
this mean "putc" is defined already?.

So I open DEBUG hoping to see debugging info by kernel itself,but it stops
at"Uncompressing Linux... done, booting the kernel."
Opening DEBUG will lead to the call of ¡°kputc #'\n' ¡± in the code above
which will also call putc!

Here,my questions comes:

1¡¢Why the error "  undefined reference to `putc'  " disappeared?
2¡¢Why it stops at"Uncompressing Linux... done, booting the kernel."?
3¡¢Can this error ( undefined reference to `putc'  ) mean the serial port is
not open? Where is it defined ?
Is it refer to the C function or just an assembly macro£¿ 


