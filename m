Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3KGNYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:24:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36683 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab3KGNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:24:36 -0500
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20131107122249.GN20521@mwanda>
Date: Thu, 7 Nov 2013 04:22:49 -0800 (PST)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] net: make ndev->irq signed for error handling
References: <20131107074849.GF21844@elgon.mountain> <527B842E.2060909@ti.com>
In-Reply-To: <527B842E.2060909@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 05:44:38PM +0530, Mugunthan V N wrote:
> On Thursday 07 November 2013 01:18 PM, Dan Carpenter wrote:
> > There is a bug in cpsw_probe() where we do:
> >
> > 	ndev->irq = platform_get_irq(pdev, 0);
> > 	if (ndev->irq < 0) {
> >
> > The problem is that "ndev->irq" is unsigned so the error handling
> > doesn't work.  I have changed it to a regular int.
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ndev->irq is never used any where in the driver, I think its better to
> remove this part of code from probe. If every one is ok, I can send a
> patch to remove the code.

It seems like cpsw_ndo_poll_controller() uses it.

regards,
dan carpenter
