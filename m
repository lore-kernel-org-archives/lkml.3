Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab3GDFlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:41:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:54405 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab3GDFlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:41:35 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andy Whitcroft <apw@canonical.com>, Anton Vorontsov <cbou@mail.ru>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        Felipe Balbi <balbi@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: [RFC PATCH 0/4] CONFIG_COMPILE_TEST: additional examples and checkpatch rule
Date: Thu, 4 Jul 2013 01:39:09 -0400
Message-ID: <1372916353-24050-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I only just noticed the existence of CONFIG_COMPILE_TEST (now in
mainline as of merge fc76a258d41 ("Merge tag 'driver-core-3.11-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core")

I like this; it parallels a discussion I had with Andrew a while ago:

	https://lkml.org/lkml/2013/3/7/456

I wish I had seen it earlier, as at the moment it only has three use case
instances/examples.  I have at my fingertips three more that were cases
where I wanted to add a real world dependency that limited the option to
those who it was useful to, but the rebuttals I got were that the
maintainers liked the compile coverage (see links in each commmit.)

It might be nice to have a few more examples showing proper dependency
usage of COMPILE_TEST, if the opportunity arises.  In the same vein as
having more available examples, we can teach checkpatch to spot when
people incorrectly try and use this in C (as has already happened.)
It might help avoid doing that education campaign via lkml lessons.

That said, I realize we are well into week one of the merge window,
so if need be, it isn't a problem for me to hang on to them for 3.12.

Thanks,
Paul.
---

[I made a temporary bad commit to test the new checkpatch rule.  I
[also build tested for OMAP2 with USB options on & COMPILE_TEST off]

Cc: Andy Whitcroft <apw@canonical.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Moiz Sonasath <m-sonasath@ti.com>

Paul Gortmaker (4):
  usb: limit OMAP related USB options to OMAP2PLUS platforms
  power: make goldfish_battery depend on GOLDFISH || COMPILE_TEST
  video: make goldfish video depend on GOLDFISH || COMPILE_TEST
  checkpatch: only allow COMPILE_TEST in Kconfig dependency lines

 drivers/power/Kconfig   | 2 +-
 drivers/usb/phy/Kconfig | 2 ++
 drivers/video/Kconfig   | 2 +-
 scripts/checkpatch.pl   | 6 ++++++
 4 files changed, 10 insertions(+), 2 deletions(-)

-- 
1.8.1.2

