Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbbASRLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:11:40 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:61184 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbASRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:11:38 -0500
MIME-Version: 1.0
In-Reply-To: <54BD3A75.80009@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-4-git-send-email-tomeu.vizoso@collabora.com>
 <54B7F757.5060002@wwwdotorg.org> <CAAObsKCad9O_=TUQrF7fVbBvjDTmfJsLPgr+EasCyhvY+xhdHg@mail.gmail.com>
 <CAAObsKBKnU_wBaxNFN-buz71qL-te4s6bqrrnxao_N-TwBVkAQ@mail.gmail.com> <54BD3A75.80009@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Mon, 19 Jan 2015 18:11:14 +0100
X-Google-Sender-Auth: r5AK19WybQ7dj5S6dKLiFlNWlz0
Message-ID: <CAAObsKBm5mesGqrLQnveKQMy__uEOU1vcLGptnKxqHjV-T9C0g@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] ARM: tegra: Set the sound card model that
 alsaucm expects
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
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

On 19 January 2015 at 18:10, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/16/2015 02:01 AM, Tomeu Vizoso wrote:
>>
>> On 16 January 2015 at 09:50, Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> wrote:
>>>
>>> On 15 January 2015 at 18:22, Stephen Warren <swarren@wwwdotorg.org>
>>> wrote:
>>>>
>>>> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>>>>
>>>>>
>>>>> Patches are on its way to add a config file to alsaucm for the Nyan
>>>>> boards. Use the same card ID that alsaucm will expect.
>>>>>
>>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>>> ---
>>>>>    arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++--
>>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>> b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>> index 43e58a4..9a9cffe 100644
>>>>> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>>> @@ -1976,9 +1976,9 @@
>>>>>          };
>>>>>
>>>>>          sound {
>>>>> -               compatible = "nvidia,tegra-audio-max98090-nyan-big",
>>>>> +               compatible = "nvidia,tegra-audio-max98090-nyan",
>>>>>                               "nvidia,tegra-audio-max98090";
>>>>
>>>>
>>>>
>>>> If all the boards that are derived from Nyan truly have identical audio
>>>> HW
>>>> (or at least any differences can be described by this binding), then it
>>>> seems fine to add "nvidia,tegra-audio-max98090-nyan" to the compatible
>>>> value.
>>>
>>>
>>>
>>>
>>>> However, I don't see a reason to remove the board-specific compatible
>>>> value
>>>> "nvidia,tegra-audio-max98090-nyan-big"; we should always include all the
>>>> values that are relevant.
>>>
>>>
>>> Ok.
>>
>>
>> Oh, actually, my intention was to move the whole sound node to the
>> nyan dtsi, as there isn't anything specific to the blaze regarding
>> sound.
>
>
> There are zero differences between the sound circuits of the boards? If so,
> that sounds fine. I suppose if we do need to apply a quirk to one board but
> not the other, we can always fall back on the top-level compatible value if
> we absolutely have to.

Yeah, this is what Dylan said in other thread:

"ChromeOS uses one config for both.  The only audio difference between
these two boards is the speakers, that isn't represented in UCM, so
one config file is fine."

Regards,

Tomeu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
