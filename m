Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab3J1KZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:25:37 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43786 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3J1KZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130628110730.GA6626@twins.programming.kicks-ass.net>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
	<51C7B9B8.6090309@intel.com>
	<CAPM31RKq4sVR2_mU8PWx8dK+STQDj3Geyi8dVg3MnL=ymjfV6Q@mail.gmail.com>
	<51C867CF.70908@intel.com>
	<CAPM31RLTrQ_E6VAwO000zcL09F1oV7vgkjTJXY9wPC-pZ_6h0Q@mail.gmail.com>
	<20130628110730.GA6626@twins.programming.kicks-ass.net>
Date: Mon, 28 Oct 2013 11:25:34 +0100
Message-ID: <CAFTL4hxSfWOb_DVryjGY4hgsaoBFi7zfbKuJC6eMk4+4nQOf-Q@mail.gmail.com>
Subject: Re: [Resend patch v8 0/13] use runnable load in schedule balance
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/28 Peter Zijlstra <peterz@infradead.org>:
> On Fri, Jun 28, 2013 at 03:56:25AM -0700, Paul Turner wrote:
>
>> So this is actually an interesting idea, but don't think of it as
>> overweight.  What "cfs_rq->blocked_load_avg / 2" means is actually
>> blocked_load_avg one period from now.  This is interesting because it
>> makes the (reasonable) supposition that blocked load is not about to
>> immediately wake, but will continue to decay.
>>
>> Could you try testing the gvr_lb_tip branch at
>> git://git.kernel.org/pub/scm/linux/kernel/git/pjt/sched-tip.git ?
>>
>> It's an extension to your series that tries to improve some of the
>> cpu_load interactions in an alternate way to the above.
>>
>> It seems a little better on one and two-socket machines; but we
>> couldn't reproduce/compare to your best performance results since they
>> were taken on larger machines.
>
> Oh nice.. it does away with the entire cpu_load[] array thing. Just what
> Frederic needs for his NOHZ stuff as well -- he's currently abusing
> LB_BIAS for that.

Hi guys,

Is there any updates on the status of this work? I'm getting back on
fixing the cpu_load for full dynticks and this patchset was apparently
taking care of that.

Thanks.
