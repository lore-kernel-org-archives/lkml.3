Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3A2Wxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:53:47 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34379 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3A2Wxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:53:45 -0500
MIME-Version: 1.0
Date: Tue, 29 Jan 2013 23:53:44 +0100
Message-ID: <CACRpkdaViOmDNP0YD+jd_aKNt0uXhzHNwfqpx=TsckfhE_hj_Q@mail.gmail.com>
Subject: [GIT PULL] late pinctrl fixes for v3.8
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Fabio Estevam <festevam@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a late pinctrl fix pull request, we had to revert out the pinctrl-single
GPIO backend, because of, well, design issues. We're cooking a better
thing for the next cycle.

Please pull it in!

Yours,
Linus Walleij


The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-rc6

for you to fetch changes up to 0fafd50e4b41c06bf6be8dead87075e88ef25303:

  pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused (2013-01-29
23:10:30 +0100)

----------------------------------------------------------------
Pinctrl fixes for the v3.8 series:
- Revert gpio request/free backend, new patch set
  in the works, will be for v3.9. Get this old cruft
  out before anyone hurts himself on it.
- Kconfig buzz
- Various compile warnings
- MPP6 value for the Kirkwood

----------------------------------------------------------------
Andrew Lunn (1):
      pinctrl: mvebu: Fix compiler warnings

Arnd Bergmann (2):
      pinctrl: exynos: don't mark probing functions as __init
      pinctrl: nomadik: nmk_prcm_gpiocr_get_mode may be unused

Fabio Estevam (1):
      pinctrl: pinctrl-mxs: Fix variables' definition type

Haojian Zhuang (1):
      Revert "pinctrl: single: support gpio request and free"

Kukjin Kim (1):
      pinctrl: samsung: removing duplicated condition for PINCTRL_SAMSUNG

Simon Guinot (1):
      pinctrl: mvebu: fix MPP6 value for kirkwood driver

 drivers/pinctrl/Kconfig                  |  1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c     |  2 +-
 drivers/pinctrl/mvebu/pinctrl-kirkwood.c |  8 ++--
 drivers/pinctrl/pinctrl-exynos5440.c     | 10 ++--
 drivers/pinctrl/pinctrl-mxs.c            |  9 ++--
 drivers/pinctrl/pinctrl-nomadik.c        |  2 +-
 drivers/pinctrl/pinctrl-single.c         | 79 +-------------------------------
 7 files changed, 17 insertions(+), 94 deletions(-)
