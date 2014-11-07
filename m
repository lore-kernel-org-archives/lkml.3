Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaKGE0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:26:22 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:39923 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaKGE0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <545C47BC.4050207@nvidia.com>
References: <1415319715-21757-1-git-send-email-anatol.pomozov@gmail.com>
	<545C47BC.4050207@nvidia.com>
Date: Thu, 6 Nov 2014 20:26:18 -0800
Message-ID: <CAOMFOmVdpbP1v5xFF80mxq4z2Yjs+aZuW=89ArtwvgAX8MVQtQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: tegra: Port tegra20 clocksource to arm64
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: pdeschrijver@nvidia.com, Marc Zyngier <marc.zyngier@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Nov 6, 2014 at 8:17 PM, Stephen Warren <swarren@nvidia.com> wrote:
> On 11/06/2014 05:21 PM, Anatol Pomozov wrote:
>> register_persistent_clock() are in different headers in arm/arm64
>>
>> Tested: Compiled the driver on 64bit platform and make sure that
>> it works
>
> I assume "it works" refers to "it compiles" not "it executes successfully"?

It execute successfully, at least on 3.14 + bunch of backported
changes. I tested it on chromiumos 3.14 kernel and 64bit tegra board.

> I think it'd be better to make the same APIs available on arm and arm64,
> or even across all architectures.
>
>> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
>> ---
>>  drivers/clocksource/tegra20_timer.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
>> index d2616ef..e0123c7 100644
>> --- a/drivers/clocksource/tegra20_timer.c
>> +++ b/drivers/clocksource/tegra20_timer.c
>> @@ -29,8 +29,12 @@
>>  #include <linux/sched_clock.h>
>>  #include <linux/delay.h>
>>
>> +#ifdef CONFIG_ARM64
>> +#include <asm/time.h>
>> +#else
>>  #include <asm/mach/time.h>
>>  #include <asm/smp_twd.h>
>> +#endif
>>
>>  #define RTC_SECONDS            0x08
>>  #define RTC_SHADOW_SECONDS     0x0c
>>
>
