Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3KRLs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:48:28 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48788 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab3KRLsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:48:22 -0500
Date: Mon, 18 Nov 2013 11:48:10 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH 1/3] mfd: cros ec: spi: Add delay for raising CS
Message-ID: <20131118114810.GE30853@e106331-lin.cambridge.arm.com>
References: <1384770649-8593-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384770649-8593-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 10:30:47AM +0000, Thierry Reding wrote:
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
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  Documentation/devicetree/bindings/mfd/cros-ec.txt |  4 +++
>  drivers/mfd/cros_ec_spi.c                         | 30 +++++++++++++++++++++++
>  2 files changed, 34 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
> index 5f229c5f6da9..fb3034a87ae0 100644
> --- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
> +++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
> @@ -17,6 +17,10 @@ Required properties (SPI):
>  - compatible: "google,cros-ec-spi"
>  - reg: SPI chip select
>  
> +Optional properties (SPI):
> +- google,cros-ec-spi-msg-delay: This property is how long of a delay, in usecs,
> +  to use on the last transfer of a message, to force time between transactions.
> +

Lose the "This property is", that's obvious from the structure of the
document.

It would be nice to have an explanation in the binding document as to
_why_ you might want to do this (e.g. the HW expects the rising edge to
come some number of uS after the data, if it comes too early it
explodes).

Otherwise this looks fine to me.

Thanks,
Mark.
