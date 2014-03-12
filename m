Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaCLStD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:49:03 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:44072 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaCLStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:49:00 -0400
Message-ID: <5320AC16.8030901@gmail.com>
Date: Wed, 12 Mar 2014 19:48:54 +0100
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Warner Losh <imp@bsdimp.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND timing
 mode property
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com> <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com> <F8865D0A-59A7-41A7-AA7F-9B91DF5C8258@gmail.com>
In-Reply-To: <F8865D0A-59A7-41A7-AA7F-9B91DF5C8258@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/03/2014 19:27, Warner Losh a écrit :
> On Mar 12, 2014, at 12:07 PM, Boris BREZILLON <b.brezillon.dev@gmail.com> wrote:
>
>> Add documentation for the ONFI NAND timing mode property.
> I don’t see a Toggle/JEDEC mode timing property. Will that be defined for Toshiba, Samsung
> and San Disk flash? Or will this be limited to Micron, Intel and Hynix (the only ones
> supporting ONFI)?

There is currently no Toggle/JEDEC timing mode support, and I don't know 
what these
timing modes describe.
But I guess they can be converted to standard timings described in 
nand_sdr_timings
struct (or in your case in the future nand_ddr_timings struct).

Could you check that the timings described by these modes use the same 
naming convention
as those defined in the ONFI specification 
(www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf
  chapter 4.15.4) ?

If this is the case, we can define a new DT property and new converters.

Best Regards,

Boris

> Warner
>
>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>> Documentation/devicetree/bindings/mtd/nand.txt |    8 ++++++++
>> 1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
>> index b53f92e..2046027 100644
>> --- a/Documentation/devicetree/bindings/mtd/nand.txt
>> +++ b/Documentation/devicetree/bindings/mtd/nand.txt
>> @@ -19,3 +19,11 @@ errors per {size} bytes".
>> The interpretation of these parameters is implementation-defined, so not all
>> implementations must support all possible combinations. However, implementations
>> are encouraged to further specify the value(s) they support.
>> +
>> +- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
>> +  the NAND chip. Each supported mode is represented as a bit position (i.e. :
>> +  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
>> +  This is only used when the chip does not support the ONFI standard.
>> +  The last bit set represent the closest mode fulfilling the NAND chip timings.
>> +  For a full description of the different timing modes see this document:
>> +  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf
>> -- 
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

