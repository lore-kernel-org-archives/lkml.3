Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbbA2C2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:28:51 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:59585 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761905AbbA2C2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:28:47 -0500
MIME-Version: 1.0
In-Reply-To: <54C7C16B.2080003@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-5-git-send-email-tomeu.vizoso@collabora.com>
 <54B7F84A.6020906@wwwdotorg.org> <CAAObsKDx_W23OTL2RE4xxgXL-rtp3npkBtx6qMHV1j8ZXmo1rw@mail.gmail.com>
 <54C7C16B.2080003@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Wed, 28 Jan 2015 11:24:17 +0100
X-Google-Sender-Auth: xtwa4wBIRHkZvJvMnFJaY5phcYI
Message-ID: <CAAObsKC8T7VR6JEY41pDEsuvJzLqwW0CUewW=QB-sSwkP95rfw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] ARM: tegra: Set spi-max-frequency property to
 flash node
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Alexandre Courbot <gnurou@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Simon Glass <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Kumar Gala <galak@codeaurora.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Dylan Reid <dgreid@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 January 2015 at 17:48, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/27/2015 04:13 AM, Tomeu Vizoso wrote:
>>
>> On 15 January 2015 at 18:26, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>>
>>> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>>>
>>>>
>>>> To silence a warning on Nyan boards.
>>>>
>>>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>>>> ---
>>>>    arch/arm/boot/dts/tegra124-nyan-big.dts | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>> b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>> index 9a9cffe..94c7ba9 100644
>>>> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
>>>> @@ -1660,6 +1660,7 @@
>>>>
>>>>                  flash@0 {
>>>>                          compatible = "winbond,w25q32dw";
>>>> +                       spi-max-frequency = <25000000>;
>>>
>>>
>>>
>>> This property already exists in the SPI controller. Isn't the max
>>> frequency
>>> supposed to inherit from there? If so, shouldn't the code not warn when
>>> such
>>> inheritance happens, i.e. it'd be better to fix the code?
>>
>>
>> I don't think it's supposed to fall back to the controller's max freq,
>> as each device has its own maximum frequency that it can support and
>> it's not related to what the master supports.
>
>
> If the controller-specific frequency property isn't ever used, we should
> remove it. No point carrying cruft that looks like it does something but
> doesn't.
>
> Logically, each device's max frequency certainly should be influenced by all
> of the controller, board, and device max frequency. Those should all impose
> a cap on the speed used. I'd expect this to be expressed in DT as a single
> property in each device where the user has calculated that max for the
> device, with the option to have all the devices fall back to the "default"
> provided at the controller/bus level if the device imposes a cap that's no
> lower.

My understanding is that each device node needs to specify the maximum
frequency it supports, and the same for each controller.

When configuring the transfer parameters, its frequency will be capped
by both the device and controller maximum frequencies.

So we currently need to specify the maximum frequencies in both device
and controller nodes, and it sounds like a good idea to me.

I'm probably missing your point. Is it that it should be possible for
device nodes to leave unspecified their max frequency and that in that
case the one for the controller should be used instead?

Regards,

Tomeu
