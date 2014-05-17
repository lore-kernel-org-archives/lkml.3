Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaEQWhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:37:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:51757 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750973AbaEQWhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:37:17 -0400
Date: Sat, 17 May 2014 23:35:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Emil Goode <emilgoode@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
	registration
Message-ID: <20140517223555.GR3693@n2100.arm.linux.org.uk>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com> <20140517191821.GD16662@pengutronix.de> <20140517220836.GI15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517220836.GI15585@mwanda>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 01:08:36AM +0300, Dan Carpenter wrote:
> Let's look at that error handling again.
> 
> err:  <-- the name is not descriptive.  the location is bad.
> 		kfree(pdev->dev.dma_mask);  <- null dereference.
> 		platform_device_put(pdev);  <- ok
> 		return ERR_PTR(-ENODEV);    <- should be "return ERR_PTR(ret);"
> 
> 3 out of 4 of the lines are bad.

2 out of 4.  kfree(NULL) is perfectly legal.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
