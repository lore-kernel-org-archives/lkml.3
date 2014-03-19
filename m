Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbaCSJHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:07:17 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:50088 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbaCSJHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:07:12 -0400
Date: Wed, 19 Mar 2014 09:07:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: tps65910: Fix possible invalid pointer
 dereference on regmap_add_irq_chip fail
Message-ID: <20140319090707.GD31687@lee--X1>
References: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394639445-7737-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> tps65910_irq_init() sets the 'tps65910->chip_irq' before calling
> regmap_add_irq_chip(). If this regmap_add_irq_chip() call fails in
> memory allocation of regmap_irq_chip_data members then:
> 1. The 'tps65910->chip_irq' will still hold some value;
> 2. 'tps65910->irq_data' will be pointing to already freed memory
>    (because regmap_add_irq_chip() will free it on error);
> 
> This results in invalid memory access during driver remove because the
> tps65910_irq_exit() tests whether 'tps65910->chip_irq' is not null.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 4aab3fadad32 ("mfd: tps65910: Move interrupt implementation code to mfd file")
> ---
>  drivers/mfd/tps65910.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied after cleaning up the commit message a little.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
