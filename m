Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338AbaHVQPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:15:00 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34208 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaHVQO5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:14:57 -0400
MIME-Version: 1.0
In-Reply-To: <080101cfbdf6$c8fd1f30$5af75d90$@samsung.com>
References: <53DCD74B.8090400@gmail.com>
	<1408539764-5835-1-git-send-email-afaerber@suse.de>
	<080101cfbdf6$c8fd1f30$5af75d90$@samsung.com>
Date: Fri, 22 Aug 2014 09:14:56 -0700
X-Google-Sender-Auth: FKPX_qjmPV-uMv_G1iaeNzFt25c
Message-ID: <CAD=FV=VS8e4Fs-j4CFvGYtvj58QwOk52gWh7AfnZcpswVRnDKA@mail.gmail.com>
Subject: Re: [PATCH v7] ARM: dts: Prepare node labels for exynos5250
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin,

On Fri, Aug 22, 2014 at 3:49 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Andreas Färber wrote:
>>
>> Allows them to be extended by reference.
>>
>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>> ---
>>  v6 -> v7:
>>  * Dropped uart* labels (Tomasz Figa)
>>
>>  v6: Split off from Snow/SMDK cleanups (Doug Anderson)
>>
>>  arch/arm/boot/dts/exynos5250.dtsi | 16 ++++++++--------
>>  1 file changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
>> index 492e1eff37bd..42eafd19cfb2 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -218,7 +218,7 @@
>>               clock-names = "fimg2d";
>>       };
>>
>> -     codec@11000000 {
>> +     mfc: codec@11000000 {
>>               compatible = "samsung,mfc-v6";
>>               reg = <0x11000000 0x10000>;
>>               interrupts = <0 96 0>;
>> @@ -227,7 +227,7 @@
>>               clock-names = "mfc";
>>       };
>>
>> -     rtc@101E0000 {
>> +     rtc: rtc@101E0000 {
>>               clocks = <&clock CLK_RTC>;
>>               clock-names = "rtc";
>>               status = "disabled";
>> @@ -261,7 +261,7 @@
>>               clock-names = "uart", "clk_uart_baud0";
>>       };
>>
>> -     sata@122F0000 {
>> +     sata: sata@122F0000 {
>>               compatible = "snps,dwc-ahci";
>>               samsung,sata-freq = <66>;
>>               reg = <0x122F0000 0x1ff>;
>> @@ -573,7 +573,7 @@
>>               #phy-cells = <1>;
>>       };
>>
>> -     usb@12110000 {
>> +     ehci: usb@12110000 {
>
> I'm not sure which one is recommended between above and "ehci: ehci@12110000 {"

My understanding is that more generic names should be used for node
names.  AKA: "usb" and not "ehci".  "mmc" and not "dwmmc".

In another thread I was pointed at ePAPR
<http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf>:

The name of a node should be somewhat generic, reflecting the function
of the device and not its precise programming model.


>> -     hdmi {
>> +     hdmi: hdmi {
>
> Should be
>
> +       hdmi: hdmi@14530000 { ?

Seems like that should be a followon patch.
