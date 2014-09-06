Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaIFMMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:12:23 -0400
Received: from mout.gmx.net ([212.227.17.22]:64814 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaIFMMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:12:20 -0400
Message-ID: <540AFA13.6010207@gmx.de>
Date: Sat, 06 Sep 2014 14:12:03 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: gyro: bmg160: only set power state if PM_RUNTIME
 is defined
References: <1409655759-28849-1-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1409655759-28849-1-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:PqozdocyOAXyPbIzVBmA6VnfK/4WNHKgdQ+sz9i3StJFw6cWrdO
 otmwsXMM/hvlkNXWiMs2cCGgM5Set5BC6xLC0F6qCY/8UKwvXbJp5cDI45e4D37BjY20Qgh
 oH00S3kKkKEi2BbrUtgkLnzwoCmp0F6b03tFlnl+qeHplKKUklEs07Uk4QDlESA8U7mE8we
 sXcNR7tWQRH9qykGE+m4A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irina Tirdea schrieb:
> When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
> off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
> which is not implemented (wil return -ENOSYS).
>
> Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.
Unless there is anything more to come, what about putting the #ifdef into first line inside bmg160_set_power_state() and just an #endif before the return 0 at the end? Saves 5 lines.
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> ---
>  drivers/iio/gyro/bmg160.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
> index 7524698..e41d6b5 100644
> --- a/drivers/iio/gyro/bmg160.c
> +++ b/drivers/iio/gyro/bmg160.c
> @@ -235,6 +235,7 @@ static int bmg160_chip_init(struct bmg160_data *data)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
>  static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>  {
>  	int ret;
> @@ -254,6 +255,12 @@ static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>  
>  	return 0;
>  }
> +#else
> +static int bmg160_set_power_state(struct bmg160_data *data, bool on)
> +{
> +	return 0;
> +}
> +#endif
>  
>  static int bmg160_setup_any_motion_interrupt(struct bmg160_data *data,
>  					     bool status)

