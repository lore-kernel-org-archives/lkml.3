Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaIQPwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 11:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaIQPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 11:51:29 -0400
Message-ID: <5419ADF9.3010509@suse.de>
Date: Wed, 17 Sep 2014 17:51:21 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Daniel Drake <drake@endlessm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: Add rtc_src clk for s3c-rtc on exynos5250-snow
References: <1410954633-27025-1-git-send-email-javier.martinez@collabora.co.uk>	<1410954633-27025-3-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
In-Reply-To: <CAD=FV=W7xJ01m2oLtuDnogOmrpwpztbir=59oSWU6oojFYUWKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.09.2014 um 17:47 schrieb Doug Anderson:
> Hi,
> 
> On Wed, Sep 17, 2014 at 4:50 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> commit 546b117fdf17 ("rtc: s3c: add support for RTC of Exynos3250 SoC")
>> added an "rtc_src" DT property for the Samsung's S3C Real Time Clock
>> controller that specifies the 32.768 kHz clock that uses the RTC as its
>> source clock. In the case of the Exynos5250 based Snow board, the Maxim
>> 77686 32kHz AP clock is used as the source clock.
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>  arch/arm/boot/dts/exynos5250-snow.dts | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
>> index e51fcef..56eec56 100644
>> --- a/arch/arm/boot/dts/exynos5250-snow.dts
>> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
>> @@ -10,6 +10,7 @@
>>
>>  /dts-v1/;
>>  #include <dt-bindings/gpio/gpio.h>
>> +#include <dt-bindings/clock/maxim,max77686.h>
>>  #include "exynos5250.dtsi"
>>
>>  / {
>> @@ -29,6 +30,8 @@
>>
>>         rtc@101E0000 {
>>                 status = "okay";
>> +               clocks = <&clock CLK_RTC>, <&max77686 MAX77686_CLK_AP>;
>> +               clock-names = "rtc", "rtc_src";
> 
> Wait, seriously?  Snow is still using the "rtc@101E0000" syntax?
> Whatever happened to the series that Andreas worked so hard on,
> including <https://patchwork.kernel.org/patch/4664801/>?
> 
> Kukjin: Andreas's patch series was Reviewed long ago I think and by
> now I'd imagine it's got some conflicts due to it not having been
> applied in a timely fashion.  Perhaps you could fix it up for Andreas
> (since he's already rebased it several times) and land it?
> 
> If I had to guess, outstanding from Andreas's series (patchwork IDs listed):
> 
> 4751131 New          [v7] ARM: dts: Prepare node labels for exynos5250
> 4664801 New          [v6,04/10] ARM: dts: Clean up exynos5250-snow
> 4664771 New          [v6,05/10] ARM: dts: Fill in bootargs for exynos5250-snow
> 4664731 New          [v6,06/10] ARM: dts: Clean up exynos5250-smdk5250
> 4664751 New          [v6,07/10] ARM: dts: Clean up exynos5250-arndale
> 4664711 New          [v6,08/10] ARM: dts: Fix apparent GPIO typo in
> exynos5250-arndale
> 4664681 New          [v6,09/10] ARM: dts: Simplify USB3503 on exynos5250-arndale
> 4664691 New          [v6,10/10] ARM: dts: Add exynos5250-spring device tree

Yes, Kukjin told me not to resend anything, and I haven't heard back
from him since his Kernel Summit trip.

Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
