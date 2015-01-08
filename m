Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbbAHBBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 20:01:40 -0500
Received: from ozlabs.org ([103.22.144.67]:44509 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbbAHBBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 20:01:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/3] Module load failure race fix.
Date: Thu,  8 Jan 2015 11:28:04 +1030
Message-Id: <1420678687-30548-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	This bug has been around since 2009, but only reported now.
I'm debating whether to cc: stable.

To fix it, I had to change module_free.  Please ensure I haven't broken
your arch!

Thanks,
Rusty.

Rusty Russell (3):
  module_arch_freeing_init(): new hook for archs before
    module->module_init freed.
  module: remove mod arg from module_free, rename module_memfree().
  module: fix race in kallsyms resolution during module load success.

 arch/avr32/kernel/module.c      | 13 +-------
 arch/cris/kernel/module.c       |  2 +-
 arch/ia64/kernel/module.c       |  6 ++--
 arch/mips/net/bpf_jit.c         |  2 +-
 arch/nios2/kernel/module.c      |  2 +-
 arch/parisc/kernel/module.c     |  6 +---
 arch/powerpc/net/bpf_jit_comp.c |  2 +-
 arch/s390/kernel/module.c       | 10 ++----
 arch/sparc/net/bpf_jit_comp.c   |  4 +--
 arch/tile/kernel/module.c       |  4 +--
 arch/x86/kernel/ftrace.c        |  2 +-
 include/linux/moduleloader.h    |  4 ++-
 kernel/bpf/core.c               |  2 +-
 kernel/kprobes.c                |  2 +-
 kernel/module.c                 | 74 ++++++++++++++++++++++++++++++-----------
 15 files changed, 76 insertions(+), 59 deletions(-)

-- 
2.1.0

