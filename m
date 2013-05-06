Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3EFP0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:26:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:48205 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab3EFP0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:26:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="332583190"
Message-ID: <5187CB8E.6090303@intel.com>
Date: Mon, 06 May 2013 23:26:06 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com> <5187760D.8060900@intel.com> <CAPM31RJSi1X4PbK86NKiAJFtiq7q2_3t4Ke=sqgXO5rLjbeh7A@mail.gmail.com>
In-Reply-To: <CAPM31RJSi1X4PbK86NKiAJFtiq7q2_3t4Ke=sqgXO5rLjbeh7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 06:22 PM, Paul Turner wrote:
>>> >> This is missing a scale_load() right?  Further: Why not put this in
>>> >> __sched_fork?
>> >
>> > scale_load is not working now. Anyway I can add this.
> I believe someone tracked down a plausible cause for this:
> A governor was examining the values and making a mess with the scaled
> ones.  I'm sorry, I don't have the post off hand.
> 
> You actually likely ideally want this _on_ for these patches; the
> available resolution with SCHED_LOAD_SHIFT=10 disappears really
> quickly and scaling by runnable_avg only further accelerates that.

Sorry for can not follow you. Do you mean the scaling by runnable_avg is
better than scale_load?

In fact, after think twice of scale_load, guess better to figure out a
good usage for it before enabling blindly.

> We should try to get this generally turned on by default again.
>> >
-- 
Thanks
    Alex
