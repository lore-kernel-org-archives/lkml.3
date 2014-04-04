Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaDDRRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:17:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50974 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaDDRRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:17:40 -0400
Message-ID: <533EE932.5090100@tilera.com>
Date: Fri, 4 Apr 2014 13:17:38 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile changes for v3.15
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.15 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

These fix a few stray build issues seen in linux-next, and also
add the minimal required support for perf to tilegx.

Thanks!

Chris Metcalf (2):
      tile: don't use __get_cpu_var() with structure-typed arguments
      arch/tile: remove unused variable 'devcap'

Henrik Austad (1):
      tile: avoid overflow in ns2cycles

Kerry Sheh (1):
      tile: Fix vDSO compilation issue with allyesconfig

Zhigang Lu (4):
      tile: Add support for handling PMC hardware
      tile: Enable NMIs on return from handle_nmi() without errors
      tile/perf: Support perf_events on tilegx and tilepro
      perf tools: Allow building for tile

 arch/tile/Kconfig                  |    6 +
 arch/tile/include/asm/perf_event.h |   22 +
 arch/tile/include/asm/pmc.h        |   64 +++
 arch/tile/kernel/Makefile          |    2 +
 arch/tile/kernel/intvec_32.S       |   24 +-
 arch/tile/kernel/intvec_64.S       |   24 +-
 arch/tile/kernel/irq.c             |   18 +
 arch/tile/kernel/messaging.c       |    4 +-
 arch/tile/kernel/pci.c             |    2 -
 arch/tile/kernel/perf_event.c      | 1005 ++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/pmc.c             |  121 +++++
 arch/tile/kernel/time.c            |   10 +-
 arch/tile/kernel/vdso/Makefile     |    2 +-
 tools/perf/config/Makefile.arch    |    3 +-
 tools/perf/perf.h                  |    8 +
 15 files changed, 1295 insertions(+), 20 deletions(-)
 create mode 100644 arch/tile/include/asm/perf_event.h
 create mode 100644 arch/tile/include/asm/pmc.h
 create mode 100644 arch/tile/kernel/perf_event.c
 create mode 100644 arch/tile/kernel/pmc.c

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

