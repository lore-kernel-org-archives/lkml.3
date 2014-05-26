Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaEZQwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:52:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34252 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751128AbaEZQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:52:39 -0400
Date: Mon, 26 May 2014 17:51:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Emil Goode <emilgoode@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] driver core/platform: don't leak memory allocated
	for dma_mask
Message-ID: <20140526165105.GD3693@n2100.arm.linux.org.uk>
References: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401122483-31603-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 06:41:21PM +0200, Emil Goode wrote:
> @@ -211,6 +215,7 @@ struct platform_device *platform_device_alloc(const char *name, int id)
>  		strcpy(pa->name, name);
>  		pa->pdev.name = pa->name;
>  		pa->pdev.id = id;
> +		pa->pdev.dev.dma_mask = &pa->dma_mask;

There is code in the kernel which, rightly or wrongly, checks whether
dev->dma_mask is NULL to determine whether the device can do any kind
of DMA.  The above results in devices allocated via this interface
always having this member set, which is a change of core kernel behaviour.

How sure are you that this will not break anything?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
