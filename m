Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaE1IcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:32:07 -0400
Received: from ozlabs.org ([103.22.144.67]:48147 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaE1IcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:32:04 -0400
Message-ID: <1401265922.3355.4.camel@concordia>
Subject: BUG at mm/memory.c:1489!
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        trinity@vger.kernel.org
Date: Wed, 28 May 2014 18:32:02 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey folks,

Anyone seen this before? Trinity hit it just now:

Linux Blade312-5 3.15.0-rc7 #306 SMP Wed May 28 17:51:18 EST 2014 ppc64

[watchdog] 27853 iterations. [F:22642 S:5174 HI:1276]
------------[ cut here ]------------
kernel BUG at /home/michael/mmk-build/flow/mm/memory.c:1489!
cpu 0xc: Vector: 700 (Program Check) at [c000000384eaf960]
    pc: c0000000001ad6f0: .follow_page_mask+0x90/0x650
    lr: c0000000001ad6d8: .follow_page_mask+0x78/0x650
    sp: c000000384eafbe0
   msr: 8000000000029032
  current = 0xc0000003c27e1bc0
  paca    = 0xc000000001dc3000   softe: 0        irq_happened: 0x01
    pid   = 20800, comm = trinity-c12
kernel BUG at /home/michael/mmk-build/flow/mm/memory.c:1489!
enter ? for help
[c000000384eafcc0] c0000000001e5514 .SyS_move_pages+0x524/0x7d0
[c000000384eafe30] c00000000000a1d8 syscall_exit+0x0/0x98
--- Exception: c01 (System Call) at 00003fff795f30a8
SP (3ffff958f290) is in userspace


I've left it in the debugger, can dig into it a bit more tomorrow if anyone has
any clues.

cheers


