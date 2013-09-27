Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab3I0PtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 11:49:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48903 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab3I0PtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 11:49:09 -0400
Message-ID: <5245A8CA.4020805@ti.com>
Date: Fri, 27 Sep 2013 10:48:26 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Kumar Gala <galak@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 0/9] omap hwspinlock dt support
References: <cover.1379445653.git.s-anna@ti.com>
In-Reply-To: <cover.1379445653.git.s-anna@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 02:30 PM, Suman Anna wrote:
> Hi,
> 
> This is an updated series for adding the device tree support to
> the OMAP hwspinlock driver. The series is based on 3.12-rc1, and
> includes patches on hwspinlock driver, OMAP hwmod data files and
> OMAP DTS files. The updated series adds new patches to enable the
> hwspinlock driver on OMAP5 and AM335x SoCs as well.
> 
> Tested this on Panda4, BeagleBone Black and OMAP5 uEVM (with
> out-of-tree clock patches from Tero).

Ohad, Benoit,
A gentle reminder - can you please provide your review comments on these
patches. I am hoping that this series can make it to 3.13.

Paul,
The hwmod data patches needs to be merged only after the respective DT
node patches are merged, without which the hwmod entry will not have a
base address while enabling and idling (using sysc) the hwmod during
hwmod initialization.

regards
Suman

> 
> Changes new in v2:
> - Added a new common DT binding documentation and OF helpers (Patch1),
>   addressing the review comments from v1 [2]. The MSM support [1] needs
>   to be reworked on top of this common patch. 
> - Revised OMAP DT parse support to use the new OF helper (Patch2)
> - OMAP5 hwspinlock support including the hwmod entry and DT node (Patches 4, 5)
> - Add AM335x support to OMAP hwspinlock driver, including a fix
>   needed in driver given that AM335 spinlock module requires s/w wakeup
>   (Patches 6, 7)
> - AM335 DT node for spinlock, and a hwmod change to enable smart-idle
>   for AM335 (Patches 8, 9). The sysc patch is not essential for AM335
>   spinlock functionality, but is needed for smart-idling the IP when
>   the module is enabled.
> - OMAP4 DT node patch is unchanged (Patch 3)
> 
> v1:
> - Add DT parse support to OMAP hwspinlock driver
> - Add OMAP4 DT node and bindings information
> http://marc.info/?l=linux-omap&m=137823082308009&w=2
> 
> [1] https://lkml.org/lkml/2013/8/14/528
> [2] http://marc.info/?t=137823090300005&r=1&w=2
> 
> 
> Suman Anna (9):
>   hwspinlock/core: add common dt bindings and OF helpers
>   hwspinlock/omap: add support for dt nodes
>   ARM: dts: OMAP4: Add hwspinlock node
>   ARM: OMAP5: hwmod data: Add spinlock data
>   ARM: dts: OMAP5: Add hwspinlock node
>   hwspinlock/omap: support AM33xx
>   hwspinlock/omap: enable module before reading SYSSTATUS register
>   ARM: dts: AM33XX: Add hwspinlock node
>   ARM: AM33xx: hwmod_data: add the sysc configuration for spinlock
> 
>  .../devicetree/bindings/hwlock/hwlock.txt          | 26 +++++++++
>  .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 31 +++++++++++
>  arch/arm/boot/dts/am33xx.dtsi                      |  6 +++
>  arch/arm/boot/dts/omap4.dtsi                       |  6 +++
>  arch/arm/boot/dts/omap5.dtsi                       |  6 +++
>  arch/arm/mach-omap2/Makefile                       |  3 --
>  arch/arm/mach-omap2/hwspinlock.c                   | 60 ---------------------
>  arch/arm/mach-omap2/omap_hwmod_33xx_data.c         | 13 +++++
>  arch/arm/mach-omap2/omap_hwmod_54xx_data.c         | 44 ++++++++++++++++
>  drivers/hwspinlock/Kconfig                         |  2 +-
>  drivers/hwspinlock/hwspinlock_core.c               | 61 +++++++++++++++++++++-
>  drivers/hwspinlock/omap_hwspinlock.c               | 44 ++++++++++++----
>  include/linux/hwspinlock.h                         | 11 ++--
>  13 files changed, 233 insertions(+), 80 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
>  create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
>  delete mode 100644 arch/arm/mach-omap2/hwspinlock.c
> 

