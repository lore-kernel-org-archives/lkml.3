Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbbAVC5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:57:04 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:51707 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbbAVC47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:56:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1oZWzeev-1uE7gxPnJA=L4Th65CRj8C_LQ7hMJLPHGssDjNQ@mail.gmail.com>
References: <CAN1oZWxB5N=YMQcsJppZgp7TXodcR4tKZM+LNFXS7PSx3F-Yag@mail.gmail.com>
	<CAN1oZWzeev-1uE7gxPnJA=L4Th65CRj8C_LQ7hMJLPHGssDjNQ@mail.gmail.com>
Date: Thu, 22 Jan 2015 10:56:57 +0800
Message-ID: <CAN1oZWwBb3nWDKcwFmDD1kc94mxCWBz+O-nUnZdByYsfZSTtCQ@mail.gmail.com>
Subject: Re: [PATCH mtd] mtd:devices: Add Altera EPCQ Driver
From: Viet Nga Dao <vndao@altera.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Viet Nga Dao <vndao@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:05 AM, Viet Nga Dao <vndao@altera.com> wrote:
> On Thu, Jan 15, 2015 at 5:27 PM, Viet Nga Dao <vndao@altera.com> wrote:
>> On Tue, Jan 13, 2015 at 11:33 AM, Brian Norris
>> <computersforpeace@gmail.com> wrote:
>>> On Thu, Dec 18, 2014 at 12:23:16AM -0800, vndao@altera.com wrote:
>>>> From: Viet Nga Dao <vndao@altera.com>
>>>>
>>>> Altera EPCQ Controller is a soft IP which enables access to Altera EPCQ and
>>>> EPCS flash chips. This patch adds driver for these devices.
>>>>
>>>> Signed-off-by: Viet Nga Dao <vndao@altera.com>
>>>
>>> This drivers seems awfully similar to (and so I infer it is likely
>>> copy-and-pasted from) m25p80.c / spi-nor.c. Do you think it can be
>>> rewritten as a SPI NOR driver, under drivers/mtd/spi-nor/ ? It looks
>>> like these flash share most (all?) the same basic opcodes.
>>>
>> For Altera EPCQ flashes, almost operations are performed underline
>> hardware. Software only able to perform the following through
>> registers:
>>  -  read status register
>>  -  read id
>>  -  write status registers bit SR_BP0,SR_BP1, SR_BP2,SR_BP3, SR_TB
>> (http://www.altera.com.my/literature/hb/cfg/cfg_cf52012.pdf)
>> For read/write data: all the operations like QUAD_READ/WRITE,
>> FAST_READ/WRITE are handled by hardware as well. From software point
>> of view, there is no difference between these 2 modes.
>> That is why if rewrite the drivers to follow spi-nor structure, it
>> will require extra decoding works for the only few used opcodes.
>>
> Is it OK to remain this driver structure?
Can someone please reply my question as it is been a while?
Viet Nga
