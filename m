Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaDWQu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:50:27 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21255 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbaDWQuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:50:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,7417"; a="62402903"
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="666749930"
Message-ID: <5357EF4D.6080302@qti.qualcomm.com>
Date: Wed, 23 Apr 2014 09:50:21 -0700
From: Max Krasnyansky <maxk@qti.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Christoph Lameter <cl@linux.com>
Subject: Re: vmstat: On demand vmstat workers V3
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com> <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
In-Reply-To: <CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 04/22/2014 03:32 AM, Viresh Kumar wrote:
> On Thu, Oct 3, 2013 at 11:10 PM, Christoph Lameter <cl@linux.com> wrote:
>> V2->V3:
>> - Introduce a new tick_get_housekeeping_cpu() function. Not sure
>>   if that is exactly what we want but it is a start. Thomas?
>> - Migrate the shepherd task if the output of
>>   tick_get_housekeeping_cpu() changes.
>> - Fixes recommended by Andrew.
> 
> Hi Christoph,
> 
> This vmstat interrupt is disturbing my core isolation :), have you got
> any far with this patchset?

You don't mean an interrupt, right?
The updates are done via the regular priority workqueue.

I'm playing with isolation as well (has been more or less a background thing
for the last 6+ years). Our threads that run on the isolated cores are SCHED_FIFO
and therefor low prio workqueue stuff, like vmstat, doesn't get in the way.
I do have a few patches for the workqueues to make things better for isolation.

Max
