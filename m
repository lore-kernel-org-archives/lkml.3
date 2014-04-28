Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaD1OJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:09:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:15216 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbaD1OJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:09:03 -0400
X-AuditID: cbfee61b-b7f766d00000646c-39-535e60fe3223
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 0/2] mfd: max77693: improve regmap support
Date: Mon, 28 Apr 2014 16:08:21 +0200
Message-id: <1398694103-29320-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e+xoO6/hLhgg5c3OCyWXLzKbvH6haHF
	/a9HGS0u75rDZrH2yF12iweHd7Jb7O/sYLQ43c3qwOGxZ+JJNo871/awecw7GejRt2UVo8f0
	eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DK+DT5JnvBJPaKhs2/GRsYd7N2MXJwSAiYSNxr5Opi
	5AQyxSQu3FvP1sXIxSEkMJ1R4mXfZ3aQhJBAO5PEvgeaIDabgI7Elu8TGEFsEQF9iQ87rjKD
	NDALbGSUmDjzIzNIQljASuL6781MIDaLgKrEtsVXwWxeAVeJI4++s0Nsk5M4eWwy6wRG7gWM
	DKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkPmmfQOxlUNFocYBTgYlXh4O2LigoVYE8uK
	K3MPMUpwMCuJ8ArGAYV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJ
	MnFwSjUwrkndnb17jexchqlty89Ndg+Yp/R6qVxVafOktxtu6p8/Lrs1xO9FGb9r6eKojK+6
	B6PVOCc8Wu/Kvqq/S+HtBk3WWX9OJgdKHb33n601WO7i8eB9p3XaubdJFpe8zZUKf/P7+gGp
	dNO/vq1yCxde3yA8h7NUw/Uy003Bol0tHT8jX8mx+LF/UWIpzkg01GIuKk4EAJqZy5gVAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies max77693 driver and associated function drivers
to improve regmap support. It removes unnecessary wrapper functions,
which make code more clean, and modifies IRQ handling to use regmap irq.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Robert Baldyga (2):
  mfd: max77693: remove unnecessary wrapper functions
  mfd: max77693: handle IRQs using regmap

 drivers/extcon/extcon-max77693.c     |  33 ++--
 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/Makefile                 |   2 +-
 drivers/mfd/max77693-irq.c           | 336 -----------------------------------
 drivers/mfd/max77693.c               | 210 +++++++++++++++-------
 drivers/regulator/max77693.c         |  12 +-
 include/linux/mfd/max77693-private.h |  55 ++++--
 7 files changed, 217 insertions(+), 432 deletions(-)
 delete mode 100644 drivers/mfd/max77693-irq.c

-- 
1.9.1

