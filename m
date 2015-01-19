Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbbASOp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:45:57 -0500
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:52067 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751864AbbASOpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:45:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAFd313wyVqsqGNdxrAzmGCCYd-RAEcrX6f4y2Gngi44OOkbx-Q@mail.gmail.com>
References: <1421671269-19441-1-git-send-email-rsahu@apm.com>
	<1421671269-19441-3-git-send-email-rsahu@apm.com>
	<2407238.x2YxDm0cd4@wuerfel>
	<CAFd313wyVqsqGNdxrAzmGCCYd-RAEcrX6f4y2Gngi44OOkbx-Q@mail.gmail.com>
Date: Mon, 19 Jan 2015 20:15:54 +0530
Message-ID: <CAFd313zc_4fNMGvVNWqUOP+tzHoaCZDbFKVSyBsmT-OtwzHBHQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] arm64: dts: Add APM X-Gene DMA device and DMA
 clock DTS nodes
From: Rameshwar Sahu <rsahu@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ddutile@redhat.com,
        jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,
with regards,
Ram


On Mon, Jan 19, 2015 at 8:11 PM, Rameshwar Sahu <rsahu@apm.com> wrote:
> Hi Arnd,
>
>
>
>
>
>
> Thanks,
> with regards,
> Ram
>
> On Mon, Jan 19, 2015 at 7:10 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> On Monday 19 January 2015 18:11:08 Rameshwar Prasad Sahu wrote:
>> > diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi
>> > b/arch/arm64/boot/dts/apm/apm-storm.dtsi
>> > index f1ad9c2..e20da23 100644
>> > --- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
>> > +++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
>> > @@ -103,6 +103,9 @@
>> >                 #size-cells = <2>;
>> >                 ranges;
>> >
>> > +               /* DDR range is 42-bit addressing */
>> > +               dma-ranges = <0x40 0x0 0x40 0x0 0x1ff 0xffffffff>;
>> > +
>> >
>>
>> The comment above is misleading, and the value is wrong. I assume you
>>
>> copied these from the AMD patch that introduced the respective property.
>
>
> I referred this patch from AMD only.
>>
>>
>> The value should be
>>
>>         dma-ranges = <0x40 0x0 0x40 0x0 0x200 0>;
>
>
> then it should be :
>
> dma-ranges = <0x40 0x0 0x40 0x0 0x400 0>;
>
>
>> to say that any DMA to physical addresses from 0 to 0x3f.ffffffff
>> is disallowed and dma to physical addresses from 0x40.00000000
>> to 0x23f.ffffffff is allowed and gets translated using an
>> identity mapping.
>>
>> I also see that on Mustang, all memory is outside of this range,
>
>
> Do you mean all other device controller node in DT here??
> Basically these are all device controller memory, as what I understood is
> dma-ranges tells about DDR ranges like start address of DDR
> and length.
>
>
>>
>> which is a bit suspicious, while your PCI memory space is
>> included.
>
>
>>
>> It would be best to match the numbers up with your data sheet.
>>
>>         Arnd
>> --
>> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
