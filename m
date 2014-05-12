Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaELJjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:39:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10298 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaELJjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:39:07 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-33-537096b998fe
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v6 0/7] Support 4 levels of translation tables for ARM64
Date: Mon, 12 May 2014 18:39:05 +0900
Message-id: <000001cf6dc6$03ded0c0$0b9c7240$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9twai47p7ahJoTSz25KpCtiQQYHg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zA92d0wqCDQ42yVj8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	2ZMOBXvlK26en8HYwHhVvIuRk0NCwESi504TE4QtJnHh3nq2LkYuDiGBZYwSq7ZeYYEpmj15
	CjNEYjqjxJqmP+wQzh9GiSlfWthAqtgENCUe3e0BS4gI7GCUmLx2ESuIwyzwkFHi59v9zCBV
	wgIeEiefnmEHsVkEVCWae8+BxXkFLCU234eI8woISvyYfA9sN7OAlsT6nceZIGx5ic1r3jJD
	3KQgsePsa8YuRg6gbXoSt94ZQpSISOx78Y4RZK+EQCeHxOHps5kgdglIfJt8iAWkXkJAVmLT
	AagxkhIHV9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+du
	YoRE9cQdjPcPWB9iTAZaP5FZSjQ5H5gU8kriDY3NjCxMTUyNjcwtzUgTVhLnTX+UFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBUenkvyvzM+Pqtap+F5/dcn7Z6vKn9qvjVRXnvzhuyp/z
	XuLKDRtF2/N/w4NbvoouPVanz7t6Y9/rAAFeXutpiidfW5k8TE4RfrxU6eTz6y8knS6Zbi/e
	eHnhiZ6qI6e+i7DEHun78e/DodMa4Wu3zXAP7DfSiLy47YrQpNkpj3x22GjFHzNZuluJpTgj
	0VCLuag4EQDdO9zJAAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQd2d0wqCDRavFrP4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosV85axWXyYsZLR
	gcdjzbw1jB6/f01i9LhzbQ+bx/lNa5g9Ni+p9+jbsorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygS5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGWdPOhTsla+4eX4GYwPjVfEuRk4OCQETidmTpzBD2GIS
	F+6tZ+ti5OIQEpjOKLGm6Q87hPOHUWLKlxY2kCo2AU2JR3d7wBIiAjsYJSavXcQK4jALPGSU
	+Pl2P9gsYQEPiZNPz7CD2CwCqhLNvefA4rwClhKb70PEeQUEJX5MvscCYjMLaEms33mcCcKW
	l9i85i3UTQoSO86+Zuxi5ADapidx650hRImIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4JTxTHoH46oGi0OMAhyMSjy8HxgKgoVYE8uKK3MP
	MUpwMCuJ8J6cCBTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGA6yyuJNzQ2MTOyNDKzMDIx
	NydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRpn2f4kvLpov/9B0Z06O16fywE2vdJIM
	7yxa28UVvmCz8fe+036XH5/OeLHE4NPXeP0vvhElIW5VWetXT/jY2pDvrZt54pSaTfaD1V6i
	Jt+6zko75dr5TRI58nXlepcFZ+U3TGnj/8wVK/k0nu3H68yJ9/rlT5w6dCp79f2EnTMZ36gt
	kkyo367EUpyRaKjFXFScCABASj94XQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This v6 patchset supports 4 levels of tranlsation tables for ARM64.

Firstly, the patchset introduces virtual address space size and
translation level options as taking account into the comment from
Catalin Marinas:
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

Then, it implements 4 levels of translation tables for native.

A dynamic VTTBR_X configuration is added before implementing 4 levels
for both HYP and stage2 sides.

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

Changes since v5:
- added dynamic VTTBR_X configuration logic
- removed a redundant logic in stage2_set_pte as per Christoffer's comment
- added comments for create_pud_entry as per Christoffer and Steve's comment
- fixed typos in 4 level descriptions as per Christoffer's comment
- revised arm64 Kconfig help message as per Christoffer's comment
- rebased on top of for-next/core branch of arm64/linux.git

Jungseok Lee (7):
  arm64: Use pr_* instead of printk
  arm64: Introduce VA_BITS and translation level options
  arm64: Add a description on 48-bit address space with 4KB pages
  arm64: Add 4 levels of page tables definition with 4KB pages
  arm64: mm: Implement 4 levels of translation tables
  arm64: KVM: Set physical address size related factors in runtime
  arm64: KVM: Implement 4 levels of translation tables for HYP and
    stage2

 Documentation/arm64/memory.txt                |   59 +++++++++++++---
 arch/arm/include/asm/kvm_mmu.h                |   10 +++
 arch/arm/kvm/arm.c                            |   90 ++++++++++++++++++++++++-
 arch/arm/kvm/mmu.c                            |   77 ++++++++++++++++++---
 arch/arm64/Kconfig                            |   53 ++++++++++++++-
 arch/arm64/include/asm/kvm_arm.h              |   29 ++++----
 arch/arm64/include/asm/kvm_mmu.h              |   12 ++++
 arch/arm64/include/asm/memblock.h             |    6 ++
 arch/arm64/include/asm/memory.h               |    6 +-
 arch/arm64/include/asm/page.h                 |    6 +-
 arch/arm64/include/asm/pgalloc.h              |   24 ++++++-
 arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 ++++++++++++++
 arch/arm64/include/asm/pgtable-4level-types.h |   71 +++++++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h        |    8 ++-
 arch/arm64/include/asm/pgtable.h              |   53 +++++++++++++--
 arch/arm64/include/asm/tlb.h                  |   11 ++-
 arch/arm64/kernel/head.S                      |   54 ++++++++++++---
 arch/arm64/kernel/traps.c                     |   13 ++--
 arch/arm64/kvm/hyp-init.S                     |   20 ++++--
 arch/arm64/mm/fault.c                         |    1 +
 arch/arm64/mm/mmu.c                           |   16 +++--
 21 files changed, 592 insertions(+), 77 deletions(-)
 create mode 100644 arch/arm64/include/asm/pgtable-4level-hwdef.h
 create mode 100644 arch/arm64/include/asm/pgtable-4level-types.h

-- 
1.7.10.4


