Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaBTKxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:53:00 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63238 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaBTKw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:52:56 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-0f-5305de85e6b2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 0/7] reserved-memory regions/CMA in devicetree, again
Date: Thu, 20 Feb 2014 11:52:40 +0100
Message-id: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRXUhTYQCG+875zo/LwWmaHEQsFoUETo2Cr5AYQfhdREYWlAS56VDBqW1t
	ZDfZnFPndDoFpUxdui6Wf0xRZyY6hkplaP4V6iLsB3VmOY2yzXJ497wvz3v1sqToDxnJZufe
	VahyZTliWgBf747NxBo8VEr88x4CBSyjDPqhKybRxjMTQE3utxQye60UGvb3A+StKIXI2fEd
	oAmdl0F9ZfUM2pr5RCDH8hyFrIZWiKYHGmjU7l5iUNfKCIFs81MEah7TU8hfF41ezfto1OZu
	YVBVXTtExS/dDAr0OSBaHTFA1Fm/BpF9wA/Qys9xKI3CbY1tAP/dsQC8VlMF8HRlBYGdj5YY
	bPLqKeywl9F4cW6Qxt2tD/DC7jKJZ8Z1FO7wrxLYHIjHTwYqAa7ssQPsc0RfOZQqSMxQ5GRr
	Faq482mCLP1OC5m/EXOvudtBFALbESMIYXnuNG9+uE3tcwQ/6emkjUDAijgb4Ldqaon9UE7w
	T+t/M0GL5hJ447qRDnI4ZwW8rxEGJZL7SPOlU6a9BcuGcZivdkcGHcgd5z2TThishXu18821
	IPLcUb7BklgFDjaDA3ZwWKFJz1fLM5WnJGqZUq3JzZSk5ykdYP+u7X5gGz3nAhwLxKHCG/Mw
	RUTJtOoCpQvwLCkOF/Z+oFJEwgxZwX2FKu+2SpOjULsAwYZEFgJpUbKkN5a+2CtvK3nenvhC
	mrXZ9M80Vr6wKk8eWi+OKqhI3V2+WeRCF+Cd8M/XZ5NCdIOSusuP4ZfS7ls+08SahyxJ9f9a
	lJ45VttVYj3BOGPenY2Td7o0SWkRwz36ofIWd3WYXfs1kP8+dMgAYxzmxrLNqEta9VW35Ztz
	VgzVWbKEk6RKLfsPDTSBpIwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

This is another quick update of the patches which add basic support for
dynamic allocation of memory reserved regions defined in device tree.

This time I hope I've really managed to address all the issues reported
by Grant Likely, see the change log for more details. As a bonus, I've
added support for ARM64 and PowerPC, as those architectures had quite
well defined place where early memory reservation can be done.

The initial code for this feature were posted here [1], merged as commit
9d8eab7af79cb4ce2de5de39f82c455b1f796963 ("drivers: of: add
initialization code for dma reserved memory") and later reverted by
commit 1931ee143b0ab72924944bc06e363d837ba05063. For more information,
see [2]. Finally a new bindings has been proposed [3] and Josh
Cartwright a few days ago prepared some code which implements those
bindings [4]. This finally pushed me again to find some time to finish
this task and review the code. Josh agreed to give me the ownership of
this series to continue preparing them for mainline inclusion.

For more information please refer to the changlelog below.

[1]: http://lkml.kernel.org/g/1377527959-5080-1-git-send-email-m.szyprowski@samsung.com
[2]: http://lkml.kernel.org/g/1381476448-14548-1-git-send-email-m.szyprowski@samsung.com
[3]: http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
[4]: http://thread.gmane.org/gmane.linux.documentation/19579

Changelog:

v4:
- dynamic allocations are processed after all static reservations has been
  done
- moved code for handling static reservations to drivers/of/fdt.c
- removed node matching by string comparison, now phandle values are used
  directly
- moved code for DMA and CMA handling directly to
  drivers/base/dma-{coherent,contiguous}.c
- added checks for proper #size-cells, #address-cells, ranges properties
  in /reserved-memory node
- even more code cleanup
- added init code for ARM64 and PowerPC

v3: http://article.gmane.org/gmane.linux.documentation/20169/
- refactored memory reservation code, created common code to parse reg, size,
  align, alloc-ranges properties
- added support for multiple tuples in 'reg' property
- memory is reserved regardless of presence of the driver for its compatible
- prepared arch specific hooks for memory reservation (defaults use memblock
  calls)
- removed node matching by string during device initialization
- CMA init code: added checks for required region alignment
- more code cleanup here and there

v2: http://thread.gmane.org/gmane.linux.documentation/19870/
- removed copying of the node name
- split shared-dma-pool handling into separate files (one for CMA and one
  for dma_declare_coherent based implementations) for making the code easier
  to understand
- added support for AMBA devices, changed prototypes to use struct decice
  instead of struct platform_device
- renamed some functions to better match other names used in drivers/of/
- restructured the rest of the code a bit for better readability
- added 'reusable' property to exmaple linux,cma node in documentation
- exclusive dma (dma_coherent) is used for only handling 'shared-dma-pool'
  regions without 'reusable' property and CMA is used only for handling
  'shared-dma-pool' regions with 'reusable' property.

v1: http://thread.gmane.org/gmane.linux.documentation/19579
- initial version prepared by Josh Cartwright

Summary:

Grant Likely (1):
  of: document bindings for reserved-memory nodes

Marek Szyprowski (6):
  drivers: of: add initialization code for reserved memory
  drivers: dma-coherent: add initialization from device tree
  drivers: dma-contiguous: add initialization from device tree
  arm: add support for reserved memory defined by device tree
  arm64: add support for reserved memory defined by device tree
  powerpc: add support for reserved memory defined by device tree

 .../bindings/reserved-memory/reserved-memory.txt   |  138 +++++++++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/mm/init.c                                 |    3 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/mm/init.c                               |    2 +
 arch/powerpc/Kconfig                               |    1 +
 arch/powerpc/kernel/prom.c                         |    3 +
 drivers/base/dma-coherent.c                        |   41 +++
 drivers/base/dma-contiguous.c                      |  130 +++++++--
 drivers/of/Kconfig                                 |    6 +
 drivers/of/Makefile                                |    1 +
 drivers/of/fdt.c                                   |  145 ++++++++++
 drivers/of/of_reserved_mem.c                       |  296 ++++++++++++++++++++
 drivers/of/platform.c                              |    7 +
 include/asm-generic/vmlinux.lds.h                  |   11 +
 include/linux/of_reserved_mem.h                    |   65 +++++
 16 files changed, 829 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 include/linux/of_reserved_mem.h

-- 
1.7.9.5

