Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3KLPlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:41:39 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39884 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab3KLPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:41:38 -0500
Date: Tue, 12 Nov 2013 15:41:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] regulator: s5m8767: Disable OVCB in probe
Message-ID: <20131112154132.GB3863@lee--X1>
References: <1383923118-26921-1-git-send-email-k.kozlowski@samsung.com>
 <1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384263715-5713-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Nov 2013, Krzysztof Kozlowski wrote:

> According to SW Guide the Over-Voltage Clamp may malfunction at VBatt
> 5.25V and 110'C temperature. This may result in overshooting or
> undershooting LDO's voltage outputs.
> Disable the Over-Voltage Clamp in probe by updating proper bit in all
> LDO registers.
> 
> The patch uses sec_bulk_read/write() API with reordered buf and count
> parameters so it depends on:
>   "mfd: sec: reorder params in API for regmap consistency"
>   http://www.spinics.net/lists/kernel/msg1632519.html
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/s5m8767.c         |   26 ++++++++++++++++++++++++++
>  include/linux/mfd/samsung/s5m8767.h |    1 +
>  2 files changed, 27 insertions(+)

For the MFD change:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
