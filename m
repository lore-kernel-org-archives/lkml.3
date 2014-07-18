Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbaGRECJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:02:09 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60281 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaGRECG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:02:06 -0400
MIME-Version: 1.0
In-Reply-To: <53C85BE5.6030901@codeaurora.org>
References: <1405553740-5067-1-git-send-email-sboyd@codeaurora.org>
	<CAKohpond9aNvX+x--G7AADkRhAu1iZ5mFW8pDvAXJ6yp_CCH_A@mail.gmail.com>
	<53C85BE5.6030901@codeaurora.org>
Date: Fri, 18 Jul 2014 09:32:06 +0530
Message-ID: <CAKohpon5787nmLO02=UtSkQZY=p3F_xZ0_E-tu+psME_UoWdHQ@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: cpufreq: Avoid sleeping while atomic
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 July 2014 04:57, Stephen Boyd <sboyd@codeaurora.org> wrote:
> First you need to enable sleeping while atomic checking, but in reality,
> I assume nobody has tried inserting a cpufreq driver as a module. The

I did for sure, but long back. Over 6 months atleast :)

> might_sleep() code has a check to see if the system_state is
> SYSTEM_RUNNING. If it isn't running then there isn't a warning and
> might_sleep() doesn't flag any problem. I wonder if that is actually the
> right thing to do though? Perhaps the intention of that code is to skip
> warning early on in the boot path when the scheduler isn't up and
> running yet. But once the scheduler is running (which is fairly early
> nowadays) I would think we want might_sleep() to trigger warnings. Maybe
> that check in might_sleep() needs to be updated to check for "scheduler
> running" instead of "system running"?
> Right. It seems that we moved to RCU in commit
> 0f5c890e9b9754d9aa5bf6ae2fc00cae65780d23 so the real Fixes line should be:
>
> Fixes: 0f5c890e9b97 "PM / OPP: Remove cpufreq wrapper dependency on
> internal data organization"

Right.

> One way to avoid this problem is to put things back the way they were
> before that change. Is there any real benefit to having this code live
> in drivers/cpufreq/ instead of just under some config option in
> drivers/base/power/opp.c?

Maybe Nishanth can give more arguments than I can :), but the idea was
just to keep cpufreq stuff together..
