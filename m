Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaH3KnB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:43:01 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33717 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaH3KnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:43:00 -0400
Message-ID: <5401AA33.4010206@mev.co.uk>
Date: Sat, 30 Aug 2014 11:40:51 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chase Southwood <chase.southwood@gmail.com>, <gregkh@linuxfoundation.org>
CC: <hsweeten@visionengravers.com>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: comedi: usbdux: fix sparse endianness warnings
References: <1409362832-1312-1-git-send-email-chase.southwood@gmail.com>
In-Reply-To: <1409362832-1312-1-git-send-email-chase.southwood@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/08/14 02:40, Chase Southwood wrote:
> Sparse has many warnings like:
>
> drivers/staging/comedi/drivers/usbdux.c:366:32: warning: cast to
> restricted __le16
>
> on lines on which devpriv->in_buf or devpriv->insn_buf are passed to
> le16_to_cpu().  This suggests that both of these variables should actually
> be of type __le16.
>
> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> Cc: Ian Abbott <abbotti@mev.co.uk>
> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> ---
> This is, as usual, compile tested only.  I tried to verify as best as I
> could that this is a sane change, but I am unable to test on the hardware.
>
>   drivers/staging/comedi/drivers/usbdux.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
> index 053bc50..e1a19222 100644
> --- a/drivers/staging/comedi/drivers/usbdux.c
> +++ b/drivers/staging/comedi/drivers/usbdux.c
> @@ -198,9 +198,9 @@ struct usbdux_private {
>   	/* size of the PWM buffer which holds the bit pattern */
>   	int pwm_buf_sz;
>   	/* input buffer for the ISO-transfer */
> -	uint16_t *in_buf;
> +	__le16 *in_buf;
>   	/* input buffer for single insn */
> -	uint16_t *insn_buf;
> +	__le16 *insn_buf;
>
>   	unsigned int ao_readback[USBDUX_NUM_AO_CHAN];
>
>

That seems fine.  Perhaps the variable 'p' in usbdux_ao_insn_write() 
should also be of type '__le16 *'?

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
