Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbbA2OkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:40:14 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:46169 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777AbbA2OkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:40:12 -0500
X-Sender-Id: abbotti@mev.co.uk
Message-ID: <54CA463C.9090804@mev.co.uk>
Date: Thu, 29 Jan 2015 14:39:56 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Heena Sirwani <heenasirwani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: drivers: mite: Removed variables that
 is never used
References: <1422484584-9164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1422484584-9164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/15 22:36, Rickard Strandqvist wrote:
> Variable ar assigned a value that is never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/comedi/drivers/mite.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
> index ffc9e61..8d2903b 100644
> --- a/drivers/staging/comedi/drivers/mite.c
> +++ b/drivers/staging/comedi/drivers/mite.c
> @@ -494,9 +494,8 @@ EXPORT_SYMBOL_GPL(mite_bytes_read_from_memory_ub);
>   unsigned mite_dma_tcr(struct mite_channel *mite_chan)
>   {
>   	struct mite_struct *mite = mite_chan->mite;
> -	int lkar;
>
> -	lkar = readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
> +	readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
>   	return readl(mite->mite_io_addr + MITE_TCR(mite_chan->channel));
>   }
>   EXPORT_SYMBOL_GPL(mite_dma_tcr);
>

Reading the MITE_LKAR(channel) register won't have any side-effects, so 
that call to readl() can be removed altogether.  In previous versions of 
the driver, the value of lkar was only used in debugging messages.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk> )=-
-=(                          Web: http://www.mev.co.uk/  )=-
