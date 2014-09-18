Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaIROur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:50:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50976 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756665AbaIROu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:50:28 -0400
Date: Thu, 18 Sep 2014 10:50:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <kgene.kim@samsung.com>, <jg1.han@samsung.com>
Subject: Re: [PATCH v4 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy
 support
In-Reply-To: <1411014258-17877-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1409181048290.894-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2014, Vivek Gautam wrote:

> Now that we have completely moved from older USB-PHY drivers
> to newer GENERIC-PHY drivers for PHYs available with USB controllers
> on Exynos series of SoCs, we can remove the support for the same
> in our host drivers too.
> 
> We also defer the probe for our host in case we end up getting
> EPROBE_DEFER error when getting PHYs.

Better now.  But I didn't notice this the first time:

> +		if (IS_ERR(phy)) {
> +			ret = PTR_ERR(phy);
> +			if (ret == -EPROBE_DEFER) {
> +				return ret;
> +			} else if (ret != -ENOSYS && ret != -ENODEV) {
> +				dev_err(dev,
> +					"Error retrieving usb2 phy: %d\n", ret);
> +				return PTR_ERR(phy);

It doesn't make any real difference, but wouldn't you prefer to say
"return ret" here?

With or without that change, for both these two patches:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

