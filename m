Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3CZWWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:22:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54063 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab3CZWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:22:50 -0400
Message-ID: <51521FA8.6030806@ti.com>
Date: Tue, 26 Mar 2013 18:22:32 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.daniel@samsung.com>, <durgadoss.r@intel.com>, <andi@lisas.de>
Subject: Re: [RFC, 2/5] Thermal: thermal framework registration failure case
 cleanup
References: <1364315169-15427-3-git-send-email-rui.zhang@intel.com>
In-Reply-To: <1364315169-15427-3-git-send-email-rui.zhang@intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-03-2013 12:26, Zhang Rui wrote:
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>

Could you please describe why these resource releases are not required 
anymore? Even on thermal_exit.

> ---
> drivers/thermal/thermal_core.c |   12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 5b7863a..845ed6e 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -1863,13 +1863,9 @@ static int __init thermal_init(void)
>   	int result = 0;
>
>   	result = class_register(&thermal_class);
> -	if (result) {
> -		idr_destroy(&thermal_tz_idr);
> -		idr_destroy(&thermal_cdev_idr);
> -		mutex_destroy(&thermal_idr_lock);
> -		mutex_destroy(&thermal_list_lock);
> +	if (result)
>   		return result;
> -	}
> +
>   	result = genetlink_init();
>   	return result;
>   }
> @@ -1877,10 +1873,6 @@ static int __init thermal_init(void)
>   static void __exit thermal_exit(void)
>   {
>   	class_unregister(&thermal_class);
> -	idr_destroy(&thermal_tz_idr);
> -	idr_destroy(&thermal_cdev_idr);
> -	mutex_destroy(&thermal_idr_lock);
> -	mutex_destroy(&thermal_list_lock);
>   	genetlink_exit();
>   }
>
>

