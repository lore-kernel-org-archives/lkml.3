Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab3EQTAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:00:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59073 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3EQTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:00:46 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] perf tools: Add MIPS userspace DWARF callchains.
Date: Fri, 17 May 2013 12:00:36 -0700
Message-Id: <1368817238-11548-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

These patches to the perf tool depend on the kernel patch here:

http://www.linux-mips.org/archives/linux-mips/2013-05/msg00124.html

With these two applied, I get the same nice call graphs on MIPS that
are obtained on my x86_64 workstation.

The patches are against Jiri Olsa's
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git perf/core
branch.  I hope that is the proper thing to base these things off of.

David Daney (2):
  perf tools: Add support for MIPS userspace DWARF callchains.
  perf tools: Hook up MIPS unwind and dwarf-regs in the Makefile

 tools/perf/Makefile                      |  3 ++
 tools/perf/arch/mips/Makefile            |  7 +++
 tools/perf/arch/mips/include/perf_regs.h | 84 ++++++++++++++++++++++++++++++++
 tools/perf/arch/mips/util/dwarf-regs.c   | 37 ++++++++++++++
 tools/perf/arch/mips/util/unwind.c       | 20 ++++++++
 tools/perf/config/Makefile               | 12 ++++-
 6 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/arch/mips/Makefile
 create mode 100644 tools/perf/arch/mips/include/perf_regs.h
 create mode 100644 tools/perf/arch/mips/util/dwarf-regs.c
 create mode 100644 tools/perf/arch/mips/util/unwind.c

-- 
1.7.11.7

