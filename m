Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaGaNX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:23:28 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46917 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaNX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:23:26 -0400
MIME-Version: 1.0
In-Reply-To: <53DA3C36.1040206@gmail.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
 <1406805732-17372-5-git-send-email-hsnaves@gmail.com> <53DA3C36.1040206@gmail.com>
From: Humberto Naves <hsnaves@gmail.com>
Date: Thu, 31 Jul 2014 15:23:03 +0200
Message-ID: <CAEe5pB_7e_5YkpcuRvsaUg6vKfdu6C+XhwRYyY1uUGptxM5zkg@mail.gmail.com>
Subject: Re: [PATCHv2 4/5] clk: samsung: exynos5410: Add fixed rate clocks
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

I perfectly see your point.
However my question was why you did you decide to postpone
Sylwester's? Was there any specific reason?
I suppose it would break all the dtb compatibility, but besides that,
was there any other reason?

Best,
Humberto

On Thu, Jul 31, 2014 at 2:53 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> Hi Humberto,
>
> You can find my comments inline.
>
> On 31.07.2014 13:22, Humberto Silva Naves wrote:
>> This implements the fixed rate clocks generated either inside or
>> outside the SoC. It also adds a dt-binding constant for the
>> sclk_hdmiphy clock, which shall be later used by other drivers,
>> such as the DRM.
>>
>> Since the external fixed rate clock fin_pll is now registered by
>> the clk-exynos5410 file, the bindings with the device tree file have
>> changed. It is no longer needed to define fin_pll as a fixed clock,
>> such as in:
>>
>>       fin_pll: xxti {
>>               compatible = "fixed-clock";
>>               clock-frequency = <24000000>;
>>               clock-output-names = "fin_pll";
>>               #clock-cells = <0>;
>>       };
>>
>> The above lines should be replaced by the following lines:
>>
>>       fixed-rate-clocks {
>>               oscclk {
>>                       compatible = "samsung,exynos5410-oscclk";
>>                       clock-frequency = <24000000>;
>>               };
>>       };
>>
>> This new form of binding was properly documented in the relevant
>> documentation file.
>
> In general this is backwards. This Exynos-specific clock binding was
> invented before generic fixed rate clock binding showed up and so few
> drivers still use it to maintain DT ABI compatibility. However new
> drivers are required to use the new generic binding and so does the one
> for Exynos5410.
>
> Best regards,
> Tomasz
