Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3KFC5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:57:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11315 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3KFC5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:57:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Nov 2013 18:56:32 -0800
Message-ID: <5279AFF0.1080105@nvidia.com>
Date: Wed, 6 Nov 2013 10:56:48 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>
CC: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 02/18] thermal: core: allow binding via .bind when tzp
 is present
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
 <1380251605-3804-3-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1380251605-3804-3-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 11:13 AM, Eduardo Valentin wrote:
> This patch allows drivers register thermal zone devices
> with thermal zone params and .bind callbacks. In this case,
> it will use the .bind callback.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  drivers/thermal/thermal_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 8a94300..f7a9f4f 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -247,7 +247,7 @@ static void bind_cdev(struct thermal_cooling_device *cdev)
>  		if (!pos->tzp && !pos->ops->bind)
>  			continue;
>  
> -		if (!pos->tzp && pos->ops->bind) {
> +		if (pos->ops->bind) {

Hi, Eduardo
In bind_tz() routine, it also has same problem.
I had sent out similar patch "[PATCHv4 02/18] thermal: core: allow
binding via .bind when tzp is present" to fix it, but no response yet.
I think you can add my changes in your series :)

Thanks.
Wei.

>  			ret = pos->ops->bind(pos, cdev);
>  			if (ret)
>  				print_bind_err_msg(pos, cdev, ret);
> 

