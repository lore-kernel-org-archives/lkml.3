Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaAVTB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:01:58 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46035 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVTBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:01:54 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: [PATCH RFC 0/4] reserved-memory regions/CMA in devicetree, again
Date: Wed, 22 Jan 2014 12:58:48 -0600
Message-Id: <1390417133-6650-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Marek-

What is the current status of the reserved-memory/CMA device tree support
series?  It looks like it's stalled out a bit since the revert[2].  Hopefully
this series is a push in the right direction?

---
This set is an adaptation of Marek's original patchset posted here[1],
and then subsequently reverted here[2].  In [3], Grant proposed a new
set of bindings after discussion in Edinburgh.

This is a partially complete implementation of these proposed bindings.

It's functionality is now split into two pieces, the first of which
implements a default/fallback behavior for reserved-memory nodes; that
is, reserved memory nodes describing fixed-address static regions will
be unconditionally reserved, regardless of their intended use.  In
addition, it provides an interface for adding additional reserved-memory
types, using a method similar to CLOCKSOURCE_OF_DECLARE().

The second piece uses the above method to provide support for
reserved-memory nodes whose compatible = "shared-dma-pool".  It makes
use of CMA when available, and when a describing node has the 'reusable'
property.

There is basic support for dynamic allocation of memory reserved
regions, however, noticeably missing is support for additional
restrictions (use of alignment and alloc-ranges properties).

[1]: http://lkml.kernel.org/g/1377527959-5080-1-git-send-email-m.szyprowski@samsung.com
[2]: http://lkml.kernel.org/g/1381476448-14548-1-git-send-email-m.szyprowski@samsung.com
[3]: http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca

Grant Likely (1):
  of: document bindings for reserved-memory nodes

Josh Cartwright (1):
  drivers: of: implement reserved-memory handling for dma

Marek Szyprowski (2):
  drivers: of: add initialization code for reserved memory
  ARM: init: add support for reserved memory defined by device tree

 .../bindings/reserved-memory/reserved-memory.txt   | 137 +++++++++++++++
 arch/arm/mm/init.c                                 |   3 +
 drivers/of/Kconfig                                 |  13 ++
 drivers/of/Makefile                                |   2 +
 drivers/of/of_reserved_mem.c                       | 188 +++++++++++++++++++++
 drivers/of/of_reserved_mem_dma.c                   | 178 +++++++++++++++++++
 drivers/of/platform.c                              |   4 +
 include/asm-generic/vmlinux.lds.h                  |  11 ++
 include/linux/of_reserved_mem.h                    |  61 +++++++
 9 files changed, 597 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 create mode 100644 drivers/of/of_reserved_mem_dma.c
 create mode 100644 include/linux/of_reserved_mem.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

