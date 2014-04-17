Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaDQII7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:08:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39271 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaDQIIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:08:52 -0400
Date: Thu, 17 Apr 2014 09:08:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH resend] mfd/rtc: s5m: Do not allocate RTC I2C dummy and
 regmap for unsupported chipsets
Message-ID: <20140417080847.GF28725@lee--X1>
References: <1397461245-818-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397461245-818-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The rtc-s5m driver does not support all of S2M and S5M chipsets
> supported by main MFD sec-core driver. For such chipsets unsupported by
> rtc-s5m, the MFD sec-core driver initialized regmap with default config.
> This config in such cases wouldn't work at all.
> 
> The main MFD sec-core driver shouldn't initialize regmap for child
> drivers which is not used by them and even not valid.
> 
> Move the allocation of RTC I2C dummy device and initialization of RTC
> regmap from main MFD sec-core driver to the rtc-s5m driver. The rtc-s5m
> driver will use proper regmap config for supported devices.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c           | 53 +---------------------------
>  drivers/rtc/rtc-s5m.c            | 75 +++++++++++++++++++++++++++++++++++++---
>  include/linux/mfd/samsung/core.h |  3 --
>  3 files changed, 71 insertions(+), 60 deletions(-)

MFD changes look good to me. If Alessandro provides his Ack for the
RTC adaptions I can setup an MFD-RTC branch for him to pull from in
order to save conflicts at merge time.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
