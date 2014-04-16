Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaDPEdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:33:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:08 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-95-534e0802e862
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 0/7] Support 4 levels of translation tables for ARM64
Date: Wed, 16 Apr 2014 13:33:06 +0900
Message-id: <004001cf592c$f64eb4a0$e2ec1de0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZJ1p6t5V5VVqQRnCYFTpBZpPH3Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zA10mDr9ggydPJSz+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	4tc2xoI20Yq5b5azNDBO4e9i5OCQEDCR2LrDsIuRE8gUk7hwbz1bFyMXh5DAMkaJm3unM0Mk
	TCTmzOxmhkgsYpQ4Pf89I4Tzh1Hi084LTCBVbAKaEo/u9rCDJEQEdjBKTF67iBXEYRZ4yCjx
	8+1+sFnCAh4SN7dtBLNZBFQlri76DNbNK2ApsW/WSxYIW1Dix+R7YDazgJbE+p3HmSBseYnN
	a95C3aQgsePsa0YQW0RAT6J5wndWiBoRiX0v3oGdJyHQyiHxqHsLO8QyAYlvkw+xQDwtK7Hp
	ANQcSYmDK26wTGAUm4Vk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3
	MULiuncH4+0D1ocYk4HWT2SWEk3OB6aFvJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJpCeW
	pGanphakFsUXleakFh9iZOLglGpgdP+b7X3n4yFPFZHjXzZ2rD+hV8fodHVN6oE28QQ35cbe
	Ovm+ao5qdYXYhpPn7e8vjYm7/8QqYI5WxrkAn6mzVif7HDV4N/nWiubwV15L9fv++8lK38nT
	X8F1fvuiI19mH7dkic9z9Po2sVZSRUTllwHLt443iQKzb26e8eZNvLLV9VBdlpJHSizFGYmG
	WsxFxYkA+iqC5QEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jAV0mDr9gg3erhS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxsSvbYwFbaIVc98sZ2lgnMLfxcjJISFgIjFnZjczhC0m
	ceHeerYuRi4OIYFFjBKn579nhHD+MEp82nmBCaSKTUBT4tHdHnaQhIjADkaJyWsXsYI4zAIP
	GSV+vt0PNktYwEPi5raNYDaLgKrE1UWfwbp5BSwl9s16yQJhC0r8mHwPzGYW0JJYv/M4E4Qt
	L7F5zVuomxQkdpx9zQhiiwjoSTRP+M4KUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDIsopR
	NLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOG08k9rBuLLB4hCjAAejEg/vjBzfYCHWxLLiytxD
	jBIczEoivF++AIV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5jS8kriDY1NzIwsjcwsjEzM
	zUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsU1sttfOQ7KXLs02VVxR+vK4ILun07w/
	wl8/6h7/pJFTeWCCzcP5bcd2Lt9aE5VlHSBeyZ/iajxHnv3dg0l1bRYyXnpbXN2nqhxu3l0o
	cVXlaN7vnRsPrVe2lhGwXrNp9sHv34XUW+dKTZrMEnTMIr56WU/Q9nMJlqnXvDmMtwUnX9+w
	PeYBkxJLcUaioRZzUXEiAGw3NVZfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This the 2nd patchset supports 4 levels of tranlsation tables for ARM64.

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
 arch/arm64/include/asm/kvm_arm.h              |   20 ++++
 arch/arm64/include/asm/kvm_mmu.h              |   10 ++
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
 19 files changed, 485 insertions(+), 62 deletions(-)

