Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab3EISPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 14:15:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:32188 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3EISPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 14:15:06 -0400
Message-ID: <518BE7A9.9010907@tilera.com>
Date: Thu, 9 May 2013 14:15:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] tile changes for v3.10
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.10 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git stable

These are actually "stable" changes so if the merge window closes, please
do apply them for -rc2.

The interesting bug fix is support for the upcoming "4.2" release of
the Tilera hypervisor, which by default launches Linux at privilege level 2
instead of 1.  The fix lets new and old hypervisors and Linuxes
interoperate more smoothly, so I've tagged it for stable@kernel.org so
that older Linuxes will be able to boot under the newer hypervisor.

Chris Metcalf (1):
      tile: support new Tilera hypervisor

Denis Efremov (1):
      arch/tile: remove inline marking of EXPORT_SYMBOL functions

Libo Chen (1):
      usb: tilegx: fix memleak when create hcd fail

Wei Yongjun (1):
      rtc: rtc-tile: add missing platform_device_unregister() when module exit

 arch/tile/Kconfig                  |   14 ++++++++++----
 arch/tile/include/hv/hypervisor.h  |   27 ++++++++++++++++++++++++---
 arch/tile/kernel/head_32.S         |    2 +-
 arch/tile/kernel/head_64.S         |   12 +++++++++---
 arch/tile/lib/spinlock_32.c        |    2 +-
 drivers/net/ethernet/tile/tilegx.c |    2 +-
 drivers/rtc/rtc-tile.c             |    1 +
 drivers/usb/host/ehci-tilegx.c     |    7 +++++--
 drivers/usb/host/ohci-tilegx.c     |    7 +++++--
 9 files changed, 57 insertions(+), 17 deletions(-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

