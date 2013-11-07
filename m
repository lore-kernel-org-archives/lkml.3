Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3KGMOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:14:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:50120 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3KGMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:14:44 -0500
Message-ID: <527B842E.2060909@ti.com>
Date: Thu, 7 Nov 2013 17:44:38 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] net: make ndev->irq signed for error handling
References: <20131107074849.GF21844@elgon.mountain>
In-Reply-To: <20131107074849.GF21844@elgon.mountain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 November 2013 01:18 PM, Dan Carpenter wrote:
> There is a bug in cpsw_probe() where we do:
>
> 	ndev->irq = platform_get_irq(pdev, 0);
> 	if (ndev->irq < 0) {
>
> The problem is that "ndev->irq" is unsigned so the error handling
> doesn't work.  I have changed it to a regular int.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
ndev->irq is never used any where in the driver, I think its better to
remove this part of code from probe. If every one is ok, I can send a
patch to remove the code.

Regards
Mugunthan V N
