Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaB1H1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:27:11 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54750 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaB1H1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <1375189476-21557-1-git-send-email-coelho@ti.com>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Fri, 28 Feb 2014 08:26:46 +0100
Message-ID: <CAGm1_kvdzkvzEEymQ+H0XiKugifHF27KDz3jwX5Frg_U=S7KgA@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] wilink: add device tree support
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, luca@coelho.fi, mturquette@linaro.org,
        mark.rutland@arm.com, balbi@ti.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, kernel list <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, nm@ti.com,
        martinez.javier@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 3:04 PM, Luciano Coelho <coelho@ti.com> wrote:
> Hi,
>
> This patch series adds device tree support to the wlcore_sdio driver,
> which is used by WiLink6, WiLink7 and WiLink8.
>
> The first patches do some clean-up to make the data needed in the
> wilink device tree node smaller.  The remaining patches implement the
> actual device tree node parsing in wlcore_sdio.
>
> Regarding the XTAL clock issues, for now we don't support XTAL mode
> with DT, but I have sent a proposal for a small change in the clock
> framework to support this, but it's still under discussions [1].
>
> The DTS file changes will be sent separately, since they need to go
> via different trees.
>
> A new version of the bindings documentation has been sent [2] and, if
> no more comments are given to it, I'll apply it via my tree.
>
> [1] http://news.gmane.org/find-root.php?message_id=1372971912-10877-1-git-send-email-coelho@ti.com
> [2] http://news.gmane.org/find-root.php?message_id=1375109728-5931-1-git-send-email-coelho@ti.com
>
> Changes in v4:
>
> * Rebased on top of 3.11-rc3 (eg. no more changes on the board files
>   that were removed);
>
> * Use the new irq_get_trigger_type() instead of
>   irqd_get_trigger_type() (thanks Javier);
>
> * Added some missing const's (thanks Felipe);
>
> * Reverted Tony's workaround to get WiLink to work on Panda while DT
>   was not supported yet.
>
>
> Please review.

What is the state of the series? Who is now responsible for the
patches? What issues were still not handled?

Yegor

> Luciano Coelho (8):
>   wl1251: split wl251 platform data to a separate structure
>   wlcore: set irq_flags in the board files instead of hiding behind a
>     quirk
>   wlcore: remove pwr_in_suspend from platform data
>   wl12xx: use frequency instead of enumerations for pdata clocks
>   wlcore: add initial device tree support to the sdio module
>   wlcore: sdio: add wilink clock providers
>   wlcore: sdio: get clocks from device tree
>   wlcore/wl12xx: check if we got correct clock data from DT
>
>  arch/arm/mach-davinci/board-da850-evm.c        |  11 ++-
>  arch/arm/mach-omap2/board-omap3evm.c           |  22 ++++-
>  arch/arm/mach-omap2/board-omap3pandora.c       |   4 +-
>  arch/arm/mach-omap2/board-rx51-peripherals.c   |   2 +-
>  arch/arm/mach-omap2/board-zoom-peripherals.c   |  33 +++++++-
>  arch/arm/mach-omap2/devices.c                  |  39 ---------
>  drivers/net/wireless/ti/wilink_platform_data.c |  37 ++++++--
>  drivers/net/wireless/ti/wl1251/sdio.c          |  12 +--
>  drivers/net/wireless/ti/wl1251/spi.c           |   2 +-
>  drivers/net/wireless/ti/wl12xx/main.c          |  78 +++++++++++++++--
>  drivers/net/wireless/ti/wl12xx/wl12xx.h        |  28 +++++++
>  drivers/net/wireless/ti/wlcore/debugfs.c       |   2 +-
>  drivers/net/wireless/ti/wlcore/main.c          |  20 ++---
>  drivers/net/wireless/ti/wlcore/sdio.c          | 112 +++++++++++++++++++++++--
>  drivers/net/wireless/ti/wlcore/wlcore.h        |   5 +-
>  drivers/net/wireless/ti/wlcore/wlcore_i.h      |   1 +
>  include/linux/wl12xx.h                         |  52 +++++-------
>  17 files changed, 340 insertions(+), 120 deletions(-)
>
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
