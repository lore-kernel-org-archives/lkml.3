Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaEBQvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:51:21 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58565 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbaEBQvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:51:18 -0400
Message-ID: <5363CCAE.9000006@mev.co.uk>
Date: Fri, 2 May 2014 17:49:50 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: H Hartley Sweeten <hsweeten@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/comedi: fix sparse warning: shift too big
References: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
In-Reply-To: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVEXCHANGE.mev.local (10.0.0.4) To MEVEXCHANGE.mev.local
 (10.0.0.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-05-02 15:57, Brilliantov Kirill Vladimirovich wrote:
> Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
> ---
>   drivers/staging/comedi/drivers/ni_stc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
> index f0630b78..197b568 100644
> --- a/drivers/staging/comedi/drivers/ni_stc.h
> +++ b/drivers/staging/comedi/drivers/ni_stc.h
> @@ -717,7 +717,7 @@ enum AI_AO_Select_Bits {
>   static inline unsigned ni_stc_dma_channel_select_bitfield(unsigned channel)
>   {
>   	if (channel < 4)
> -		return 1 << channel;
> +		return 1 << (channel & 0x3);
>   	if (channel == 4)
>   		return 0x3;
>   	if (channel == 5)
>

The warning seems a bit spurious!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
