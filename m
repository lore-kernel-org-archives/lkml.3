Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaD2E7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 00:59:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64219 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbaD2E7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 00:59:12 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-64-535f319e8337
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v4 0/7] Support 4 levels of translation tables for ARM64
Date: Tue, 29 Apr 2014 13:59:03 +0900
Message-id: <000001cf6367$c1a2d890$44e889b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jZR9x7F0xhWvwTSqMr06oGWdTXg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zA915hvHBBi9+C1j8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	uhktjAUzxCu27/nF3MD4T6CLkZNDQsBEYuqZVnYIW0ziwr31bF2MXBxCAssYJZq/fWGGKVq+
	tY8dIjGdUWL5sg9QVX8YJe693cACUsUmoCnx6G4PWJWIwA5GiclrF7GCOMwCDxklfr7dDzZL
	WMBDYtmsHWA2i4CqxPrprxhBbF4BS4k5HU+hbEGJH5PvgU1lFtCSWL/zOBOELS+xec1bqJsU
	JHacfQ1WLyKgJ3Hu8T+oehGJfS/eMYIslhBo5ZD4/G01O8QyAYlvkw8BFXEAJWQlNh2AmiMp
	cXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSGRP
	3MF4/4D1IcZkoPUTmaVEk/OBiSGvJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2amp
	BalF8UWlOanFhxiZODilGhjPMBk9lLwd5ekmeXhJ/ofV0s25MRYRnzIUbCqlWF8qmzT9uBmd
	o6LXqZu5O/pI34QLJ1/+//O94fX3/TnPzx9Qtp/o99dU9zt/WM717CIh0Q5LtgMvL/eeYLn4
	xp358tl/7LPk51SGXlzk93nTCpaA1LecJ9ao7QuOsyzi2etqsZpvFpdJuZASS3FGoqEWc1Fx
	IgCQX/I/AgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd15hvHBBt/vclv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjHUzWhgLZohXbN/zi7mB8Z9AFyMnh4SAicTyrX3sELaY
	xIV769m6GLk4hASmM0osX/YByvnDKHHv7QYWkCo2AU2JR3d72EESIgI7GCUmr13ECuIwCzxk
	lPj5dj8zSJWwgIfEslk7wGwWAVWJ9dNfMYLYvAKWEnM6nkLZghI/Jt8Dm8osoCWxfudxJghb
	XmLzmrfMEDcpSOw4+xqsXkRAT+Lc439Q9SIS+168Y5zAKDALyahZSEbNQjJqFpKWBYwsqxhF
	UwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC08YzqR2MKxssDjEKcDAq8fAaRMUFC7EmlhVX5h5i
	lOBgVhLh5dCMDxbiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGBKyyuJNzQ2MTOyNDKzMDIx
	NydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxs6X2rPTGyUTWhmyVninXxaeFMr8ct0l
	s83v//W+CGisvfOa0T1/4dXypGMJX/6d3/33VIHcNUuZvxLGK/tnGe7z8arrNy5eeev2P53m
	7T07asrd1vQrBagbfD12+f4EpTm/Du6J51j7VMHuqnOhcpzvmpkdufUVPYpRbWYuXkUxWe7c
	dRdjlViKMxINtZiLihMBWvublF8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This v4 patchset supports 4 levels of tranlsation tables for ARM64.

Firstly, The patchset decouples page size from level of translation tables
as taking account into the comment from Catalin Marinas:
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
arch/arm64/include/asm/pgtable.h              |   53 +++++++++-
arch/arm64/include/asm/tlb.h                  |   11 ++-
arch/arm64/kernel/head.S                      |   46 +++++++--
arch/arm64/kernel/traps.c                     |   19 ++--
arch/arm64/mm/fault.c                         |    1 +
arch/arm64/mm/mmu.c                           |   16 ++-
19 files changed, 508 insertions(+), 63 deletions(-)

