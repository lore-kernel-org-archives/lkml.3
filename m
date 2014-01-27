Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaA0I2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 03:28:18 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30190 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA0I2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 03:28:14 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-b3-52e618992f25
Content-transfer-encoding: 8BIT
Message-id: <1390811288.4974.4.camel@AMDC1943>
Subject: Re: [PATCH 1/2] mfd: max14577: max14577_{suspend,resume}() should
 depend on CONFIG_PM_SLEEP
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 09:28:08 +0100
In-reply-to: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
References: <1390732723-7129-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xK7ozJZ4FGXxdrmhx/ctzVotnt/Yy
	Wdz/epTR4vKuOWwWp7tZLS6u+MLkwOZx59oeNo9DhzsYPeadDPTo27KK0ePzJrkA1igum5TU
	nMyy1CJ9uwSujIeNT1gLPnBW9B4/w9LAOJmji5GTQ0LAROLAynWsELaYxIV769m6GLk4hASW
	Mkr82f6LDSTBKyAo8WPyPZYuRg4OZgF5iSOXskHCzALqEpPmLWKGqP/MKDHx5icWiHo9iZaH
	f5lBbGGBNIlFsyeB2WwCxhKbly9hA5kjIqArMecnE0gvs8A2RonGP/OZQGpYBFQlLux9DraX
	U8BF4vKUXWAzhQScJXYd3wd1qJLE7vZO9gmMArOQnDcL4bxZSM5bwMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkqL/uYFx6zOoQowAHoxIPb8b1p0FCrIllxZW5hxglOJiVRHir2J4F
	CfGmJFZWpRblxxeV5qQWH2Jk4uCUamCMCPga4y57QY/5/LoZsW1yFoaO3nfEcidq1il3flCe
	dGWtJ0/Sl7h2/QfJXleE755dab/yaa5UmXQ7o8itDevfBm3ZK6aeqJfqLyp6i+GTqq/OeaHv
	FpWaxlOuhF7/lnnSN27y+mnvJ7WGsQjO621rOvx6zwerd05b1lxYPXdFr+f2lDyOVxFKLMUZ
	iYZazEXFiQA1UkCnSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-26 at 11:38 +0100, Geert Uytterhoeven wrote:
> If CONFIG_PM_SLEEP=n:
> 
> drivers/mfd/max14577.c:177: warning: ‘max14577_suspend’ defined but not used
> drivers/mfd/max14577.c:200: warning: ‘max14577_resume’ defined but not used
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/mfd/max14577.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index ac514fb2b877..71aa14a6bfbb 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
>  
> +#ifdef CONFIG_PM_SLEEP
>  static int max14577_suspend(struct device *dev)
>  {
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> @@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
>  
>  	return 0;
>  }
> +#endif /* CONFIG_PM_SLEEP */
>  
>  static struct of_device_id max14577_dt_match[] = {
>  	{ .compatible = "maxim,max14577", },

Same here:
http://thread.gmane.org/gmane.linux.kernel/1615513/focus=1615563
although I don't mind if your patch comes in :).

Best regards,
Krzysztof

