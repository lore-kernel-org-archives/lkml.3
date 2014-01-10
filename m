Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbaAJQDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:03:21 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50304 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbaAJQDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:03:18 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-29-52d019c4e877
Message-id: <52D019BD.30401@samsung.com>
Date: Fri, 10 Jan 2014 17:03:09 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH 7/8 v3] crypto:s5p-sss: validate iv before memcpy
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389354321-32096-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354321-32096-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xy7pHJC8EGSz7YGlx9/lhRouXhzQt
	ul/JWNy/95PJ4vKuOWwWM87vY7JYtO0/s8WqXX8YLc7OOcTkwOmxc9Zddo9tB1Q9+rasYvT4
	vEkugCWKyyYlNSezLLVI3y6BK2Py1S/MBfvYK65Oa2ZpYGxh62Lk5JAQMJG4vOcVC4QtJnHh
	3nqgOBeHkMBSRokbDxeyQzifGSX+vzjGCFLFK6AhceTIdbAOFgFViWPnzzCB2GwCahKfGx6B
	TRUViJD4O289VL2gxI/J98DqRQTKJf7dWAO2gVlgDqPEwyXtYAlhAVeJ6QdvM0Nsa2SU6P5/
	hxkkwSngJnF58htWEJtZwFpi5aRtjBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9iFE0tTS4o
	TkrPNdIrTswtLs1L10vOz93ECAn3rzsYlx6zOsQowMGoxMP7Q/BCkBBrYllxZe4hRgkOZiUR
	3msgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYweZo3TGGNyZvt1/cuzntT3e4rCQ13didJbvv/J
	4bqfcOXnRM6zuk+PmKp9cWD8kbJePueMVZlRnamTe+6fSb25s0VP70936U45tY/7THXkrYsX
	/Qu26f06ua5O5uS5dd/Wei6xyzTJ6bd69vHxK8ODxgoGvo6L1BU35V+68DWtVfvheQGXtSpK
	LMUZiYZazEXFiQDPl5HTVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
> This patch adds code to validate "iv" buffer before trying to
> memcpy the contents
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/s5p-sss.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index f274f5f..7058bb6 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -381,8 +381,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>   	struct samsung_aes_variant *var = dev->variant;
>   	void __iomem *keystart;
>
> -	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
> -				(var->aes_offset, 0), iv, 0x10);
> +	if (iv)
> +		memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
> +					(var->aes_offset, 0), iv, 0x10);

In what conditions can the iv end up being NULL?

Best regards,
Tomasz
