Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaKSOoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:44:09 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:50698 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbaKSOoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:44:08 -0500
Message-ID: <546CAC92.3020504@st.com>
Date: Wed, 19 Nov 2014 15:43:30 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <edubezval@gmail.com>, <kernel@stlinux.com>, <linux-pm@vger.kernel.org>
Subject: Re: [STLinux Kernel] [PATCH] thermal: sti: Ignore suspend/resume
 functions when !PM
References: <1416404939-365-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1416404939-365-1-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-19_04:2014-11-19,2014-11-19,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/19/2014 02:48 PM, Lee Jones wrote:
> Prevents build warning:
>
> st_thermal.c:278:12:
>      warning: ‘st_thermal_suspend’ defined but not used [-Wunused-function]
> st_thermal.c:286:12:
>      warning: ‘st_thermal_resume’ defined but not used [-Wunused-function]
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
You can add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime

> ---
>   drivers/thermal/st/st_thermal.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
> index 90163b3..9841488 100644
> --- a/drivers/thermal/st/st_thermal.c
> +++ b/drivers/thermal/st/st_thermal.c
> @@ -275,6 +275,7 @@ int st_thermal_unregister(struct platform_device *pdev)
>   }
>   EXPORT_SYMBOL_GPL(st_thermal_unregister);
>   
> +#ifdef CONFIG_PM
>   static int st_thermal_suspend(struct device *dev)
>   {
>   	struct platform_device *pdev = to_platform_device(dev);
> @@ -305,6 +306,8 @@ static int st_thermal_resume(struct device *dev)
>   
>   	return 0;
>   }
> +#endif
> +
>   SIMPLE_DEV_PM_OPS(st_thermal_pm_ops, st_thermal_suspend, st_thermal_resume);
>   EXPORT_SYMBOL_GPL(st_thermal_pm_ops);
>   

