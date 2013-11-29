Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3K2JEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 04:04:38 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:50037 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab3K2JEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 04:04:35 -0500
Date: Fri, 29 Nov 2013 09:04:29 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/5] mfd/rtc: s5m: Fix register updating by adding
 regmap for RTC
Message-ID: <20131129090429.GA26086@lee--X1>
References: <1385626183-22990-1-git-send-email-k.kozlowski@samsung.com>
 <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385626183-22990-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov 2013, Krzysztof Kozlowski wrote:

> Rename old regmap field of "struct sec_pmic_dev" to "regmap_pmic" and
> add new regmap for RTC.
> 
> On S5M8767A registers were not properly updated and read due to usage of
> the same regmap as the PMIC. This could be observed in various hangs,
> e.g. in infinite loop during waiting for UDR field change.
> 
> On this chip family the RTC has different I2C address than PMIC so
> additional regmap is needed.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/sec-core.c           |   30 ++++++++++++++++++++++--------
>  drivers/mfd/sec-irq.c            |    6 +++---
>  drivers/regulator/s5m8767.c      |    2 +-
>  drivers/rtc/rtc-s5m.c            |    2 +-
>  include/linux/mfd/samsung/core.h |    3 ++-
>  5 files changed, 29 insertions(+), 14 deletions(-)

The MFD parts look fine to me. I just need the Acks from the other
maintainers before I can apply it:

Acked-by: Lee Jones <lee.jones@lianro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
