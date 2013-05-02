Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3EBF7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:59:20 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3414
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226Ab3EBF7R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:59:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
Message-ID: <51820127.5060003@freescale.com>
Date: Thu, 2 May 2013 14:01:11 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: "Gupta, Pekon" <pekon@ti.com>
CC: "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH V4 5/9] mtd: replace the hardcode with the onfi_feature()
References: <1366967337-5534-1-git-send-email-b32955@freescale.com> <1366967337-5534-6-git-send-email-b32955@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com> <5181CC19.8000904@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9C09FC@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9C09FC@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月02日 13:42, Gupta, Pekon 写道:
>>>> -	*busw = 0;
>>>> -	if (le16_to_cpu(p->features)&   1)
>>>> -		*busw = NAND_BUSWIDTH_16;
>>>> +
>>>> +	*busw = (onfi_feature(chip)&   ONFI_FEATURE_16_BIT_BUS) ?
>>>> +			NAND_BUSWIDTH_16 : 0;
>>> Is this really needed ? you have already checked the 'onfi_version'
>> above in
>>> nand_flash_detect_onfi() ..
>>> 	if (!chip->onfi_version) {
>>> 		pr_info("%s: unsupported ONFI version: %d\n",
>> __func__, val);
>>> 		return 0;
>>> 	}
>>>
>>>
>> I think checking the onfi_version has no relationship with this patch. :)
>> This patch is just replace the hardcode for 16-bit onfi nand check.
>>
> [Pekon]: [Patch 3/9]: add a helper to get the supported features
> I mean, do you really need this helper function ?
> +static inline int onfi_feature(struct nand_chip *chip)
> +{
> +       return chip->onfi_version ? le16_to_cpu(chip->onfi_params.features) : 0;
> + }
>
> Following change should have been enough..
> *busw = (le16_to_cpu(p->features)&   ONFI_FEATURE_16_BIT_BUS) ?
> 			NAND_BUSWIDTH_16 : 0;
yes. for this function, it's enough.

But we may use the onfi_feature() in other places, such as some drivers. That's reason why i added this helper.



thanks
Huang Shijie










