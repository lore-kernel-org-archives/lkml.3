Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbbA2OqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:46:10 -0500
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:33245 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbbA2OqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:46:07 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA47AB.5070505@mev.co.uk>
Date: Thu, 29 Jan 2015 14:46:03 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: ni_mio_cs: Removed variables
 that is never used
References: <1422484660-9399-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484660-9399-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:37, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/ni_mio_cs.c |    3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
> index 9b201e4..b152330 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_cs.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
> @@ -163,7 +163,6 @@ static int mio_cs_auto_attach(struct comedi_device *dev,
>   {
>   	struct pcmcia_device *link = comedi_to_pcmcia_dev(dev);
>   	static const struct ni_board_struct *board;
> -	struct ni_private *devpriv;
>   	int ret;
>
>   	board = ni_getboardtype(dev, link);
> @@ -188,8 +187,6 @@ static int mio_cs_auto_attach(struct comedi_device *dev,
>   	if (ret)
>   		return ret;
>
> -	devpriv = dev->private;
> -
>   	return ni_E_init(dev, 0, 1);
>   }
>
>

Yes, devpriv is not needed here.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
