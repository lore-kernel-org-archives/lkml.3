Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaGQA2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:28:25 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:52124 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaGQA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:28:23 -0400
X-Greylist: delayed 57813 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 20:28:23 EDT
MIME-Version: 1.0
In-Reply-To: <1450785.beFNo3ByBF@vostro.rjw.lan>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<CAKohpo=Z5gEHOC5q40q8dfQfoNP5-WyhjG1arV99zJiG2c+6Xg@mail.gmail.com>
	<CAKohpo=bUMKa752fBXZTb0WPYMfJtuR5uk7z-YaXYV63fhJWtg@mail.gmail.com>
	<1450785.beFNo3ByBF@vostro.rjw.lan>
Date: Thu, 17 Jul 2014 05:58:22 +0530
Message-ID: <CAKohpomPAp74Sf_DxqzFk1WzUTx5m=G-nj+d+QHW5q=gnVphhA@mail.gmail.com>
Subject: Re: [PATCH 00/14] cpufreq: cpu0: Extend support beyond CPU0, V2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <rob.herring@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Simon Horman <horms@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2014 02:48, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I don't like that idea, but I wonder what other people think.

Hmm, the other thread around looking at the bindings is really slow.

One common thing around the platforms which want to use
cpufreq-cpu0 is they have different clocks for ALL CPUs.

I was wondering if instead of a clock-matching routine, we can provide
some temporary relief to them via some other means.

I meant we can allow cpufreq-cpu0/generic to either set policy->cpus
to ALL CPUs or just 1. So that existing and these new platforms can
atleast get going..

But don't know how should we do that. Not a binding ofcourse, a
Kconfig option could work but multiplatform stuff would break. What
else?

Maybe platform data as we are handling cpufreq-cpu0 with a platform
device?

--
viresh
