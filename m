Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab3INEJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 00:09:33 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:39371 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3INEJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 00:09:31 -0400
MIME-Version: 1.0
In-Reply-To: <52339729.7030309@wwwdotorg.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<69073c98beae28a6a75103dd202ec2a6b8b1a674.1379063063.git.viresh.kumar@linaro.org>
	<52339729.7030309@wwwdotorg.org>
Date: Sat, 14 Sep 2013 09:39:31 +0530
Message-ID: <CAKohpono-J-Ohzdn=pbNK+HhXhJ2Lf-UBM7OPynTgAwxLd4F4A@mail.gmail.com>
Subject: Re: [PATCH 211/228] cpufreq: tegra: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2013 04:22, Stephen Warren <swarren@wwwdotorg.org> wrote:
> I wonder if this series is bisectable? Perhaps I should just go and read
> the rest of the series, but I presume there's a patch somewhere else
> that adds those two cpufreq_notify_transition() to the cpufreq core.
> Either that happens before this patch (in which case listeners will get
> two notifications each time; perhaps that is safe?), or after this patch
> (in which case with just this patch applied, no notifications will be
> sent until a later patch!

Hmm.. Good Catch..

So, yes git bisect would be compilable but not runnable.. As we are
already serialized notifications and so two PRE notifications will
generate a crash..

But I don't want to get all that in a single patch as that would be:

 40 files changed, 192 insertions(+), 623 deletions(-)

And that would be hard to review it..

Any suggestions?

> Aside from that, all the Tegra-specific patches in this series,
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks..
