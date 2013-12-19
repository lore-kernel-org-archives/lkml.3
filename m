Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab3LSI4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:56:17 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:53662 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3LSI4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:56:13 -0500
Date: Thu, 19 Dec 2013 08:56:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Felipe Balbi <balbi@ti.com>, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mfd: ti_am335x_tscadc: don't read back REG_SE
Message-ID: <20131219085607.GG2621@lee--X1>
References: <1387385577-24447-1-git-send-email-bigeasy@linutronix.de>
 <1387385577-24447-4-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387385577-24447-4-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Sebastian Andrzej Siewior wrote:

> The purpose of reg_se_cache has been defeated. It should avoid the
> read-back of the register to avoid the latency and the fact that the
> bits are reset to 0 after the individual conversation took place.
> 
> The reason why this is required like this to work, is that read-back of
> the register removes the bits of the ADC so they do not start another
> conversation after the register is re-written from the TSC side for the
> update.
> To avoid the unrequired read-back I introduce a "set adc" variant which
> does not update the cache mask. After the conversation completes, the
> register bit is removed from the SE reister anyway and we don't plan a
> new conversation "any time soon".
> This is a small preparation for a larger sync-rework.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/iio/adc/ti_am335x_adc.c      |  2 +-
>  drivers/mfd/ti_am335x_tscadc.c       | 12 ++++++++++--
>  include/linux/mfd/ti_am335x_tscadc.h |  1 +
>  3 files changed, 12 insertions(+), 3 deletions(-)

Looks about right: Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
