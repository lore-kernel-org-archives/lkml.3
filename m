Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbaD2JMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:12:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13546 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbaD2JMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:12:36 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-80-535f6d02b44d
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, lgirdwood@gmail.com,
        broonie@kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, k.kozlowski@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 0/2] mfd: max77693: improve regmap support
Date: Tue, 29 Apr 2014 11:12:25 +0200
Message-id: <1398762747-1138-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgC5Tbnywwat+XYupD5+wWVz/8pzV
	4vULQ4v7X48yWny70sFkcXnXHDaLtUfuslvcblzBZvHg8E52i9PdrA5cHjtn3WX32LSqk83j
	zrU9bB7zTgZ69G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8bqxudsBa1cFQ8n/mRrYPzA3sXI
	wSEhYCKx/LhWFyMnkCkmceHeerYuRi4OIYFFjBJbjs9lh3DamSSa/1xkBKliE9CR2PJ9Apgt
	IqAv8WHHVWaQImaBm4wSZ34eZwVJCAvYShxq+8IEYrMIqEpsWbwJrIFXwEXi9t9/rBDr5CRO
	HpvMOoGRewEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4EB6JrWDcWWDxSFGAQ5GJR5e
	g6i4YCHWxLLiytxDjBIczEoivPlW8cFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQn
	lqRmp6YWpBbBZJk4OKUaGEMleXusD7zYesH6er+16PxF+s+2/N3nG/z9d6XbPSd78QdPHRc6
	L1pvtOyf7KQ3z5da2Lo6iT4V/HKhWu+76ufClg3ry1b32GbLXE+ZvKl67uMfL7lVZCVm/r9k
	YdFmzhPc7HU/Im//gQY3pw/LIs8eE7tefG9pfIb8gd1Pa6vveOoXz2H12KHEUpyRaKjFXFSc
	CACrrp7mIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset modifies max77693 driver and associated function drivers
to improve regmap support. It removes unnecessary wrapper functions,
which make code more clean, and modifies IRQ handling to use regmap irq.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:

v3:
- fix some style problems

v2: https://lkml.org/lkml/2014/4/29/32
- change type of array given to regmap_bulk_read() from unsigned int to u8
- remove mfd_remove_devices() call from error handling, since it's not needed
- call disable_irq()/enable_irq() in suspend/resume regardless of wakeup source

v1: https://lkml.org/lkml/2014/4/28/298


Robert Baldyga (2):
  mfd: max77693: remove unnecessary wrapper functions
  mfd: max77693: handle IRQs using regmap

 drivers/extcon/extcon-max77693.c     |  35 ++--
 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/Makefile                 |   2 +-
 drivers/mfd/max77693-irq.c           | 336 -----------------------------------
 drivers/mfd/max77693.c               | 210 +++++++++++++++-------
 drivers/regulator/max77693.c         |  12 +-
 include/linux/mfd/max77693-private.h |  54 ++++--
 7 files changed, 217 insertions(+), 433 deletions(-)
 delete mode 100644 drivers/mfd/max77693-irq.c

-- 
1.9.1

