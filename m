Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756Ab3IXFXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 01:23:38 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43481 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3IXFXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 01:23:37 -0400
MIME-Version: 1.0
Date: Tue, 24 Sep 2013 10:53:36 +0530
Message-ID: <CAPoNrtuuMn=Bm9Mo=PsJfJp6DMQaM-Eaz5An+0+DXL2=uObndg@mail.gmail.com>
Subject: [Query] Stack Overflow in "arch/arm/kernel/unwind.c" while unwinding frame
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

While executing unwind backtrace instructions in ARM, in the function
unwind_exec_insn()
there are chances that SP overflows from stack.


For example while executing instruction with opcode 0xAE, vsp can go
beyond stack to area that has not been allocated till now.

unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
int reg;

/* pop R4-R[4+bbb] */
for (reg = 4; reg <= 4 + (insn & 7); reg++)
ctrl->vrs[reg] = *vsp++;

The above scenario can happen while executing any of the unwind instruction.

One of the ways to fix the problem is to check for vsp with stack
limits before we increment it, but doing it for all the instructions
seems a little bad.

I just want to know that if anyone has faced the problem before

I am working on Linux kernel for Android phones and I saw one case
when this happened.

I am new to Linux Kernel so not sure if this is the right place to ask
the question.


-- 
Anurag Aggarwal
