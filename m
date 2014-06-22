Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaFVSbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:31:08 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47700 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaFVSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:31:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140621090446.GA8053@pengutronix.de>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
	<20140621090446.GA8053@pengutronix.de>
Date: Sun, 22 Jun 2014 13:31:02 -0500
Message-ID: <CAF03EBeUdrqfjOPCf4XxaKL_ZSqAcrgSbpDfTKov9_5oG4-Btg@mail.gmail.com>
Subject: Re: [PATCHv6 1/3] devicetree: Addition of the Altera SDRAM controller
From: Thor Thayer <tthayer.linux@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 4:04 AM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> Hi!
>
> On Fri, Jun 20, 2014 at 06:22:01PM -0500, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>>
>> Addition of the Altera SDRAM Controller bindings and device tree changes.
>>
>> v2: Changes to SoC SDRAM EDAC code.
>>
>> v3: Implement code suggestions for SDRAM EDAC code.
>>
>> v4: Remove syscon from SDRAM controller bindings.
>>
>> v5: No Change, bump version for consistency.
>>
>> v6: Only map the ctrlcfg register as syscon.
>>
>> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> ---
>>  .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
>>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
>>  2 files changed, 16 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>> new file mode 100644
>> index 0000000..5027026
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
>> @@ -0,0 +1,11 @@
>> +Altera SOCFPGA SDRAM Controller
>> +
>> +Required properties:
>> +- compatible : "altr,sdr-ctl";
>> +- reg : Should contain 1 register ranges(address and length)
>> +
>> +Example:
>> +     sdrctl@ffc25000 {
>> +             compatible = "altr,sdr-ctl";
>> +             reg = <0xffc25000 0x4>;
>> +     };
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 4676f25..310292e 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -682,6 +682,11 @@
>>                       clocks = <&l4_sp_clk>;
>>               };
>>
>> +             sdrctl@ffc25000 {
>> +                     compatible = "altr,sdr-ctl", "syscon";
>
> Did you forget to add the syscon to the binding documentation?
>
Hi Steffen,

I guess I'm confused about when to use syscon. In my last series, I
was advised not to include syscon in the bindings but to use it in the
device tree. I had been including it in the binding document until
this patch.

Thanks,

Thor
>> +                     reg = <0xffc25000 0x4>;
>> +             };
>> +
>>               rst: rstmgr@ffd05000 {
>>                       compatible = "altr,rst-mgr";
>>                       reg = <0xffd05000 0x1000>;
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
