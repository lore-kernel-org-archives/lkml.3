Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaB1Dsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:48:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaB1Ds2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:48:28 -0500
Date: Thu, 27 Feb 2014 21:45:47 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 5/9] Input: pmic8xxx-pwrkey - Migrate to DT
Message-ID: <20140228034547.GE7308@joshc.qualcomm.com>
References: <1393552520-9068-1-git-send-email-sboyd@codeaurora.org>
 <1393552520-9068-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393552520-9068-6-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:55:16PM -0800, Stephen Boyd wrote:
> The driver is only supported on DT enabled platforms. Convert the
> driver to DT so that it can probe properly.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
> --- a/drivers/input/misc/pmic8xxx-pwrkey.c
> +++ b/drivers/input/misc/pmic8xxx-pwrkey.c
> @@ -172,7 +178,7 @@ static int pmic8xxx_pwrkey_probe(struct platform_device *pdev)
>  	}
>  
>  	platform_set_drvdata(pdev, pwrkey);
> -	device_init_wakeup(&pdev->dev, pdata->wakeup);
> +	device_init_wakeup(&pdev->dev, 1);

Is there a particular reason you aren't providing a 'linux,wakeup'
property for pwrkey?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
