Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbaCGQIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:08:48 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41971 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752166AbaCGQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:08:46 -0500
Date: Fri, 7 Mar 2014 16:08:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140307160836.GM21483@n2100.arm.linux.org.uk>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
> @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
>  exit_free_irq:
>  	free_irq(drv_data->irq, drv_data);
>  exit_reset:
> -	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> +	if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> +	    !IS_ERR(drv_data->rstc))
>  		reset_control_assert(drv_data->rstc);

Another question is... why do we need to check pd->dev.of_node here?
If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
controller node, so drv_data->rstc is either going to be a valid
pointer, or it's going to be an error pointer - neither
reset_control_get() nor devm_reset_control_get return NULL.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
