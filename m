Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3HZCmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:42:10 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59695 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HZCmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <5217A3E7.50706@samsung.com>
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
 <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com> <5217A3E7.50706@samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 26 Aug 2013 08:11:45 +0530
Message-ID: <CA+V-a8tStFRbELAmZL=418VpR9SJgp8uo_4hrtny2UEMEoXakg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv7343: add OF support
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        device-tree <devicetree-discuss@lists.ozlabs.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Fri, Aug 23, 2013 at 11:33 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Cc: DT binding maintainers
>
> On 07/20/2013 08:21 AM, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> add OF support for the adv7343 driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
> [...]
>>  .../devicetree/bindings/media/i2c/adv7343.txt      |   48 ++++++++++++++++++++
>>  drivers/media/i2c/adv7343.c                        |   46 ++++++++++++++++++-
>>  2 files changed, 93 insertions(+), 1 deletion(-)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> new file mode 100644
>> index 0000000..5653bc2
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
>> @@ -0,0 +1,48 @@
>> +* Analog Devices adv7343 video encoder
>> +
>> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
>> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
>> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
>> +definition (SD), enhanced definition (ED), or high definition (HD) video
>> +formats.
>> +
>> +Required Properties :
>> +- compatible: Must be "adi,adv7343"
>> +
>> +Optional Properties :
>> +- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
>> +                           micro ampere level. All DACs and the internal PLL
>> +                           circuit are disabled.
>
> Sorry for getting back so late to this. I realize this is already queued in
> the media tree. But this binding doesn't look good enough to me. I think it
> will need to be corrected during upcoming -rc period.
>
Thanks for the catch :-)

> It might be hard to figure out only from the chip's datasheet what
> adi,power-mode-sleep-mode really refers to. AFAICS it is for assigning some
> value to a specific register. If we really need to specify register values
> in the device tree then it would probably make sense to describe to which
> register this apply. Now the name looks like derived from some structure
> member name in the Linux driver of the device.
>
the property is derived from the datasheet itself for example the
'adi,power-mode-sleep-mode' --> Register 0x0 power mode bit 0
'adi,power-mode-pll-ctrl' ---> Register 0x0 power mode bit 1
'adi,dac-enable' ----> Register 0x0 power mode bit 2-7
'adi,sd-dac-enable' ---> Register 0x82 SD mode register bit 1-2

[1] http://www.analog.com/static/imported-files/data_sheets/ADV7342_7343.pdf

>> +- adi,power-mode-pll-ctrl: PLL and oversampling control. This control allows
>> +                        internal PLL 1 circuit to be powered down and the
>> +                        oversampling to be switched off.
>
> Similar comments applies to this property.
>
>> +- ad,adv7343-power-mode-dac: array configuring the power on/off DAC's 1..6,
>> +                           0 = OFF and 1 = ON, Default value when this
>> +                           property is not specified is <0 0 0 0 0 0>.
>
> Name of the property is incorrect here. It has changed to "adi,dac-enable".
>
OK

>> +- ad,adv7343-sd-config-dac-out: array configure SD DAC Output's 1 and 2, 0 = OFF
>> +                              and 1 = ON, Default value when this property is
>> +                              not specified is <0 0>.
>
> Similarly, "adi,sd-dac-enable.
>
OK

Regards,
--Prabhakar Lad
