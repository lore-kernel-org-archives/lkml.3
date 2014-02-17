Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaBQNQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 08:16:13 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39657 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbaBQNQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 08:16:07 -0500
Message-ID: <53020B92.6060805@mev.co.uk>
Date: Mon, 17 Feb 2014 13:16:02 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>, gregkh@linuxfoundation.org
CC: hsweeten@visionengravers.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: fix brace-related coding
 style issues in hwdrv_apci035.c
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-02-16 08:40, Chase Southwood wrote:
> This patch for hwdrv_apci035 removes some unneeded braces, and moves some
> improperly placed braces to the correct position, as found by checkpatch.
> It also removes a commented out if-statement that I found whilst cleaning
> braces that is identical to another un-commented if-statement directly
> above it, so it is just added clutter and so we can delete it to clean up
> further.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
> So I decided to venture into addi-data today and found that most of the
> files in there are very messy from a style standpoint.  This is the first
> (of probably a few) patchsets to try and clean those files up a bit.  I
> hope that this will be helpful!

Quite a few have been cleaned up extensively by Hartley, but they needed 
more extensive changes than clean-ups due to them trying to handle 
things differently to the normal comedi way of doing things.

>
>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 49 ++++++++++------------
>   1 file changed, 22 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> index 1128c22..584a1d5 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
> @@ -177,11 +177,11 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>   	devpriv->tsk_Current = current;
>   	devpriv->b_TimerSelectMode = data[0];
>   	i_WatchdogNbr = data[1];
> -	if (data[0] == 0) {
> +	if (data[0] == 0)
>   		ui_Mode = 2;
> -	} else {
> +	else
>   		ui_Mode = 0;
> -	}
> +
>   /* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12); */
>   	ui_Command = 0;
>   /* ui_Command = ui_Command & 0xFFFFF9FEUL; */
> @@ -366,8 +366,7 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	}
>
> -	if (data[0] == 0)	/* Stop The Watchdog */
> -	{
> +	if (data[0] == 0) {
>   		/* Stop The Watchdog */
>   		ui_Command = 0;
>   /*
> @@ -377,15 +376,15 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   		outl(ui_Command,
>   			devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>   	}			/*   if (data[1]==0) */
> -	if (data[0] == 3)	/* stop all Watchdogs */
> -	{
> +	if (data[0] == 3) {
> +		/* stop all Watchdogs */
>   		ui_Command = 0;
>   		for (i_Count = 1; i_Count <= 4; i_Count++) {
> -			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
> +			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>   				ui_Command = 0x2UL;
> -			} else {
> +			else
>   				ui_Command = 0x10UL;
> -			}
> +
>   			i_WatchdogNbr = i_Count;
>   			outl(ui_Command,
>   				devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
> @@ -393,30 +392,29 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>   		}
>
>   	}
> -	if (data[0] == 4)	/* start all Watchdogs */
> -	{
> +	if (data[0] == 4) {
> +		/* start all Watchdogs */
>   		ui_Command = 0;
>   		for (i_Count = 1; i_Count <= 4; i_Count++) {
> -			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
> +			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>   				ui_Command = 0x1UL;
> -			} else {
> +			else
>   				ui_Command = 0x8UL;
> -			}
> +
>   			i_WatchdogNbr = i_Count;
>   			outl(ui_Command,
>   				devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
>   				0);
>   		}
>   	}
> -	if (data[0] == 5)	/* trigger all Watchdogs */
> -	{
> +	if (data[0] == 5) {
> +		/* trigger all Watchdogs */
>   		ui_Command = 0;
>   		for (i_Count = 1; i_Count <= 4; i_Count++) {
> -			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
> +			if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>   				ui_Command = 0x4UL;
> -			} else {
> +			else
>   				ui_Command = 0x20UL;
> -			}
>
>   			i_WatchdogNbr = i_Count;
>   			outl(ui_Command,
> @@ -488,11 +486,9 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
>   	/* Get the overflow status */
>   	/***************************/
>   	data[3] = ((ui_Status >> 0) & 1);
> -	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
> +	if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER)
>   		data[4] = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);
>
> -	}			/*   if  (devpriv->b_TimerSelectMode==ADDIDATA_TIMER) */
> -
>   	return insn->n;
>   }
>
> @@ -655,8 +651,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>   	ui_StatusRegister2 =
>   		inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 20);
>
> -	if ((((ui_StatusRegister1) & 0x8) == 0x8))	/* Test if warning relay interrupt */
> -	{
> +	/* Test if warning relay interrupt */
> +	if ((((ui_StatusRegister1) & 0x8) == 0x8)) {
>   	/**********************************/
>   		/* Disable the temperature warning */
>   	/**********************************/
> @@ -675,9 +671,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>   	}			/* if (((ui_StatusRegister1 & 0x8) == 0x8)) */
>
>   	else {
> -		if ((ui_StatusRegister2 & 0x1) == 0x1) {
> +		if ((ui_StatusRegister2 & 0x1) == 0x1)
>   			send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
> -		}
>   	}			/* else if (((ui_StatusRegister1 & 0x8) == 0x8)) */
>
>   	return;
>

Looks good.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
