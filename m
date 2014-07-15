Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761AbaGOGZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:25:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55664 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaGOGZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:25:31 -0400
From: Zi Shen Lim <zlim.lnx@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <liuj97@gmail.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFCv3 00/14] arm64: eBPF JIT compiler
Date: Mon, 14 Jul 2014 23:24:58 -0700
Message-Id: <1405405512-4423-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements eBPF JIT compiler for arm64.
See [14/14] for change log.

Patches [1-13/14] implement code generation functions.
Patch [14/14] implements the actual eBPF JIT compiler.

Zi Shen Lim (14):
  arm64: introduce aarch64_insn_gen_comp_branch_imm()
  arm64: introduce aarch64_insn_gen_branch_reg()
  arm64: introduce aarch64_insn_gen_cond_branch_imm()
  arm64: introduce aarch64_insn_gen_load_store_reg()
  arm64: introduce aarch64_insn_gen_load_store_pair()
  arm64: introduce aarch64_insn_gen_add_sub_imm()
  arm64: introduce aarch64_insn_gen_bitfield()
  arm64: introduce aarch64_insn_gen_movewide()
  arm64: introduce aarch64_insn_gen_add_sub_shifted_reg()
  arm64: introduce aarch64_insn_gen_data1()
  arm64: introduce aarch64_insn_gen_data2()
  arm64: introduce aarch64_insn_gen_data3()
  arm64: introduce aarch64_insn_gen_logical_shifted_reg()
  arm64: eBPF JIT compiler

 Documentation/networking/filter.txt |   2 +-
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/Makefile                 |   1 +
 arch/arm64/include/asm/insn.h       | 249 +++++++++++++
 arch/arm64/kernel/insn.c            | 644 +++++++++++++++++++++++++++++++++-
 arch/arm64/net/Makefile             |   4 +
 arch/arm64/net/bpf_jit.h            | 169 +++++++++
 arch/arm64/net/bpf_jit_comp.c       | 677 ++++++++++++++++++++++++++++++++++++
 8 files changed, 1739 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/net/Makefile
 create mode 100644 arch/arm64/net/bpf_jit.h
 create mode 100644 arch/arm64/net/bpf_jit_comp.c

-- 
1.9.1

