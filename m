Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3AZRmO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:42:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43787 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3AZRmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:42:11 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] regulator: lp8755: Use LP8755_BUCK_MAX instead of magic number
From: daniel jeong <gshark.jeong@gmail.com>
In-Reply-To: <1359177587.9041.1.camel@phoenix>
Date: Sun, 27 Jan 2013 02:42:06 +0900
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <51A2EA10-91C6-45DA-B138-AF2CDC07FD90@gmail.com>
References: <1359177587.9041.1.camel@phoenix>
To: Axel Lin <axel.lin@ingics.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 26, 2013, at 2:19 PM, Axel Lin <axel.lin@ingics.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> drivers/regulator/lp8755.c |    6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
> index 8b1ce0f..f0f6ea0 100644
> --- a/drivers/regulator/lp8755.c
> +++ b/drivers/regulator/lp8755.c
> @@ -373,7 +373,7 @@ static irqreturn_t lp8755_irq_handler(int irq, void *data)
> 		goto err_i2c;
> 
> 	/* sent power fault detection event to specific regulator */
> -	for (icnt = 0; icnt < 6; icnt++)
> +	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
> 		if ((flag0 & (0x4 << icnt))
> 		    && (pchip->irqmask & (0x04 << icnt))
> 		    && (pchip->rdev[icnt] != NULL))
> @@ -508,7 +508,7 @@ err_irq:
> 
> err_regulator:
> 	/* output disable */
> -	for (icnt = 0; icnt < 0x06; icnt++)
> +	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
> 		lp8755_write(pchip, icnt, 0x00);
> 
> 	return ret;
> @@ -522,7 +522,7 @@ static int lp8755_remove(struct i2c_client *client)
> 	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
> 		regulator_unregister(pchip->rdev[icnt]);
> 
> -	for (icnt = 0; icnt < 0x06; icnt++)
> +	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
> 		lp8755_write(pchip, icnt, 0x00);
> 
> 	if (pchip->irq != 0)
> -- 
> 1.7.9.5
> 
> 
> 
Yes you're right!
Thank you Axel. 
Daniel.