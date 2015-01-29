Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbbA2PRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:17:47 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:46724 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168AbbA2PRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:17:44 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA4F0F.6070809@mev.co.uk>
Date: Thu, 29 Jan 2015 15:17:35 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: addi_apci_3501: Removed variables
 that is never used
References: <1422484392-8566-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484392-8566-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:33, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/addi_apci_3501.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi_apci_3501.c b/drivers/staging/comedi/drivers/addi_apci_3501.c
> index a726efc..0cdcecc 100644
> --- a/drivers/staging/comedi/drivers/addi_apci_3501.c
> +++ b/drivers/staging/comedi/drivers/addi_apci_3501.c
> @@ -267,7 +267,6 @@ static irqreturn_t apci3501_interrupt(int irq, void *d)
>   	struct apci3501_private *devpriv = dev->private;
>   	unsigned int ui_Timer_AOWatchdog;
>   	unsigned long ul_Command1;
> -	int i_temp;
>
>   	/*  Disable Interrupt */
>   	ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
> @@ -285,7 +284,7 @@ static irqreturn_t apci3501_interrupt(int irq, void *d)
>   	ul_Command1 = inl(dev->iobase + APCI3501_TIMER_CTRL_REG);
>   	ul_Command1 = ((ul_Command1 & 0xFFFFF9FDul) | 1 << 1);
>   	outl(ul_Command1, dev->iobase + APCI3501_TIMER_CTRL_REG);
> -	i_temp = inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
> +	inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;

Same as for hwdrv_apci3501.c, the ' & 0x1' part should be removed to 
avoid compiler warnings.

Keep the inl() call as it might have side-effects for the watchdog 
functionality of the board.

>
>   	return IRQ_HANDLED;
>   }
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
