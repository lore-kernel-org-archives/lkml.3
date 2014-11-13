Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbaKMAfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:35:45 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40782 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaKMAfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:35:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Haojian Zhuang <haojian.zhuang@gmail.com>,
        "Chao Xie" <chao.xie@marvell.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAN1soZyqWtKUajbW_R-_uTwSbN4Apo0+NJ9WupS+YLOP_nGJ3w@mail.gmail.com>
Cc: "Haojian Zhuang" <haojian.zhuang@linaro.org>, xiechao_mail@163.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
 <CAN1soZyqWtKUajbW_R-_uTwSbN4Apo0+NJ9WupS+YLOP_nGJ3w@mail.gmail.com>
Message-ID: <20141113003537.25314.19238@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH V2 00/13] clk: mmp: clock device tree support
Date: Wed, 12 Nov 2014 16:35:37 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Haojian Zhuang (2014-11-04 00:15:55)
> On Fri, Oct 31, 2014 at 10:13 AM, Chao Xie <chao.xie@marvell.com> wrote:
> > From: Chao Xie <chao.xie@marvell.com>
> >
> > The patch set focuses at support device tree for clock.
> >
> > The first part of the patches
> >   clk: mmp: add prefix "mmp" for structures defined for clk-frac
> >   clk: mmp: add spin lock for clk-frac
> >   clk: mmp: add init callback for clk-frac
> >   clk: mmp: move definiton of mmp_clk_frac to clk.h It enhances the clk-frac.
> >
> > The second part of the patches
> >   clk: mmp: add clock type mix
> >   clk: mmp: add mmp private gate clock
> >
> > The third part of the patches
> >   clk: mmp: add basic support functions for DT support
> >   clk: mmp: add reset support
> >   clk: mmp: add pxa168 DT support for clock driver
> >   clk: mmp: add pxa910 DT support for clock driver
> >   clk: mmp: add mmp2 DT support for clock driver
> > It add the device tree support for pxa168, pxa910 and mmp2.
> >
> > V1 -> V2:
> >   Add reset support for the clocks that have reset bit.
> >
> > Chao Xie (13):
> >   clk: mmp: add prefix "mmp" for structures defined for clk-frac
> >   clk: mmp: add spin lock for clk-frac
> >   clk: mmp: add init callback for clk-frac
> >   clk: mmp: move definiton of mmp_clk_frac to clk.h
> >   clk: mmp: add clock type mix
> >   clk: mmp: add mmp private gate clock
> >   clk: mmp: add basic support functions for DT support
> >   clk: mmp: add reset support
> >   clk: mmp: add pxa168 DT support for clock driver
> >   clk: mmp: add pxa910 DT support for clock driver
> >   clk: mmp: add mmp2 DT support for clock driver
> >   arm: mmp: Make all the dts file to be compiled by Makefile
> >   arm: mmp: Make use of the DT supported clock
> >
> >  .../devicetree/bindings/clock/marvell,mmp2.txt     |  21 +
> >  .../devicetree/bindings/clock/marvell,pxa168.txt   |  21 +
> >  .../devicetree/bindings/clock/marvell,pxa910.txt   |  21 +
> >  arch/arm/boot/dts/Makefile                         |   3 +
> >  arch/arm/boot/dts/mmp2-brownstone.dts              |   2 +-
> >  arch/arm/boot/dts/mmp2.dtsi                        |  29 +-
> >  arch/arm/boot/dts/pxa168-aspenite.dts              |   2 +-
> >  arch/arm/boot/dts/pxa168.dtsi                      |  27 +-
> >  arch/arm/boot/dts/pxa910-dkb.dts                   |   2 +-
> >  arch/arm/boot/dts/pxa910.dtsi                      |  28 +-
> >  arch/arm/mach-mmp/Kconfig                          |  12 +-
> >  arch/arm/mach-mmp/mmp-dt.c                         |  57 +--
> >  arch/arm/mach-mmp/mmp2-dt.c                        |  26 +-
> >  drivers/clk/mmp/Makefile                           |   7 +-
> >  drivers/clk/mmp/clk-frac.c                         |  74 ++-
> >  drivers/clk/mmp/clk-gate.c                         | 133 ++++++
> >  drivers/clk/mmp/clk-mix.c                          | 513 +++++++++++++++++++++
> >  drivers/clk/mmp/clk-mmp2.c                         |   6 +-
> >  drivers/clk/mmp/clk-of-mmp2.c                      | 334 ++++++++++++++
> >  drivers/clk/mmp/clk-of-pxa168.c                    | 279 +++++++++++
> >  drivers/clk/mmp/clk-of-pxa910.c                    | 301 ++++++++++++
> >  drivers/clk/mmp/clk-pxa168.c                       |   6 +-
> >  drivers/clk/mmp/clk-pxa910.c                       |   6 +-
> >  drivers/clk/mmp/clk.c                              | 192 ++++++++
> >  drivers/clk/mmp/clk.h                              | 226 ++++++++-
> >  drivers/clk/mmp/reset.c                            |  99 ++++
> >  drivers/clk/mmp/reset.h                            |  31 ++
> >  include/dt-bindings/clock/marvell,mmp2.h           |  74 +++
> >  include/dt-bindings/clock/marvell,pxa168.h         |  57 +++
> >  include/dt-bindings/clock/marvell,pxa910.h         |  54 +++
> >  30 files changed, 2538 insertions(+), 105 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,mmp2.txt
> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa168.txt
> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa910.txt
> >  create mode 100644 drivers/clk/mmp/clk-gate.c
> >  create mode 100644 drivers/clk/mmp/clk-mix.c
> >  create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
> >  create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
> >  create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
> >  create mode 100644 drivers/clk/mmp/clk.c
> >  create mode 100644 drivers/clk/mmp/reset.c
> >  create mode 100644 drivers/clk/mmp/reset.h
> >  create mode 100644 include/dt-bindings/clock/marvell,mmp2.h
> >  create mode 100644 include/dt-bindings/clock/marvell,pxa168.h
> >  create mode 100644 include/dt-bindings/clock/marvell,pxa910.h
> >
> > --
> > 1.8.3.2
> >
> 
> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
> 
> Mike,
> Please merge all mach-mmp patches with clock together. Otherwise, it
> may result in build issue.

Can patches #12 & #13 go through arm-soc?

Regards,
Mike

> 
> Best Regards
> Haojian
