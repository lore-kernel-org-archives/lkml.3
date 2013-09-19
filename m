Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3ISJNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:13:32 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:58910 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3ISJNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:13:30 -0400
Date: Thu, 19 Sep 2013 10:13:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Marc Reilly <marc@cpdesign.com.au>, u.kleine-koenig@pengutronix.de,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
Message-ID: <20130919091318.GA22389@lee--X1>
References: <1379527587-14567-1-git-send-email-broonie@kernel.org>
 <1379527587-14567-2-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379527587-14567-2-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Move the workaround for double sending AUDIO_CODEC and AUDIO_DAC writes
> into the SPI core, aiding refactoring to eliminate the ASoC custom I/O
> functions and avoiding the extra writes for I2C.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/mc13xxx-spi.c   | 5 +++++
>  include/linux/mfd/mc13xxx.h | 7 +++++++
>  sound/soc/codecs/mc13783.c  | 4 ----
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 77189da..363c359 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -94,10 +94,15 @@ static int mc13xxx_spi_write(void *context, const void *data, size_t count)
>  {
>  	struct device *dev = context;
>  	struct spi_device *spi = to_spi_device(dev);
> +	char *reg = data;

I think this requires a cast.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
