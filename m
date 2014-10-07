Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaJGR0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:26:13 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56869 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaJGR0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:26:11 -0400
Date: Tue, 7 Oct 2014 10:26:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/4] Input: pmic8xxx-keypad - use regmap_field for
 register access
Message-ID: <20141007172606.GG16469@dtor-ws>
References: <1412675448-11990-1-git-send-email-iivanov@mm-sol.com>
 <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412675448-11990-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On Tue, Oct 07, 2014 at 12:50:46PM +0300, Ivan T. Ivanov wrote:
> @@ -527,10 +538,55 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, kp);
>  
> +	if (rows < info->min_rows)
> +		rows = info->min_rows;
> +
> +	if (cols < info->min_cols)
> +		cols = info->min_cols;
> +
>  	kp->num_rows	= rows;
>  	kp->num_cols	= cols;
>  	kp->dev		= &pdev->dev;
>  
> +	kp->events = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +					     info->events);
> +	if (IS_ERR(kp->events))
> +		return PTR_ERR(kp->events);
> +
> +	kp->scan_rows = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +						info->scan_rows);
> +	if (IS_ERR(kp->scan_rows))
> +		return PTR_ERR(kp->scan_rows);
> +
> +	kp->scan_cols = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +						info->scan_cols);
> +	if (IS_ERR(kp->scan_cols))
> +		return PTR_ERR(kp->scan_cols);
> +
> +	kp->enable = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +					     info->enable);
> +	if (IS_ERR(kp->enable))
> +		return PTR_ERR(kp->enable);
> +
> +	kp->read_state = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +						 info->read_state);
> +	if (IS_ERR(kp->read_state))
> +		return PTR_ERR(kp->read_state);
> +
> +	kp->dbonce = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +					     info->dbonce);
> +	if (IS_ERR(kp->dbonce))
> +		return PTR_ERR(kp->dbonce);
> +
> +	kp->pause = devm_regmap_field_alloc(kp->dev, kp->regmap, info->pause);
> +	if (IS_ERR(kp->pause))
> +		return PTR_ERR(kp->pause);
> +
> +	kp->row_hold = devm_regmap_field_alloc(kp->dev, kp->regmap,
> +					       info->row_hold);
> +	if (IS_ERR(kp->row_hold))
> +		return PTR_ERR(kp->row_hold);

Why do we have to allocate all regmap fields separately instead of
embedding them into keypad structure?

Thanks.

-- 
Dmitry
