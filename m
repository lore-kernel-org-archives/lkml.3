Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaD1MLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 08:11:01 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:51324 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaD1MLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 08:11:00 -0400
Date: Mon, 28 Apr 2014 13:10:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/2] mfd: max14577: Fix IRQ handling after resume if this
 is not a wakeup source
Message-ID: <20140428121053.GA21279@lee--X1>
References: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398175162-20244-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> During suspend the IRQ should be disabled even if this is not a wakeup
> source. This is a proper way of fixing the IRQ handling issue during
> resume (IRQ handler fails because I2C bus did not resume yet).
> 
> When device is suspended and max14577 interrupt is signaled the irq chip
> will try to handle it regardless of wakeup source. Device could be woken
> up by different IRQ but still the IRQ handler will try to read the
> registers over I2C bus and fail because I2C bus won't be ready yet:
> 	max14577 2-0025: Failed to read IRQ status: -5
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max14577.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)

It's pretty worrying that these two patches are so alike and they
actually change different files. Is there any way we can unify more of
the code?

Patch applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
