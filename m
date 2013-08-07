Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3HGL37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:29:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60155 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab3HGL35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:29:57 -0400
Message-ID: <52022FC2.2010109@arm.com>
Date: Wed, 07 Aug 2013 12:30:10 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sudeep.KarkadaNagesha@arm.com
Subject: Re: [PATCH] cpufreq: exynos5440: Fix to skip when new frequency same
 as current
References: <1375874171-16951-1-git-send-email-amit.daniel@samsung.com> <CAKohpokp04HXau1fOA6w9K675LwRw6uCCZZKyFAJtF1_pkcC=Q@mail.gmail.com>
In-Reply-To: <CAKohpokp04HXau1fOA6w9K675LwRw6uCCZZKyFAJtF1_pkcC=Q@mail.gmail.com>
X-OriginalArrivalTime: 07 Aug 2013 11:29:53.0736 (UTC) FILETIME=[6FD05C80:01CE9361]
X-MC-Unique: 113080712295403601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 12:22, Viresh Kumar wrote:
> On 7 August 2013 16:46, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
>> This patch fixes the issue of un-necessary setting the clock controller
>> when the new target frequency is same as the current one. This case usually
>> occurs with governors like ondemand which passes the target frequency as the
>> percentage of average frequency. This check is present in most of the cpufreq
>> driver.
>>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/cpufreq/exynos5440-cpufreq.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> Applied.
Hi Viresh,

Any particular reason we need this check in all drivers after your
commit: 5a1c0228 "cpufreq: Avoid calling cpufreq driver's target()
routine if target_freq == policy->cur"

I think it can removed from all drivers, am I missing something ?

Regards,
Sudeep


