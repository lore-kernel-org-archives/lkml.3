Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3FXO5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:57:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:54009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3FXO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:57:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,929,1363158000"; 
   d="scan'208";a="359545705"
Message-ID: <51C85E3A.5040609@intel.com>
Date: Mon, 24 Jun 2013 22:56:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Subject: Re: [Resend patch v8 06/13] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com> <1371694737-29336-7-git-send-email-alex.shi@intel.com> <51C80C33.4050606@intel.com> <CAKfTPtCz4bP05sqS7VBuZ_iDYBNGyb8sNUcoSTGbOkZoZU2D9g@mail.gmail.com> <CAPM31RKrvY4zVRQBKnaQjdH0ROO3nAvPn5biP0O3ogmfubuXbg@mail.gmail.com>
In-Reply-To: <CAPM31RKrvY4zVRQBKnaQjdH0ROO3nAvPn5biP0O3ogmfubuXbg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 07:06 PM, Paul Turner wrote:
>> AFAICT, the RT tasks activity is already taken into account by
>> decreasing the cpu_power that is used during load balance like in the
>> find_busiest_queue where weighted_cpuload is divided by cpu_power.
>>
> 
> Yes.  RT tasks used to be handled as having a very-large weight [e.g.
> 2*nice(-20)] but now we just scale cpu-power for how much non-RT time
> there is available.
> 

yes. you're right. thanks Vincent&Paul for all clarifying!

-- 
Thanks
    Alex
