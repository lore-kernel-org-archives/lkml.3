Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585Ab3HNIus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:50:48 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39070 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3HNIul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpoksGB6bBtFF4DaqqLME2kpDve5uMycZDCXahaigdRhwKQ@mail.gmail.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=QKPvqUcQVsbbSQdWOOi5L-P2CBFzcfMsobs8uGpLkVw@mail.gmail.com>
	<CAFgnuDes_F7Q5CHbXKC=ndrn9Gr3PJfGj0QvDXA-FuGcq41CHQ@mail.gmail.com>
	<CAKohponD2LdDsJy=UJCf-1yANjyPjmAyokV5a4HOSJn_DMJVhA@mail.gmail.com>
	<CAFgnuDetTVYayBABNPhME15b+b6qUtJX2hBaJ6y4+gOSgGFwdQ@mail.gmail.com>
	<CAKohpoksGB6bBtFF4DaqqLME2kpDve5uMycZDCXahaigdRhwKQ@mail.gmail.com>
Date: Wed, 14 Aug 2013 16:50:39 +0800
Message-ID: <CAFgnuDe1VwH2_xyyRN382=gGO8N6QKONKpGkLBGK8Hv2Zh1orA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Add governor operation ongoing flag
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/14 Viresh Kumar <viresh.kumar@linaro.org>:
> On 14 August 2013 13:49, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
>> Yes, "START (If STOP passed)", this is important,  we don't have this
>> patch on our code base, So even Process B's STOP failed(as governor
>> enable flag is set to false by process A already ), it can still do
>> START operation, So my problem occurs.
>> My problem is that I see ondemand governor is started twice during
>> frequent governor switch and cpu hotplug stress test.
>>
>> The After seeing your patch for the return value checking, I think my
>> problem should not occur.
>> This issue really botherred me for a long time. :(
>
> Exactly, the problem was users of this API were abusing it as they didn't
> cared for its return value. I hope that is fixed widely now and in case
> some places are still left, they should be fixed as well.
>
> --
> viresh


Hi, Viresh
After checking your patch, I find that __cpufreq_set_policy function
doesn't check STOP and EXIT 's return value
is it on purpose? if not, I can provide a patch to add it.

Thanks
Xiaoguang
