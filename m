Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3DAPhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:37:13 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:41351 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab3DAPhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1364804657-16590-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Mon, 1 Apr 2013 21:07:08 +0530
X-Google-Sender-Auth: 819GElSb_6xdwhMv9aKUTJexwcA
Message-ID: <CAOh2x=nPJa0GReiN=OHLG=m4Gq51F=4VppdaQL20xi-aUa8x2Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] cpufreq: Introduce LAB cpufreq governor.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, sw0312.kim@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 1:54 PM, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> <<Purpose>>
>  One of the problem of ondemand is that it considers the most busy
> cpu only while doesn't care how many cpu is in busy state at the
> moment. This may results in unnecessary power consumption, and it'll
> be critical for the system having limited power source.
>
>  To get the best energy efficiency, LAB governor considers not only
> idle time but also the number of idle cpus. It primarily focuses on
> supplying adequate performance to users within the limited resource.
> It checks the number of idle cpus then controls the maximum frequency
> dynamically. And it also applies different frequency increasing level
> depends on that information. In simple terms the less the number of
> busy cpus, the better performance will be given.
>  In addition, stable system's power consumption in the busy state can
> be achieved also with using LAB governor. This will help to manage and
> estimate power consumption in certain system.

Hi Jonghwa,

First of all, i should accept that i haven't got to the minute details
about your
patch until now but have done a broad review of it.

There are many things that i am concerned about:
- I don't want an additional governor to be added to cpufreq unless there is a
very very strong reason for it. See what happened to earlier attempts:

https://lkml.org/lkml/2012/2/7/504

But it doesn't mean you can't get it in. :)

- What the real logic behind your patchset: I haven't got it
completely with your
mails. So what you said is:

  - The lesser the number of busy cpus: you want to run at higher freqs
  - The more the number of busy cpus: you want to run at lower freqs

But the basic idea i had about this stuff was: The more the number of
busy cpus, the more loaded the system is, otherwise scheduler wouldn't
have used so many cpus and so there is need to run at higher frequency
rather than a lower one. Which would save power in a sense.. Finish work
early and let most of the cpus enter idle state as early as possible. But
with your solution we would run at lower frequencies and so these cpus
will take longer to get into idle state again. This will really kill
lot of power.

Think about it.

- In case you need some sort of support on this use case, why replicate ondemand
governor again by creating another governor. I have had some hard time removing
the amount of redundancy inside governors and you are again going towards that
direction. Modifying ondemand governor for this response would be a
better option.

- You haven't rebased of latest code from linux-next :)

--
viresh
