Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaDRIDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:03:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDRH7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:01 -0400
X-AuditID: cbfee68e-b7f566d000002344-d9-5350db436761
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 0/7] Support 4 levels of translation tables for ARM64
Date: Fri, 18 Apr 2014 16:58:59 +0900
Message-id: <000101cf5adc$0e403e70$2ac0bb50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a0tEVPWfzpSTVTruY7oEOSBrZKg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfV3n2wHBBq2/jSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugSvj
	VtcztoLVYhX/Fv5hbWCcKtDFyMkhIWAicfr1LyYIW0ziwr31bF2MXBxCAssYJU6sOsMMUzRn
	7SN2iMR0Ron/P5tZIZw/jBInO9rYQarYBDQlHt3tAasSEdjBKDF57SKwKmaBh4wSP9/uB5sl
	LOAhcWX3caAEBweLgKrEtUYrkDCvgKXElgnzWCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3kL
	dZKCxI6zrxlBbBEBPYml3zczQtSISOx78Y4RZK+EQCeHRPPfL2CDWAQEJL5NPsQCsldCQFZi
	0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefn
	bmKExHXfDsabB6wPMSYDrZ/ILCWanA9MC3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgbHitNCbMKMTTzm33dK7efafzn4PVzGL3L/3lgv+D5gZ
	GOr0oZfxo+LUufXFq9Icrn3YHeN+9vCi+8fjU4omnCteemtijshH/7sTbbxNvBKfzt3cvFhE
	9XHk9zdTVhqnF6+cvK1Kb2FSbfGDnutuNSov1H4/EOlPejv30qaWTzvulE79/POu81YvJZbi
	jERDLeai4kQAMC8/WQEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV3n2wHBBrdP61r8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjFtdz9gKVotV/Fv4h7WBcapAFyMnh4SAicSctY/YIWwx
	iQv31rN1MXJxCAlMZ5T4/7OZFcL5wyhxsqMNrIpNQFPi0d0edpCEiMAORonJaxeBVTELPGSU
	+Pl2PzNIlbCAh8SV3ceBEhwcLAKqEtcarUDCvAKWElsmzGOFsAUlfky+xwJiMwtoSazfeZwJ
	wpaX2LzmLTPESQoSO86+ZgSxRQT0JJZ+38wIUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDI
	sopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOGk8k97BuKrB4hCjAAejEg/vjoMBwUKsiWXF
	lbmHGCU4mJVEeJVLgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xoeSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWLBqYccHrhMO8tar7vLvMFLJNBTs
	TLuYF+rMPqHkvu6Tk4ETCjcWOl0QnM0fJcxevHT6Lo7dYru3LXs17bna1Bm1PEGy8f9ncTSF
	BM34Hj1Dz5Y7M/v7ZpaZr8JFEk1/Se8+acSvUf/ZmYPVqznOT8jvXeJ1aV4Vi61l0tdWV0Uq
	vxd5+LlKiaU4I9FQi7moOBEAAANUcF4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This the 3rd patchset supports 4 levels of tranlsation tables for ARM64.

Firstly, The patchset decouples page size from level of translation tables
as taking account into the comment from Catalin Marinas:
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

Then, it implements 4 levels of translation tables for native, HYP
and stage2 sides.

All ARMv8 and ARMv7 related changes are validated with FastModels+kvmtool
and A15+QEMU, respectively.

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

Jungseok Lee (7):
      arm64: Use pr_* instead of printk
      arm64: Decouple page size from level of translation tables
      arm64: Introduce a kernel configuration option for VA_BITS
      arm64: Add a description on 48-bit address space with 4KB pages
      arm64: Add 4 levels of page tables definition with 4KB pages
      arm64: mm: Implement 4 levels of translation tables
      arm64: KVM: Implement 4 levels of translation tables for HYP and stage2

 Documentation/arm64/memory.txt                |   59 +++++++++--
 arch/arm/include/asm/kvm_mmu.h                |   10 ++
 arch/arm/kvm/mmu.c                            |   88 ++++++++++++++---
 arch/arm64/Kconfig                            |   51 +++++++++-
 arch/arm64/include/asm/kvm_arm.h              |   34 +++++--
 arch/arm64/include/asm/kvm_mmu.h              |   12 +++
 arch/arm64/include/asm/memblock.h             |    6 ++
 arch/arm64/include/asm/memory.h               |    6 +-
 arch/arm64/include/asm/page.h                 |    6 +-
 arch/arm64/include/asm/pgalloc.h              |   24 ++++-
 arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 ++++++++++
 arch/arm64/include/asm/pgtable-4level-types.h |   71 +++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h        |    8 +-
 arch/arm64/include/asm/pgtable.h              |   52 ++++++++--
 arch/arm64/include/asm/tlb.h                  |   10 +-
 arch/arm64/kernel/head.S                      |   40 +++++---
 arch/arm64/kernel/traps.c                     |   19 ++--
 arch/arm64/mm/fault.c                         |    1 +
 arch/arm64/mm/mmu.c                           |   16 ++-
 19 files changed, 495 insertions(+), 68 deletions(-)

