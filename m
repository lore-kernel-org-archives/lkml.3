Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbbAYTVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:21:43 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57336 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbbAYSJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:06 -0500
Date: Sun, 25 Jan 2015 20:08:55 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: arm@kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/4] ARM: Conexant Digicolor CX92755 SoC support
Message-ID: <20150125180855.GA3148@tarshish>
References: <cover.1421219953.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1421219953.git.baruch@tkos.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ARM SoC maintainers,

On Wed, Jan 14, 2015 at 10:40:29AM +0200, Baruch Siach wrote:
> This series adds initial support for the Conexant CX92755 SoC. The CX92755 is
> one of the Digicolor series of SoCs, all sharing many of the same peripherals.
> The code was tested on the CX92755 evaluation kit, AKA Equinox.
> 
> Uses attempting to try this code will most likely also want the UART/console
> driver available from https://patchwork.kernel.org/patch/5515861/.

Any chance of having this series merged for 3.20? Arnd has acked this already.

Thanks,
baruch

> v3:
>    * Remove earlyprintk from dts bootargs (Arnd Bergmann)
> 
>    * Move aliases from chip .dtsi to board .dts (Arnd Bergmann)
> 
>    * Add 'cpus' node (Mark Rutland)
> 
>    * Add commit log messages to all patches (Arnd Bergmann)
> 
>    * Add Arnd's ack
> 
>    * Split arch/arm stuff from the irq and timer drivers
> 
> v2:
>    http://marc.info/?t=142074613900007&r=1&w=2
> 
>    * Remove .map_io assignment, debug_ll is enabled by default (Arnd Bergmann)
> 
>    * Migrate the irq driver to generic irq chip, simplifying the code somewhat
>      (Arnd Bergmann)
> 
>    * Change the timer dt binding, so that the 'reg' property points to the
>      first "Agent Communication" register. This should improve the chance of
>      reusing this binding for other SoCs in this series.
> 
>    * Add the CONTROL() and COUNT() macros to the timer driver to make the code
>      clearer.
> 
>    * Move arch/arm Kconfig changes from the clocksource driver patch to the
>      base arch support patch to reduce dependency between them
> 
> v1:
>    http://thread.gmane.org/gmane.linux.kernel/1855027
> 
> Baruch Siach (4):
>   ARM: initial support for Conexant Digicolor CX92755 SoC
>   ARM: digicolor: add low level debug support
>   ARM: digicolor: add minimal device tree description
>   ARM: devicetree: document supported Conexant Digicolor SoC
> 
>  .../devicetree/bindings/arm/digicolor.txt          |   6 ++
>  arch/arm/Kconfig                                   |   2 +
>  arch/arm/Kconfig.debug                             |  12 ++-
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/conexant_equinox.dts             |  74 ++++++++++++++
>  arch/arm/boot/dts/cx92755.dtsi                     | 107 +++++++++++++++++++++
>  arch/arm/include/debug/digicolor.S                 |  35 +++++++
>  arch/arm/mach-digicolor/Kconfig                    |   5 +
>  arch/arm/mach-digicolor/Makefile                   |   1 +
>  arch/arm/mach-digicolor/digicolor.c                |  18 ++++
>  10 files changed, 259 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/digicolor.txt
>  create mode 100644 arch/arm/boot/dts/conexant_equinox.dts
>  create mode 100644 arch/arm/boot/dts/cx92755.dtsi
>  create mode 100644 arch/arm/include/debug/digicolor.S
>  create mode 100644 arch/arm/mach-digicolor/Kconfig
>  create mode 100644 arch/arm/mach-digicolor/Makefile
>  create mode 100644 arch/arm/mach-digicolor/digicolor.c

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
