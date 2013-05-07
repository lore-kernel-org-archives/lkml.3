Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3EGLV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:21:28 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:48961 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab3EGLV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <5188DFEF.6010403@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
 <20130507095715.GE4068@e103034-lin> <5188DFEF.6010403@intel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 7 May 2013 04:20:55 -0700
Message-ID: <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
To: Alex Shi <alex.shi@intel.com>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, 1024 was only intended as a starting point.  We could also
arbitrarily pick something larger, the key is that we pick
_something_.

If we wanted to be more exacting about it we could just give them a
sched_slice() worth; this would have a few obvious "nice" properties
(pun intended).

On Tue, May 7, 2013 at 4:05 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/07/2013 05:57 PM, Morten Rasmussen wrote:
>> Agree. The tracked load of new tasks is often very unstable during first
>> couple of ms on loaded systems. I'm not sure if 1024 is the right
>> initial value. It may need to be larger.
>
> Maybe Peter can give a better value according to the experience on
> scheduler. :)
>
> --
> Thanks
>     Alex
