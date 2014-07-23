Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbaGWVUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:20:09 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:42165 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932921AbaGWVUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:20:07 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux@openrisc.net
Cc: jonas@southpole.se,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH 0/6] openrisc: support for l.lwa and l.swa atomic instructions
Date: Thu, 24 Jul 2014 00:18:10 +0300
Message-Id: <1406150296-13308-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest revision (v1.1-0) of the OpenRISC 1000 architecture
specification [1], adds definitions for load-linked/store-conditional
type of atomic instructions.

There are already a couple of implementations available that has support
for these instructions implemented.
E.g. a hardware implementation - mor1kx and a functional simulator - or1ksim.

This series of patches takes these new instructions into use to create hardware
assisted versions of atomic/bitops/cmpxchg.
It also enables proper support for futexes, something that hasn't been available
previously.

[1] https://github.com/openrisc/doc/blob/master/openrisc-arch-1.1-rev0.pdf?raw=true

Stefan Kristiansson (6):
  openrisc: add Kconfig for l.lwa and l.swa atomic instructions
  openrisc: add atomic bitops
  openrisc: add cmpxchg and xchg implementations
  openrisc: add atomic operations implementations
  openrisc: include l.swa in check for write data pagefault
  openrisc: add futex_atomic_* implementations

 arch/openrisc/Kconfig                     |   7 ++
 arch/openrisc/include/asm/Kbuild          |   4 -
 arch/openrisc/include/asm/atomic.h        |  88 +++++++++++++++++++
 arch/openrisc/include/asm/bitops.h        |   2 +-
 arch/openrisc/include/asm/bitops/atomic.h | 109 +++++++++++++++++++++++
 arch/openrisc/include/asm/cmpxchg.h       |  83 ++++++++++++++++++
 arch/openrisc/include/asm/futex.h         | 140 ++++++++++++++++++++++++++++++
 arch/openrisc/kernel/entry.S              |   2 +-
 8 files changed, 429 insertions(+), 6 deletions(-)
 create mode 100644 arch/openrisc/include/asm/atomic.h
 create mode 100644 arch/openrisc/include/asm/bitops/atomic.h
 create mode 100644 arch/openrisc/include/asm/cmpxchg.h
 create mode 100644 arch/openrisc/include/asm/futex.h

-- 
1.8.3.2

