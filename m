Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3LNOQL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 09:16:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21718 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3LNOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 09:16:10 -0500
Date: Sat, 14 Dec 2013 17:15:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Stephen Warren <swarren@nvidia.com>, josh@joshtriplett.org
Subject: Re: [PATCH] drivers: reset: Mark function as static in core.c
Message-ID: <20131214141534.GD5443@mwanda>
References: <20131214132610.GA8691@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214132610.GA8691@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:56:10PM +0530, Rashika Kheria wrote:
> This patch marks the function of_reset_simple_xlate() and
> devm_reset_control_put() as static in core.c because it is not used
> outside this file.
> 
> Thus, it also eliminate the following warnings in core.c:
> drivers/reset/core.c:46:5: warning: no previous prototype for ‘of_reset_simple_xlate’ [-Wmissing-prototypes]
> drivers/reset/core.c:262:6: warning: no previous prototype for ‘devm_reset_control_put’ [-Wmissing-prototypes]
> 

These are EXPORT_SYMBOL_GPL() so that doesn't make sense.
devm_reset_control_put() is not used at all and of_reset_simple_xlate()
doesn't look like it needs to be exported.  Philipp?

regards,
dan carpenter

