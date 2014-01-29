Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaA2Waz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 17:30:55 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33444 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaA2Way (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 17:30:54 -0500
Date: Wed, 29 Jan 2014 14:29:01 -0800
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: [GIT PULL] platform/chrome: Cleanups and improvements
Message-ID: <20140129222901.GA28622@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

For 3.13 we split off the Chromebook platform pieces to their own platform
directory since I anticipated adding more code that cuts across both
x86 and ARM to it. It didn't happen for 3.14, but likely for next release.

I apologize for the random merge base -- I temporarily started the branch
after you had merged Matthew's branch that moved out chrome platforms
post 3.13-rc1, and forgot to rebase on the -rc2 when it came out.

Please pull.

Thanks,

-Olof

The following changes since commit 7e3528c3660a2e8602abc7858b0994d611f74bc3:

  slab.h: remove duplicate kmalloc declaration and fix kernel-doc warnings (2013-11-24 11:01:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/olof/chrome-platform.git tags/for-linus

for you to fetch changes up to 2b8454a75b90d7cd1ac325a0baba77244733354f:

  platform/chrome: unregister platform driver/device when module exit (2013-11-26 20:18:07 -0800)

----------------------------------------------------------------
platform/chrome: Cleanups and improvements

* Use deferred probing on Chrome OS platforms for the i2c
  device registration. This fixes a long-standing race of initialization
  of touchpad/screen on Chromebooks.
* Added in platform device registration for pstore console on supported hardware
* Misc smaller fixes (__initdata, module exit cleanup, etc)

----------------------------------------------------------------
Aaron Durbin (1):
      platform/chrome: chromeos_laptop - Restructure device associations

Benson Leung (2):
      platform/chrome: chromeos_laptop - Use deferred probing
      platform/chrome: chromeos_laptop - fix incorrect placement of __initdata tag

Olof Johansson (2):
      platform/chrome: Add pstore platform_device
      platform/chrome: Make i2c_adapter_names static

Wei Yongjun (1):
      platform/chrome: unregister platform driver/device when module exit

 drivers/platform/chrome/Kconfig           |  14 ++
 drivers/platform/chrome/Makefile          |   1 +
 drivers/platform/chrome/chromeos_laptop.c | 298 +++++++++++++++++++++---------
 drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++
 4 files changed, 323 insertions(+), 91 deletions(-)
 create mode 100644 drivers/platform/chrome/chromeos_pstore.c
