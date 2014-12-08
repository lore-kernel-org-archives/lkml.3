Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaLHB4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 20:56:16 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:41157 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaLHB4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 20:56:15 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2014 20:56:14 EST
From: Christoph Jaeger <cj@linux.com>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dborkman@redhat.com, Christoph Jaeger <cj@linux.com>
Subject: [PATCH 0/3] remove undocumented type definition alias
Date: Sun,  7 Dec 2014 20:49:17 -0500
Message-Id: <cover.1418003065.git.cj@linux.com>
X-Mailer: git-send-email 2.1.0
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset removes support for the undocumented type definition keyword
'boolean', that is used in some config option definitions, in favor of the
much more widely used 'bool'. Both are semantically equivalent.

% git grep -w bool -- '*Kconfig*' | wc -l
7065
% git grep -w boolean -- '*Kconfig*' | wc -l
94

Having this alias is more confusing than helpful.

This change was suggested by Daniel Borkmann <dborkman@redhat.com>.


Patch 3/3 is purely cosmetic and therefore optional.

Christoph Jaeger (3):
  kconfig: regenerate parser
  kconfig: remove undocumented type definition alias 'boolean'
  kconfig: rename S_BOOLEAN to S_BOOL for consistency

 arch/cris/arch-v32/drivers/Kconfig   |    2 +-
 arch/mips/pmcs-msp71xx/Kconfig       |    6 +-
 drivers/connector/Kconfig            |    2 +-
 drivers/hwmon/Kconfig                |    2 +-
 drivers/i2c/Kconfig                  |    4 +-
 drivers/iio/Kconfig                  |    4 +-
 drivers/isdn/hardware/mISDN/Kconfig  |    2 +-
 drivers/md/Kconfig                   |    4 +-
 drivers/md/persistent-data/Kconfig   |    2 +-
 drivers/net/ethernet/ti/Kconfig      |    4 +-
 drivers/net/usb/Kconfig              |   12 +-
 drivers/net/wireless/rt2x00/Kconfig  |    6 +-
 drivers/pci/pcie/aer/Kconfig         |    2 +-
 drivers/rtc/Kconfig                  |    8 +-
 drivers/spi/Kconfig                  |    6 +-
 drivers/staging/board/Kconfig        |    2 +-
 drivers/staging/emxx_udc/Kconfig     |    2 +-
 drivers/staging/iio/Kconfig          |    4 +-
 drivers/tty/serial/Kconfig           |    2 +-
 drivers/usb/gadget/Kconfig           |   26 +-
 drivers/usb/gadget/legacy/Kconfig    |    2 +-
 drivers/usb/gadget/udc/Kconfig       |    4 +-
 drivers/usb/phy/Kconfig              |    2 +-
 init/Kconfig                         |    4 +-
 lib/Kconfig                          |   30 +-
 mm/Kconfig                           |   22 +-
 net/Kconfig                          |   14 +-
 net/sched/Kconfig                    |    2 +-
 scripts/kconfig/confdata.c           |   22 +-
 scripts/kconfig/expr.c               |   10 +-
 scripts/kconfig/expr.h               |    2 +-
 scripts/kconfig/gconf.c              |    4 +-
 scripts/kconfig/mconf.c              |    6 +-
 scripts/kconfig/menu.c               |   10 +-
 scripts/kconfig/nconf.c              |    4 +-
 scripts/kconfig/qconf.cc             |   10 +-
 scripts/kconfig/symbol.c             |   34 +-
 scripts/kconfig/zconf.gperf          |    5 +-
 scripts/kconfig/zconf.hash.c_shipped |   53 +-
 scripts/kconfig/zconf.tab.c_shipped  | 1248 +++++++++++++++-------------------
 scripts/kconfig/zconf.y              |    6 +-
 security/integrity/Kconfig           |    4 +-
 security/integrity/evm/Kconfig       |    2 +-
 43 files changed, 737 insertions(+), 865 deletions(-)

-- 
2.1.0

