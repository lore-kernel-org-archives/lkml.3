Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbbATRCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:02:01 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:42659 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbbATRB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:01:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAAObsKBm5mesGqrLQnveKQMy__uEOU1vcLGptnKxqHjV-T9C0g@mail.gmail.com>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-4-git-send-email-tomeu.vizoso@collabora.com>
 <54B7F757.5060002@wwwdotorg.org> <CAAObsKCad9O_=TUQrF7fVbBvjDTmfJsLPgr+EasCyhvY+xhdHg@mail.gmail.com>
 <CAAObsKBKnU_wBaxNFN-buz71qL-te4s6bqrrnxao_N-TwBVkAQ@mail.gmail.com>
 <54BD3A75.80009@wwwdotorg.org> <CAAObsKBm5mesGqrLQnveKQMy__uEOU1vcLGptnKxqHjV-T9C0g@mail.gmail.com>
From: Dylan Reid <dgreid@chromium.org>
Date: Tue, 20 Jan 2015 09:01:34 -0800
X-Google-Sender-Auth: 0Ow32eGDL_YoZZJNZrC5TQIrHtc
Message-ID: <CAEUnVG4R6NH3EAM9qBaxzC+T26qWeiEm=iZtFQKyrQTcvfzicg@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] ARM: tegra: Set the sound card model that
 alsaucm expects
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Simon Glass <sjg@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 9:11 AM, Tomeu Vizoso
<tomeu.vizoso@collabora.com> wrote:
> On 19 January 2015 at 18:10, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 01/16/2015 02:01 AM, Tomeu Vizoso wrote:
>>>
>>> On 16 January 2015 at 09:50, Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>> wrote:
>>>>
>>>> On 15 January 2015 at 18:22, Stephen Warren <swarren@wwwdotorg.org>
>>>> wrote:
>>>>>
>>>>> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>>>>>
>>>>>>
>>>>>> Patches are on its way to add a config file to alsaucm for the Nyan
>>>>>> boards. Use the same card ID that alsaucm will expect.
>>>>>>
>>>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>>>> ---
>>>>>>    arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++--
>>>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>>> b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>>> index 43e58a4..9a9cffe 100644
>>>>>> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>>> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>>> @@ -1976,9 +1976,9 @@
>>>>>>          };
>>>>>>
>>>>>>          sound {
>>>>>> -               compatible = "nvidia,tegra-audio-max98090-nyan-big",
>>>>>> +               compatible = "nvidia,tegra-audio-max98090-nyan",
>>>>>>                               "nvidia,tegra-audio-max98090";
>>>>>
>>>>>
>>>>>
>>>>> If all the boards that are derived from Nyan truly have identical audio
>>>>> HW
>>>>> (or at least any differences can be described by this binding), then it
>>>>> seems fine to add "nvidia,tegra-audio-max98090-nyan" to the compatible
>>>>> value.
>>>>
>>>>
>>>>
>>>>
>>>>> However, I don't see a reason to remove the board-specific compatible
>>>>> value
>>>>> "nvidia,tegra-audio-max98090-nyan-big"; we should always include all the
>>>>> values that are relevant.
>>>>
>>>>
>>>> Ok.
>>>
>>>
>>> Oh, actually, my intention was to move the whole sound node to the
>>> nyan dtsi, as there isn't anything specific to the blaze regarding
>>> sound.
>>
>>
>> There are zero differences between the sound circuits of the boards? If so,
>> that sounds fine. I suppose if we do need to apply a quirk to one board but
>> not the other, we can always fall back on the top-level compatible value if
>> we absolutely have to.
>
> Yeah, this is what Dylan said in other thread:
>
> "ChromeOS uses one config for both.  The only audio difference between
> these two boards is the speakers, that isn't represented in UCM, so
> one config file is fine."

Correct, they share the same headset chip and codec, they are both
wired up the same.

>
> Regards,
>
> Tomeu
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
