Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbbA2PaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:30:21 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:38405 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbbA2PaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:30:19 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA5203.5000508@mev.co.uk>
Date: Thu, 29 Jan 2015 15:30:11 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: rtd520: Removed variables that
 is never used
References: <1422484698-9539-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484698-9539-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:38, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/rtd520.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
> index 581aa58..305631c 100644
> --- a/drivers/staging/comedi/drivers/rtd520.c
> +++ b/drivers/staging/comedi/drivers/rtd520.c
> @@ -1031,8 +1031,6 @@ static int rtd_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>   static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
>   {
>   	struct rtd_private *devpriv = dev->private;
> -	u32 overrun;
> -	u16 status;
>
>   	/* pacer stop source: SOFTWARE */
>   	writel(0, dev->mmio + LAS0_PACER_STOP);
> @@ -1040,8 +1038,8 @@ static int rtd_ai_cancel(struct comedi_device *dev, struct comedi_subdevice *s)
>   	writel(0, dev->mmio + LAS0_ADC_CONVERSION);
>   	writew(0, dev->mmio + LAS0_IT);
>   	devpriv->ai_count = 0;	/* stop and don't transfer any more */
> -	status = readw(dev->mmio + LAS0_IT);
> -	overrun = readl(dev->mmio + LAS0_OVERRUN) & 0xffff;
> +	readw(dev->mmio + LAS0_IT);
> +	readl(dev->mmio + LAS0_OVERRUN) & 0xffff;

The ' & 0xffff' part produces compiler warnings.

Those two lines can be removed.  The values read were previously only 
used in a kernel log message.

>   	writel(0, dev->mmio + LAS0_ADC_FIFO_CLEAR);
>   	return 0;
>   }
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
