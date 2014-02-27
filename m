Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaB0Idr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:33:47 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:39122 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB0Idq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:33:46 -0500
Date: Thu, 27 Feb 2014 08:33:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/8] mfd: Move pm8xxx-irq.c contents into only driver
 that uses it
Message-ID: <20140227083339.GU9195@lee--X1>
References: <1393441166-32692-1-git-send-email-sboyd@codeaurora.org>
 <1393441166-32692-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393441166-32692-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The pm8xxx-irq.c code is practically mandatory given that the
> pm8921-core driver will WARN about it missing and the Kconfig
> marks it as default y when a PM8xxx chips is enabled. The only
> reason the file was split out was because we planned to support
> other pm8xxx chips with different pm8xxx-core.c files. Now that
> we have DT on ARM this isn't necessary because we should be able
> to support all the ssbi based PM8xxx chips in one driver and one
> file with no data bloat. Let's move this code into the only
> driver that uses it right now (pm8921) so that it's always compiled when
> needed. In the future we can rename pm8921-core.c to something
> more generic.
> 
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig            |  10 --
>  drivers/mfd/Makefile           |   1 -
>  drivers/mfd/pm8921-core.c      | 348 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/pm8xxx-irq.c       | 371 -----------------------------------------
>  include/linux/mfd/pm8xxx/irq.h |  23 ---
>  5 files changed, 348 insertions(+), 405 deletions(-)
>  delete mode 100644 drivers/mfd/pm8xxx-irq.c

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
