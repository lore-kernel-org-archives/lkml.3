Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3HWUIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:08:48 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:56535 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3HWUIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:08:46 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: lee.jones@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] max77693: added device tree support
Date: Fri, 23 Aug 2013 22:08:39 +0200
Message-ID: <3144986.QWu11iEeBj@flatron>
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-Reply-To: <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
References: <1377104014-21910-1-git-send-email-a.hajda@samsung.com> <1377104014-21910-3-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrzej,

On Wednesday 21 of August 2013 18:53:34 Andrzej Hajda wrote:
> This patch adds only of_match_table.
> There are no device specific properties.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max77693.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index 27f5da3..e0b11a9 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -225,11 +225,19 @@ static const struct dev_pm_ops max77693_pm = {
>  	.resume = max77693_resume,
>  };
> 
> +#ifdef CONFIG_OF
> +static struct of_device_id max77693_dt_match[] = {
> +	{.compatible = "maxim,max77693"},
> +	{},
> +};
> +#endif
> +
>  static struct i2c_driver max77693_i2c_driver = {
>  	.driver = {
>  		   .name = "max77693",
>  		   .owner = THIS_MODULE,
>  		   .pm = &max77693_pm,
> +		   .of_match_table = of_match_ptr(max77693_dt_match),

As far as I'm aware of, you don't need explicit OF match table for I2C 
devices, because the I2C OF core can use the array of struct i2c_device_id 
pointed by .id_table field of struct i2c_driver.

I'm not sure if a separate OF table isn't preferred, though, so your patch 
might be fine.

Best regards,
Tomasz

