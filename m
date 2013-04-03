Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986Ab3DCCW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:22:57 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47595 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565Ab3DCCW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <515B90A5.7080403@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
 <1364654108-16307-11-git-send-email-alex.shi@intel.com> <87a9phfgox.fsf@sejong.aot.lge.com>
 <515B90A5.7080403@intel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 2 Apr 2013 19:22:24 -0700
Message-ID: <CAPM31RKj0SJB6eCDSpH29OdfeNGDXqzoQQWhQP7t3gdxYx+wrQ@mail.gmail.com>
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
To: Alex Shi <alex.shi@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 7:15 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 04/02/2013 05:02 PM, Namhyung Kim wrote:
>>> > +  cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
>>> > +                  : (FULL_UTIL - rt_util);
>>> > +  nr_running = rq->nr_running ? rq->nr_running : 1;
>> This can be cleaned up with proper min/max().
>>
>>> > +
>>> > +  return rt_util + cfs_util * nr_running;
>> Should this nr_running consider tasks in cfs_rq only?
>
> use nr_running of cfs_rq seems better, but when use sched autogroup,
> only cfs->nr_running just the active group number, not the total active
> task number. :(

Why not just use cfs_rq->h_nr_running?  This is always the total
*tasks* in he hierarchy parented that cfs_rq.  (This also has the nice property
of not including group_entities.)

>
>   Also it seems
>> there's no upper bound so that it can possibly exceed FULL_UTIL.
>
>
> --
> Thanks Alex
