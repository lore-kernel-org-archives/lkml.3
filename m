Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaDNHkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58081 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaDNHjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:39:53 -0400
X-AuditID: cbfee68e-b7f566d000002344-e0-534b90c7f6b4
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 0/8] Support 4 levels of translation tables for ARM64
Date: Mon, 14 Apr 2014 16:39:51 +0900
Message-id: <000001cf57b4$b86facd0$294f0670$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XqvDiot5A7T37S4CDj5Fj9VDL6A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zQ93jE7yDDd4stLb4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CVcfTiCcaC
	2wIVu+bNYW9gfMjdxcjJISFgIvFteQMThC0mceHeerYuRi4OIYFljBKT9uxhhCk6eWYJE0Ri
	OqNE473jUFV/GCV2dexiBqliE9CUeHS3hx0kISKwg1Fi8tpFrCAOs8AJRomld9ayglQJC7hK
	tH95D9bBIqAq0TD5FwuIzStgKdF05QY7hC0o8WPyPbA4s4CWxPqdx5kgbHmJzWveMkPcpCCx
	4+xrsPtEBPQk/v46xw5RIyKx78U7RpDFEgKNHBL3p8xmh1gmIPFt8iGgoRxACVmJTQeg5khK
	HFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREs99
	OxhvHrA+xJgMtH4is5Rocj4wHeSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6Yklqdmpq
	QWpRfFFpTmrxIUYmDk6pBsZu3otM4sEnw3SMZNYsmhHqYn/dSK3uUO2v99tjc25NPrLx1zIV
	n+Sp/k9FGpa+OGttLpL2ddryT5udJjtOTM5dNXejvPDeGy8D9q3fsPxpVoHnU9frlvmmLzJv
	7haJ+/Zau2HS7IsJy55+VSzakbleo/3h6Y3TbVmtuSJeXXZzvtG/9OFhC8liJZbijERDLeai
	4kQAiN/MqP0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd3jE7yDDW7OMbP4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKSSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePoxROMBbcFKnbNm8PewPiQu4uRk0NCwETi5JklTBC2mMSFe+vZ
	uhi5OIQEpjNKNN47DuX8YZTY1bGLGaSKTUBT4tHdHnaQhIjADkaJyWsXsYI4zAInGCWW3lnL
	ClIlLOAq0f7lPVgHi4CqRMPkXywgNq+ApUTTlRvsELagxI/J98DizAJaEut3HmeCsOUlNq95
	ywxxk4LEjrOvGUFsEQE9ib+/zrFD1IhI7HvxjnECo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIThbPpHcwrmqwOMQowMGoxMObsN0zWIg1say4MvcQowQH
	s5II77YMr2Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmsrySeENjEzMjSyMzCyMTc3PS
	hJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPQRyjT29SjamP9MbtMyo58TVwgcOda1+qym
	aU3RrklctYvkE+4fcXn3e2dr5LzjNosNlp8qPsH5WVnLsziIzTCwdKXk4WlL5HQFzlx7Hdvr
	ER6VFPcwR6u86NVD1TuLDt13jm46ddIyLC3wS8LZdWcWpvnmijVs3bC2tWaC/Ec3kcuJbiq6
	zEosxRmJhlrMRcWJACnPE/JaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patchset supports 4 levels of tranlsation tables for ARM64.

Firstly, the patchset decouples page size from level of translation tables
as taking account into the comment from Catalin Marinas:
http://www.spinics.net/linux/lists/arm-kernel/msg319552.html

Then, it implements 4 levels of translation tables for both native, HYP
and stage2 sides.

This series is validated with Fast Models and kvmtool as platform and guest
launcher, respectively.

Jungseok Lee (8):
      arm64: Use pr_* instead of printk
      arm/arm64: KVM: Fix line length exceeding 80 characters
      arm64: Decouple page size from level of translation tables
      arm64: Introduce a kernel configuration option for VA_BITS
      arm64: Add a description on 48-bit address space with 4KB pages
      arm64: Add 4 levels of page tables definition with 4KB pages
      arm64: mm: Implement 4 levels of translation tables
      arm64: KVM: Implement 4 levels of translation tables for HYP and stage2

Documentation/arm64/memory.txt                |   59 ++++++++++--
 arch/arm/kvm/mmu.c                            |  100 ++++++++++++++++++---
 arch/arm64/Kconfig                            |   51 ++++++++++-
 arch/arm64/include/asm/kvm_arm.h              |   20 +++++
 arch/arm64/include/asm/kvm_mmu.h              |    1 +
 arch/arm64/include/asm/memory.h               |    6 +-
 arch/arm64/include/asm/page.h                 |    6 +-
 arch/arm64/include/asm/pgalloc.h              |   24 ++++-
 arch/arm64/include/asm/pgtable-4level-hwdef.h |   50 +++++++++++
 arch/arm64/include/asm/pgtable-4level-types.h |   71 +++++++++++++++
 arch/arm64/include/asm/pgtable-hwdef.h        |   10 ++-
 arch/arm64/include/asm/pgtable.h              |   52 +++++++++--
 arch/arm64/include/asm/tlb.h                  |   10 ++-
 arch/arm64/kernel/head.S                      |   45 +++++++++-
 arch/arm64/kernel/traps.c                     |   19 ++--
 arch/arm64/mm/fault.c                         |    1 +
 arch/arm64/mm/mmu.c                           |   14 ++-
 17 files changed, 488 insertions(+), 51 deletions(-)


