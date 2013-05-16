Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3EPCOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 22:14:21 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:19216
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab3EPCOR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 22:14:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z3121kz98dIc89bh936eIzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
Message-ID: <51944184.7090107@freescale.com>
Date: Thu, 16 May 2013 10:16:36 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 01/11] mtd: add datasheet's ECC information to nand_chip{}
References: <1368607232-2210-1-git-send-email-b32955@freescale.com>	 <1368607232-2210-2-git-send-email-b32955@freescale.com> <1368619917.15764.99.camel@sauron.fi.intel.com>
In-Reply-To: <1368619917.15764.99.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月15日 20:11, Artem Bityutskiy 写道:
> On Wed, 2013-05-15 at 16:40 +0800, Huang Shijie wrote:
>> + * @ecc_strength:	[INTERN] ECC correctability from the datasheet.
>> + *			Minimum amount of bit errors per @ecc_step guaranteed to
>> + *			be correctable. If unknown, set to zero.
>> + * @ecc_step:		[INTERN] ECC step required by the @ecc_strength,
>> + *                      also from the datasheet. It is the recommended ECC step
>> + *			size, if known; if unknown, set to zero.
> Here and in other places you talk about "datasheet". Do you assume that
> the real ECC strength/step used by NAND chips may be different? Or you
> assume it must be the same?
>
The two fields are used to store the ecc info from the datasheet.
The two fields are just for a reference.

[1] The nand controller may do not use these two fields, it's ok;
     For example, the datasheet requires "4bits per 512 bytes".
     The nand controller can uses 8bits per 512 bytes.


[2] but sometimes the nand controller must use these two fields.
     For example, the datasheet requires "40bits per 1024 bytes".
     For the hardware limit, the nand controller(BCH) may supports the 
40bits ecc in the maximum.
     So the nand controller must use these two fields now.


thanks
Huang Shijie



