Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaAFOrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:47:48 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61780 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaAFOrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:47:47 -0500
Date: Mon, 6 Jan 2014 14:47:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/7] mfd: Move pm8xxx-irq.c contents into only driver
 that uses it
Message-ID: <20140106144741.GH30156@lee--X1>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387831563-13535-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013, Stephen Boyd wrote:

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
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/Kconfig            |  10 --
>  drivers/mfd/pm8921-core.c      | 348 ++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/pm8xxx-irq.c       | 371 -----------------------------------------
>  include/linux/mfd/pm8xxx/irq.h |  23 ---
>  4 files changed, 348 insertions(+), 404 deletions(-)
>  delete mode 100644 drivers/mfd/pm8xxx-irq.c

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
