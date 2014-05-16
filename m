Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaEPWWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:22:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50039 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774AbaEPWWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:22:09 -0400
Date: Sat, 17 May 2014 01:21:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Emil Goode <emilgoode@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: fix error handling
Message-ID: <20140516222108.GI8897@mwanda>
References: <1400234045-6022-1-git-send-email-emilgoode@gmail.com>
 <20140516192451.GP16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140516192451.GP16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 09:24:51PM +0200, Uwe Kleine-König wrote:
> I didn't check if it is easily possible, but converting this file to use
> platform_device_register_full might simplify it considerably.

In a separate patch, though, please.

> 
> I'm not sure this fix is critical, because the problem happens if an
> allocation during boot fails. But still, if you want to get this fix
> into a stable release, you should simplify it, i.e. don't do the code
> reorganisations. (Also the "more clear" part seems to be subjective, I
> like the error handling better as it is now. But that might only be me.)

Emil's error handling is done exactly in the correct way...  The error
path and success path are separate.  Unwinding in the reverse order.
The label names describe the label locations.  Most days I spend hours
looking at linux kernel error handling and I can assure you that
sensible labels like this are a rare and wonderful gift.

It's hard for me to imagine how anyone could defend the original error
handling.  The label was "err".  The error handling was randomly plopped
in the middle of the success handling.  Whenever I see new "creative"
error handling like this it drives me nuts because obviously it's going
to be buggy like a swamp picnic.

regards,
dan carpenter

