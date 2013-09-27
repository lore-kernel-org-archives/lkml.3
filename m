Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab3I0Htj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:49:39 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58547 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3I0Hth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:49:37 -0400
Date: Fri, 27 Sep 2013 08:49:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org, swarren@nvidia.com
Subject: Re: [PATCH 4/4] mfd: palmas: fix resource leak of i2c_dummy devices
Message-ID: <20130927074931.GC5100@lee--X1>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
 <1380202431-4868-5-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380202431-4868-5-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Laxman Dewangan wrote:

> Palmas device supports multiple i2c device address and the client
> for these addressed are created in the driver as i2c_new_dummy().
> 
> The new devices are not getting released in error or removal path and
> so it is causing resource leak.
> 
> Add the unregister of these newly created dummy devices to avoid resource
> leaks.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)

Patch looks sane.

>  no_irq:
>  	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
> @@ -552,7 +552,6 @@ no_irq:
>  		} else if (pdata->pm_off && !pm_power_off) {
>  			palmas_dev = palmas;
>  			pm_power_off = palmas_power_off;
> -			return ret;
>  		}
>  	}

Sneaky! ;)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
