Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3LPNu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 08:50:59 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47512 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3LPNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 08:50:58 -0500
Date: Mon, 16 Dec 2013 13:50:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mfd: cros ec: spi: Add delay for raising CS
Message-ID: <20131216135050.GJ18769@lee--X1>
References: <1387192180-15333-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387192180-15333-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rhyland Klein <rklein@nvidia.com>
> 
> The EC has specific timing it requires. Add support for an optional delay
> after raising CS to fix timing issues. This is configurable based on
> a DT property "google,cros-ec-spi-msg-delay".
> 
> If this property isn't set, then no delay will be added. However, if set
> it will cause a delay equal to the value passed to it to be inserted at
> the end of a transaction.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> Reviewed-by: Bernie Thompson <bhthompson@chromium.org>
> Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v5:
> - modify correct hunk to use 0 instead of '\0'
> - add Mark's Acked-by
> 
> Changes in v4:
> - unconditionally call cros_ec_spi_dt_probe() since the driver now
>   depends on OF
> 
> Changes in v3:
> - rename cros_ec_probe_spi_dt() to cros_ec_spi_dt_probe()
> - use 0 instead of '\0'
> 
> Changes in v2:
> - make property description more verbose
> 
>  Documentation/devicetree/bindings/mfd/cros-ec.txt |  9 +++++++
>  drivers/mfd/cros_ec_spi.c                         | 29 +++++++++++++++++++++++
>  2 files changed, 38 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
