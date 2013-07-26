Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab3GZMq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:46:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47606 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab3GZMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:46:20 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-d1-51f26f9a927f
Date: Fri, 26 Jul 2013 14:46:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, durgadoss.r@intel.com
Subject: Re: [PATCH v6 1/8] cpufreq: Store cpufreq policies in a list
Message-id: <20130726144612.5939419c@amdc308.digital.local>
In-reply-to: <CAKohpokqHsHZP0AkPBbmGP=ekLPQrnLCc5j6BsfM6KY01uzG1w@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-2-git-send-email-l.majewski@samsung.com>
 <CAKohpoktwZUvs2ap7wk1tudVsiKjbhFkoM5=+AaFZP=+73fEyg@mail.gmail.com>
 <20130726125827.72f9ef18@amdc308.digital.local>
 <CAKohpokqHsHZP0AkPBbmGP=ekLPQrnLCc5j6BsfM6KY01uzG1w@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e+xgO7s/E+BBs0TWCw2zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2uLxrDpvF594jjBb9C3uZLJ487GOz2PjV
	w4HXY/Gel0wed67tYfNYN+0ts0ffllWMHo8WtzB6HL+xncnj8ya5APYoLpuU1JzMstQifbsE
	royvL/8xFSzlq2jds5y5gbGXu4uRk0NCwETi5ZbPTBC2mMSFe+vZuhi5OIQEFjFK9O78xArh
	tDNJzHuxmQ2kikVAVWLRtQ4WEJtNQE/i892nQN0cHCICWhIvb6aC1DML/GWW6HvUAFYvLOAq
	sbZrLZjNK2AtMWHtYkYQm1MgWGLNrAPMEAv+M0ns3LYK7Ax+AUmJ9n8/mCFOspM492kDO0Sz
	oMSPyffAFjMDLdu8rYkVwpaX2LzmLfMERsFZSMpmISmbhaRsASPzKkbR1ILkguKk9FxDveLE
	3OLSvHS95PzcTYzgWHomtYNxZYPFIUYBDkYlHl4Fp4+BQqyJZcWVuYcYJTiYlUR4r3t/ChTi
	TUmsrEotyo8vKs1JLT7EKM3BoiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXAaCW3xUfcstnt
	k6+/qr6EX227kdCyJZv9K3uVPgo5fz/Sp3/L9iuH5p5dd4qWWa4Oqzo1x3vnSlndBqlqmwMn
	t+1v2pkx6U+iy1zOX7L2027mxrNqPz8ZJD712Ies707a7z2YDk34eGG+8/u3TfF9khvW55+Z
	VXVHxDT55hXhRzyM6rq60V5LlFiKMxINtZiLihMBxiUFlqECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jul 2013 16:32:34 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 July 2013 16:28, Lukasz Majewski <l.majewski@samsung.com> wrote:
> > On Fri, 26 Jul 2013 15:44:29 +0530 Viresh Kumar
> > viresh.kumar@linaro.org wrote,
> >> On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com>
> >> wrote:
> 
> >> Looks good but would have been better if you could have moved
> >> existing code to use this infrastructure..
> >>
> >> For example, this code in __cpufreq_add_dev()
> >>
> >> #ifdef CONFIG_HOTPLUG_CPU
> >>       /* Check if this cpu was hot-unplugged earlier and has
> >> siblings */ read_lock_irqsave(&cpufreq_driver_lock, flags);
> >>       for_each_online_cpu(sibling) {
> >>
> >>          ---
> >>
> >>       }
> >>       read_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >> #endif
> >
> > Do you mean to write something like:
> >
> > #ifdef CONFIG_CPU_FREQ_BOOST_SW
> >         write_lock_irqsave(&cpufreq_driver_lock, flags);
> >         list_add(&policy->policy_list, &cpufreq_policy_list);
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > #endif
> >
> > Or Am I missing something?
> 
> I can't imaging how you though I am saying this :)
>

:-)
 
> The code I mentioned actually requires to iterate through the
> list of available policies but was iterating over all online cpus..
> 
> And so your new infrastructure or this list can be used instead
> of looping for all cpus.

So instead of reading policies from per_cpu variables for all online
cpus, you think of using the list explicitly.

Good idea, but can we first finish the boost patches? Such change can
be applied on top of boost patch series as well.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
