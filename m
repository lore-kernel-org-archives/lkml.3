Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbaDOJBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:01:42 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49144 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaDOJBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:01:40 -0400
MIME-Version: 1.0
Date: Tue, 15 Apr 2014 11:01:39 +0200
Message-ID: <CACRpkdZJ3A=u1CyKqNOEhkL5Zw7p4+V476HOcvdymJSB=A6RuA@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.15, take 1
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sherman Yin <syin@broadcom.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a set of pin control fixes for v3.15.

I have no clue why the rename is not appearing as a rename in the
shortlog, maybe some fuzzing issue, or Sherman has changed too many
things inside the moved file for it to be detected as a proper rename.

I know the renaming thing may be disturbing, tell me if you hate it and
I'll send a tag without this and move it over to the v3.16 cycle, no biggie.

Anyway, please pull this for the -rc2.

Yours,
Linus Walleij


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.15-2

for you to fetch changes up to dc4bb474cd1ff39dcda996344114edb47cc8df04:

  pinctrl: fix typo in bindings documentation (2014-04-14 09:39:33 +0200)

----------------------------------------------------------------
A first set of pin control fixes for the v3.15 series:

- Fix a couple of barnsjukdomar on the Rockchip driver.

- Remove an idiotic debug print I happened to leave behind
  in the Nomadik driver.

- Fixup the Qualcomm MSM interrupt handling code for the
  TLMM v2.

- Three patches renaming the Broadcom Capri driver to
  BCM28155. This has been falling between the chairs for
  some time due to some cross-tree synchronization
  misunderstandings, now I'm fed up with this and just
  rename it in this -rc1 phase.

----------------------------------------------------------------
Beniamino Galvani (1):
      pinctrl: rockchip: fix offset of mux registers for rk3188

Bjorn Andersson (1):
      pinctrl: msm: Correct interrupt code for TLMM v2

Heiko Stübner (2):
      pinctrl: rockchip: add return value to rockchip_set_mux
      pinctrl: rockchip: handle first half of rk3188-bank0 correctly

Linus Walleij (1):
      pinctrl: nomadik: delete stray debug print

Sherman Yin (3):
      pinctrl: Rename Broadcom Capri pinctrl driver
      Update bcm_defconfig with new pinctrl CONFIG
      pinctrl: fix typo in bindings documentation

 .../bindings/pinctrl/brcm,bcm11351-pinctrl.txt     |    2 +-
 arch/arm/configs/bcm_defconfig                     |    2 +-
 drivers/pinctrl/Kconfig                            |    8 +-
 drivers/pinctrl/Makefile                           |    2 +-
 drivers/pinctrl/pinctrl-bcm281xx.c                 | 1461 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-capri.c                    | 1454 -------------------
 drivers/pinctrl/pinctrl-msm.c                      |    6 +-
 drivers/pinctrl/pinctrl-msm.h                      |    1 +
 drivers/pinctrl/pinctrl-nomadik.c                  |    1 -
 drivers/pinctrl/pinctrl-rockchip.c                 |   48 +-
 10 files changed, 1514 insertions(+), 1471 deletions(-)
 create mode 100644 drivers/pinctrl/pinctrl-bcm281xx.c
 delete mode 100644 drivers/pinctrl/pinctrl-capri.c
