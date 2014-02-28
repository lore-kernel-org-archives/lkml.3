Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaB1DoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:44:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42432 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB1DoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:44:19 -0500
Date: Thu, 27 Feb 2014 21:41:38 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/9] Input: pmic8xxx-keypad - Migrate to DT
Message-ID: <20140228034138.GD7308@joshc.qualcomm.com>
References: <1393552520-9068-1-git-send-email-sboyd@codeaurora.org>
 <1393552520-9068-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393552520-9068-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, with the exception of one thing...

On Thu, Feb 27, 2014 at 05:55:15PM -0800, Stephen Boyd wrote:
> The driver is only supported on DT enabled platforms. Convert the
> driver to DT so that it can probe properly.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/input/keyboard/pmic8xxx-keypad.c | 150 ++++++++++++++++++-------------
> @@ -471,50 +514,27 @@ static void pmic8xxx_kp_close(struct input_dev *dev)
>   */
>  static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  {
[..]
> -	keymap_data = pdata->keymap_data;
> -	if (!keymap_data) {
> -		dev_err(&pdev->dev, "no keymap data supplied\n");
> -		return -EINVAL;
> -	}
> +	repeat = !of_property_read_bool(pdev->dev.of_node,
> +					"linux,input-no-autorepeat");
> +	wakeup = !of_property_read_bool(pdev->dev.of_node,
> +					"linux,keypad-wakeup");

I don't think you mean to invert this.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
