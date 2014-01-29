Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241AbaA2IBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:01:02 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:53714
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbaA2IBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:01:00 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz936eIe0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h1082kzz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Steven Miao <realmz6@kernel.org>
To: <torvalds@linux-foundation.org>
CC: <adi-buildroot-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.14
Date: Wed, 29 Jan 2014 16:06:02 +0800
Message-ID: <1390982762-18697-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin updates for Linux 3.14, some minor changes and bug fixes.

The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to 58095fdaaf1cee12d8e01aa20f94b976e3137d27:

  From: Eunbong Song <eunb.song@samsung.com> (2014-01-29 15:14:56 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.14

----------------------------------------------------------------
Aaron Wu (2):
      fix build error for bf527-ezkit_defconfig for old silicon
      Add platfrom device resource for bfin-sport on bf533 stamp

Chen Gang (1):
      arch: blackfin: uapi: be sure of "_UAPI" prefix for all guard macros

Jiang Liu (1):
      06/18] smp, blackfin: kill SMP single function call interrupt

Paul Gortmaker (1):
      blackfin: delete non-required instances of <linux/init.h>

Sonic Zhang (2):
      blackfin: bf609: update the anomaly list to Nov 2013
      blackfin: Support L1 SRAM parity checking feature on bf60x

Steven Miao (2):
      From: Paul Walmsley <pwalmsley@nvidia.com>
      From: Eunbong Song <eunb.song@samsung.com>

 arch/blackfin/configs/BF527-EZKIT_defconfig     |    1 +
 arch/blackfin/configs/BF538-EZKIT_defconfig     |    1 -
 arch/blackfin/configs/BF561-ACVILON_defconfig   |    1 -
 arch/blackfin/configs/BlackStamp_defconfig      |    1 -
 arch/blackfin/configs/CM-BF533_defconfig        |    1 -
 arch/blackfin/configs/CM-BF548_defconfig        |    1 -
 arch/blackfin/configs/CM-BF561_defconfig        |    1 -
 arch/blackfin/configs/DNP5370_defconfig         |    1 -
 arch/blackfin/configs/H8606_defconfig           |    1 -
 arch/blackfin/configs/IP0X_defconfig            |    1 -
 arch/blackfin/configs/PNAV-10_defconfig         |    1 -
 arch/blackfin/configs/SRV1_defconfig            |    1 -
 arch/blackfin/configs/TCM-BF518_defconfig       |    1 -
 arch/blackfin/include/asm/def_LPBlackfin.h      |    1 +
 arch/blackfin/include/uapi/asm/byteorder.h      |    5 +++
 arch/blackfin/include/uapi/asm/cachectl.h       |    6 +--
 arch/blackfin/include/uapi/asm/fcntl.h          |    6 +--
 arch/blackfin/include/uapi/asm/ioctls.h         |    6 +--
 arch/blackfin/include/uapi/asm/poll.h           |    6 +--
 arch/blackfin/include/uapi/asm/posix_types.h    |    6 +--
 arch/blackfin/include/uapi/asm/sigcontext.h     |    6 +--
 arch/blackfin/include/uapi/asm/siginfo.h        |    6 +--
 arch/blackfin/include/uapi/asm/signal.h         |    6 +--
 arch/blackfin/include/uapi/asm/stat.h           |    6 +--
 arch/blackfin/include/uapi/asm/swab.h           |    6 +--
 arch/blackfin/mach-bf533/boards/stamp.c         |   47 +++++++++++++++++++-
 arch/blackfin/mach-bf609/Kconfig                |    6 +++
 arch/blackfin/mach-bf609/clock.c                |    3 +-
 arch/blackfin/mach-bf609/include/mach/anomaly.h |   54 ++++++++++++++++++-----
 arch/blackfin/mach-common/cache-c.c             |   11 ++++-
 arch/blackfin/mach-common/clocks-init.c         |    1 -
 arch/blackfin/mach-common/ints-priority.c       |   41 +++++++++--------
 arch/blackfin/mach-common/scb-init.c            |    1 -
 arch/blackfin/mach-common/smp.c                 |    6 +--
 34 files changed, 166 insertions(+), 83 deletions(-)

