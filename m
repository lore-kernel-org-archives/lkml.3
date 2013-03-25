Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3CYBSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:18:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:59493 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3CYBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:18:37 -0400
X-Greylist: delayed 125419 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Mar 2013 21:18:37 EDT
MIME-Version: 1.0
X-Originating-IP: [114.39.106.54]
In-Reply-To: <16f801ce28f5$b9095c20$2b1c1460$%kim@samsung.com>
References: <1364048887.13141.0.camel@phoenix>
	<16f801ce28f5$b9095c20$2b1c1460$%kim@samsung.com>
Date: Mon, 25 Mar 2013 09:18:36 +0800
Message-ID: <CAFRkauCDg9G3JLpB+fi3JZdu-18jr0ibFqM30tOH4rPQVO8dUQ@mail.gmail.com>
Subject: Re: [PATCH] clocksource: exynos_mct: Add terminating entry for
 exynos_mct_ids table
From: Axel Lin <axel.lin@ingics.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Changhwan Youn <chaos.youn@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/25 Kukjin Kim <kgene.kim@samsung.com>:
> Axel Lin wrote:
>>
>> The of_device_id table is supposed to be zero-terminated.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>>  drivers/clocksource/exynos_mct.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/clocksource/exynos_mct.c
>> b/drivers/clocksource/exynos_mct.c
>> index 203ac05..3cdafc0 100644
>> --- a/drivers/clocksource/exynos_mct.c
>> +++ b/drivers/clocksource/exynos_mct.c
>> @@ -514,6 +514,7 @@ static void __init exynos4_timer_resources(struct
>> device_node *np)
>>  static const struct of_device_id exynos_mct_ids[] = {
>>       { .compatible = "samsung,exynos4210-mct", .data = (void
>> *)MCT_INT_SPI },
>>       { .compatible = "samsung,exynos4412-mct", .data = (void
>> *)MCT_INT_PPI },
>> +     { }
>
> Thanks for your pointing out. But as I know, it is not mandatory now.
>
> Please correct me if I'm wrong.

of_find_matching_node_and_match()
-> __of_match_node()
    while (matches->name[0] || matches->type[0] || matches->compatible[0])

My understanding is the implementation in _of_match_node() still needs
zero-terminated entry to break out the while loop.
