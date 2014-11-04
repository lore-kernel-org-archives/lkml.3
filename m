Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKDIQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:16:01 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:37587 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaKDIP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:15:57 -0500
MIME-Version: 1.0
In-Reply-To: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
Date: Tue, 4 Nov 2014 16:15:55 +0800
Message-ID: <CAN1soZyqWtKUajbW_R-_uTwSbN4Apo0+NJ9WupS+YLOP_nGJ3w@mail.gmail.com>
Subject: Re: [PATCH V2 00/13] clk: mmp: clock device tree support
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mike Turquette <mturquette@linaro.org>, xiechao_mail@163.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:13 AM, Chao Xie <chao.xie@marvell.com> wrote:
> From: Chao Xie <chao.xie@marvell.com>
>
> The patch set focuses at support device tree for clock.
>
> The first part of the patches
>   clk: mmp: add prefix "mmp" for structures defined for clk-frac
>   clk: mmp: add spin lock for clk-frac
>   clk: mmp: add init callback for clk-frac
>   clk: mmp: move definiton of mmp_clk_frac to clk.h It enhances the clk-frac.
>
> The second part of the patches
>   clk: mmp: add clock type mix
>   clk: mmp: add mmp private gate clock
>
> The third part of the patches
>   clk: mmp: add basic support functions for DT support
>   clk: mmp: add reset support
>   clk: mmp: add pxa168 DT support for clock driver
>   clk: mmp: add pxa910 DT support for clock driver
>   clk: mmp: add mmp2 DT support for clock driver
> It add the device tree support for pxa168, pxa910 and mmp2.
>
> V1 -> V2:
>   Add reset support for the clocks that have reset bit.
>
> Chao Xie (13):
>   clk: mmp: add prefix "mmp" for structures defined for clk-frac
>   clk: mmp: add spin lock for clk-frac
>   clk: mmp: add init callback for clk-frac
>   clk: mmp: move definiton of mmp_clk_frac to clk.h
>   clk: mmp: add clock type mix
>   clk: mmp: add mmp private gate clock
>   clk: mmp: add basic support functions for DT support
>   clk: mmp: add reset support
>   clk: mmp: add pxa168 DT support for clock driver
>   clk: mmp: add pxa910 DT support for clock driver
>   clk: mmp: add mmp2 DT support for clock driver
>   arm: mmp: Make all the dts file to be compiled by Makefile
>   arm: mmp: Make use of the DT supported clock
>
>  .../devicetree/bindings/clock/marvell,mmp2.txt     |  21 +
>  .../devicetree/bindings/clock/marvell,pxa168.txt   |  21 +
>  .../devicetree/bindings/clock/marvell,pxa910.txt   |  21 +
>  arch/arm/boot/dts/Makefile                         |   3 +
>  arch/arm/boot/dts/mmp2-brownstone.dts              |   2 +-
>  arch/arm/boot/dts/mmp2.dtsi                        |  29 +-
>  arch/arm/boot/dts/pxa168-aspenite.dts              |   2 +-
>  arch/arm/boot/dts/pxa168.dtsi                      |  27 +-
>  arch/arm/boot/dts/pxa910-dkb.dts                   |   2 +-
>  arch/arm/boot/dts/pxa910.dtsi                      |  28 +-
>  arch/arm/mach-mmp/Kconfig                          |  12 +-
>  arch/arm/mach-mmp/mmp-dt.c                         |  57 +--
>  arch/arm/mach-mmp/mmp2-dt.c                        |  26 +-
>  drivers/clk/mmp/Makefile                           |   7 +-
>  drivers/clk/mmp/clk-frac.c                         |  74 ++-
>  drivers/clk/mmp/clk-gate.c                         | 133 ++++++
>  drivers/clk/mmp/clk-mix.c                          | 513 +++++++++++++++++++++
>  drivers/clk/mmp/clk-mmp2.c                         |   6 +-
>  drivers/clk/mmp/clk-of-mmp2.c                      | 334 ++++++++++++++
>  drivers/clk/mmp/clk-of-pxa168.c                    | 279 +++++++++++
>  drivers/clk/mmp/clk-of-pxa910.c                    | 301 ++++++++++++
>  drivers/clk/mmp/clk-pxa168.c                       |   6 +-
>  drivers/clk/mmp/clk-pxa910.c                       |   6 +-
>  drivers/clk/mmp/clk.c                              | 192 ++++++++
>  drivers/clk/mmp/clk.h                              | 226 ++++++++-
>  drivers/clk/mmp/reset.c                            |  99 ++++
>  drivers/clk/mmp/reset.h                            |  31 ++
>  include/dt-bindings/clock/marvell,mmp2.h           |  74 +++
>  include/dt-bindings/clock/marvell,pxa168.h         |  57 +++
>  include/dt-bindings/clock/marvell,pxa910.h         |  54 +++
>  30 files changed, 2538 insertions(+), 105 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell,mmp2.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa168.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa910.txt
>  create mode 100644 drivers/clk/mmp/clk-gate.c
>  create mode 100644 drivers/clk/mmp/clk-mix.c
>  create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
>  create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
>  create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
>  create mode 100644 drivers/clk/mmp/clk.c
>  create mode 100644 drivers/clk/mmp/reset.c
>  create mode 100644 drivers/clk/mmp/reset.h
>  create mode 100644 include/dt-bindings/clock/marvell,mmp2.h
>  create mode 100644 include/dt-bindings/clock/marvell,pxa168.h
>  create mode 100644 include/dt-bindings/clock/marvell,pxa910.h
>
> --
> 1.8.3.2
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Mike,
Please merge all mach-mmp patches with clock together. Otherwise, it
may result in build issue.

Best Regards
Haojian
