Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbaGYWbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:31:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61415 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaGYWbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:31:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Lee Jones" <lee.jones@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
Cc: "Mark Brown" <broonie@kernel.org>, "Liam Girdwood" <lgirdwood@gmail.com>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Yadwinder Singh Brar" <yadi.brar01@gmail.com>,
        "Tushar Behera" <trblinux@gmail.com>,
        "Andreas Farber" <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>
References: <1405337769-3741-1-git-send-email-javier.martinez@collabora.co.uk>
Message-ID: <20140725223140.4791.61816@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v8 00/13] Add Maxim 77802 PMIC support
Date: Fri, 25 Jul 2014 15:31:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Javier Martinez Canillas (2014-07-14 04:35:56)
> This series are based on drivers added by Simon Glass to the Chrome OS
> kernel and adds support for the Maxim 77802 Power Management IC, their
> regulators, clocks, RTC and i2c interface.
> 
> This is a v8 of the patch-set that addresses issues pointed out in v7.
> Individual changes are added on each patch but the biggest changes are:
> 
> * Patches 1-7 from v7 are not included since those were improvements to
> the max77686 mfd driver and can be applied independently. Lee Jones said
> that he is going to pick them from the posted v7 series.
> 
> I've created a patchwork bundle with 1-7 from v7 to make it easy to apply:
> 
> https://patchwork.kernel.org/bundle/javier/max77686-improvements/
> 
> * The Dynamic Voltage Scaling support has been removed since that can be
> added in a follow up series and shouldn't block the minimum PMIC support.
> 
> The patch-set has been tested on both Daisy/Snow (max77686) and Peach
> Pit (max77802) Chromebooks and it's composed of the following patches:
> 
> [PATCH v8 01/13] mfd: max77686: Add Maxim 77802 PMIC support
> [PATCH v8 02/13] mfd: max77802: Add DT binding documentation
> [PATCH v8 03/13] regulator: Add driver for Maxim 77802 PMIC regulators
> [PATCH v8 04/13] clk: max77686: Add DT include for MAX77686 PMIC clock
> [PATCH v8 05/13] clk: Add generic driver for Maxim PMIC clocks
> [PATCH v8 06/13] clk: max77686: Convert to the generic max clock driver
> [PATCH v8 07/13] clk: max77686: Improve Maxim 77686 PMIC clocks binding
> [PATCH v8 08/13] clk: Add driver for Maxim 77802 PMIC clocks
> [PATCH v8 09/13] clk: max77802: Add DT binding documentation

For patches 4-9:

Acked-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike

> [PATCH v8 10/13] rtc: max77686: Allow the max77686 rtc to wakeup the system
> [PATCH v8 11/13] rtc: max77686: Remove dead code for SMPL and WTSR
> [PATCH v8 12/13] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
> [PATCH v8 13/13] ARM: dts: Add max77802 to exynos5420-peach-pit and exynos5800-peach-pi
> 
> Patch 01/13 extend the max77686 mfd driver to also support the max77802
> PMIC and patch 02/13 adds the DT binding documentation for this PMIC.
> 
> Patch 03/13 adds support for the regulators found in the PMIC.
> 
> Patch 04/13 to 07/13 are improvements and refactoring to the max77686 clock
> driver to avoid code duplication when adding max77802 clocks support in patch
> 08/13. Patch 09/13 adds the DT binding document for the max77802 clock driver.
> 
> Patches 10/13 and 11/13 are improvements to max77686 RTC driver and patch
> 12/13 adds support for the RTC found in the max77802 PMIC.
> 
> Finally patch 13/13 adds the required device node to the Peach Pit and Pi
> exynos5 based boards.
> 
> Since there are cross-subsystems dependencies, I think that the best way to
> sort this out is if relevant maintainers ack the patches so 01/13 to 012/13
> can be merged through the mfd tree. The patches and the relevant acks are:
> 
> Patch 03/13 (regulator - Mark Brown)
> Patches 04/13 to 09/13 (clk - Mike Turquette)
> Patches 10/13 to 12/13 (rtc - Alessandro Zummo)
> 
> Patch 13/13 is only a DTS change so it can be picked by Kukjin Kim once the
> other patches are picked by Lee Jones.
> 
> Since we are in 3.16-rc5 already, it would be great if I can get your acks
> or feedback since I was hoping this series to make it to 3.17. This is due
> other series that were already posted depend on this one.
> 
> Also, the series have been reviewed and tested by Samsung folks and most of
> the patches already collected Reviewed-by and Tested-by tags.
> 
> Thanks a lot and best regards,
> Javier
> 
