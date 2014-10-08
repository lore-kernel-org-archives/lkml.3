Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaJHGxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:53:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:45220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaJHGxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:53:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,675,1406617200"; 
   d="scan'208";a="585193307"
Message-ID: <5434DE4A.60604@intel.com>
Date: Wed, 08 Oct 2014 14:48:42 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH 1/1] Cpufreq: Keep cpufreq sysfs nodes across S2RAM/S2DISK
 when using intel_pstate driver.
References: <1411023787-11458-1-git-send-email-tianyu.lan@intel.com> <CAKohpokht4=7XCftPYa5PqpPMN-O-5b_RjJ3BgHnxjYV4VzyTg@mail.gmail.com>
In-Reply-To: <CAKohpokht4=7XCftPYa5PqpPMN-O-5b_RjJ3BgHnxjYV4VzyTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry later response and just back from vacation.

On 2014年09月29日 16:20, Viresh Kumar wrote:
> But this change is buggy.. Because you are updating 'cpufreq_suspended'
> before actually stopping the governor, any calls to __cpufreq_governor()
> will be converted to NO-operations because of this in __cpufreq_governor():
> 
> /* Don't start any governor operations if we are entering suspend */
> if (cpufreq_suspended)
>     return 0;
> 
> And so the governor's will never stop :(
> 
> So you need to keep the above line where it was :)
> 

Yes, you are right. Thanks for fixing it.
-- 
Best regards
Tianyu Lan
