Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3DNB3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 21:29:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:19032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab3DNB3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 21:29:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,469,1363158000"; 
   d="scan'208";a="321980237"
Message-ID: <516A0652.8040505@intel.com>
Date: Sun, 14 Apr 2013 09:28:50 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Len Brown <lenb@kernel.org>, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com> <516724F5.20504@kernel.org> <5167C9FA.8050406@intel.com> <20130412162348.GE2368@pd.tnic>
In-Reply-To: <20130412162348.GE2368@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2013 12:23 AM, Borislav Petkov wrote:
> On Fri, Apr 12, 2013 at 04:46:50PM +0800, Alex Shi wrote:
>> > Thanks a lot for comments, Len!
> AFAICT, you kinda forgot to answer his most important question:
> 
>> > These numbers suggest that this patch series simultaneously
>> > has a negative impact on performance and energy required
>> > to retire the workload.  Why do it?

Even some scenario the total energy cost more, at least the avg watts
dropped in that scenarios. Len said he has low p-state which can work
there. but that's is different. I had sent some data in another email
list to show the difference:

The following is 2 times kbuild testing result for 3 kinds condiation on
SNB EP box, the middle column is the lowest p-state testing result, we
can see, it has the lowest power consumption, also has the lowest
performance/watts value.
At least for kbuild benchmark, powersaving policy has the best
compromise on powersaving and power efficient. Further more, due to cpu
boost feature, it has better performance in some scenarios.

   powersaving + ondemand  userspace + fixed 1.2GHz performance+ondemand
x = 8    231.318 /75 57           165.063 /166 36        253.552 /63 62
x = 16   280.357 /49 72           174.408 /106 54        296.776 /41 82
x = 32   325.206 /34 90           178.675 /90 62         314.153 /37 86

x = 8    233.623 /74 57           164.507 /168 36        254.775 /65 60
x = 16   272.54  /38 96           174.364 /106 54        297.731 /42 79
x = 32   320.758 /34 91           177.917 /91 61         317.875 /35 89
x = 64   326.837 /33 92           179.037 /90 62         320.615 /36 86

-- 
Thanks
    Alex
