Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaIIXkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:40:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38494 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaIIXkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:40:14 -0400
Date: Tue, 9 Sep 2014 16:40:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: nick.dyer@itdev.co.uk
Cc: Stephen Warren <swarren@wwwdotorg.org>, Yufeng Shen <miletus@google.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 1/2] Input: atmel_mxt_ts - downgrade warning about empty
 interrupts
Message-ID: <20140909234010.GA5971@core.coreip.homeip.net>
References: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
 <1410274249-3469-2-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410274249-3469-2-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 03:50:48PM +0100, nick.dyer@itdev.co.uk wrote:
> From: Nick Dyer <nick.dyer@itdev.co.uk>
> 
> In the case where the CHG/interrupt line mode is not configured correctly,
> this warning is output to dmesg output for each interrupt. Downgrade the
> message to debug.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>

Applied, thank you.

> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index db178ed..d954b81 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -837,7 +837,12 @@ static irqreturn_t mxt_process_messages_t44(struct mxt_data *data)
>  	count = data->msg_buf[0];
>  
>  	if (count == 0) {
> -		dev_warn(dev, "Interrupt triggered but zero messages\n");
> +		/*
> +		 * This condition is caused by the CHG line being configured
> +		 * in Mode 0. It results in unnecessary I2C operations but it
> +		 * is benign.
> +		 */
> +		dev_dbg(dev, "Interrupt triggered but zero messages\n");
>  		return IRQ_NONE;
>  	} else if (count > data->max_reportid) {
>  		dev_err(dev, "T44 count %d exceeded max report id\n", count);
> -- 
> 1.9.1
> 

-- 
Dmitry
