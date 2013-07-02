Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3GBDE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 23:04:59 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:9314 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3GBDE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 23:04:58 -0400
Message-ID: <51D24318.40908@atmel.com>
Date: Tue, 2 Jul 2013 11:03:52 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [RFC PATCH 02/13] misc: atmel_ssc: keep the count of pdev->id
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com> <1372667978-4718-3-git-send-email-richard.genoud@gmail.com>
In-Reply-To: <1372667978-4718-3-git-send-email-richard.genoud@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 7/1/2013 16:39, Richard Genoud wrote:
> With device tree, pdev->id is always -1, so we introduce a local
> counter.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>   drivers/misc/atmel-ssc.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
> index 3afbd82..d1ec5ab 100644
> --- a/drivers/misc/atmel-ssc.c
> +++ b/drivers/misc/atmel-ssc.c
> @@ -173,6 +173,12 @@ out:
>   	return err;
>   }
>
> +/* counter of ssc devive instances.
> + * With device tree pdev->id is always -1, so we have to keep the
> + * count ourselves
> + */
> +static int ssc_device_id;

Do we really need this? If Yes, would it better to get from device 
through of_alias_get_id?

> +
>   static int ssc_probe(struct platform_device *pdev)
>   {
>   	struct resource *regs;
> @@ -235,6 +241,7 @@ static int ssc_probe(struct platform_device *pdev)
>   	}
>
>   	spin_lock(&user_lock);
> +	pdev->id = ssc_device_id++;
>   	list_add_tail(&ssc->list, &ssc_list);
>   	spin_unlock(&user_lock);
>
>

Best Regards,
Bo Shen

