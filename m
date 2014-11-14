Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161939AbaKNUk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:40:28 -0500
Received: from smtprelay4.synopsys.com ([198.182.44.111]:50610 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaKNUkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:40:24 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "balbi@ti.com" <balbi@ti.com>
CC: "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv7 3/8] usb: dwc2: convert to use dev_pm_ops API
Thread-Topic: [PATCHv7 3/8] usb: dwc2: convert to use dev_pm_ops API
Thread-Index: AQHP/dNyR8UKqAd8YUmeQU55Zljpz5xgmmrg
Date: Fri, 14 Nov 2014 20:40:20 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844EBCA9@US01WEMBX2.internal.synopsys.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
 <1415726020-19238-4-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1415726020-19238-4-git-send-email-dinguyen@opensource.altera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.altera.com]
> Sent: Tuesday, November 11, 2014 9:14 AM
> 
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Update suspend/resume to use dev_pm_ops API.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
>  drivers/usb/dwc2/platform.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index eeba8a4..b94867b 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -219,9 +219,9 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  	return retval;
>  }
> 
> -static int dwc2_suspend(struct platform_device *dev, pm_message_t state)
> +static int dwc2_suspend(struct device *dev)
>  {
> -	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
> +	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
>  	int ret = 0;
> 
>  	if (dwc2_is_device_mode(dwc2))
> @@ -229,9 +229,9 @@ static int dwc2_suspend(struct platform_device *dev, pm_message_t state)
>  	return ret;
>  }
> 
> -static int dwc2_resume(struct platform_device *dev)
> +static int dwc2_resume(struct device *dev)
>  {
> -	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
> +	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
>  	int ret = 0;
> 
>  	if (dwc2_is_device_mode(dwc2))
> @@ -239,15 +239,18 @@ static int dwc2_resume(struct platform_device *dev)
>  	return ret;
>  }
> 
> +static const struct dev_pm_ops dwc2_dev_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dwc2_suspend, dwc2_resume)
> +};
> +
>  static struct platform_driver dwc2_platform_driver = {
>  	.driver = {
>  		.name = dwc2_driver_name,
>  		.of_match_table = dwc2_of_match_table,
> +		.pm = &dwc2_dev_pm_ops,
>  	},
>  	.probe = dwc2_driver_probe,
>  	.remove = dwc2_driver_remove,
> -	.suspend = dwc2_suspend,
> -	.resume = dwc2_resume,
>  };
> 
>  module_platform_driver(dwc2_platform_driver);

Acked-by: Paul Zimmerman <paulz@synopsys.com>

