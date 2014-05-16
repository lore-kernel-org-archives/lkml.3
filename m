Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaEPPUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:20:49 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:43961 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbaEPPUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:20:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokUP6rnV=UyES1GY0yqwiUndBrJFtw7fwJScsRigbE7tA@mail.gmail.com>
References: <cover.1400230695.git.viresh.kumar@linaro.org>
	<CAJuA9aitMu_=OLT+=6pX=us03HVfrPZ1zCYFXfNg58W+-nzm3g@mail.gmail.com>
	<CAKohpokUP6rnV=UyES1GY0yqwiUndBrJFtw7fwJScsRigbE7tA@mail.gmail.com>
Date: Fri, 16 May 2014 08:20:45 -0700
X-Google-Sender-Auth: HdOeklUwX9ftUQCTD6v1Zfg3OP4
Message-ID: <CAD=FV=XHy1jZ6EL8M+KByA1fhZkNc2Afvn2+QKaMe=0wyEo7Pg@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] cpufreq: add support for intermediate (stable)
From: Doug Anderson <dianders@chromium.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Abraham <ta.omasab@gmail.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arvind Chauhan <arvind.chauhan@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 3:10 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 May 2014 15:39, Thomas Abraham <ta.omasab@gmail.com> wrote:
>> In the given example above, the reworked implementation of cpufreq for
>> exynos maintains the transition frequency at 800MHz / 4 = 200MHz by
>> using a clock divider. So the transition frequency is ensured to be
>> less than or equal to the pre-transition cpu clock frequency.
>
> Thanks for the information. But I think this patchset is still required for
> many platforms. Anyway these extra notifications must be sent for exynos
> as well.

Right, so I think on exynos no functionality will be broken once
Thomas's cpufreq-cpu0 change lands (udelay will only run long, never
short).  ...but from the purist standpoint we will be transitioning
from 1.6 GHz => 800 MHz => 1.7 GHz without any notification about the
800 MHz.   You could imagine someone registering for cpufreq
notifications that would care about the 800MHz transition.

...so it seems like we could wait for Thomas's patches to land as-is
(since they make things better) and then atop that see about adding
support for intermediate frequencies to cpufreq-cpu0.

-Doug
