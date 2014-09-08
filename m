Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaIHPfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:35:01 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:59752 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIHPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Mon, 8 Sep 2014 17:34:37 +0200
X-Google-Sender-Auth: r4tqld0IliuIhTz98-eaqU2YH8A
Message-ID: <CAAObsKAYqpJMJnxSMxhkkRtnoEwLwgUa1y7ij5ZHvHf1jRok+Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Tegra xHCI support
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 September 2014 23:34, Andrew Bresticker <abrestic@chromium.org> wrote:
>
> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
> USB3.0 memory sticks and ethernet dongles using controller firmware
> recently posted by Andrew Chew [2].

I have had mixed results when testing this on a Jetson TK1 board. Of 8
USB devices I tested with, about half where probed correctly, but the
other half repeatedly fail in hub_port_init because in the GET_STATUS
right after the reset, the C_PORT_CONNECTION bit is set.

I don't see any correlation between the failure and the kind of usb
device, but I don't have much experience with USB implementations
either.

Regards,

Tomeu

> Notes:
>  - HSIC support is mostly untested and I think there are still some issues
>    to work out there.  I do have a Tegra124 board with a HSIC hub so I'll
>    try to sort those out later.
>  - The XUSB padctl driver doesn't play nice with the existing Tegra USB2.0
>    PHY driver, so all ports should be assigned to the XHCI controller.
>
> Based on work by:
>   a lot of people, but from what I can tell from the L4T tree [3], the
>   original authors of the Tegra xHCI driver are:
>     Ajay Gupta <ajayg@nvidia.com>
>     Bharath Yadav <byadav@nvidia.com>
>
> Chagnes from v2:
>  - Dropped mailbox channel specifier.  The mailbox driver allocates virtual
>    channels backed by the single physical channel.
>  - Added support for HS_CURR_LEVEL adjustment pinconfig property, which
>    will be required for the Blaze board.
>  - Addressed Stephen's review comments.
>
> Changes from v1:
>  - Converted mailbox driver to use the common mailbox framework.
>  - Fixed up host driver so that it can now be built and used as a module.
>  - Addressed Stephen's review comments.
>  - Misc. cleanups.
>
> Changes from RFC:
>  - Dropped Tegra114 support.
>  - Split out mailbox into separate driver.
>  - Stopped using child xhci-plat device in xHCI host-controller driver.
>  - Added PHY support to Thierry's XUSB padctl driver instead of in a separate
>    USB PHY driver.
>  - Added Jetson TK1 support.
>  - Misc. cleanups.
>
> [0] https://lkml.org/lkml/2014/8/1/200
> [1] https://lkml.org/lkml/2014/8/18/504
> [2] https://patchwork.ozlabs.org/patch/384013/
> [3] git://nv-tegra.nvidia.com/linux-3.10.git
>
> Andrew Bresticker (9):
>   of: Add NVIDIA Tegra XUSB mailbox binding
>   mailbox: Add NVIDIA Tegra XUSB mailbox driver
>   of: Update Tegra XUSB pad controller binding for USB
>   pinctrl: tegra-xusb: Add USB PHY support
>   of: Add NVIDIA Tegra xHCI controller binding
>   usb: xhci: Add NVIDIA Tegra xHCI host-controller driver
>   ARM: tegra: Add Tegra124 XUSB mailbox and xHCI controller
>   ARM: tegra: jetson-tk1: Add xHCI support
>   ARM: tegra: venice2: Add xHCI support
>
>  .../bindings/mailbox/nvidia,tegra124-xusb-mbox.txt |   32 +
>  .../pinctrl/nvidia,tegra124-xusb-padctl.txt        |   56 +-
>  .../bindings/usb/nvidia,tegra124-xhci.txt          |  104 ++
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   48 +-
>  arch/arm/boot/dts/tegra124-venice2.dts             |   79 +-
>  arch/arm/boot/dts/tegra124.dtsi                    |   41 +
>  drivers/mailbox/Kconfig                            |    3 +
>  drivers/mailbox/Makefile                           |    2 +
>  drivers/mailbox/tegra-xusb-mailbox.c               |  290 +++++
>  drivers/pinctrl/Kconfig                            |    1 +
>  drivers/pinctrl/pinctrl-tegra-xusb.c               | 1233 +++++++++++++++++++-
>  drivers/usb/host/Kconfig                           |    9 +
>  drivers/usb/host/Makefile                          |    1 +
>  drivers/usb/host/xhci-tegra.c                      |  905 ++++++++++++++
>  include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h   |   20 +
>  include/soc/tegra/xusb.h                           |   53 +
>  16 files changed, 2796 insertions(+), 81 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/nvidia,tegra124-xusb-mbox.txt
>  create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
>  create mode 100644 drivers/mailbox/tegra-xusb-mailbox.c
>  create mode 100644 drivers/usb/host/xhci-tegra.c
>  create mode 100644 include/soc/tegra/xusb.h
>
> --
> 2.1.0.rc2.206.gedb03e5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
