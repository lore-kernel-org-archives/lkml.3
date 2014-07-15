Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaGOEfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 00:35:23 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:57269 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaGOEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 00:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <53C42AA8.8010107@codeaurora.org>
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org>
	<1405052287-4744-1-git-send-email-skannan@codeaurora.org>
	<CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
	<2f549e6e4871ccf2a94dd4c8872c7a0b.squirrel@www.codeaurora.org>
	<CAKohpokhmj1OkCRj=X+Q7eYiun8fsqD2dpEt66VKYnqo3dENVA@mail.gmail.com>
	<53C0A12A.2060204@codeaurora.org>
	<CAKohpon9en_VnSx+CVydPsWBHtArvmazn0hrodrRJt9jgOa0-g@mail.gmail.com>
	<53C42AA8.8010107@codeaurora.org>
Date: Tue, 15 Jul 2014 10:05:19 +0530
Message-ID: <CAKohpomkqbHZo9KrJMSwsEKGt6+Ac2Fg2X0+S7ZAo=OzhAc45g@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 July 2014 00:38, Saravana Kannan <skannan@codeaurora.org> wrote:
> Yeah, it definitely crashes if policy->cpu if an offline cpu. Because the
> mutex would be uninitialized if it's stopped after boot or it would never
> have been initialized (depending on how you fix policy->cpu at boot).
>
> Look at this snippet on the actual tree and it should be pretty evident.

Yeah, I missed it. So the problem is we initialize timer_mutex's for
policy->cpus. So we need to do that just for policy->cpu and also we don't
need a per-cpu timer_mutex anymore.
