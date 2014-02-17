Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaBQGI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:08:56 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:61994 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaBQGIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <52FE71BD.3020103@wwwdotorg.org>
References: <cover.1392273722.git.viresh.kumar@linaro.org>
	<52FE71BD.3020103@wwwdotorg.org>
Date: Mon, 17 Feb 2014 11:38:53 +0530
Message-ID: <CAKohpo=7Kbvh5UN9iZ6V3e=1ZY6y5_grQjxj6raEL_djHnMZrQ@mail.gmail.com>
Subject: Re: [PATCH V5 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Kgene Kim <kgene.kim@samsung.com>,
        jinchoi@broadcom.com, Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2014 01:12, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/12/2014 11:50 PM, Viresh Kumar wrote:
>> This patchset creates/calls cpufreq suspend/resume callbacks from dpm_{suspend|resume}()
>> for handling suspend/resume of cpufreq governors and core.
>
> Are these patches for 3.14 or 3.15?

3.15

> I ask because I just tested Linus's master from a few days back (some
> point after v3.14-rc2; commit 9398a10cd964 Merge tag
> 'regulator-v3.14-rc2'), and I see a lot of the following messages during
> suspend and/or resume (about 2-7 times, perhaps more of them from the
> resume path, but it's hard to tell):
>
> cpufreq: __cpufreq_driver_target: Failed to change cpu frequency: -16

That's because you return -EBUSY from your tegra_cpu_init() once
suspend/resume has started. Probably the print message is new here,
and so you are able to see it failing.. Nothing else should have changed
otherwise.

> This series does appear to solve those, so I think at least part of it
> needs to be applied for 3.14.

Because we disallow calls to __cpufreq_driver_target() after suspend/
resume have started.

> Also, I sometimes see the following during resume. I saw it twice with
> Linus's tree, but then I did 10 more reboot+suspend+resume cycles and
> couldn't repro it, and I saw it once with Linus's tree plus this series
> applied, then couldn't reproduce it in 5 more tries.

> Do you have any idea what the problem might be, and how to solve it?

Not yet, will check..
