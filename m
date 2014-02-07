Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaBGKmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:42:46 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45418 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaBGKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:42:45 -0500
Date: Fri, 7 Feb 2014 10:42:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Jenny Tc <jenny.tc@intel.com>
Subject: Re: [PATCH v2 14/15] charger: max14577: Configure battery-dependent
 settings from DTS
Message-ID: <20140207104238.GH14727@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-15-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1391767487-10017-15-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove hard-coded values for:
>  - Fast Charge current,
>  - End Of Charge current,
>  - Fast Charge timer,
>  - Overvoltage Protection Threshold,
>  - Battery Constant Voltage,
> and use DTS to configure them. This allows using the max14577 charger
> driver with different batteries.
> 
> Now the charger driver requires valid configuration data from DTS. In
> case of wrong configuration data it fails during probe. Patch adds
> of_compatible to the charger mfd cell in MFD driver core.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

I already acked the MFD parts of this. Or has the patch changed?

> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Jenny Tc <jenny.tc@intel.com>
> ---
>  drivers/mfd/max14577.c               |    5 +-
>  drivers/power/max14577_charger.c     |  234 +++++++++++++++++++++++++++++-----
>  include/linux/mfd/max14577-private.h |   10 ++
>  include/linux/mfd/max14577.h         |    8 ++
>  4 files changed, 227 insertions(+), 30 deletions(-)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
