Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaBKJ7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:59:09 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47525 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaBKJ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:59:04 -0500
Date: Tue, 11 Feb 2014 09:58:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-core: Fix possible NULL pointer dereference
 when i2c_new_dummy error
Message-ID: <20140211095858.GJ32042@lee--X1>
References: <1392109945-333-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392109945-333-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> During probe the sec-core driver allocates dummy I2C device for RTC with
> i2c_new_dummy() but return value is not checked. In case of error
> (i2c_new_device(): memory allocation failure or I2C address cannot be
> used) this function returns NULL which is later used by
> devm_regmap_init_i2c() or i2c_unregister_device().
> 
> If i2c_new_dummy() fails for RTC device, fail also the probe for main
> MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/sec-core.c |    4 ++++
>  1 file changed, 4 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
