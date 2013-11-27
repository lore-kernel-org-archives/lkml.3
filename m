Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3K0MDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:03:54 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:38507 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3K0MDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:03:53 -0500
Date: Wed, 27 Nov 2013 12:03:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 4/5] mfd: sec: Add PM ops and make it a wake up source
Message-ID: <20131127120344.GD3296@lee--X1>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
 <1385473828-31078-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385473828-31078-5-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Krzysztof Kozlowski wrote:

> Add PM suspend/resume ops to the sec MFD core driver and make it a wake
> up source. This allows proper waking from suspend to RAM and also fixes
> broken interrupts after resuming:
> [   42.705703] sec_pmic 7-0066: Failed to read IRQ status: -5
> 
> Interrupts stop working after first resume initiated by them (e.g. by
> RTC Alarm interrupt) because interrupt registers were not cleared properly.
> 
> When device is woken up from suspend by RTC Alarm, an interrupt occurs
> before resuming I2C bus controller. The interrupt is handled by
> regmap_irq_thread which tries to read RTC registers. This read fails
> (I2C is still suspended) and RTC Alarm interrupt is disabled.
> 
> Disable the S5M8767 interrupts during suspend (disable_irq()) and enable
> them during resume so the device will be still woken up but the interrupt
> won't happen before resuming I2C bus.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/sec-core.c |   40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)

Patch looks good to me and appears to be orthogonal therefore I have
tentatively applied it.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
