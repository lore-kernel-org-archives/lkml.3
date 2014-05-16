Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007AbaEPP0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:26:21 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46561 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbaEPP0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:26:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=XHy1jZ6EL8M+KByA1fhZkNc2Afvn2+QKaMe=0wyEo7Pg@mail.gmail.com>
References: <cover.1400230695.git.viresh.kumar@linaro.org>
	<CAJuA9aitMu_=OLT+=6pX=us03HVfrPZ1zCYFXfNg58W+-nzm3g@mail.gmail.com>
	<CAKohpokUP6rnV=UyES1GY0yqwiUndBrJFtw7fwJScsRigbE7tA@mail.gmail.com>
	<CAD=FV=XHy1jZ6EL8M+KByA1fhZkNc2Afvn2+QKaMe=0wyEo7Pg@mail.gmail.com>
Date: Fri, 16 May 2014 20:56:18 +0530
Message-ID: <CAKohpo=VKsAdSJLL+cvGnBMFLj8JDecd2ZRKfQtEc9ZmqkC1eg@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] cpufreq: add support for intermediate (stable)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Doug Anderson <dianders@chromium.org>
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

On 16 May 2014 20:50, Doug Anderson <dianders@chromium.org> wrote:
> Right, so I think on exynos no functionality will be broken once
> Thomas's cpufreq-cpu0 change lands (udelay will only run long, never
> short).  ...but from the purist standpoint we will be transitioning
> from 1.6 GHz => 800 MHz => 1.7 GHz without any notification about the
> 800 MHz.   You could imagine someone registering for cpufreq
> notifications that would care about the 800MHz transition.
>
> ...so it seems like we could wait for Thomas's patches to land as-is
> (since they make things better) and then atop that see about adding
> support for intermediate frequencies to cpufreq-cpu0.

Hmm, don't know. I think these patches aren't aimed at solving exynos's
problem but rather a general solution which must have already been there.

If some platform can work without it then its fine, but otherwise they should
use it, even if udelay does work for them..

So, I would propose to go ahead with these patches in linux-next and lets
see who all would use it.
