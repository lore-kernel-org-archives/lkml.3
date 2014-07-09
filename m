Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaGIUHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:07:51 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:49201 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaGIUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140626094507.GM15240@leverpostej>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
	<1403730927-16163-3-git-send-email-tthayer@altera.com>
	<20140626094507.GM15240@leverpostej>
Date: Wed, 9 Jul 2014 15:07:46 -0500
Message-ID: <CAF03EBdBMphBLkGj4=_kGADF4iq_uUpyBbRJ7O63OvSHcR5hSw@mail.gmail.com>
Subject: Re: [PATCHv7 2/3] devicetree: Addition of the Altera SDRAM EDAC.
From: Thor Thayer <tthayer.linux@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "tthayer@altera.com" <tthayer@altera.com>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "dinguyen@altera.com" <dinguyen@altera.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 4:45 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Jun 25, 2014 at 10:15:26PM +0100, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>>
>> Add the Altera SDRAM EDAC bindings and device tree changes to the Altera SoC project.
>>
>> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> ---
>> v2: Changes to SoC EDAC source code.
>>
>> v3: Fix typo in device tree documentation.
>>
>> v4,v5: No changes - bump version for consistency.
>>
>> v6: Assign ECC registers in SDRAM controller to EDAC
>>
>> v7: Fix SDRAM EDAC base address.
>> ---
>>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>>  arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
>>  2 files changed, 21 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>> new file mode 100644
>> index 0000000..d68e033
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>> @@ -0,0 +1,15 @@
>> +Altera SOCFPGA SDRAM Error Detection & Correction [EDAC]
>> +
>> +Required properties:
>> +- compatible : should contain "altr,sdram-edac";
>> +- reg : should contain the ECC register range in sdram
>> +        controller (address and length).
>> +- interrupts : Should contain the SDRAM ECC IRQ in the
>> +     appropriate format for the IRQ controller.
>> +
>> +Example:
>> +     sdramedac@ffc2502c {
>> +             compatible = "altr,sdram-edac";
>> +             reg = <0xffc2502c 0x28>;
>> +             interrupts = <0 39 4>;
>> +     };
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 310292e..da0785d 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -687,6 +687,12 @@
>>                       reg = <0xffc25000 0x4>;
>>               };
>>
>> +             sdramedac@ffc2502c {
>> +                     compatible = "altr,sdram-edac";
>> +                     reg = <0xffc2502c 0x28>;
>> +                     interrupts = <0 39 4>;
>> +             };
>
> I'm not sure I understand this. The ECC register existing within the
> SDRAM controller, which we have a binding for. Why do we need a separate
> binding for a subset of registers within an IP block?
>
> Why can we not have a single binding for the entire SDRAM controlelr and
> decompse that within Linux as it makes sense for the appropriate
> subsystyems?
>
> Leaking Linux design into bindings is a bad idea; it makes it harder to
> change things.
>
> Mark.

Hi Mark,

How would we decompose this within Linux. MFD? Is there an example
that I can look at?

We originally used syscon for the entire sdram controller register
block but we got dinged on it.

Thanks for your help.

Thor
