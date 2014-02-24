Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaBXONy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:13:54 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:50314 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbaBXONx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:13:53 -0500
Message-ID: <530B539B.8050201@mev.co.uk>
Date: Mon, 24 Feb 2014 14:13:47 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Staging: comedi: addi-data: cleanup conditional blocks
 in hwdrv_apci035.c
References: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com> <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-22 03:21, Chase Southwood wrote:
> There were some conditional blocks that had an unneccesary level of
> indentation in them.  We can remove this to improve code clarity.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 31 ++++++++++------------
>   1 file changed, 14 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 7c40535..34e5321 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -207,23 +207,22 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   		ui_Command =
>   			(ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
>
> -	} else {
> -		if (data[0] == ADDIDATA_WATCHDOG) {
> +	} else if (data[0] == ADDIDATA_WATCHDOG) {
>
> -			/* Set the mode :             */
> -			/* - Disable the hardware     */
> -			/* - Disable the counter mode */
> -			/* - Disable the warning      */
> -			/* - Disable the reset        */
> -			/* - Disable the timer mode   */
> +		/* Set the mode :             */
> +		/* - Disable the hardware     */
> +		/* - Disable the counter mode */
> +		/* - Disable the warning      */
> +		/* - Disable the reset        */
> +		/* - Disable the timer mode   */
>
> -			ui_Command = ui_Command & 0xFFF819E2UL;
> +		ui_Command = ui_Command & 0xFFF819E2UL;
>
> -		} else {
> -			dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
> -			return -EINVAL;
> -		}
> +	} else {
> +		dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
> +		return -EINVAL;
>   	}
> +
>   	outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	ui_Command = 0;
>   	ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
> @@ -628,10 +627,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>   		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
>   	}
>
> -	else {
> -		if ((ui_StatusRegister2 & 0x1) == 0x1)
> -			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
> -	}
> +	else if ((ui_StatusRegister2 & 0x1) == 0x1)
> +		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */

The usual style there is to put the "else" or the "else if" on the same 
line as the preceding closing brace.

Also, if any branch in the if, else if, ..., else chain uses braces, 
they all should (see the bit that says "This does not apply if only one 
branch of a conditional statement is a single statement; in the latter 
case use braces in both branches:" in the CodingStyle).

>
>   	return;
>   }
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
