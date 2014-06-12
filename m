Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaFLIgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:36:51 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57873 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932399AbaFLIgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:36:49 -0400
Message-ID: <5399667C.20203@st.com>
Date: Thu, 12 Jun 2014 10:36:12 +0200
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: st-keyscan - Protect PM-only functions by #ifdef
 CONFIG_PM_SLEEP
References: <1402513493-17613-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1402513493-17613-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-12_03:2014-06-11,2014-06-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Geert

Acked-by : Gabriel Fernandez <gabriel.fernandez@linaro.org>

Best Regards


On 06/11/2014 09:04 PM, Geert Uytterhoeven wrote:
> If CONFIG_PM_SLEEP=n:
>
> drivers/input/keyboard/st-keyscan.c:219: warning: ‘keyscan_suspend’ defined but not used
> drivers/input/keyboard/st-keyscan.c:236: warning: ‘keyscan_resume’ defined but not used
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/input/keyboard/st-keyscan.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/input/keyboard/st-keyscan.c b/drivers/input/keyboard/st-keyscan.c
> index 758b48731415..668e3cf4b491 100644
> --- a/drivers/input/keyboard/st-keyscan.c
> +++ b/drivers/input/keyboard/st-keyscan.c
> @@ -215,6 +215,7 @@ static int keyscan_probe(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +#ifdef CONFIG_PM_SLEEP
>   static int keyscan_suspend(struct device *dev)
>   {
>   	struct platform_device *pdev = to_platform_device(dev);
> @@ -249,6 +250,7 @@ static int keyscan_resume(struct device *dev)
>   	mutex_unlock(&input->mutex);
>   	return retval;
>   }
> +#endif /* CONFIG_PM_SLEEP */
>   
>   static SIMPLE_DEV_PM_OPS(keyscan_dev_pm_ops, keyscan_suspend, keyscan_resume);
>   

