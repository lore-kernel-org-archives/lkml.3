Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaJBSwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:52:19 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35821 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaJBSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:52:17 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 0/5] pinctrl: samsung: Data structure clean-up
Date: Thu,  2 Oct 2014 20:52:06 +0200
Message-Id: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.1
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

Tested on S3C6410-based Mini6410 board booted using device tree, with GPIO
leds and GPIO keyboard. Compile tested for s3c24xx, exynos, s5pv210.

Changes since v1:
 - rebased on current devel branch of pinctrl tree.

Tomasz Figa (5):
  pinctrl: samsung: Make samsung_pinctrl_get_soc_data use ERR_PTR()
  pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
  pinctrl: samsung: Constify samsung_pin_bank_type struct
  pinctrl: samsung: Constify samsung_pin_ctrl struct
  pinctrl: samsung: Separate per-bank init and runtime data

 drivers/pinctrl/samsung/pinctrl-exynos.c  | 111 ++++++++++----------------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  30 +++----
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  31 ++++----
 drivers/pinctrl/samsung/pinctrl-samsung.c | 126 ++++++++++++++++--------------
 drivers/pinctrl/samsung/pinctrl-samsung.h |  78 ++++++++++++------
 5 files changed, 192 insertions(+), 184 deletions(-)

-- 
2.1.1

