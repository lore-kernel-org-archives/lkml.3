Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaLXXLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 18:11:04 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44147 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaLXXLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 18:11:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141224094516.GI13070@pengutronix.de>
References: <1419339862-29852-1-git-send-email-walter@vanguardiasur.com.ar>
	<20141224094516.GI13070@pengutronix.de>
Date: Wed, 24 Dec 2014 20:11:00 -0300
Message-ID: <CABxpGwC=swEFq-APo2B9u+PHP5DMEOiYgOuF1pKqxqWQEhyUZg@mail.gmail.com>
Subject: Re: [PATCH] ARM: socfpga: dts: Add adxl34x
From: Walter Lozano <walter@vanguardiasur.com.ar>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 6:45 AM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
> Hi!
>
> On Tue, Dec 23, 2014 at 10:04:22AM -0300, Walter Lozano wrote:
>> This patch adds the DTS bindings for the adxl34x digital
>> accelerometer.
>>
>
> Thanks for doing this. Does the ADXL34 work now? Last time I
> tried it, I didn't get any interrupts, but as I didn't really
> care for the accelerometer I didn't dig deeper.

Yes, now it works. There was a problem with the interrupts as the gpio was
probed after i2c. I have done some patches to fix this but some else
did a better job
deferring the probe so now it work out of the box.

>> Signed-off-by: Walter Lozano <walter@vanguardiasur.com.ar>
>> ---
>>  arch/arm/boot/dts/socfpga_cyclone5_sockit.dts |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
>> index 16ea6f5..f99d7dec 100644
>> --- a/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
>> +++ b/arch/arm/boot/dts/socfpga_cyclone5_sockit.dts
>> @@ -68,3 +68,20 @@
>>  &usb1 {
>>       status = "okay";
>>  };
>> +
>> +&gpio2 {
>> +     status = "okay";
>> +};
>> +
>> +&i2c1{
>        ^^^
>
> Add a space here and ...
>
>> +     status = "okay";
>> +
>> +     accel1: accel1@53{
>                         ^^^
> here. Also, this should be accelerometer@53.
>
>> +             compatible = "adxl34x";
>> +             reg = <0x53>;
>> +
>> +             interrupt-parent = < &portc >;
>                                    ^^^    ^^^
> Please remove the spaces here.
>> +             interrupts = <3 2>;
>> +
>> +     };
>> +};
>
> Finally, please sort the nodes alphabetically and not just append them.

Great, no problem at all. Thanks for the corrections.

Regards,

Walter

-- 
Walter Lozano, VanguardiaSur
www.vanguardiasur.com.ar
