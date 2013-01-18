Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3ARWW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:22:29 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45910 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab3ARWW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:22:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nishanth Menon <nm@ti.com>, MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-pm <linux-pm@vger.kernel.org>, Kevin <khilman@deeprootsystems.com>,
        lkml <linux-kernel@vger.kernel.org>, lo <linux-omap@vger.kernel.org>,
        Jack <jack@embed.me.uk>, Alexander <holler@ahsoftware.de>
Subject: Re: [PATCH 0/4] OPP usage fixes for RCU locking
Date: Fri, 18 Jan 2013 23:28:22 +0100
Message-ID: <2007041.tOt4VKpdOD@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358538755-29109-1-git-send-email-nm@ti.com>
References: <1358538755-29109-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 01:52:31 PM Nishanth Menon wrote:
> Hi,
> Despite being documented in function documentation and in
> Documentation/power/opp.txt, many of the users of OPP APIs
> dont honor RCU lock usage appropriately.
> 
> This recently appeared in IRC discussion earlier today [1]. 
> I did an audit of current usage and the following series
> is a result of this.
> 
> NOTE:
> 1. The patch "PM / devfreq: exynos4_bus: honor RCU lock usage" has only
>    been build tested as I dont have an exynos platform to try it on. I have
>    tried to make it as least intrusive as possible and at least reviewed
>    to ensure I haven't screwed anything up.
> 
> Other than this, I have added appropriate tested by information in requisite
> patches.

Thanks for the fixes.

MyungJoo, do you want me to take the devfreq ones too?

Rafael


> Series is based off: v3.8-rc4 tag
> Also available in the following location[2]:
> https://github.com/nmenon/linux-2.6-playground branch: post/pm/opp-fixes-v1
> 
> Nishanth Menon (4):
>   cpufreq: OMAP: use RCU locks around usage of OPP
>   cpufreq: cpufreq-cpu0: use RCU locks around usage of OPP
>   PM / devfreq: add locking documentation for recommend_opp
>   PM / devfreq: exynos4_bus: honor RCU lock usage
> 
>  drivers/cpufreq/cpufreq-cpu0.c |    5 +++
>  drivers/cpufreq/omap-cpufreq.c |    3 ++
>  drivers/devfreq/devfreq.c      |    5 +++
>  drivers/devfreq/exynos4_bus.c  |   94 ++++++++++++++++++++++++++++------------
>  4 files changed, 80 insertions(+), 27 deletions(-)
> 
> [1] http://www.beagleboard.org/irclogs/index.php?date=2013-01-18#T14:14:07
> [2] https://github.com/nmenon/linux-2.6-playground/commits/post/pm/opp-fixes-v1
> 
> Regards,
> Nishanth Menon
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
