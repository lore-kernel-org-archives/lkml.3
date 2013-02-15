Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935619Ab3BOJzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 04:55:09 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:46433 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260Ab3BOJzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 04:55:08 -0500
Message-ID: <511E05F3.2020505@mev.co.uk>
Date: Fri, 15 Feb 2013 09:54:59 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130115 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: Fix if(); by adding proper code
References: <1360877784-12144-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1360877784-12144-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-14 21:36, Peter Huewe wrote:
> Smatch warns about:
> staging/comedi/drivers/cb_pcidas64.c:3304 prep_ao_dma() warn: if();
>
> So the check currently does nothing and could be removed, but the better
> alternative is to activate the check again and return -1; if it
> evaluates to true.
>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>   drivers/staging/comedi/drivers/cb_pcidas64.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
> index d33fc32..782498f 100644
> --- a/drivers/staging/comedi/drivers/cb_pcidas64.c
> +++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
> @@ -3301,7 +3301,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
>   	num_bytes = load_ao_dma_buffer(dev, cmd);
>   	if (num_bytes == 0)
>   		return -1;
> -	if (num_bytes >= DMA_BUFFER_SIZE) ;
> +	if (num_bytes >= DMA_BUFFER_SIZE)
> +		return -1;
>   	load_ao_dma(dev, cmd);
>
>   	dma_start_sync(dev, 0);

I think the test is wrong as load_ao_dma_buffer can legitimately return 
DMA_BUFFER_SIZE.  Probably best just to get rid of the test altogether.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
