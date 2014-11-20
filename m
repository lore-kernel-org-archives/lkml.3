Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbaKTPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:16:59 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49051 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaKTPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <8642876.4lpJWZTuhf@wuerfel>
References: <1414503414-3863-1-git-send-email-suravee.suthikulpanit@amd.com> <8642876.4lpJWZTuhf@wuerfel>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 20 Nov 2014 09:16:31 -0600
Message-ID: <CAL_Jsq+J3izFDepJ04Lb=caUOKJ4eNja0NrhqowyCOEPBVAPdA@mail.gmail.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle platform
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Joel Schopp <Joel.Schopp@amd.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Liviu Dudau <liviu.dudau@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 5:29 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 October 2014 08:36:54 suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>>
>> Initial revision of device tree for AMD Seattle platform
>
> Sorry for not looking at this earlier in enough detail.
>
>> +     dma0: dma@0500000 {
>> +             compatible = "arm,pl330", "arm,primecell";
>> +             reg = <0 0x0500000 0 0x1000>;
>> +             interrupts =
>> +                     <0 368 4>,
>> +                     <0 369 4>,
>> +                     <0 370 4>,
>> +                     <0 371 4>,
>> +                     <0 372 4>,
>> +                     <0 373 4>,
>> +                     <0 374 4>,
>> +                     <0 375 4>;
>> +             clocks = <&dmaclk_500mhz>;
>> +             clock-names = "apb_pclk";
>> +             #dma-cells = <1>;
>> +     };
>
> Is this device cache-coherent?
>
> Does it support larger than 32-bit DMA addresses?

No.

>
>> +     sata0: sata@00300000 {
>> +             compatible = "snps,dwc-ahci";

This should have an AMD specific compatible string in addition in case
you have AMD specific configuration or bugs.

>> +             reg = <0 0x300000 0 0x800>;
>> +             interrupts = <0 355 4>;
>> +             clocks = <&sataclk_333mhz>;
>> +             clock-names = "apb_pclk";

This name is obviously wrong and copied from other (ARM Primecell)
bindings as this IP does not have an APB PCLK. You can drop the name
as it is optional.

>> +             dma-coherent;
>> +     };
>
> Same here: you list it as coherent, but not 64-bit DMA capable.
> Is that intentional?

AHCI controllers are probeable as to whether they support 64-bit DMA or not.

Rob
