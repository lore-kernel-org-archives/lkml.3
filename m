Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaHZEze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:55:34 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:47065 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaHZEzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
References: <1409027904-21859-1-git-send-email-chao.xie@marvell.com>
Date: Tue, 26 Aug 2014 12:55:31 +0800
Message-ID: <CAD6h2NQtkbbLr94jFQu_Sk66A2T1QoLXtAewdsiP2SqcCzBt0w@mail.gmail.com>
Subject: Re: [PATCH 00/12] clk: mmp: clock device tree support
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Chao Xie <chao.xie@marvell.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Chao Xie <xiechao_mail@163.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 August 2014 12:38, Chao Xie <chao.xie@marvell.com> wrote:
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
>   clk: mmp: add pxa168 DT support for clock driver
>   clk: mmp: add pxa910 DT support for clock driver
>   clk: mmp: add mmp2 DT support for clock driver
> It add the device tree support for pxa168, pxa910 and mmp2.
>
> The final part of the patches
>   arm: mmp: Make all the dts file to be compiled by Makefile
>   arm: mmp: Make use of the DT supported clock
> It changes the mmp platform to use device tree to parse the clocks.
>
> Chao Xie (12):
>   clk: mmp: add prefix "mmp" for structures defined for clk-frac
>   clk: mmp: add spin lock for clk-frac
>   clk: mmp: add init callback for clk-frac
>   clk: mmp: move definiton of mmp_clk_frac to clk.h
>   clk: mmp: add clock type mix
>   clk: mmp: add mmp private gate clock
>   clk: mmp: add basic support functions for DT support
>   clk: mmp: add pxa168 DT support for clock driver
>   clk: mmp: add pxa910 DT support for clock driver
>   clk: mmp: add mmp2 DT support for clock driver
>   arm: mmp: Make all the dts file to be compiled by Makefile
>   arm: mmp: Make use of the DT supported clock
>
>  .../bindings/clock/marvell-mmp2-clock.txt          |  20 +
>  .../bindings/clock/marvell-pxa168-clock.txt        |  20 +
>  .../bindings/clock/marvell-pxa910-clock.txt        |  20 +
>  arch/arm/boot/dts/Makefile                         |   3 +
>  arch/arm/boot/dts/mmp2-brownstone.dts              |   2 +-
>  arch/arm/boot/dts/mmp2.dtsi                        |  20 +-
>  arch/arm/boot/dts/pxa168-aspenite.dts              |   2 +-
>  arch/arm/boot/dts/pxa168.dtsi                      |  19 +-
>  arch/arm/boot/dts/pxa910-dkb.dts                   |   2 +-
>  arch/arm/boot/dts/pxa910.dtsi                      |  20 +-
>  arch/arm/mach-mmp/Kconfig                          |  10 +-
>  arch/arm/mach-mmp/mmp-dt.c                         |  57 +--
>  arch/arm/mach-mmp/mmp2-dt.c                        |  26 +-
>  drivers/clk/mmp/Makefile                           |   5 +-
>  drivers/clk/mmp/clk-frac.c                         |  74 ++-
>  drivers/clk/mmp/clk-gate.c                         | 133 ++++++
>  drivers/clk/mmp/clk-mix.c                          | 513 +++++++++++++++++++++
>  drivers/clk/mmp/clk-mmp2.c                         |   6 +-
>  drivers/clk/mmp/clk-of-mmp2.c                      | 307 ++++++++++++
>  drivers/clk/mmp/clk-of-pxa168.c                    | 251 ++++++++++
>  drivers/clk/mmp/clk-of-pxa910.c                    | 260 +++++++++++
>  drivers/clk/mmp/clk-pxa168.c                       |   6 +-
>  drivers/clk/mmp/clk-pxa910.c                       |   6 +-
>  drivers/clk/mmp/clk.c                              | 192 ++++++++
>  drivers/clk/mmp/clk.h                              | 226 ++++++++-
>  include/dt-bindings/clock/marvell-mmp2.h           |  74 +++
>  include/dt-bindings/clock/marvell-pxa168.h         |  57 +++
>  include/dt-bindings/clock/marvell-pxa910.h         |  54 +++
>  28 files changed, 2280 insertions(+), 105 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell-mmp2-clock.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell-pxa168-clock.txt
>  create mode 100644 Documentation/devicetree/bindings/clock/marvell-pxa910-clock.txt
>  create mode 100644 drivers/clk/mmp/clk-gate.c
>  create mode 100644 drivers/clk/mmp/clk-mix.c
>  create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
>  create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
>  create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
>  create mode 100644 drivers/clk/mmp/clk.c
>  create mode 100644 include/dt-bindings/clock/marvell-mmp2.h
>  create mode 100644 include/dt-bindings/clock/marvell-pxa168.h
>  create mode 100644 include/dt-bindings/clock/marvell-pxa910.h
>
> --
> 1.8.3.2
>

Hi Mike,

I think that these clock patches are ready to merge. I want to go
through arm-soc tree since chao will also move timer into clock source
directory. Those patches will be depend on these clock patches.

Could you help to give your Ack on these patches?

Best Regards
Haojian
