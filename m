Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaLCRPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:15:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:19665 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaLCRO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:14:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,508,1413270000"; 
   d="scan'208";a="647607777"
Message-ID: <1417623491.2043.320.camel@spandruv-desktop.jf.intel.com>
Subject: Re: [PATCH] iio / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 03 Dec 2014 08:18:11 -0800
In-Reply-To: <202529361.GBbZ7zGgn8@vostro.rjw.lan>
References: <202529361.GBbZ7zGgn8@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 03:06 +0100, Rafael J. Wysocki wrote: 
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> drivers/iio/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

There are some other drivers using this define, we need to change all
those.

Thanks,
Srinivas

> 
> ---
>  drivers/iio/accel/bmc150-accel.c |    4 ++--
>  drivers/iio/accel/kxcjk-1013.c   |    4 ++--
>  drivers/iio/gyro/bmg160.c        |    4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> Index: linux-pm/drivers/iio/accel/bmc150-accel.c
> ===================================================================
> --- linux-pm.orig/drivers/iio/accel/bmc150-accel.c
> +++ linux-pm/drivers/iio/accel/bmc150-accel.c
> @@ -510,7 +510,7 @@ static int bmc150_accel_get_bw(struct bm
>  	return -EINVAL;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int bmc150_accel_get_startup_times(struct bmc150_accel_data *data)
>  {
>  	int i;
> @@ -1349,7 +1349,7 @@ static int bmc150_accel_resume(struct de
>  }
>  #endif
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int bmc150_accel_runtime_suspend(struct device *dev)
>  {
>  	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> Index: linux-pm/drivers/iio/accel/kxcjk-1013.c
> ===================================================================
> --- linux-pm.orig/drivers/iio/accel/kxcjk-1013.c
> +++ linux-pm/drivers/iio/accel/kxcjk-1013.c
> @@ -358,7 +358,7 @@ static int kxcjk1013_chip_init(struct kx
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int kxcjk1013_get_startup_times(struct kxcjk1013_data *data)
>  {
>  	int i;
> @@ -1357,7 +1357,7 @@ static int kxcjk1013_resume(struct devic
>  }
>  #endif
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int kxcjk1013_runtime_suspend(struct device *dev)
>  {
>  	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> Index: linux-pm/drivers/iio/gyro/bmg160.c
> ===================================================================
> --- linux-pm.orig/drivers/iio/gyro/bmg160.c
> +++ linux-pm/drivers/iio/gyro/bmg160.c
> @@ -237,7 +237,7 @@ static int bmg160_chip_init(struct bmg16
>  
>  static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>  {
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	int ret;
>  
>  	if (on)
> @@ -1164,7 +1164,7 @@ static int bmg160_resume(struct device *
>  }
>  #endif
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int bmg160_runtime_suspend(struct device *dev)
>  {
>  	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
> 


