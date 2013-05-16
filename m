Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3EPRSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:18:12 -0400
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46953 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab3EPRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:18:07 -0400
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix suspend/resume issues created by pinmux on exynos
Date: Thu, 16 May 2013 10:12:30 -0700
Message-Id: <1368724352-10849-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches fixes some problems with suspend/resume that were
introduced by the switch from the old gpio code to the new pinmux
code.  Specifically:
* It adds saving and restoring of pincontrol registers.
* It fixes eint wakeups.

This set of two patches was verified on a backport of the current
pinmux code onto 3.8 on a Samsung ARM Chromebook.  Suspend/resume does
not seem functional on the ARM Chromebook on current ToT Linux so I
couldn't validate there.  This gets us one step closer, though!  Since
patches applied cleanly I'm fairly certain that they will work on ToT
as well as they do in our tree.

These patches have only been tested on exynos5250.  I have made an
effort to support other samsung boards (even those with two CONF
registers), but that support is untested.

Tomasz Figa has said that he has similar patches in development.  I'm
posting what we have here but if Tomasz's patches end up being more
suitable I have no objections to taking them over these (or of Tomasz
wants to merge the two?).

If you'd like to see the gerrit reviews of these in the Chrome OS tree,
you can see:
* https://gerrit.chromium.org/gerrit/#/c/51336/4
* https://gerrit.chromium.org/gerrit/#/c/51342/3


Doug Anderson (1):
  pinctrl: samsung: fix suspend/resume functionality

Prathyush K (1):
  pinctrl: exynos: fix eint wakeup by using irq_set_wake()

 drivers/pinctrl/pinctrl-exynos.c  |  45 ++++++---
 drivers/pinctrl/pinctrl-exynos.h  |   3 +-
 drivers/pinctrl/pinctrl-samsung.c | 199 ++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/pinctrl-samsung.h |  13 +++
 4 files changed, 247 insertions(+), 13 deletions(-)

-- 
1.8.2.1

