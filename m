Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaB1Hxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 02:53:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaB1Hxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 02:53:35 -0500
Date: Fri, 28 Feb 2014 10:52:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chase Southwood <chase.southwood@yahoo.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Chase Southwood <chase.southwoo@yahoo.com>,
        linux-kernel@vger.kernel.org, abbotti@mev.co.uk
Subject: Re: [PATCH 1/2] Staging: comedi: addi-data: fix lines that are over
 80 characters
Message-ID: <20140228075232.GH26776@mwanda>
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 01:31:20AM -0600, Chase Southwood wrote:
> hwdrv_apci1564.c had numerous lines over the column limit.  This patch
> splits all such lines to bring them in compliance with coding style.
> 
> Signed-off-by: Chase Southwood <chase.southwoo@yahoo.com>
> ---
>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 50 ++++++++++++++++------
>  1 file changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> index 2b47fa1..77030c5 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
> @@ -324,11 +324,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
>  			inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
>  			APCI1564_TCW_PROG);
>  		ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
> -		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);	/* Stop The Timer */
> +		/* Stop The Timer */
> +		outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER +
> +			APCI1564_TCW_PROG);

Just make a helper function so that you can call it like this:

static void outl_1564_timer(struct addi_private *devpriv, unsigned int cmd,
			    unsigned int reg)
{
	outl(cmd, devpriv->i_IobaseAmcc + APCI1564_TIMER, reg);
}

Then the caller becomes:

		outl_1564_timer(devpriv, cmd, APCI1564_TCW_PROG);

regards,
dan carpenter

