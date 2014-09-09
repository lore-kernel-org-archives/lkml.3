Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaIIWOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:14:31 -0400
Received: from mout.gmx.net ([212.227.15.19]:54735 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbaIIWO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:14:27 -0400
Message-ID: <540F7BB5.2080801@gmx.de>
Date: Wed, 10 Sep 2014 00:14:13 +0200
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26.1
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, Jonathan Cameron <jic23@kernel.org>,
        linux-iio@vger.kernel.org
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: gyro: bmg160: only set power state if PM_RUNTIME
 is defined
References: <1410185127-13039-1-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1410185127-13039-1-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:SlUSxYaJ8EvfMsiIRqq7FeKBZJQp8R+yVce27JXs+xFS4ay5pfp
 Xf68VbZBqvqbQWXGNJPdCMVgiLuZgGhWjXaU+jYrsvJULmToyozeK1ZMRK9T562kHwXzKzT
 JBl5L7wMYoUG7dr/7INEjgjFTnnih2Ofe8zf/nVMt6kSYnVIBmSa0EQWrruh9AvnckqKf27
 Xj78FlB2xZDnPjYuxwMnQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irina Tirdea schrieb, Am 08.09.2014 16:05:
> When CONFIG_PM_RUNTIME is not defined and bmg160 tries to power
> off the device, bmg160_set_power_state will call pm_runtime_put_autosuspend,
> which is not implemented (wil return -ENOSYS).
> 
> Only call bmg160_set_power_state when CONFIG_PM_RUNTIME is defined.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
> 
> Changes in v2:
>  - moved ifdef CONFIG_PM_RUNTIME inside bmg160_set_power_state as
> Hartmut Knaack suggested
> 
>  drivers/iio/gyro/bmg160.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/iio/gyro/bmg160.c b/drivers/iio/gyro/bmg160.c
> index 7524698..1f967e0d 100644
> --- a/drivers/iio/gyro/bmg160.c
> +++ b/drivers/iio/gyro/bmg160.c
> @@ -237,6 +237,7 @@ static int bmg160_chip_init(struct bmg160_data *data)
>  
>  static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>  {
> +#ifdef CONFIG_PM_RUNTIME
>  	int ret;
>  
>  	if (on)
> @@ -251,6 +252,7 @@ static int bmg160_set_power_state(struct bmg160_data *data, bool on)
>  			"Failed: bmg160_set_power_state for %d\n", on);
>  		return ret;
>  	}
> +#endif
>  
>  	return 0;
>  }
> 

