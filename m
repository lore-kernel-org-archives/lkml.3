Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbaJ1XXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:23:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:43167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbaJ1XXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,805,1406617200"; 
   d="scan'208";a="622410700"
Message-ID: <5450253B.5020802@linux.intel.com>
Date: Wed, 29 Oct 2014 07:22:35 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027074419.GE10501@worktop.programming.kicks-ass.net> <544F4B31.7050308@linux.intel.com> <20141028082503.GN3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141028082503.GN3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/28 16:25, Peter Zijlstra wrote:
> On Tue, Oct 28, 2014 at 03:52:17PM +0800, Li, Aubrey wrote:
> 
>> Both clocksource and clockevents are not per-cpu device, why do we need
>> to run their suspend callback on *each* cpu?
> 
> Uhm, you mean to say we don't use per-cpu timer lists and per-cpu timer
> hardware for clockevents then?
> 

>From OS level, currently tick device is per-cpu implementation while
clocksource and clockevent devices are global device.

We already stop tick by clockevents_notify(suspend) on each cpu, that
addresses per-cpu timer list.

And, we already call clocksource_suspend() and clockevents_suspend() in
timekeeping_suspend() on the tick timer CPU. Yes, we didn't suspend
per-cpu timer hardware on x86 because x86 does not have lapic timer
suspend implementation. If we need to implement this, I think we can do
the cross-CPU calls in clocksource/clockevents suspend(), but I didn't
see any necessary we need to do this now.

so, I think we are okay now, :)

Thanks,
-Aubrey
