Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3C0Ncn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:32:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:35458 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391Ab3C0Ncm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276642301"
Message-ID: <5152F4EE.5000104@intel.com>
Date: Wed, 27 Mar 2013 21:32:30 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org> <1363955155-18382-6-git-send-email-vincent.guittot@linaro.org> <1364302359.5053.21.camel@laptop> <CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com> <1364308932.5053.46.camel@laptop> <CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com> <51527C17.3070901@intel.com> <CAKfTPtDK6vSDhGa9=ReaHt_oO8Xz2agZZ4x3q5Wvv6gXjhFevg@mail.gmail.com> <5152B215.2040808@intel.com> <CAKfTPtD0zYuskipbvukVWRh5rzqTaBiHsuMR8cBwmYieP=v=mQ@mail.gmail.com>
In-Reply-To: <CAKfTPtD0zYuskipbvukVWRh5rzqTaBiHsuMR8cBwmYieP=v=mQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 06:30 PM, Vincent Guittot wrote:
>> Arguing the performance/power balance does no much sense without
>> > detailed scenario. We just want to seek a flexible compromise way.
>> > But fixed buddy cpu is not flexible. and it may lose many possible
>> > powersaving fit scenarios on x86 system. Like if 2 SMT cpu can handle
>> > all tasks, we don't need to wake another core. or if 2 cores in one
>> > socket can handle tasks, we also don't need to wakeup another socket.
> Using 2 SMT for all tasks implies to accept latency and to share
> resources like cache and memory bandwidth so it means that you also
> accept some potential performance decrease which implies that someone
> must select this mode with a knob.
> The primary goal of the patchset is not to select between powersaving
> and performance but to stay in performance mode. We pack the small
> tasks in one CPU so the performance will not decrease but the low load
> scenario will consume less power. Then, I can add another step which
> will be more power saving aggressive with a potential cost of
> performance and i this case the buddy CPU will be updated dynamically
> according to the system load
> 

Predication of small task behavior is often wrong. so for performance
purpose, packing task is a bad idea.

-- 
Thanks
    Alex
