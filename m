Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaEVOow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 10:44:52 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36964 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaEVOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 10:44:50 -0400
Date: Thu, 22 May 2014 16:44:46 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: add missing kfree call in error paths
Message-ID: <20140522144446.GA7348@lianli>
References: <1400764482-20147-1-git-send-email-emilgoode@gmail.com>
 <20140522135016.GK15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522135016.GK15585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

On Thu, May 22, 2014 at 04:50:16PM +0300, Dan Carpenter wrote:
> On Thu, May 22, 2014 at 03:14:42PM +0200, Emil Goode wrote:
> > We forgot to free pdev->dev.dma_mask as it is not freed
> > by platform_device_put().
> > 
> 
> Every function which calls imx31_alloc_mx3_camera() is buggy.  That
> means that, at best, it is a 2 on Rusty's API rating.
> http://sweng.the-davies.net/Home/rustys-api-design-manifesto
> 
> The correct fix is to introduce an imx31_free_mx3_camera() otherwise we
> will just keep introducing these bugs.

I guess I could add this to arch/arm/mach-imx/devices/platform-ipu-core.c
it would be a very small function though.

Best regards,

Emil Goode
