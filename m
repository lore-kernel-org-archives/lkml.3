Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaBHUhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:37:00 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43166 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaBHUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:36:58 -0500
MIME-Version: 1.0
Date: Sat, 8 Feb 2014 21:36:58 +0100
Message-ID: <CACRpkda=n3h5mtwvrbTBjaWC7hD3_YBNZM+GHA+w-3JDQ0ncVQ@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.14 take one
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some queued fixes for the v3.14 series, six of
these are even targeted for stable. More details in the
signed tag.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-v3.14-2

for you to fetch changes up to 5b232c5addc02980cfce451575f1d1f975bdb04e:

  pinctrl: tegra: return correct error type (2014-02-06 14:21:19 +0100)

----------------------------------------------------------------
First round of pin control fixes for v3.14:

- Protect pinctrl_list_add() with the proper mutex. This
  was identified by RedHat. Caused nasty locking warnings
  was rootcased by Stanislaw Gruszka.

- Avoid adding dangerous debugfs files when either half of
  the subsystem is unused: pinmux or pinconf.

- Various fixes to various drivers: locking, hardware
  particulars, DT parsing, error codes.

----------------------------------------------------------------
Chris Ruehl (2):
      pinctrl: imx27: fix wrong offset to ICONFB
      pinctrl: imx27: fix offset calculation in imx_read_2bit

Florian Vaussard (1):
      pinctrl: do not init debugfs entries for unimplemented functionalities

Laxman Dewangan (1):
      pinctrl: tegra: return correct error type

Nicolas Ferre (1):
      pinctrl: at91: use locked variant of irq_set_handler

Qipan Li (1):
      pinctrl: sirf: correct the pin index of ac97_pins group

Stanislaw Gruszka (1):
      pinctrl: protect pinctrl_list add

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

 drivers/pinctrl/core.c                |  8 ++++++--
 drivers/pinctrl/pinctrl-at91.c        | 10 +++++-----
 drivers/pinctrl/pinctrl-imx1-core.c   | 10 +++++-----
 drivers/pinctrl/pinctrl-tegra.c       |  2 +-
 drivers/pinctrl/sirf/pinctrl-prima2.c |  2 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c  | 15 ++++++++++++++-
 6 files changed, 32 insertions(+), 15 deletions(-)
