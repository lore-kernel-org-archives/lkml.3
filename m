Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaHRRTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 13:19:54 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52789 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaHRRTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 13:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAPz6YkW5RVb=Uqgh1hVG5GEftQE9gFy-2EuOCemBVCn=95O4uQ@mail.gmail.com>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
	<1408381749-14156-2-git-send-email-dianders@chromium.org>
	<CAPz6YkW5RVb=Uqgh1hVG5GEftQE9gFy-2EuOCemBVCn=95O4uQ@mail.gmail.com>
Date: Mon, 18 Aug 2014 10:19:51 -0700
X-Google-Sender-Auth: fAE4SoDxdE9dX6QRJPKpGPJJSZA
Message-ID: <CAD=FV=XqkD8DypQARfOe5fvXRsSBvGCdD4YSh063Q1std_63qg@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM IP
From: Doug Anderson <dianders@chromium.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Caesar Wang <caesar.wang@rock-chips.com>,
        Olof Johansson <olof@lixom.net>, Eddie Cai <eddie.cai@rock-chips.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sonny,

On Mon, Aug 18, 2014 at 10:11 AM, Sonny Rao <sonnyrao@chromium.org> wrote:
> On Mon, Aug 18, 2014 at 10:09 AM, Doug Anderson <dianders@chromium.org> wrote:
>> The rk3288 SoC has an option to switch all of the PWMs in the system
>> between the old IP block and the new IP block.  The new IP block is
>> working and tested and the suggested PWM to use, so setup the SoC to
>> use it and then we can pretend that the other IP block doesn't exist.
>>
>> This code could go lots of other places, but we've put it here.  Why?
>> - Pushing it to the bootloader just makes the code harder to update in
>>   the field.  If we later find a bug in the new IP block and want to
>>   change our mind about what to use we want it to be easy to update.
>> - Putting this code in the driver for IP block is a lot of extra work,
>>   device tree bindings, etc.  Now that the new IP block is validated
>>   it's likely no future SoCs will need this code.  Why pollute the PWM
>>   driver with this?  This is an rk3288 thing so it should be in rk3288
>>   code.
>> - There's a single bit that switches over PWMs, which makes it extra
>>   hard to put this under the PWM device tree nodes.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>>  arch/arm/mach-rockchip/rockchip.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/rockchip.c
>> index 8ab9e0e..99133b9 100644
>> --- a/arch/arm/mach-rockchip/rockchip.c
>> +++ b/arch/arm/mach-rockchip/rockchip.c
>> @@ -24,6 +24,24 @@
>>  #include <asm/hardware/cache-l2x0.h>
>>  #include "core.h"
>>
>> +static void __init rk3288_init_machine(void)
>> +{
>> +       void *grf = ioremap(0xff770000, 0x10000);
>
> Is it worth checking for failure here?  Will the system boot without this?

Yes, the system will boot without it.  I can't quite imagine the
ioremap failing, but I can add a test.

-Doug
