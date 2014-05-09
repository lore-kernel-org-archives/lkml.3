Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbaEIPrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:47:25 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47096 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756880AbaEIPrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:47:22 -0400
Message-ID: <536CF887.7020903@free-electrons.com>
Date: Fri, 09 May 2014 17:47:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>
CC: devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-mtd@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v3 1/9] mtd: nand: define struct nand_timings
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com> <1394647664-8258-2-git-send-email-b.brezillon.dev@gmail.com> <20140430175157.GB2497@norris-Latitude-E6410> <20140508142930.GC5767@lee--X1>
In-Reply-To: <20140508142930.GC5767@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/05/2014 16:29, Lee Jones wrote:
>>> Define a struct containing the standard NAND timings as described in NAND
>>> datasheets.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>>> ---
>>>  include/linux/mtd/nand.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 49 insertions(+)
>>>
>>> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
>>> index 389b3c5..f3ff3a3 100644
>>> --- a/include/linux/mtd/nand.h
>>> +++ b/include/linux/mtd/nand.h
> [...]
>
>>> + * Parameters)
>> Please document the units for these fields here. It looks like you're
>> using picoseconds.
> Can't we leave this open to interpretation?  For instance, it's more
> convenient for our driver to handle these as nano second values.
>
>>> + *
>>> + */
>>> +
>> Extra blank line.
>>
>>> +struct nand_sdr_timings {
>>> +	u32 tALH_min;
>>> +	u32 tADL_min;
>>> +	u32 tALS_min;
>>> +	u32 tAR_min;
>>> +	u32 tCEA_max;
>>> +	u32 tCEH_min;
>>> +	u32 tCH_min;
>>> +	u32 tCHZ_max;
>>> +	u32 tCLH_min;
>>> +	u32 tCLR_min;
>>> +	u32 tCLS_min;
>>> +	u32 tCOH_min;
>>> +	u32 tCS_min;
> 	u32 tCSD_min;

This is related to ddr2 timings, and this structure only define sdr
related timings.

>>> +	u32 tDH_min;
>>> +	u32 tDS_min;
>>> +	u32 tFEAT_max;
>>> +	u32 tIR_min;
>>> +	u32 tITC_max;
> 	u32 tR_max;

Actually this one cannot be retrieved from the ONFI timing mode, you'll
have to read bytes 137 and 138 in the parameter page.
Hence I got rid of it in the first place. Then I considered adding all
those missing timings in another structure (see [1]).

I noticed you posted something similar on the MTD mailing list (and
Lucas was waiting for the feature too).
Could we work together to propose something that fulfills all our needs ?

Here's what I need:
- get detailled timings to be able to configure the sunxi NAND
controller appropriately
- a way to get these timings on non-ONFi NANDs (the proposed solution is
exposing the closest  supported ONFI timing mode in the NAND chip DT
node, but I'm open to any new proposal).


Best Regards,

Boris

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-March/052525.html


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

