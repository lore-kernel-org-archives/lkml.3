Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaENR6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:58:31 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58792 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaENR61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:58:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140514142739.GA8612@ulmo>
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com>
	<1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com>
	<53725FED.7050303@wwwdotorg.org>
	<20140514142739.GA8612@ulmo>
Date: Wed, 14 May 2014 10:58:26 -0700
Message-ID: <CAL1qeaGS-78QaiMN-3zXYYXu+K1s7u2rFXQkt7-MRJQS1-sW5A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
From: Andrew Bresticker <abrestic@google.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 7:27 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> As for shared clocks I'm only aware of one use-case, namely EMC scaling.
> Using clocks for that doesn't seem like the best option to me. While it
> can probably fix the immediate issue of choosing an appropriate
> frequency for the EMC clock it isn't a complete solution for the problem
> that we're trying to solve. From what I understand EMC scaling is one
> part of ensuring quality of service. The current implementations of that
> seems to abuse clocks (essentially one X.emc clock per X clock) to
> signal the amount of memory bandwidth required by any given device. But
> there are other parts to the puzzle. Latency allowance is one. The value
> programmed to the latency allowance registers for example depends on the
> EMC frequency.
>
> Has anyone ever looked into using a different framework to model all of
> these requirements? PM QoS looks like it might fit, but if none of the
> existing frameworks have what we need, perhaps something new can be
> created.

On Exynos we use devfreq, though in that case we monitor performance
counters to determine how internal buses should be scaled - not sure
if Tegra SoCs have similar counters that could be used for this
purpose.  It seems like EMC scaling would fit nicely within the PM QoS
framework, perhaps with a new PM_QOS_MEMORY_THROUGHPUT class.

-Andrew
