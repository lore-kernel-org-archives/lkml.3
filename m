Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaEQWye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:54:34 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:44256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaEQWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:54:32 -0400
Date: Sun, 18 May 2014 01:53:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Emil Goode <emilgoode@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140517225339.GJ16255@mwanda>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
 <20140517191821.GD16662@pengutronix.de>
 <20140517220836.GI15585@mwanda>
 <20140517223555.GR3693@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517223555.GR3693@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

pdev was NULL though...

The bug is *caused* by trying to use the same "err" label to do all
error handling.  This is a very common anti-patern, but if you follow
canonical kernel style then your error handling is less buggy.

regards,
dan carpenter

