Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaDWMqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:46:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.131]:59882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaDWMeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:34:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 2/8] ARM: sunxi: Split out the various machines into separate files
Date: Wed, 23 Apr 2014 14:33:50 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com> <1397724379-15398-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1397724379-15398-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231433.51129.arnd@arndb.de>
X-Provags-ID: V02:K0:+lek8zXc3IhYTzOiVez8YkQmY0xcQa7i0cRd4WecVNR
 L2qYlNDf+BRF0z2h40xGNbDs5QF8CroD8fBWv7kNgLAqOsbwCi
 UKl2Jc5GHNE3AmhlBG1A3EPrDCz7BUGkT1kEBVRvBkY8iEAvmc
 axvEVkoxWIoUFdcg4c/9Z1ik1zAUgS0gh4cyDetazabOW0D9gs
 dp8Ww56h3Ub8MfiXbmUbqY85m+xJJu28/tYTE2ZJPtP4I1r3I7
 VwGGTOBPVF/zqkRJdnM0t9u6s1SSi0F+sXgid3N38sXuw3HB2o
 TAIC79Ohlg9+JDYLAUdptOF8dylTxZ263ioparUZWIY6mpYPkH
 R10gsTSMwX0nLiyhoIoU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014, Maxime Ripard wrote:
> This will allow to add per-SoC hooks more easily.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/mach-sunxi/Makefile  |   6 +-
>  arch/arm/mach-sunxi/restart.c | 104 +++++++++++++++++++++++++++
>  arch/arm/mach-sunxi/restart.h |  20 ++++++
>  arch/arm/mach-sunxi/sun4i.c   |  36 ++++++++++
>  arch/arm/mach-sunxi/sun5i.c   |  37 ++++++++++
>  arch/arm/mach-sunxi/sun6i.c   |  49 +++++++++++++
>  arch/arm/mach-sunxi/sun7i.c   |  36 ++++++++++
>  arch/arm/mach-sunxi/sunxi.c   | 164 ------------------------------------------
>  8 files changed, 287 insertions(+), 165 deletions(-)

This doesn't look like a move in the right direction, and I don't see
the connection with the DMA driver.

> diff --git a/arch/arm/mach-sunxi/restart.c b/arch/arm/mach-sunxi/restart.c
> new file mode 100644
> index 000000000000..3b89727ee943
> --- /dev/null
> +++ b/arch/arm/mach-sunxi/restart.c

Splitting out the restart code is good, but please complete this by
moving it into a driver directory. My preferred location would be
within the watchdog driver, since it's really the same registers.
You can turn on the watchdog driver as built-in in the defconfig.
While it's not ideal that you can end up without a restart function
if the driver does not get loaded, I would still prefer that over
having the driver in the mach-sunxi directory.

An alternative would be to move the restart code into
drivers/power/reset.

> diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> deleted file mode 100644
> index 460b5a4962ef..000000000000
> --- a/arch/arm/mach-sunxi/sunxi.c

Instead of splitting up this file, I think it would be better to
reduce the number of special hacks required per machine. Note that
for arm64 we require platforms not to have any code outside of
the drivers directory, and I'd like to get to the same situation
for much of arch/arm/mach-* as well.

	Arnd
