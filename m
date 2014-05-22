Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaEVNvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:51:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39514 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbaEVNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:51:19 -0400
Date: Thu, 22 May 2014 16:50:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ARM: imx: add missing kfree call in error paths
Message-ID: <20140522135016.GK15585@mwanda>
References: <1400764482-20147-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400764482-20147-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 03:14:42PM +0200, Emil Goode wrote:
> We forgot to free pdev->dev.dma_mask as it is not freed
> by platform_device_put().
> 

Every function which calls imx31_alloc_mx3_camera() is buggy.  That
means that, at best, it is a 2 on Rusty's API rating.
http://sweng.the-davies.net/Home/rustys-api-design-manifesto

The correct fix is to introduce an imx31_free_mx3_camera() otherwise we
will just keep introducing these bugs.

regards,
dan carpenter

