Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3KLSQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:16:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44255 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab3KLSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:16:49 -0500
Message-ID: <5282708A.30601@ti.com>
Date: Tue, 12 Nov 2013 12:16:42 -0600
From: "Anna, Suman" <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: Re: [PATCHv3 0/8]  omap hwspinlock dt support
References: <1381439735-52888-1-git-send-email-s-anna@ti.com>
In-Reply-To: <1381439735-52888-1-git-send-email-s-anna@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
>
> This is an updated series addressing the review comments from the
> v2 series. The hwmod patches have been dropped from the repost
> as per Paul's request, they have already been queued.

Mark,

Any comments on this series? Tony has picked up the OMAP DTS patches for 
3.13, and so
the "ti,omap4-hwspinlock" compatible string is showing up as 
undocumented in linux-next.
How do you want me to proceed here? I will be separating out the 
bindings into separate patches
in the future.

regards
Suman

>
> The series is tested on top of v3.12-rc4 + Benoit's 3.13 DTS branch and
> Tero's clock series, along with the queued hwmod patches.
>
> Changes in v3:
> - Removed the DT property hwlock-base-id and associated OF helper
> - Added changes in core to support requesting a specific hwlock using
>    phandle + args approach
> - Revised both the common and OMAP DT bindings document
> - OMAP AM335 support patches are unchanged from v2.
> - OMAP DTS patches are unchanged from v2.
>
> v2
> - Added a new common DT binding documentation and OF helpers (Patch1),
>    addressing the review comments from v1 [2]. The MSM support [1] needs
>    to be reworked on top of this common patch.
> - Revised OMAP DT parse support to use the new OF helper (Patch2)
> - OMAP5 hwspinlock support including the hwmod entry and DT node (Patches 4, 5)
> - Add AM335x support to OMAP hwspinlock driver, including a fix
>    needed in driver given that AM335 spinlock module requires s/w wakeup
>    (Patches 6, 7)
> - AM335 DT node for spinlock, and a hwmod change to enable smart-idle
>    for AM335 (Patches 8, 9). The sysc patch is not essential for AM335
>    spinlock functionality, but is needed for smart-idling the IP when
>    the module is enabled.
> - OMAP4 DT node patch is unchanged (Patch 3)
> http://marc.info/?l=linux-omap&m=137944644112727&w=2
>
> v1:
> - Add DT parse support to OMAP hwspinlock driver
> - Add OMAP4 DT node and bindings information
> http://marc.info/?l=linux-omap&m=137823082308009&w=2
>
> [1] https://lkml.org/lkml/2013/8/14/528
> [2] http://marc.info/?t=137823090300005&r=1&w=2
>
> Suman Anna (8):
>    hwspinlock/core: maintain a list of registered hwspinlock banks
>    hwspinlock/core: add common dt bindings and OF helpers
>    hwspinlock/omap: add support for dt nodes
>    hwspinlock/omap: enable module before reading SYSSTATUS register
>    hwspinlock/omap: support AM33xx
>    ARM: dts: OMAP4: Add hwspinlock node
>    ARM: dts: OMAP5: Add hwspinlock node
>    ARM: dts: AM33XX: Add hwspinlock node
>
>   .../devicetree/bindings/hwlock/hwlock.txt          |  49 ++++++++
>   .../devicetree/bindings/hwlock/omap-hwspinlock.txt |  19 +++
>   arch/arm/boot/dts/am33xx.dtsi                      |   6 +
>   arch/arm/boot/dts/omap4.dtsi                       |   6 +
>   arch/arm/boot/dts/omap5.dtsi                       |   6 +
>   arch/arm/mach-omap2/Makefile                       |   3 -
>   arch/arm/mach-omap2/hwspinlock.c                   |  60 ----------
>   drivers/hwspinlock/Kconfig                         |   2 +-
>   drivers/hwspinlock/hwspinlock_core.c               | 133 ++++++++++++++++++++-
>   drivers/hwspinlock/hwspinlock_internal.h           |   2 +
>   drivers/hwspinlock/omap_hwspinlock.c               |  38 ++++--
>   include/linux/hwspinlock.h                         |  19 ++-
>   12 files changed, 263 insertions(+), 80 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>   create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>   delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
>

