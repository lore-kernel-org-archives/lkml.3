Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422953AbaJaCQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:16:37 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52190 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422698AbaJaCMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:12:10 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <haojian.zhuang@gmail.com>, <haojian.zhuang@linaro.org>,
        <mturquette@linaro.org>, <chao.xie@marvell.com>,
        <xiechao_mail@163.com>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 00/13] clk: mmp: clock device tree support
Date: Fri, 31 Oct 2014 10:13:40 +0800
Message-ID: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_02:2014-10-30,2014-10-31,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410310021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chao Xie <chao.xie@marvell.com>

The patch set focuses at support device tree for clock.

The first part of the patches
  clk: mmp: add prefix "mmp" for structures defined for clk-frac
  clk: mmp: add spin lock for clk-frac
  clk: mmp: add init callback for clk-frac
  clk: mmp: move definiton of mmp_clk_frac to clk.h It enhances the clk-frac.

The second part of the patches
  clk: mmp: add clock type mix
  clk: mmp: add mmp private gate clock

The third part of the patches
  clk: mmp: add basic support functions for DT support
  clk: mmp: add reset support
  clk: mmp: add pxa168 DT support for clock driver
  clk: mmp: add pxa910 DT support for clock driver
  clk: mmp: add mmp2 DT support for clock driver
It add the device tree support for pxa168, pxa910 and mmp2.

V1 -> V2:
  Add reset support for the clocks that have reset bit.

Chao Xie (13):
  clk: mmp: add prefix "mmp" for structures defined for clk-frac
  clk: mmp: add spin lock for clk-frac
  clk: mmp: add init callback for clk-frac
  clk: mmp: move definiton of mmp_clk_frac to clk.h
  clk: mmp: add clock type mix
  clk: mmp: add mmp private gate clock
  clk: mmp: add basic support functions for DT support
  clk: mmp: add reset support
  clk: mmp: add pxa168 DT support for clock driver
  clk: mmp: add pxa910 DT support for clock driver
  clk: mmp: add mmp2 DT support for clock driver
  arm: mmp: Make all the dts file to be compiled by Makefile
  arm: mmp: Make use of the DT supported clock

 .../devicetree/bindings/clock/marvell,mmp2.txt     |  21 +
 .../devicetree/bindings/clock/marvell,pxa168.txt   |  21 +
 .../devicetree/bindings/clock/marvell,pxa910.txt   |  21 +
 arch/arm/boot/dts/Makefile                         |   3 +
 arch/arm/boot/dts/mmp2-brownstone.dts              |   2 +-
 arch/arm/boot/dts/mmp2.dtsi                        |  29 +-
 arch/arm/boot/dts/pxa168-aspenite.dts              |   2 +-
 arch/arm/boot/dts/pxa168.dtsi                      |  27 +-
 arch/arm/boot/dts/pxa910-dkb.dts                   |   2 +-
 arch/arm/boot/dts/pxa910.dtsi                      |  28 +-
 arch/arm/mach-mmp/Kconfig                          |  12 +-
 arch/arm/mach-mmp/mmp-dt.c                         |  57 +--
 arch/arm/mach-mmp/mmp2-dt.c                        |  26 +-
 drivers/clk/mmp/Makefile                           |   7 +-
 drivers/clk/mmp/clk-frac.c                         |  74 ++-
 drivers/clk/mmp/clk-gate.c                         | 133 ++++++
 drivers/clk/mmp/clk-mix.c                          | 513 +++++++++++++++++++++
 drivers/clk/mmp/clk-mmp2.c                         |   6 +-
 drivers/clk/mmp/clk-of-mmp2.c                      | 334 ++++++++++++++
 drivers/clk/mmp/clk-of-pxa168.c                    | 279 +++++++++++
 drivers/clk/mmp/clk-of-pxa910.c                    | 301 ++++++++++++
 drivers/clk/mmp/clk-pxa168.c                       |   6 +-
 drivers/clk/mmp/clk-pxa910.c                       |   6 +-
 drivers/clk/mmp/clk.c                              | 192 ++++++++
 drivers/clk/mmp/clk.h                              | 226 ++++++++-
 drivers/clk/mmp/reset.c                            |  99 ++++
 drivers/clk/mmp/reset.h                            |  31 ++
 include/dt-bindings/clock/marvell,mmp2.h           |  74 +++
 include/dt-bindings/clock/marvell,pxa168.h         |  57 +++
 include/dt-bindings/clock/marvell,pxa910.h         |  54 +++
 30 files changed, 2538 insertions(+), 105 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,mmp2.txt
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa168.txt
 create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa910.txt
 create mode 100644 drivers/clk/mmp/clk-gate.c
 create mode 100644 drivers/clk/mmp/clk-mix.c
 create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
 create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
 create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
 create mode 100644 drivers/clk/mmp/clk.c
 create mode 100644 drivers/clk/mmp/reset.c
 create mode 100644 drivers/clk/mmp/reset.h
 create mode 100644 include/dt-bindings/clock/marvell,mmp2.h
 create mode 100644 include/dt-bindings/clock/marvell,pxa168.h
 create mode 100644 include/dt-bindings/clock/marvell,pxa910.h

-- 
1.8.3.2

