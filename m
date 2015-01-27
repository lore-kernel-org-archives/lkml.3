Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbbA0LNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:13:42 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51391 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbA0LNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <54B7F84A.6020906@wwwdotorg.org>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-5-git-send-email-tomeu.vizoso@collabora.com> <54B7F84A.6020906@wwwdotorg.org>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 27 Jan 2015 12:13:18 +0100
X-Google-Sender-Auth: 2Pw4yl6HAoYSPpImMelPH-GygFU
Message-ID: <CAAObsKDx_W23OTL2RE4xxgXL-rtp3npkBtx6qMHV1j8ZXmo1rw@mail.gmail.com>
Subject: Re: [PATCH v2 04/11] ARM: tegra: Set spi-max-frequency property to
 flash node
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

On 15 January 2015 at 18:26, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/15/2015 09:12 AM, Tomeu Vizoso wrote:
>>
>> To silence a warning on Nyan boards.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>   arch/arm/boot/dts/tegra124-nyan-big.dts | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/boot/dts/tegra124-nyan-big.dts
>> b/arch/arm/boot/dts/tegra124-nyan-big.dts
>> index 9a9cffe..94c7ba9 100644
>> --- a/arch/arm/boot/dts/tegra124-nyan-big.dts
>> +++ b/arch/arm/boot/dts/tegra124-nyan-big.dts
>> @@ -1660,6 +1660,7 @@
>>
>>                 flash@0 {
>>                         compatible = "winbond,w25q32dw";
>> +                       spi-max-frequency = <25000000>;
>
>
> This property already exists in the SPI controller. Isn't the max frequency
> supposed to inherit from there? If so, shouldn't the code not warn when such
> inheritance happens, i.e. it'd be better to fix the code?

I don't think it's supposed to fall back to the controller's max freq,
as each device has its own maximum frequency that it can support and
it's not related to what the master supports.

Regards,

Tomeu
