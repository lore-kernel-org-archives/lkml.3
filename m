Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaEACdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 22:33:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40359 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaEACdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 22:33:41 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-49-5361b28352f3
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v5 0/6] Support 4 levels of translation tables for ARM64
Date: Thu, 01 May 2014 11:33:39 +0900
Message-id: <000001cf64e5$c2d71e40$48855ac0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9k4VuMfvO6jN3EQ3m9HsdKdi/goQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zA93mTYnBBu8WmFv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	xxUnmQr+S1ZcfDyFrYFxh3AXIyeHhICJxJqZK5ggbDGJC/fWs4HYQgLLGCXudIt0MXKA1fyb
	JN7FyAUUng4UXjiHEcL5wyjx+tE8VpAGNgFNiUd3e9hBEiICOxglJq9dxAriMAs8ZJT4+XY/
	M0iVsICHxM+ZZ8A6WARUJRYcbgGzeQUsJU5efs8EYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnN
	W2aIUxUkdpx9zQhiiwjoSRyatRSqXkRi34t3YOdJCHRySEzad5IFYpmAxLfJh1gg/pGV2HQA
	ao6kxMEVN1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsY
	IVE9YQfjvQPWhxiTgdZPZJYSTc4HJoW8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamAMsu0IsWxTfu3DyOMS46Jp33Y/oMOjcOLZrEvn9ouK8ifw
	xIW9mVrspCiqfvmzqMBql9OTRapYZy0+cPkT/0OLqN28e29XxHt8ZnVyduGxFLUz6ylmcvTV
	erbdrCa8/yz/t38rjjpxCv/fVyo070TanS0/bI4YbNx7f/2avg9SN0tEs2YcLFBiKc5INNRi
	LipOBABPgN+DAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQd3mTYnBBhM/Glr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjI8rTjIV/JesuPh4ClsD4w7hLkYODgkBE4l/k8S7GDmB
	TDGJC/fWs3UxcnEICUxnlLizcA4jhPOHUeL1o3msIFVsApoSj+72sIMkRAR2MEpMXruIFcRh
	FnjIKPHz7X5mkCphAQ+JnzPPgHWwCKhKLDjcAmbzClhKnLz8ngnCFpT4MfkeC4jNLKAlsX7n
	cSYIW15i85q3zBA3KUjsOPuaEcQWEdCTODRrKVS9iMS+F+8YJzAKzEIyahaSUbOQjJqFpGUB
	I8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCk8Ux6B+OqBotDjAIcjEo8vBPYEoOFWBPL
	iitzDzFKcDArifAGrwEK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4woeWVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OxaZLD1j13WBo7mLYt3pDmt9Hy
	ltABdgkntnA9saZn/Df5tkrd2hh9T8hh1bpICbs9J0rWHQi5wb2HOSZjl/qOWH2hpmlc9u9y
	/XdOuyZWxFYU7swq/1QlP565Z/mfxjecGgcNGLZqR9w9KvP43bOKDTyufQdX5BZIb3vXv0aO
	iWlH8+T0i0osxRmJhlrMRcWJAPeYMWJeAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This v5 patchset supports 4 levels of tranlsation tables for ARM64.

Firstly, the patchset introduces virtual address space size and
translation level options as taking account into the comment from
Catalin Marinas:
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

Then, it implements 4 levels of translation tables for native, HYP and
stage2 sides.

All ARMv8 and ARMv7 related changes are validated with FastModels+kvmtool and
A15+QEMU, respectively.

Changes since v1:
- fixed unmatched data types as per Steve's comment
- removed unnecessary #ifdef in arch/arm64/mm/* as per Steve's comment
- revised create_pgd_entry to deal with PUD entry as per Steve's comment
- introduced a macro for initial memblock limit as per Steve's comment
- dropped "Fix line length exceeding 80 characters" patch as per Marc's comment
- removed unnecessary #ifdef in arch/arm/kvm/mmu.c as per Marc's comment
- added a macro for a number of objects of as per Marc's comment

Changes since v2:
- revised some macros in a generic way as per Marc's comment
- added a 2 level option for kvm mmu cache allocation as per Marc's comment

Changes since v3:
- added #ifdef to decide swapper and idmap size as per Steve's comment
- introduced Steve's create_pgd_entry

Changes since v4:
- hided translation level options from menuconfig as per Catalin's comment
- dropped some printk changes as per Mitchel's comment
- squashed VA_BITS related patches into a single patch

Jungseok Lee (6):
  arm64: Use pr_* instead of printk
  arm64: Introduce VA_BITS and translation level options
  arm64: Add a description on 48-bit address space with 4KB pages
  arm64: Add 4 levels of page tables definition with 4KB pages
  arm64: mm: Implement 4 levels of translation tables
  arm64: KVM: Implement 4 levels of translation tables for HYP and
    stage2

 Documentation/arm64/memory.txt                |   59 ++++++++++++++---
 arch/arm/include/asm/kvm_mmu.h                |   10 +++
 arch/arm/kvm/mmu.c                            |   88 +++++++++++++++++++++----
 arch/arm64/Kconfig                            |   53 ++++++++++++++-
 arch/arm64/include/asm/kvm_arm.h              |   34 ++++++++--
 arch/arm64/include/asm/kvm_mmu.h              |   12 ++++
 arch/arm64/include/asm/memblock.h             |    6 ++
 arch/arm64/include/asm/memory.h               |    6 +-
 arch/arm64/include/asm/page.h                 |    6 +-
 arch/arm64/include/asm/pgalloc.h              |   24 ++++++-
 arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 ++++++++++++++
 arch/arm64/include/asm/pgtable-4level-types.h |   71 ++++++++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h        |    8 ++-
 arch/arm64/include/asm/pgtable.h              |   53 +++++++++++++--
 arch/arm64/include/asm/tlb.h                  |   11 +++-
 arch/arm64/kernel/head.S                      |   46 ++++++++++---
 arch/arm64/kernel/traps.c                     |   13 ++--
 arch/arm64/mm/fault.c                         |    1 +
 arch/arm64/mm/mmu.c                           |   16 +++--
 19 files changed, 507 insertions(+), 60 deletions(-)
 create mode 100644 arch/arm64/include/asm/pgtable-4level-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable-4level-types.h

-- 
1.7.10.4


