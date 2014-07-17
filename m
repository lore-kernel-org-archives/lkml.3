Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaGQHls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 03:41:48 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:38534 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaGQHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 03:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140717093518.486ac244@free-electrons.com>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
	<CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
	<1450785.beFNo3ByBF@vostro.rjw.lan>
	<CAKohpomPAp74Sf_DxqzFk1WzUTx5m=G-nj+d+QHW5q=gnVphhA@mail.gmail.com>
	<20140717093518.486ac244@free-electrons.com>
Date: Thu, 17 Jul 2014 13:11:45 +0530
Message-ID: <CAKohpokZXUzXKRWBje7QF_jrvOd5dmfmWQ2Csf3xiMuvT_vPYA@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Nishanth Menon <nm@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Simon Horman <horms@verge.net.au>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Rob Herring <rob.herring@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2014 13:05, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> Could you summarize what is the issue with the binding?
>
> At least for the case where we have one clock per CPU, the DT binding
> is really dead simple: each CPU node can carry a "clocks" property, and
> a "clock-latency" property. I really don't see why a long discussion is
> needed to agree on such a binding.
>
> Now, if the DT binding problem is related to those cases where you have
> siblings, i.e one clock controlling *some* of the CPUs, but not all
> CPUs or just one CPU, then maybe we could leave this aside for now,

Yeah, we are stuck on that for now.

> only support the following cases:
>
>  * One clock for all CPUs
>  * One clock for each CPU

Yeah, so I also proposed this yesterday that we stick to only these
two implementations for now. And was looking at how would the
cpufreq-generic driver come to know about this.

So, one way out now is to see if "clocks" property is defined in
multiple cpu nodes, if yes don't compare them and consider separate
clocks for each cpu. We don't have to try matching that to any other
node, as that's a very bad idea. Mike was already very upset with that :)

@Stephen/Rafael: Does that sound any better? Ofcourse the final thing
is to get bindings to figure out relations between CPUs..
