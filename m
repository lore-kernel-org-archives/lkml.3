Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab3HGSvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:51:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab3HGSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:51:37 -0400
Message-ID: <52029736.8040007@wwwdotorg.org>
Date: Wed, 07 Aug 2013 12:51:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 5/6] ARM: Tegra: start using cpufreq-cpu0 driver
References: <cover.1375886595.git.viresh.kumar@linaro.org> <6610c86618b781b00eba446ca19035e077d99691.1375886595.git.viresh.kumar@linaro.org> <520287EA.5060508@wwwdotorg.org> <CAKohpokOn4-RZE5mfoM+2p8jszWoGfOErrLShZmv86OgCMv+JA@mail.gmail.com> <5202898A.6050006@wwwdotorg.org> <CAKohpom3o1y+xXof3iKCn6SWxYKNAE=aBGO2P3JF+Y0Ce4GmQQ@mail.gmail.com>
In-Reply-To: <CAKohpom3o1y+xXof3iKCn6SWxYKNAE=aBGO2P3JF+Y0Ce4GmQQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 11:59 AM, Viresh Kumar wrote:
> On 7 August 2013 23:23, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> That link only describes why we shouldn't have a dedicated compatible
>> value for cpufreq. I certainly agree with that. However, I think it's
>> reasonable that whatever code binds to:
>>
>>         compatible = "arm,cortex-a9";
>>
>> ... should instantiate any virtual devices that relate to the CPU.
> 
> But how would we know here if platform really wants us to probe
> cpufreq-cpu0 driver? On multiplatform kernel there can be multiple
> cpufreq drivers available and there has to be some sort of code
> in DT or platform code that reflects which driver we want to use.

Presumably the code would look at the top-level DT node's compatible
value (e.g. "nvidia,tegra20").
