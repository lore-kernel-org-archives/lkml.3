Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935312Ab3BOFq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:46:27 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8261 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3BOFq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:46:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 14 Feb 2013 21:45:21 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 0/4] gpiolib: some fixup patches
Date: Fri, 15 Feb 2013 14:46:13 +0900
Message-ID: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series is a fixup to patch 6/9 of my previous series ("gpiolib: use
descriptors internally"), which mainly addresses issues raised by Linus W. in
this patch and a few other minor ones caught while proof-reading gpiolib.

First patch is the most significant. It mostly avoids oopses when passing an
invalid GPIO to some functions. Also gpio_get/set_value*() now return 0 when
given an invalid GPIO number instead of oopsing. I tend to think that's an
improvement, but if it's not please let me know.

Ideally these patches should be melded into the above-mentioned patch since
they were intended to become a new revision, but I leave that decision to
Grant's discretion.

This patchset has been tested on Tegra 2/Ventana with a GPIO backlight driver
and the sysfs interface.

Changes from v1:
- as suggested by Ryan Mallon, add a dedicated control flow for signaling
  invalid GPIOs to avoid meaningless error messages and ugly ternary operators
- use pr_warn instead of pr_debug to signal invalid GPIOs
- do descriptors validity check before acquiring any lock

Alexandre Courbot (4):
  gpiolib: check descriptors validity before use
  gpiolib: use const parameters when possible
  gpiolib: move comment to right function
  gpiolib: rename local offset variables to "hwgpio"

 drivers/gpio/gpiolib.c | 213 +++++++++++++++++++++++++++----------------------
 1 file changed, 117 insertions(+), 96 deletions(-)

-- 
1.8.1.3

