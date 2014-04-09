Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbaDIBWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:22:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:18611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbaDIBWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:22:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,822,1389772800"; 
   d="scan'208";a="489604834"
Message-ID: <5344A0A3.9030909@intel.com>
Date: Wed, 09 Apr 2014 09:21:39 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org" 
	<abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org>
CC: "Wu, Fengguang" <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [clocksource] INFO: possible irq lock inversion dependency detected
References: <5343740C.9010609@intel.com> <CAKohpomRb1pix3zQWeY0mKkfuikUtR6w+PUOTzQV_hngPrpHRw@mail.gmail.com>
In-Reply-To: <CAKohpomRb1pix3zQWeY0mKkfuikUtR6w+PUOTzQV_hngPrpHRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 01:21 PM, Viresh Kumar wrote:
> On 8 April 2014 09:29, Jet Chen <jet.chen@intel.com> wrote:
>> (Sorry for previous bad format email)
>> Your patch on my testing branch in LKP system:
>> git://bee.sh.intel.com/git/tchen37/linux.git timer_debug3 got the below
>> dmesg.
>> FYI, I applied your patch on the top of commit
>> 6378cb51af5f4743db0dcb3cbcf862eac5908754 - timer: don't migrate pinned
>> timers.
>
> Hi Jet,
>
> Thanks for your efforts. It looks like we must use spin_lock_irqsave() here.
> And that's all we need to fix this issue..
>

spin_lock_irqsave() does fix this issue.

Tested-by: Jet Chen <jet.chen@intel.com>

> To get the right order in which patches must be applied (obviously with the
> updates I have), please pick this branch:
>
> git://git.linaro.org/people/viresh.kumar/linux.git isolate-cpusets
>
> I hope this fixes the issues you were getting.
>

