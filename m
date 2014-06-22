Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaFVSbz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:31:55 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:53502 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaFVSbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:31:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140621090618.GB8053@pengutronix.de>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
	<1403306523-4174-3-git-send-email-tthayer@altera.com>
	<20140621090618.GB8053@pengutronix.de>
Date: Sun, 22 Jun 2014 13:31:51 -0500
Message-ID: <CAF03EBfK4kjKZxdcUGKNF91AYnad8ReoAY8oqAHUChQ4kN4dyg@mail.gmail.com>
Subject: Re: [PATCHv6 2/3] devicetree: Addition of the Altera SDRAM EDAC
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
        linux-edac@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2014 at 4:06 AM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> On Fri, Jun 20, 2014 at 06:22:02PM -0500, tthayer@altera.com wrote:
>> From: Thor Thayer <tthayer@altera.com>
>>
>> Addition of the Altera SDRAM EDAC bindings and device tree changes
>>
>> v2: Changes to SoC EDAC source code.
>>
>> v3: Fix typo in device tree documentation.
>>
>> v4,v5: No changes - bump version for consistency.
>>
>> v6: Assign ECC registers in SDRAM controller to EDAC
>>
>> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> ---
>>  .../bindings/arm/altera/socfpga-sdram-edac.txt     |   15 +++++++++++++++
>>  arch/arm/boot/dts/socfpga.dtsi                     |    6 ++++++
>>  2 files changed, 21 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram-edac.txt
>> new file mode 100644
>> index 0000000..540c9cf
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
>> +     sdramedac@0 {
>> +             compatible = "altr,sdram-edac";
>> +             reg = <0xffc2502C 0x28>;
>> +             interrupts = <0 39 4>;
>> +     };
>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>> index 310292e..fe9832e 100644
>> --- a/arch/arm/boot/dts/socfpga.dtsi
>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>> @@ -687,6 +687,12 @@
>>                       reg = <0xffc25000 0x4>;
>>               };
>>
>> +             sdramedac@0 {
>                          ^^^
>
> Please fix the baseaddress (also in the binding doc).
>

Thanks. Good catch. I will fix this.

>> +                     compatible = "altr,sdram-edac";
>> +                     reg = <0xffc2502C 0x28>;
>> +                     interrupts = <0 39 4>;
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
