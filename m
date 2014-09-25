Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaIYNSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:18:36 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38450 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaIYNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:18:34 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 25 Sep 2014 14:18:12 +0100
X-Google-Sender-Auth: PA_Bv2hqksc9UiFoaKBoIdYca_8
Message-ID: <CACxGe6vFYRO_s9Wd2dMdWd2zwCxZRXATTVQiYvBRFdSkWfOsqw@mail.gmail.com>
Subject: [GIT PULL] Devicetree bug fixes and documentation for v3.17
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bugfix branch. Description below...

Thanks,
g.

The following changes since commit 2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to 9aacd602f0246f1b1f3c4684b2ab13d0772976f7:

  of/fdt: fix memory range check (2014-09-25 11:55:50 +0100)

----------------------------------------------------------------
Devicetree bug fixes and documentation for v3.17

Several bug fix commits for issues found in the v3.17 rc series. Most of
these are minor in that they aren't actively dangerous, but they have
been seen in the wild. The one important fix is 7dbe5849fb, "of: make
sure of_alias is initialized before accessing it", without which some
powerpc platforms will fail to find stdout for the console.

----------------------------------------------------------------
Brian Norris (1):
      of: correct of_console_check()'s return value

Gaurav Minocha (2):
      of: Disabling OF functions that use sysfs if CONFIG_SYSFS disabled
      of: Documentation regarding attaching OF Selftest testdata

Geert Uytterhoeven (1):
      of: Fix memory block alignment in early_init_dt_add_memory_arch()

Laurentiu Tudor (1):
      of: make sure of_alias is initialized before accessing it

Srinivas Kandagatla (1):
      of/fdt: fix memory range check

 Documentation/devicetree/of_selftest.txt | 211 +++++++++++++++++++++++++++++++
 drivers/of/base.c                        |  16 ++-
 drivers/of/dynamic.c                     |   3 +
 drivers/of/fdt.c                         |  14 +-
 4 files changed, 237 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/of_selftest.txt
