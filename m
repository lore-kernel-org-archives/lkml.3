Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3KVIaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 03:30:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:39407 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab3KVIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 03:30:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,750,1378882800"; 
   d="scan'208";a="439734855"
Message-ID: <528F138B.1090107@intel.com>
Date: Fri, 22 Nov 2013 16:19:23 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across
 system suspend/resume
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan> <1384616184-6197-1-git-send-email-tianyu.lan@intel.com> <5288425A.6000501@linaro.org> <528F0C9E.8020409@linaro.org>
In-Reply-To: <528F0C9E.8020409@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年11月22日 15:49, viresh kumar wrote:
> On Sunday 17 November 2013 09:43 AM, viresh kumar wrote:
>> On 16 November 2013 21:06, Lan Tianyu <tianyu.lan@intel.com> wrote:
> 
>> But I don't really like the solution here. You are handling frozen for EXIT in
>> cpufreq-core and for INIT in governor. That doesn't look like the right
>> approach. There are out of tree governors too (I know we don't care about them
>> :)), and those also need to adapt with some policy made at cpufreq-core level.
>>
>> I told you that I had another solution for this problem, pretty similar to
>> yours. It looked like this:
> 
> Hi Lan,
> 

Hi Viresh:

> There is some confusion going on here :)
> 

I think you also are in the Cc list and replied the mail.:)
https://lkml.org/lkml/2013/11/21/273

> There were few problems in the approach in your patch, which I have mentioned
> above, and Rafael agreed to them..

I only saw the out-of-tree governor issue your mentioned but where they
are? How upstream kernel cares them?

> 
>> But after the PM notifiers patch I even don't want this to go.. I will make sure
>> that that patch goes in, in one form or another :)
> 
> And I was still trying to get a better solution in place of these changes. And
> was going on the suggestions you gave about calling cpufreq callbacks from
> dpm_{suspend|resume}_noirq() calls.. And I am on my way to get things fixed that
> way. And so we don't actually need this patch anymore (I just saw that you have
> sent another version of it, probably because Rafael asked? Don't know what
> happened there :))..
> 
> So, I will try to get something working soon for you and Nishanth..
> 

-- 
Best regards
Tianyu Lan
