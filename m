Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbbA2PPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:15:14 -0500
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:48243 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065AbbA2PPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:15:00 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA4E69.7070506@mev.co.uk>
Date: Thu, 29 Jan 2015 15:14:49 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@gmail.com>,
        Marcin Kostrzewa <marckostrzewa@gmail.com>,
        Fred Akers <knivey@botops.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: addi-data: hwdrv_apci3501:
 Removed variables that is never used
References: <1422481914-31418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422481914-31418-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 21:51, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> index 339519a..24126e3 100644
> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
> @@ -93,7 +93,6 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
>   {
>   	struct apci3501_private *devpriv = dev->private;
>   	unsigned int ul_Command1 = 0;
> -	int i_Temp;
>
>   	if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
>
> @@ -135,7 +134,7 @@ static int apci3501_write_insn_timer(struct comedi_device *dev,
>   		}
>   	}
>
> -	i_Temp = inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;
> +	inl(dev->iobase + APCI3501_TIMER_STATUS_REG) & 0x1;

The ' & 0x1' part produces compiler warnings and should be removed.

I don't know if the inl() call has any side-effects or not, but since 
it's part of the watchdog functionality of this board, it's safest to 
leave it in.

>   	return insn->n;
>   }
>
>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
