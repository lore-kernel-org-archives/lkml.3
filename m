Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaETTai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:30:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34769 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbaETTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:30:37 -0400
Message-ID: <537BAD59.3060902@free-electrons.com>
Date: Tue, 20 May 2014 21:30:33 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 4/9] of: mtd: add documentation for the ONFI NAND timing
 mode property
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com> <1394647664-8258-5-git-send-email-b.brezillon.dev@gmail.com> <20140520182542.GS28907@ld-irv-0074>
In-Reply-To: <20140520182542.GS28907@ld-irv-0074>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On 20/05/2014 20:25, Brian Norris wrote:
> Hi Boris,
>
> On Wed, Mar 12, 2014 at 07:07:39PM +0100, Boris BREZILLON wrote:
>> Add documentation for the ONFI NAND timing mode property.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/mtd/nand.txt |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/mtd/nand.txt b/Documentation/devicetree/bindings/mtd/nand.txt
>> index b53f92e..2046027 100644
>> --- a/Documentation/devicetree/bindings/mtd/nand.txt
>> +++ b/Documentation/devicetree/bindings/mtd/nand.txt
>> @@ -19,3 +19,11 @@ errors per {size} bytes".
>>  The interpretation of these parameters is implementation-defined, so not all
>>  implementations must support all possible combinations. However, implementations
>>  are encouraged to further specify the value(s) they support.
>> +
>> +- onfi,nand-timing-mode: an integer encoding the supported ONFI timing modes of
>> +  the NAND chip. Each supported mode is represented as a bit position (i.e. :
>> +  mode 0 and 1 => (1 << 0) | (1 << 1) = 0x3).
>> +  This is only used when the chip does not support the ONFI standard.
>> +  The last bit set represent the closest mode fulfilling the NAND chip timings.
>> +  For a full description of the different timing modes see this document:
>> +  www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf
> I'm not 100% convinced this property should go in the device tree. With
> most other flash properties (device size, page size, and even minimum
> ECC requirements), we try to auto-detect these parameters to some
> extent. ONFI makes it easy for some class of chips, but for others, we
> typically rely on an in-kernel device ID table or ID decoding heuristic
> -- we don't require a DT description of every property of the flash. So
> what makes this property different?

AFAICT nothing, but the same goes for the ECC requirements, and we've
recently added DT bindings to define these requirements.
I'm not telling we should drop these ECC requirements bindings (actually
I'm using them :-)), but what's different with the timings requirements ?

Moreover, we will end up with a lot of new entries in the device ID
table if we decide to put these informations in this table.

>
> I realize that we may not include device ID entries for every flash that
> you need in the ID table (although we still are able to detect the
> important properties accurately, like page and block size). But would it
> suffice to default these flash to a lowest common timing mode, like mode
> 0?

IMHO this is not a good solution: you'll end up with lower perfomances
on most of the supported NAND chips and I'm not sure this is what we want.

>
> If no other option works well, then I am still open to describing the
> supported timing modes in the DT.
>
> BTW, this bitfield property looks kinda strange to me. Do non-ONFI flash
> typically support multiple timing modes? And if so, how are we supposed
> to *change* modes? AFAIK, ONFI provides the only standard for
> configuring the flash's timing mode. So maybe you're really only wanting
> a "default timing mode" property that is a single integer, not a
> bitfield.

Indeed, I based it on the ONFI NAND timings mode model, but AFAIK (tell
me if I'm wrong), it should work because most of the timings are min
requirements.
This means, even if you provide slower signals transitions, the NAND
will work as expected.

But I can modify the bindings to just encode the maximum supported
timing mode.

Thanks for your feedback.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

