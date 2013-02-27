Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab3B0Cmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:42:55 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45942 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3B0Cmx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:42:53 -0500
MIME-Version: 1.0
In-Reply-To: <51220E78.5000409@ti.com>
References: <1361000036-18121-1-git-send-email-anilk4.v@gmail.com>
	<51220E78.5000409@ti.com>
Date: Wed, 27 Feb 2013 08:12:52 +0530
Message-ID: <CABYxbz5izBpc96EG++Qa2dZM3XCFeygQ-d8TOdEVw0DCeT6Qsg@mail.gmail.com>
Subject: Re: [PATCH V2] ARM: dts: omap3-devkit8000: Enable audio support
From: Anil Kumar <anilk4.v@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Alsa Devel List <alsa-devel@alsa-project.org>, linux@arm.linux.org.uk,
        b-cousson@ti.com, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, thomas@tomweber.eu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 18, 2013 at 4:50 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> On 02/16/2013 08:33 AM, Anil Kumar wrote:
>> Add the needed sections to enable audio support on
>> Devkit8000 when booted with DT blob.
>>
>> Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
>
> Looks good:
> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Gentle Ping. As there are no review comments on this patch,
Could you please pull this patch ?

Thanks,
Anil
>
>> ---
>> This patch is based on top of kernel 3.8-rc5 and
>> the following patches.
>>
>> Peter Ujfalusi:-
>> ASoC: twl4030: Correct the support for Voice port
>> ASoC: twl4030: Convert MICBIAS to SUPPLY widget
>> ASoC: omap-twl4030: Add support for routing, voice port and jack detect
>>
>> Anil Kumar:-
>> ARM: dts: add minimal DT support for DevKit8000
>> https://patchwork.kernel.org/patch/2122461/
>>
>> -Tested for playback and capture on Devkit8000.
>>
>>  Test process:-
>>
>>  #amixer set 'PredriveR Mixer AudioR2' on
>>  #amixer set 'PredriveL Mixer AudioL2' on
>>  #amixer set PreDriv 100 unmute
>>  #amixer set 'DAC2 Digital Fine' 100
>>  #amixer cset numid=27 1
>>  #arecord | aplay
>>
>> For V2:
>>  - Remove pin mux as done at device boot time by default.
>>
>> :100644 100644 6338993... c70116f... M        arch/arm/boot/dts/omap3-devkit8000.dts
>>  arch/arm/boot/dts/omap3-devkit8000.dts |   23 +++++++++++++++++++----
>>  1 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/omap3-devkit8000.dts b/arch/arm/boot/dts/omap3-devkit8000.dts
>> index 6338993..c70116f 100644
>> --- a/arch/arm/boot/dts/omap3-devkit8000.dts
>> +++ b/arch/arm/boot/dts/omap3-devkit8000.dts
>> @@ -42,6 +42,19 @@
>>                  };
>>
>>       };
>> +
>> +     sound {
>> +             compatible = "ti,omap-twl4030";
>> +             ti,model = "devkit8000";
>> +
>> +             ti,mcbsp = <&mcbsp2>;
>> +             ti,codec = <&twl_audio>;
>> +             ti,audio-routing =
>> +                     "Ext Spk", "PREDRIVEL",
>> +                     "Ext Spk", "PREDRIVER",
>> +                     "MAINMIC", "Main Mic",
>> +                     "Main Mic", "Mic Bias 1";
>> +     };
>>  };
>>
>>  &i2c1 {
>> @@ -51,6 +64,12 @@
>>               reg = <0x48>;
>>               interrupts = <7>;       /* SYS_NIRQ cascaded to intc */
>>               interrupt-parent = <&intc>;
>> +
>> +             twl_audio: audio {
>> +                     compatible = "ti,twl4030-audio";
>> +                     codec {
>> +                     };
>> +             };
>>       };
>>  };
>>
>> @@ -86,10 +105,6 @@
>>       status = "disabled";
>>  };
>>
>> -&mcbsp2 {
>> -     status = "disabled";
>> -};
>> -
>>  &mcbsp3 {
>>       status = "disabled";
>>  };
>>
>
>
> --
> Péter
