Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab3EBCNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 22:13:00 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:9153
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282Ab3EBCM5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 22:12:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
Message-ID: <5181CC19.8000904@freescale.com>
Date: Thu, 2 May 2013 10:14:49 +0800
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
References: <1366967337-5534-1-git-send-email-b32955@freescale.com> <1366967337-5534-6-git-send-email-b32955@freescale.com> <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com>
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9BF544@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月30日 18:04, Gupta, Pekon 写道:
>> -	*busw = 0;
>> -	if (le16_to_cpu(p->features)&  1)
>> -		*busw = NAND_BUSWIDTH_16;
>> +
>> +	*busw = (onfi_feature(chip)&  ONFI_FEATURE_16_BIT_BUS) ?
>> +			NAND_BUSWIDTH_16 : 0;
> Is this really needed ? you have already checked the 'onfi_version' above in
> nand_flash_detect_onfi() ..
> 	if (!chip->onfi_version) {
> 		pr_info("%s: unsupported ONFI version: %d\n", __func__, val);
> 		return 0;
> 	}
>
>
I think checking the onfi_version has no relationship with this patch. :)
This patch is just replace the hardcode for 16-bit onfi nand check.


thanks
Huang Shijie


