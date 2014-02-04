Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaBDMJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:09:53 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:12454 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBDMJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:09:50 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-51-52f0d88c4ac6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH v2 0/5] reserved-memory regions/CMA in devicetree, again
Date: Tue, 04 Feb 2014 13:09:28 +0100
Message-id: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e+xgG7PjQ9BBicnaFn8nXSM3eJDUyuz
	xfwj51gt+t8sZLU48GcHo8Wb3g4Wi53r3jFanG16w26xvXMGu8WXKw+ZLDY9vsZqsbBtCYvF
	5V1z2CzWHrnLbrHh5UEmi6XXLzJZLDjewmrxZ7qcxanrn9ksJkxfy2Kx6f5aRou/2zexWLw6
	2MZisX7GaxaLVbv+MDpIeqyZt4bR4/evSYwerydPYPS43NfL5LFz1l12j543Lawed67tYfPY
	vKTe4/a/x8weV040sXqs+/OKyaP/r4FH35ZVjB6fN8l5bJwbGsAfxWWTkpqTWZZapG+XwJVx
	cd0+5oKXUhXfjj5jbGDsFu1i5OSQEDCRmHviFCOELSZx4d56ti5GLg4hgUWMEmdnvmCBcFqZ
	JF59nM0OUsUmYCjR9baLDcQWEVjIKPF5HlgRs8A0NonPC1+ygiSEBTwk/n24CTaWRUBVYueR
	hcwgNq+Au8Sbv1+BajiA1ilIzJlkM4GRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4Lh5JrWDcWWDxSFGAQ5GJR5eBZUPQUKsiWXFlbmHGCU4mJVEeM23AYV4UxIrq1KL8uOLSnNS
	iw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwmsVf8DZY9zl5ia3L6jiDwJgFTxnO
	dsfY5Ej4zd19oXbW8XfHX2t3d+299uTnoSa1Bmmx82670uQ5xfL6BNo/lDxW1TyY491j4LJw
	z0/zQINX69dMF827uCCPWXyrx/cX7+4eufHrlnN5/EHpTS1NE1g3ldnlF9+Zk5S5vDC7o/xE
	nJY262dVJZbijERDLeai4kQAAHLM95cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

This is an updated version of the second attempt to add basic support
for dynamic allocation of memory reserved regions defined in device
tree.

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

v2:
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

Josh Cartwright (2):
  drivers: of: implement reserved-memory handling for dma
  drivers: of: implement reserved-memory handling for cma

Marek Szyprowski (2):
  drivers: of: add initialization code for reserved memory
  ARM: init: add support for reserved memory defined by device tree

 .../bindings/reserved-memory/reserved-memory.txt   |  138 ++++++++++++
 arch/arm/mm/init.c                                 |    3 +
 drivers/of/Kconfig                                 |   20 ++
 drivers/of/Makefile                                |    3 +
 drivers/of/of_reserved_mem.c                       |  219 ++++++++++++++++++++
 drivers/of/of_reserved_mem_cma.c                   |   75 +++++++
 drivers/of/of_reserved_mem_dma.c                   |   78 +++++++
 drivers/of/platform.c                              |    7 +
 include/asm-generic/vmlinux.lds.h                  |   11 +
 include/linux/of_reserved_mem.h                    |   62 ++++++
 10 files changed, 616 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 drivers/of/of_reserved_mem_cma.c
 create mode 100644 drivers/of/of_reserved_mem_dma.c
 create mode 100644 include/linux/of_reserved_mem.h

-- 
1.7.9.5

