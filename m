Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbbA2OoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:44:15 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:34288 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbbA2OoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:44:10 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA4737.9020300@mev.co.uk>
Date: Thu, 29 Jan 2015 14:44:07 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: ni_atmio: Removed variables
 that is never used
References: <1422484622-9282-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484622-9282-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
>   drivers/staging/comedi/drivers/ni_atmio.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
> index 0c5ff28..301f154 100644
> --- a/drivers/staging/comedi/drivers/ni_atmio.c
> +++ b/drivers/staging/comedi/drivers/ni_atmio.c
> @@ -300,7 +300,6 @@ static int ni_atmio_attach(struct comedi_device *dev,
>   			   struct comedi_devconfig *it)
>   {
>   	const struct ni_board_struct *boardtype;
> -	struct ni_private *devpriv;
>   	struct pnp_dev *isapnp_dev;
>   	int ret;
>   	unsigned long iobase;
> @@ -310,7 +309,6 @@ static int ni_atmio_attach(struct comedi_device *dev,
>   	ret = ni_alloc_private(dev);
>   	if (ret)
>   		return ret;
> -	devpriv = dev->private;
>
>   	iobase = it->options[0];
>   	irq = it->options[1];
>

Yes, devpriv is no longer needed here.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
