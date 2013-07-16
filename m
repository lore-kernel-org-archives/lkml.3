Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab3GPJ6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:58:55 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42538 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab3GPJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:58:54 -0400
Message-ID: <51E5195B.3020908@kernel.org>
Date: Tue, 16 Jul 2013 10:58:51 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Otavio Salvador <otavio@ossystems.com.br>
CC: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 5/5] iio: add configuration option for debug support
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br> <1373898160-8460-5-git-send-email-otavio@ossystems.com.br>
In-Reply-To: <1373898160-8460-5-git-send-email-otavio@ossystems.com.br>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 03:22 PM, Otavio Salvador wrote:
> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
seems a sensible facility to have available.

Applied to the togreg branch of iio.git
> ---
>  drivers/iio/Kconfig  | 7 +++++++
>  drivers/iio/Makefile | 2 ++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
> index 9af763a..d1f06f2 100644
> --- a/drivers/iio/Kconfig
> +++ b/drivers/iio/Kconfig
> @@ -12,6 +12,13 @@ menuconfig IIO
>  
>  if IIO
>  
> +config IIO_DEBUG
> +	boolean "Debug support for Industrial I/O"
> +	depends on DEBUG_KERNEL
> +	help
> +	  Say "yes" to enable debug messaging (like dev_dbg and pr_debug),
> +	  sysfs, and debugfs support in Industrial I/O subsystem and drivers.
> +
>  config IIO_BUFFER
>  	bool "Enable buffer support within IIO"
>  	help
> diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
> index 7a3866c..6e43e5b 100644
> --- a/drivers/iio/Makefile
> +++ b/drivers/iio/Makefile
> @@ -2,6 +2,8 @@
>  # Makefile for the industrial I/O core.
>  #
>  
> +ccflags-$(CONFIG_IIO_DEBUG) := -DDEBUG
> +
>  obj-$(CONFIG_IIO) += industrialio.o
>  industrialio-y := industrialio-core.o industrialio-event.o inkern.o
>  industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
> 
