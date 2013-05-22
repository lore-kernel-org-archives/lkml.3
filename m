Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3EVK11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:27:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18064 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab3EVK1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:27:23 -0400
X-AuditID: cbfee61a-b7efb6d000003eed-29-519c9d8ade15
Date: Wed, 22 May 2013 12:27:00 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>, "Rafael J. Wysocky" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3] LAB: Support for Legacy Application Booster governor
Message-id: <20130522122700.104ca5cd@amdc308.digital.local>
In-reply-to: <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAd2uuXMCDVomClk8bfrBbjHvs6xF
	59knzBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZdBz5xmyx8auHA5fHnWt72DzWTXvL7NG3
	ZRWjx6PFLYwenzfJBbBGcdmkpOZklqUW6dslcGWc2HyUveCiYMW/u3fYGxi7+LoYOTgkBEwk
	Gv9ndTFyApliEhfurWcDsYUEFjFKnNmQ1MXIBWS3M0nMmnWaFSTBIqAqceZkEyOIzSagJ/H5
	7lMmkDkiAloSL2+mgtQzC1xgkjh1aRZYXFjAT+LIckcQk1fAWqJ7mTBIJ6dAsMSf3hXsEKv6
	GSXeXOYGsfkFJCXa//1ghjjHTuLcpw1gNbwCghI/Jt9jAbGZgTZt3tbECmHLS2xe85Z5AqPg
	LCRls5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDw8k9rBuLLB4hCjAAej
	Eg/vg9rZgUKsiWXFlbmHGCU4mJVEeBWC5gQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0o
	JJCeWJKanZpakFoEk2Xi4JRqYAy7zHB560upHU0zD/50UdwboXJw+ZHGLZxTzwhdOaZqxr4/
	+V3xVAbN3lKXmE7j2c9WspxZoxnb7eVR1xvDzHZwbnT99QtnA7b9VvratUnuhk2arp3A2jMe
	p+aKqNYb+Kpe9Xn+U+auy3vNrIUH70hM2xWY7M7X5fB3f/GyyqagK04Re69eYldiKc5INNRi
	LipOBAA9BvDmgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thanks for reply.

> On 3 May 2013 19:37, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> > From: Lukasz Majewski <l.majewski@samsung.com>
> 
> > 2. New LAB governor.
> > It calculates number of idle CPUs (based on scheduler data). On
> > this basis it chose proper first level polynomial function for
> > approximation. Moreover it enables overclocking when single, heavy
> > loaded CPU is running.
> 
> Hi Lukasz,
> 
> I am still not sure about this governor. Do you have some results
> with which you can tell how is it better than ondemand/conservative?

I will provide proper test results. As a test platform I've used
Exynos4 CPU (4 cores) with TIZEN OS on it.

> 
> With or without overclocking. i.e. Apply only overclocking support to
> ondemand/conservative..

I think, that overclocking support is crucial here. As you pointed out
- ondemand and conservative benefit from it. Therefore, I would urge
  for its mainline acceptance.

(code for reference)
http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq

In this RFC (patch 1/3), I've decided to put the burden of overclocking
support to platform code (cpufreq/exynos-cpufreq.c and
cpufreq/exynos4x12-cpufreq.c). 

Those changes aren't intrusive for other boards/archs. Moreover
overclocking is closely related to processor clocking/power dissipation
capabilities, so SoC specific code is a good place for it.


What DO need a broad acceptance is the overclocking API proposed at:
include/linux/cpufreq.h 

This introduces interface to which others will be bind. It shouldn't be
difficult to implement overclocking at other SoCs (as it was proposed
for Exynos).

Feedback is welcome, since I might have overlooked oddities present at
other SoCs.



> 
> If you are using Android, maybe check Interactive too (Though it
> itsn't mainlined yet).

I will also delve into "Interactive" governor.




As a side note:

The "core" cpufreq code modification (patch 3/3) counts only 22 lines,
so this patch series definitely is not intrusive.

> 
> @Rafael: What do you think about this patchset?
> 
> --
> viresh

-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
