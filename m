Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaAXQDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:03:24 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53514 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaAXQDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:03:22 -0500
Date: Fri, 24 Jan 2014 16:03:14 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v3 1/2] regulator: s5m8767: Use GPIO for controlling
 Buck9/eMMC
Message-ID: <20140124160314.GB27911@lee--X1>
References: <1390570678-30686-1-git-send-email-k.kozlowski@samsung.com>
 <1390570678-30686-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390570678-30686-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Krzysztof Kozlowski wrote:

> Add support for GPIO control (enable/disable) over Buck9. The Buck9
> Converter is used as a supply for eMMC Host Controller.
> 
> BUCK9EN GPIO of S5M8767 chip may be used by application processor to
> enable or disable the Buck9. This has two benefits:
>  - It is faster than toggling it over I2C bus.
>  - It allows disabling the regulator during suspend to RAM; The AP will
>    enable it during resume; Without the patch the regulator supplying
>    eMMC must be defined as fixed-regulator.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/regulator/s5m8767.c         |   87 +++++++++++++++++++++++++++++++++--
>  include/linux/mfd/samsung/core.h    |    3 +-
>  include/linux/mfd/samsung/s5m8767.h |    7 +++
>  3 files changed, 93 insertions(+), 4 deletions(-)

For the MFD changes:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
