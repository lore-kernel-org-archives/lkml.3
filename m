Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3CDIHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:07:52 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:9042
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab3CDIHv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:07:51 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z3121kz98dIc89bh936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1155h)
Message-ID: <5134566C.2090405@freescale.com>
Date: Mon, 4 Mar 2013 16:08:12 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Huang Shijie <shijie8@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>		 <1359349039-11510-2-git-send-email-b32955@freescale.com>		 <1360684037.12703.117.camel@sauron.fi.intel.com>		 <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com>	 <1362234094.2745.9.camel@sauron> <513437DF.2030505@freescale.com> <1362383434.2943.5.camel@sauron>
In-Reply-To: <1362383434.2943.5.camel@sauron>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月04日 15:50, Artem Bityutskiy 写道:
> On Mon, 2013-03-04 at 13:57 +0800, Huang Shijie wrote:
>> The current code uses the @id to store the device id(byte 1).
>> But if we use the 8 bytes id data as the keyword, and expand the @id
>> field to 8byte array,
>> the device id is the second byte now. All the added zeros are for the
> I do not think you need to store the full array of ID's. Device ID's for
> all the 4 of above chips are different, which is enough to distinguish
> between them.
>
> The only thing you need to add is the OOB size field to 'struct
> nand_flash_dev'.
>
If i only add the oob size field. There will be two items with the same 
Device ID in nand_flash_ids table,
one has oob_size, one does not have. such as:

    {"NAND 8GIB 3,3V 8-bit", 0xDE, 0, 8192, 0, LP_OPTIONS},
    {"NAND 8GIB 3,3V 8-bit", 0xDE, 0, 8192, 0, LP_OPTIONS, 640},   //OOB 
size is 640.


How can i distinguish them? In which case, i choose the item with the 
oob_size, and in which case, i choose
the item without the oobsize?

thanks
Huang Shijie






