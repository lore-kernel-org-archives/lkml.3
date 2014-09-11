Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaIKLWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:22:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46643 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaIKLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:22:50 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-37-54118607e652
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 0/3] CMA & device tree, another approach
Date: Thu, 11 Sep 2014 13:22:38 +0200
Message-id: <1410434561-9294-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4VV32NsEQg89NFhZz1q9hs/g76Ri7
	xYE/OxgtVnY3s1nsXPeO0eJs0xt2i+2dM9gtvlx5yGSx6fE1VovLu+awWaw9cpfdYsHxFlYH
	Ho/fvyYxelzu62Xy6Hp7hcnjzrU9bB4nZvxm8di8pN7j9r/HzB7r/rxi8ujbsorR4/MmuQCu
	KC6blNSczLLUIn27BK6Mg+eOMxbcEarYucK+gXE2fxcjJ4eEgInEtO41zBC2mMSFe+vZuhi5
	OIQEljJKvJqxhxXC6WOS6NuwB6yKTcBQouttFxuILSLgJvFv3SGwDmaBycwS1xbuYQJJCAtY
	S9xbuooRxGYRUJVYv2YiO4jNK+Au8WzRelaIdXIS/1+uYJrAyL2AkWEVo2hqaXJBcVJ6rqFe
	cWJucWleul5yfu4mRkggftnBuPiY1SFGAQ5GJR7ewov8IUKsiWXFlbmHGCU4mJVEeEsLBUOE
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MLpYyfutVErzZHbY/tYtY92Rg7P2BxnUW9spvvm8fM2H
	uH8Xpxlc2PpSzDE029TFP2R/laRl3v1C5ZIavpDvX6tN5y3f+bw+Qei/w6Unf11Ttjxd1BHQ
	ZDhvAXek2C3fTGE1E6d1CjvcDBevF2vbYX/6UlTMNPMZLkmrnldL1k8oa2l3OvJrqxJLcUai
	oRZzUXEiAG0r9M0iAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is another approach to finish support for reserved memory regions
defined in device tree. Previous attempts 
(http://lists.linaro.org/pipermail/linaro-mm-sig/2014-February/003738.html
and https://lkml.org/lkml/2014/7/14/108) ended in merging parts of the
code and documentation. Merged patches allow to reserve memory, but
there is still no reserved memory drivers nor any code that actually
uses reserved memory regions.

The final conclusion from the above mentioned threads is that there is
no automated reserved memory initialization. All drivers that want to
use reserved memory, should initialize it on their own.

This patch series provides two driver for reserved memory regions (one
based on CMA and one based on dma_coherent allocator). The main
improvement comparing to the previous version is removal of automated
reserved memory for every device and support for named memory regions.

Those patches are for merging, rebased on top of recent linux-next tree.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland

Changes since v1 (https://lkml.org/lkml/2014/8/26/339):
- removed patches for named reserved regions - they will be discussed
  separately
- added a check for 'no-map' property to dma coherent allocator
  (suggested by Laura Abbott)
- removed example code for s5p-mfc driver

Changes since '[PATCH v2 RESEND 0/4] CMA & device tree, once again' version:
(https://lkml.org/lkml/2014/7/14/108)
- added return error value to of_reserved_mem_device_init()
- added support for named memory regions (so more than one region can be
  defined per device)
- added usage example - converted custom reserved memory code used by
  s5p-mfc driver to the generic reserved memory handling code

Patch summary:

Marek Szyprowski (3):
  drivers: of: add return value to of_reserved_mem_device_init
  drivers: dma-coherent: add initialization from device tree
  drivers: dma-contiguous: add initialization from device tree

 drivers/base/dma-coherent.c     | 145 ++++++++++++++++++++++++++++++++++------
 drivers/base/dma-contiguous.c   |  71 ++++++++++++++++++++
 drivers/of/of_reserved_mem.c    |   3 +-
 include/linux/cma.h             |   3 +
 include/linux/of_reserved_mem.h |   9 ++-
 mm/cma.c                        |  62 ++++++++++++++---
 6 files changed, 259 insertions(+), 34 deletions(-)

-- 
1.9.2

