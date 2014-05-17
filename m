Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaEQW5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:57:21 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:34360 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaEQW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:57:19 -0400
Date: Sun, 18 May 2014 00:57:27 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140517225727.GC20413@lianli>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
 <20140517191821.GD16662@pengutronix.de>
 <20140517220836.GI15585@mwanda>
 <20140517223555.GR3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517223555.GR3693@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, May 17, 2014 at 11:35:55PM +0100, Russell King - ARM Linux wrote:
> On Sun, May 18, 2014 at 01:08:36AM +0300, Dan Carpenter wrote:
> > Let's look at that error handling again.
> > 
> > err:  <-- the name is not descriptive.  the location is bad.
> > 		kfree(pdev->dev.dma_mask);  <- null dereference.
> > 		platform_device_put(pdev);  <- ok
> > 		return ERR_PTR(-ENODEV);    <- should be "return ERR_PTR(ret);"
> > 
> > 3 out of 4 of the lines are bad.
> 
> 2 out of 4.  kfree(NULL) is perfectly legal.

I believe pdev could potentially be NULL, so it's the dereference
that is the problem.

Best regards,

Emil Goode
