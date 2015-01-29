Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbbA2PkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:40:00 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:35412 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752040AbbA2Pj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:39:58 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA5445.3090808@mev.co.uk>
Date: Thu, 29 Jan 2015 15:39:49 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bernd Porr <mail@berndporr.me.uk>,
        Chase Southwood <chase.southwood@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: usbduxsigma: Removed variables
 that is never used
References: <1422484741-9666-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484741-9666-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:39, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/usbduxsigma.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
> index dc19435..7b80887 100644
> --- a/drivers/staging/comedi/drivers/usbduxsigma.c
> +++ b/drivers/staging/comedi/drivers/usbduxsigma.c
> @@ -215,7 +215,6 @@ static void usbduxsigma_ai_handle_urb(struct comedi_device *dev,
>   	struct usbduxsigma_private *devpriv = dev->private;
>   	struct comedi_async *async = s->async;
>   	struct comedi_cmd *cmd = &async->cmd;
> -	unsigned int dio_state;
>   	uint32_t val;
>   	int ret;
>   	int i;
> @@ -225,7 +224,7 @@ static void usbduxsigma_ai_handle_urb(struct comedi_device *dev,
>   		devpriv->ai_counter = devpriv->ai_timer;
>
>   		/* get the state of the dio pins to allow external trigger */
> -		dio_state = be32_to_cpu(devpriv->in_buf[0]);
> +		be32_to_cpu(devpriv->in_buf[0]);

That line produces a compiler warning.  The line can be removed as the 
call to be32_to_cpu() has no side-effects.  The "/* get the state ..." 
comment line can also be removed as it is only associated with this line.

Perhaps Bernd intended to use dio_state for something here, but I'm not 
sure what.

>
>   		/* get the data from the USB bus and hand it over to comedi */
>   		for (i = 0; i < cmd->chanlist_len; i++) {
>


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
