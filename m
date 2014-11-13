Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaKMBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:21:41 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:63369 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbaKMBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:21:38 -0500
MIME-Version: 1.0
In-Reply-To: <20141113003537.25314.19238@quantum>
References: <1414721633-29508-1-git-send-email-chao.xie@marvell.com>
	<CAN1soZyqWtKUajbW_R-_uTwSbN4Apo0+NJ9WupS+YLOP_nGJ3w@mail.gmail.com>
	<20141113003537.25314.19238@quantum>
Date: Thu, 13 Nov 2014 09:21:37 +0800
Message-ID: <CAD6h2NTUc7S9K-R-TfUA8Moiv3rnOd=PE_fnO6LDbj2Sk869Mg@mail.gmail.com>
Subject: Re: [PATCH V2 00/13] clk: mmp: clock device tree support
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, Chao Xie <chao.xie@marvell.com>,
        Chao Xie <xiechao_mail@163.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2014 08:35, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Haojian Zhuang (2014-11-04 00:15:55)
>> On Fri, Oct 31, 2014 at 10:13 AM, Chao Xie <chao.xie@marvell.com> wrote:
>> > From: Chao Xie <chao.xie@marvell.com>
>> >
>> > The patch set focuses at support device tree for clock.
>> >
>> > The first part of the patches
>> >   clk: mmp: add prefix "mmp" for structures defined for clk-frac
>> >   clk: mmp: add spin lock for clk-frac
>> >   clk: mmp: add init callback for clk-frac
>> >   clk: mmp: move definiton of mmp_clk_frac to clk.h It enhances the clk-frac.
>> >
>> > The second part of the patches
>> >   clk: mmp: add clock type mix
>> >   clk: mmp: add mmp private gate clock
>> >
>> > The third part of the patches
>> >   clk: mmp: add basic support functions for DT support
>> >   clk: mmp: add reset support
>> >   clk: mmp: add pxa168 DT support for clock driver
>> >   clk: mmp: add pxa910 DT support for clock driver
>> >   clk: mmp: add mmp2 DT support for clock driver
>> > It add the device tree support for pxa168, pxa910 and mmp2.
>> >
>> > V1 -> V2:
>> >   Add reset support for the clocks that have reset bit.
>> >
>> > Chao Xie (13):
>> >   clk: mmp: add prefix "mmp" for structures defined for clk-frac
>> >   clk: mmp: add spin lock for clk-frac
>> >   clk: mmp: add init callback for clk-frac
>> >   clk: mmp: move definiton of mmp_clk_frac to clk.h
>> >   clk: mmp: add clock type mix
>> >   clk: mmp: add mmp private gate clock
>> >   clk: mmp: add basic support functions for DT support
>> >   clk: mmp: add reset support
>> >   clk: mmp: add pxa168 DT support for clock driver
>> >   clk: mmp: add pxa910 DT support for clock driver
>> >   clk: mmp: add mmp2 DT support for clock driver
>> >   arm: mmp: Make all the dts file to be compiled by Makefile
>> >   arm: mmp: Make use of the DT supported clock
>> >
>> >  .../devicetree/bindings/clock/marvell,mmp2.txt     |  21 +
>> >  .../devicetree/bindings/clock/marvell,pxa168.txt   |  21 +
>> >  .../devicetree/bindings/clock/marvell,pxa910.txt   |  21 +
>> >  arch/arm/boot/dts/Makefile                         |   3 +
>> >  arch/arm/boot/dts/mmp2-brownstone.dts              |   2 +-
>> >  arch/arm/boot/dts/mmp2.dtsi                        |  29 +-
>> >  arch/arm/boot/dts/pxa168-aspenite.dts              |   2 +-
>> >  arch/arm/boot/dts/pxa168.dtsi                      |  27 +-
>> >  arch/arm/boot/dts/pxa910-dkb.dts                   |   2 +-
>> >  arch/arm/boot/dts/pxa910.dtsi                      |  28 +-
>> >  arch/arm/mach-mmp/Kconfig                          |  12 +-
>> >  arch/arm/mach-mmp/mmp-dt.c                         |  57 +--
>> >  arch/arm/mach-mmp/mmp2-dt.c                        |  26 +-
>> >  drivers/clk/mmp/Makefile                           |   7 +-
>> >  drivers/clk/mmp/clk-frac.c                         |  74 ++-
>> >  drivers/clk/mmp/clk-gate.c                         | 133 ++++++
>> >  drivers/clk/mmp/clk-mix.c                          | 513 +++++++++++++++++++++
>> >  drivers/clk/mmp/clk-mmp2.c                         |   6 +-
>> >  drivers/clk/mmp/clk-of-mmp2.c                      | 334 ++++++++++++++
>> >  drivers/clk/mmp/clk-of-pxa168.c                    | 279 +++++++++++
>> >  drivers/clk/mmp/clk-of-pxa910.c                    | 301 ++++++++++++
>> >  drivers/clk/mmp/clk-pxa168.c                       |   6 +-
>> >  drivers/clk/mmp/clk-pxa910.c                       |   6 +-
>> >  drivers/clk/mmp/clk.c                              | 192 ++++++++
>> >  drivers/clk/mmp/clk.h                              | 226 ++++++++-
>> >  drivers/clk/mmp/reset.c                            |  99 ++++
>> >  drivers/clk/mmp/reset.h                            |  31 ++
>> >  include/dt-bindings/clock/marvell,mmp2.h           |  74 +++
>> >  include/dt-bindings/clock/marvell,pxa168.h         |  57 +++
>> >  include/dt-bindings/clock/marvell,pxa910.h         |  54 +++
>> >  30 files changed, 2538 insertions(+), 105 deletions(-)
>> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,mmp2.txt
>> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa168.txt
>> >  create mode 100644 Documentation/devicetree/bindings/clock/marvell,pxa910.txt
>> >  create mode 100644 drivers/clk/mmp/clk-gate.c
>> >  create mode 100644 drivers/clk/mmp/clk-mix.c
>> >  create mode 100644 drivers/clk/mmp/clk-of-mmp2.c
>> >  create mode 100644 drivers/clk/mmp/clk-of-pxa168.c
>> >  create mode 100644 drivers/clk/mmp/clk-of-pxa910.c
>> >  create mode 100644 drivers/clk/mmp/clk.c
>> >  create mode 100644 drivers/clk/mmp/reset.c
>> >  create mode 100644 drivers/clk/mmp/reset.h
>> >  create mode 100644 include/dt-bindings/clock/marvell,mmp2.h
>> >  create mode 100644 include/dt-bindings/clock/marvell,pxa168.h
>> >  create mode 100644 include/dt-bindings/clock/marvell,pxa910.h
>> >
>> > --
>> > 1.8.3.2
>> >
>>
>> Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
>>
>> Mike,
>> Please merge all mach-mmp patches with clock together. Otherwise, it
>> may result in build issue.
>
> Can patches #12 & #13 go through arm-soc?
>

Hi Mike,

I also hope so. But patch #12 makes those dtb files built
automatically. And patch #13
references clocks that are defined in dt-binding files. If I merge
patch #12 & #13, I'll meet
build issue since I'm lack of those new dt-binding files. So it's
better to go through your
clock tree.

Best Regards
Haojian
