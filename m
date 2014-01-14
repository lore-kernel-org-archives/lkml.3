Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaANLsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:48:23 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:48269 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaANLsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:48:22 -0500
Message-ID: <52D52402.8040904@mev.co.uk>
Date: Tue, 14 Jan 2014 11:48:18 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] Staging: comedi: move trailing statement to next line
 in ni_mio_common.c
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
In-Reply-To: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-14 03:13, Chase Southwood wrote:
> This patch for ni_mio_common.c silences a checkpatch error due to a
> trailing statement.
>
> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
> ---
>   drivers/staging/comedi/drivers/ni_mio_common.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
> index 457b884..dba19e9 100644
> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
> @@ -692,7 +692,8 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>   		/*  Flush the 6143 data FIFO */
>   		ni_writel(0x10, AIFIFO_Control_6143);	/*  Flush fifo */
>   		ni_writel(0x00, AIFIFO_Control_6143);	/*  Flush fifo */
> -		while (ni_readl(AIFIFO_Status_6143) & 0x10) ;	/*  Wait for complete */
> +		while (ni_readl(AIFIFO_Status_6143) & 0x10)
> +			;	/*  Wait for complete */
>   	} else {
>   		devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
>   		if (board->reg_type == ni_reg_625x) {
>

As others mentioned, a timeout would be nice, but as this is just a 
clean-up patch, I think it's fine as-is.

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
