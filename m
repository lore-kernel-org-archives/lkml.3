Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbbATJMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:12:48 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64958 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbbATJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:12:44 -0500
MIME-Version: 1.0
Date: Tue, 20 Jan 2015 10:12:43 +0100
Message-ID: <CACRpkdb30CJebOnTGFTwHXUd7NTMGZcyzRWvstrLHU+ULwXi_g@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for the v3.19 series
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a (hopefully final) slew of pin control fixes for the v3.19 series.
The deadlock fix is kind of serious and tagged for stable, the rest is
business as usual.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.19-3

for you to fetch changes up to dbe752a34d4bd862de154d1e1f8eb9b649601f77:

  pinctrl: MAINTAINERS: add git tree reference (2015-01-19 11:27:19 +0100)

----------------------------------------------------------------
Pin control fixes for the v3.19 series:

- Fix two deadlocks around the pin control mutexes,
  a long-standing issue that manifest itself in
  plug/unplug of pin controllers. (Tagged for stable.)

- Handle an error path with zero functions in the
  Qualcomm pin controller.

- Drop a bogus second GPIO chip added in the Lantiq
  driver.

- Fix sudden IRQ loss on Rockchip pin controllers.

- Register the GIT tree in MAINTAINERS.

----------------------------------------------------------------
Doug Anderson (1):
      pinctrl: rockchip: Avoid losing interrupts when supporting both edges

Jim Lin (1):
      pinctrl: Fix two deadlocks

Johan Hovold (1):
      pinctrl: lantiq: remove bogus of_gpio_chip_add

Linus Walleij (1):
      pinctrl: MAINTAINERS: add git tree reference

Stephen Boyd (1):
      pinctrl: qcom: Don't iterate past end of function array

 MAINTAINERS                        |  1 +
 drivers/pinctrl/core.c             |  5 +++--
 drivers/pinctrl/pinctrl-rockchip.c | 45 +++++++++++++++++---------------------
 drivers/pinctrl/pinctrl-xway.c     |  2 --
 drivers/pinctrl/qcom/pinctrl-msm.c |  4 ++--
 5 files changed, 26 insertions(+), 31 deletions(-)
