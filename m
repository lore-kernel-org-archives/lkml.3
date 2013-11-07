Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3KGQdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:33:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33447 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab3KGQd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:33:29 -0500
Message-ID: <527BC0CF.70003@ti.com>
Date: Thu, 7 Nov 2013 22:03:19 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] net: make ndev->irq signed for error handling
References: <20131107074849.GF21844@elgon.mountain> <527B842E.2060909@ti.com> <20131107122249.GN20521@mwanda>
In-Reply-To: <20131107122249.GN20521@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 November 2013 05:52 PM, Dan Carpenter wrote:
> On Thu, Nov 07, 2013 at 05:44:38PM +0530, Mugunthan V N wrote:
>> On Thursday 07 November 2013 01:18 PM, Dan Carpenter wrote:
>>> There is a bug in cpsw_probe() where we do:
>>>
>>> 	ndev->irq = platform_get_irq(pdev, 0);
>>> 	if (ndev->irq < 0) {
>>>
>>> The problem is that "ndev->irq" is unsigned so the error handling
>>> doesn't work.  I have changed it to a regular int.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ndev->irq is never used any where in the driver, I think its better to
>> remove this part of code from probe. If every one is ok, I can send a
>> patch to remove the code.
> It seems like cpsw_ndo_poll_controller() uses it.
>
>

That can be changed to pass one of the interrupt numbers from priv as
the irq number is not used in interrupt service routine.

Regards
Mugunthan V N
