Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3CDF5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 00:57:37 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:51497
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab3CDF5g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 00:57:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z3121kz98dI9371Ic89bh936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1155h)
Message-ID: <513437DF.2030505@freescale.com>
Date: Mon, 4 Mar 2013 13:57:51 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Huang Shijie <shijie8@gmail.com>, <dwmw2@infradead.org>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>	 <1359349039-11510-2-git-send-email-b32955@freescale.com>	 <1360684037.12703.117.camel@sauron.fi.intel.com>	 <CAMiH66ExMK8rPMw3kvs9M2b-0ZSkfxBYteTi8QTZf+XCzJw5Dw@mail.gmail.com> <1362234094.2745.9.camel@sauron>
In-Reply-To: <1362234094.2745.9.camel@sauron>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 22:21, Artem Bityutskiy 写道:
> On Sat, 2013-02-16 at 11:56 +0800, Huang Shijie wrote:
>> On Tue, Feb 12, 2013 at 11:47 PM, Artem Bityutskiy<dedekind1@gmail.com>  wrote:
>>> On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
>>>> +       {"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },
>>>> +       {"SmartMedia 256MiB 3,3V ROM",  {0, 0x5b}, 512, 256, 0x4000,
>>>> NAND_ROM},
>>> Sorry for a possibly stupid question, but what does it buy you adding
>>> another "0" to all the entries? I see you add another table, which you
>>> look up if the "traditional" table does not work. Why you need to add
>>> these zeroes?
>> The zeros are for the maf_id.
>>
>> The dev_id is the second byte of the 8-byte id data.
> It does not really make me understand why we add these zeroes, they
> still look useless to me... Would you please be a little more verbose
> about your solution?
>
the 8bytes id data read out by the READ ID command is in the following 
order:
    byte 0(Maker id): such as 0x98 stands for Toshiba, 0xec stands for 
Samsung.
    byte 1(device id):
    byte 2(used to store the chip number,cell type information):
    byte 3(used to store the page size, block size information)
    byte 4(used to store the Plane information).
    ........................


The current code uses the @id to store the device id(byte 1).
But if we use the 8 bytes id data as the keyword, and expand the @id 
field to 8byte array,
the device id is the second byte now. All the added zeros are for the 
Maker id.
For example,
     {"SmartMedia 256MiB 3,3V",      {0, 0x71}, 512, 256, 0x4000 },

We really do not use the zeros. All the zeros are added for avoiding the 
misunderstanding.
If we do not add the zero, it will looks like:

      {"SmartMedia 256MiB 3,3V",      {0x71}, 512, 256, 0x4000 },

The device id (0x71) becomes the first byte of 8byte id array, people will treat the 0x71 as the Maker code.


thanks
Huang Shijie


