Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaIWTFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:05:50 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64182 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbaIWTFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:05:47 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 0/5] pinctrl: samsung: Data structure clean-up
Date: Tue, 23 Sep 2014 21:05:36 +0200
Message-Id: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series intends to clean up data structures used by pinctrl-samsung driver.
More specifically, it separates initial compile time constants from data used
at runtime, allowing unused variant data to be dropped and selected structures
constified to improve safety.

As a side effect, size of vmlinux built from multi_v7_defconfig was reduced
from:

 text     data    bss    dec      hex    filename
 10296708 1227100 313544 11837352 b49fa8 vmlinux

to:

 text     data    bss    dec      hex    filename
 10296740 1176860 313544 11787144 b3db88 vmlinux

and quite a bit of data were moved from normal data sections to .init.data:

pre:

Idx Name          Size      VMA       LMA       File off  Algn
  3 .rodata       0026c080  c0881000  c0881000  00681000  2**6
 23 .init.data    0003ff7c  c0bdb830  c0bdb830  009e3830  2**3
 24 .data..percpu 00002100  c0c1c000  c0c1c000  00a24000  2**6
 25 .data         000e98e0  c0c20000  c0c20000  00a28000  2**6

post:

Idx Name          Size      VMA       LMA       File off  Algn
  3 .rodata       0026bf20  c0881000  c0881000  00681000  2**6
 23 .init.data    00041bbc  c0bdb830  c0bdb830  009e3830  2**3
 24 .data..percpu 00002100  c0c1e000  c0c1e000  00a26000  2**6
 25 .data         000db860  c0c22000  c0c22000  00a2a000  2**6

This series should not introduce any functional changes.

Tested on S3C6410-based Mini6410 board, booting with device tree.

Marek, Bart, could you do some testing on Exynos-based boards,
just to make sure?

Tomasz Figa (5):
  pinctrl: samsung: Make samsung_pinctrl_get_soc_data use ERR_PTR()
  pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
  pinctrl: samsung: Constify samsung_pin_bank_type struct
  pinctrl: samsung: Constify samsung_pin_ctrl struct
  pinctrl: samsung: Separate per-bank init and runtime data

 drivers/pinctrl/samsung/pinctrl-exynos.c  | 113 +++++++++++----------------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  30 +++----
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  31 ++++----
 drivers/pinctrl/samsung/pinctrl-samsung.c | 126 ++++++++++++++++--------------
 drivers/pinctrl/samsung/pinctrl-samsung.h |  78 ++++++++++++------
 5 files changed, 193 insertions(+), 185 deletions(-)

-- 
2.1.0

