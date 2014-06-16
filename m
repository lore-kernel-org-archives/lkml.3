Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaFPL0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:54 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40200 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaFPL0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:50 -0400
Message-ID: <539ED472.5020102@gmail.com>
Date: Mon, 16 Jun 2014 16:56:42 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Javier Martinez Canillas <javier@dowhile0.org>,
        Tushar Behera <tushar.b@samsung.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        mturquette@linaro.org, t.figa@samsung.com,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        dianders@google.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: Re: [PATCH 2/3] ARM: dts: Update the parent for Audss clocks in Exynos5420
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>	<1402464739-19044-3-git-send-email-tushar.b@samsung.com> <CABxcv=kX07pNCd-YPYp6J8S5hHzG1rsoer1YRfdPE0g-xFqZnQ@mail.gmail.com>
In-Reply-To: <CABxcv=kX07pNCd-YPYp6J8S5hHzG1rsoer1YRfdPE0g-xFqZnQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 09:28 PM, Javier Martinez Canillas wrote:
> On Wed, Jun 11, 2014 at 7:32 AM, Tushar Behera <tushar.b@samsung.com> wrote:
>> Currently CLK_FOUT_EPLL was set as one of the parents of AUDSS mux.
>> As per the user manual, it should be CLK_MAU_EPLL.
>>
>> The problem surfaced when the bootloader in Peach-pit board set
>> the EPLL clock as the parent of AUDSS mux. While booting the kernel,
>> we used to get a system hang during late boot if CLK_MAU_EPLL was
>> disabled.
>>
>> Signed-off-by: Tushar Behera <tushar.b@samsung.com>
>> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
>> Reported-by: Kevin Hilman <khilman@linaro.org>
>> ---
>>  arch/arm/boot/dts/exynos5420.dtsi |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
>> index e385322..79e9119 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -167,7 +167,7 @@
>>                 compatible = "samsung,exynos5420-audss-clock";
>>                 reg = <0x03810000 0x0C>;
>>                 #clock-cells = <1>;
>> -               clocks = <&clock CLK_FIN_PLL>, <&clock CLK_FOUT_EPLL>,
>> +               clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MAU_EPLL>,
>>                          <&clock CLK_SCLK_MAUDIO0>, <&clock CLK_SCLK_MAUPCM0>;
>>                 clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
>>         };
>> --
>> 1.7.9.5
>>
>> --
> 
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 

Kukjin,

Would you please take this patch as a fix for 3.16?

-- 
Tushar Behera
