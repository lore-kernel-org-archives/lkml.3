Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab3EOPqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:46:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46322 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866Ab3EOPqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:46:36 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>, <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devel@driverdev.osuosl.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 0/2] staging -> thermal: move ti-soc-thermal to drivers/thermal
Date: Wed, 15 May 2013 11:45:59 -0400
Message-ID: <1368632761-10528-1-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Greg and Rui,

I am proposing to move the ti-soc-thermal driver from drivers/stating/
to drivers/thermal. It has been some time that we have been fixing and
improving the code under staging tree.

I believe it is time to move on. The driver now has a better code
organization (split between code and data), DT support, better coding
style, it supports TI OMAP chips 4430, 4460, 4470 and 5430, and it is
ready for easy addition of other SoC chips containing the bandgap IP.
Besides, this driver required some major changes in the thermal framework,
before it could provide basic functionality using the device capability.
These changes have been already merged in previous merge windows,
so there is no pending dependencies.

The remaining items in the TODO list are actually not a blocker for this
move, IMO. The PM support is not fully completed on all supported OMAP chips.
The locking so far has not caused any issues, and I believe that most of
the interesting data is protected by the thermal framework.

I am sending this patch for your appreciation and also to get wider review.

All best,

Eduardo Valentin (2):
  thermal: introduce TI SoC thermal driver
  MAINTAINERS: update TI SoC thermal driver entry

 .../devicetree/bindings/thermal}/ti_soc_thermal.txt                   | 0
 MAINTAINERS                                                           | 4 ++--
 drivers/staging/Kconfig                                               | 2 --
 drivers/staging/Makefile                                              | 1 -
 drivers/thermal/Kconfig                                               | 3 +++
 drivers/thermal/Makefile                                              | 2 +-
 drivers/{staging => thermal}/ti-soc-thermal/Kconfig                   | 0
 drivers/{staging => thermal}/ti-soc-thermal/Makefile                  | 0
 drivers/{staging => thermal}/ti-soc-thermal/TODO                      | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c      | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h        | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c      | 0
 drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h        | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c              | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h              | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c       | 0
 drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h              | 0
 17 files changed, 6 insertions(+), 6 deletions(-)
 rename {drivers/staging/ti-soc-thermal => Documentation/devicetree/bindings/thermal}/ti_soc_thermal.txt (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/Kconfig (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/Makefile (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/TODO (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap4-thermal-data.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap4xxx-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap5-thermal-data.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/omap5xxx-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-bandgap.h (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal-common.c (100%)
 rename drivers/{staging => thermal}/ti-soc-thermal/ti-thermal.h (100%)

-- 
1.8.2.1.342.gfa7285d

