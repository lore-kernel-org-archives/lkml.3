Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab3INHmf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:42:35 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:45886 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3INHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:42:33 -0400
Date: Sat, 14 Sep 2013 09:41:51 +0200
From: Vladimir Murzin <murzin.v@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 211/228] cpufreq: tegra: remove calls to
 cpufreq_notify_transition()
Message-ID: <20130914074148.GA1862@hp530>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
 <69073c98beae28a6a75103dd202ec2a6b8b1a674.1379063063.git.viresh.kumar@linaro.org>
 <52339729.7030309@wwwdotorg.org>
 <CAKohpono-J-Ohzdn=pbNK+HhXhJ2Lf-UBM7OPynTgAwxLd4F4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <CAKohpono-J-Ohzdn=pbNK+HhXhJ2Lf-UBM7OPynTgAwxLd4F4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 14, 2013 at 09:39:31AM +0530, Viresh Kumar wrote:
> On 14 September 2013 04:22, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > I wonder if this series is bisectable? Perhaps I should just go and read
> > the rest of the series, but I presume there's a patch somewhere else
> > that adds those two cpufreq_notify_transition() to the cpufreq core.
> > Either that happens before this patch (in which case listeners will get
> > two notifications each time; perhaps that is safe?), or after this patch
> > (in which case with just this patch applied, no notifications will be
> > sent until a later patch!
> 
> Hmm.. Good Catch..
> 
> So, yes git bisect would be compilable but not runnable.. As we are
> already serialized notifications and so two PRE notifications will
> generate a crash..
> 
> But I don't want to get all that in a single patch as that would be:
> 
>  40 files changed, 192 insertions(+), 623 deletions(-)
> 
> And that would be hard to review it..
> 
> Any suggestions?
> 

It reminds me time of removing CONFIG_HOTPLUG and following __dev* attributes.
At least stats for 48c68c4 "Drivers: video: remove __dev* attributes" is:

135 files changed, 1017 insertions(+), 1129 deletions(-)

Maybe coccinelle script, which maintainers could run it on their trees, would
help?

Vladimir

> > Aside from that, all the Tegra-specific patches in this series,
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Thanks..
> 
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
