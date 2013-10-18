Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab3JRJ2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:28:08 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40375 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3JRJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:28:05 -0400
Message-ID: <1382088475.16935.4.camel@phoenix>
Subject: Build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected
From: Axel Lin <axel.lin@ingics.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 18 Oct 2013 17:27:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I got below build error for nommu if CONFIG_DEBUG_ATOMIC_SLEEP is selected.
Also got the same build error if CONFIG_PROVE_LOCKING is selected.

Seems this issue is introduced by commit 662bbcb2747c2
"mm, sched: Allow uaccess in atomic with pagefault_disable()".

arch/arm/kernel/built-in.o: In function `arch_ptrace':
arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
arch/arm/kernel/built-in.o: In function `restore_sigframe':
arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
make: *** [vmlinux] Error 1

Regards,
Axel

