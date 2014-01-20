Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaATVWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:22:21 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:54822 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaATVWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:22:18 -0500
From: Jean Pihet <jean.pihet@linaro.org>
To: libunwind-devel <libunwind-devel@nongnu.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        patches@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [RFC PATCH 0/3] Add support for dwarf compat mode unwinding
Date: Mon, 20 Jan 2014 22:21:59 +0100
Message-Id: <1390252922-25889-1-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of unwinding the debug info from a binary that has a different
address size than the current native platform, it is needed to record
it in the address space struct, in order to correctly parse the debug
info later. This mode is known as compat mode.

This is the case when e.g. profiling an ARMv7 binary that runs on an
ARMv8 (aka AARCH64) platform.

Depending on the target binary address size, loading and parsing of the
dwarf debug info and unwinding of the recorded stack frame must be
performed accordingly.

Tested dwarf local unwinding on ARMv8 (aka AARCH64) with ARMv7 and
ARMv8 binaries; and natively on X86_64.

Note:
- this series is an RFC, although tested OK on ARMv7, ARMv8 and x86_64,
- only local unwinding has been tested,
- retrieval of the next ip and frame pointer is performed using a
  native read followed by a cast to the desired target address size.


Jean Pihet (3):
  Add support for different binary target address sizes
  Dwarf: load and parse the debug info of different target address
    sizes
  Dwarf: unwind the recorded stack frame of different target address
    sizes

 include/libunwind_i.h              |   7 ++
 include/tdep-aarch64/libunwind_i.h |   1 +
 include/tdep-arm/libunwind_i.h     |   1 +
 include/tdep-hppa/libunwind_i.h    |   1 +
 include/tdep-ia64/libunwind_i.h    |   1 +
 include/tdep-mips/libunwind_i.h    |   1 +
 include/tdep-ppc32/libunwind_i.h   |   1 +
 include/tdep-ppc64/libunwind_i.h   |   1 +
 include/tdep-sh/libunwind_i.h      |   1 +
 include/tdep-x86/libunwind_i.h     |   1 +
 include/tdep-x86_64/libunwind_i.h  |   1 +
 src/dwarf/Gfde.c                   |  25 +++--
 src/dwarf/Gfind_proc_info-lsb.c    | 194 +++++++++++++++++++++++++++++--------
 src/dwarf/Gparser.c                |  27 ++++++
 14 files changed, 214 insertions(+), 49 deletions(-)

-- 
1.7.11.7

