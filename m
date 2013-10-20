Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3JTWPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 18:15:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13492 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3JTWPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 18:15:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 20 Oct 2013 15:15:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/3] Fixup patches for gpiod interface
Date: Sun, 20 Oct 2013 15:14:56 -0700
Message-ID: <1382307299-22587-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix a few issues of the gpiod series highlighted by the
autobuild system. They take root in the fact that devres.c was compiled
even when gpiolib is not to be built, which should obviously not happen.
But they also reveal missing includes in the same file, and sparse also
pointed out a suspiscious line that happened to be completely wrong.

Patch 1/3 and 2/3 can be applied on their own, but would probably better
be squashed into bae48da2 "add gpiod_get() and gpiod_put() functions".

Patch 3/3 stands on its own, and should preferably be applied before the
rest of the gpiod series. It would not hurt to apply it after if 1/3 and
2/3 are properly squashed.

Apologies for these issues that could have been caught earlier had I been
less negligent.

Alexandre Courbot (3):
  gpiolib: devres: fix devm_gpiod_get_index()
  gpiolib: devres: add missing headers
  gpiolib: make GPIO_DEVRES depend on GPIOLIB

 drivers/gpio/Kconfig  | 8 ++++----
 drivers/gpio/devres.c | 4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.4.1

