Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab3HHCsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:48:39 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:35877 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3HHCsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <52029736.8040007@wwwdotorg.org>
References: <cover.1375886595.git.viresh.kumar@linaro.org>
	<6610c86618b781b00eba446ca19035e077d99691.1375886595.git.viresh.kumar@linaro.org>
	<520287EA.5060508@wwwdotorg.org>
	<CAKohpokOn4-RZE5mfoM+2p8jszWoGfOErrLShZmv86OgCMv+JA@mail.gmail.com>
	<5202898A.6050006@wwwdotorg.org>
	<CAKohpom3o1y+xXof3iKCn6SWxYKNAE=aBGO2P3JF+Y0Ce4GmQQ@mail.gmail.com>
	<52029736.8040007@wwwdotorg.org>
Date: Thu, 8 Aug 2013 08:18:36 +0530
Message-ID: <CAKohpo=tKYx8KC6jX+qoqGKJBwpJbhGUD5cM4ErOMJ4NMB+hRA@mail.gmail.com>
Subject: Re: [PATCH 5/6] ARM: Tegra: start using cpufreq-cpu0 driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>, Shawn Guo <shawn.guo@linaro.org>
Cc: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2013 00:21, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 11:59 AM, Viresh Kumar wrote:
>> On 7 August 2013 23:23, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> That link only describes why we shouldn't have a dedicated compatible
>>> value for cpufreq. I certainly agree with that. However, I think it's
>>> reasonable that whatever code binds to:
>>>
>>>         compatible = "arm,cortex-a9";
>>>
>>> ... should instantiate any virtual devices that relate to the CPU.
>>
>> But how would we know here if platform really wants us to probe
>> cpufreq-cpu0 driver? On multiplatform kernel there can be multiple
>> cpufreq drivers available and there has to be some sort of code
>> in DT or platform code that reflects which driver we want to use.
>
> Presumably the code would look at the top-level DT node's compatible
> value (e.g. "nvidia,tegra20").

So you are actually asking us to get a compatibility list inside
cpufreq-cpu0 driver which will list all the platforms for which this driver
would work?

Honestly speaking I wasn't in favor of getting a platform-device
registered for cpufreq-cpu0 earlier and had few discussion on the
thread I passed to you.

The problem with the new solution you just proposed is, for every
new platform that comes in we need to update this file.. And that's
it probably..

Don't know how others would see it...
@Rafael/Rob/Shawn: Any suggestions here?
