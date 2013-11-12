Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3KLK6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:58:00 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37854 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <20131112105508.GN5056@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
	<1382097147-30088-5-git-send-email-vincent.guittot@linaro.org>
	<20131112103228.GE4971@laptop.programming.kicks-ass.net>
	<CAKfTPtBymfyQC7=oTscrZVByHmFcgcZM5fPJRssqP9YEQjDECA@mail.gmail.com>
	<20131112105508.GN5056@laptop.programming.kicks-ass.net>
Date: Tue, 12 Nov 2013 11:57:56 +0100
Message-ID: <CAKfTPtAjOYtOaNnCZUmoPrmCy4SyD=RXvs+mU2abvaqwK6Y39Q@mail.gmail.com>
Subject: Re: [RFC][PATCH v5 05/14] sched: add a packing level knob
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2013 11:55, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Nov 12, 2013 at 11:44:15AM +0100, Vincent Guittot wrote:
>> On 12 November 2013 11:32, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, Oct 18, 2013 at 01:52:18PM +0200, Vincent Guittot wrote:
>> >> +int sched_proc_update_packing(struct ctl_table *table, int write,
>> >> +             void __user *buffer, size_t *lenp,
>> >> +             loff_t *ppos)
>> >> +{
>> >> +     int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>> >> +     if (ret || !write)
>> >> +             return ret;
>> >> +
>> >> +     if (sysctl_sched_packing_level)
>> >> +             sd_pack_threshold = (100 * 1024) / sysctl_sched_packing_level;
>> >> +
>> >> +     return 0;
>> >> +}
>> >
>> >> +#ifdef CONFIG_SCHED_PACKING_TASKS
>> >> +static int min_sched_packing_level;
>> >> +static int max_sched_packing_level = 100;
>> >> +#endif /* CONFIG_SMP */
>> >
>> >> +#ifdef CONFIG_SCHED_PACKING_TASKS
>> >> +     {
>> >> +             .procname       = "sched_packing_level",
>> >> +             .data           = &sysctl_sched_packing_level,
>> >> +             .maxlen         = sizeof(int),
>> >> +             .mode           = 0644,
>> >> +             .proc_handler   = sched_proc_update_packing,
>> >> +             .extra1         = &min_sched_packing_level,
>> >> +             .extra2         = &max_sched_packing_level,
>> >> +     },
>> >> +#endif
>> >
>> > Shouldn't min_sched_packing_level be 1? Userspace can now write 0 and
>> > expect something; but then we don't update sd_pack_threshold so nothing
>> > really changed.
>>
>> value 0 is used to disable to packing feature and the scheduler falls
>> back to default behavior. This value is tested when setting which cpus
>> will be used by the scheduler.
>
> I suspected as much, but it wasn't clear from the Changelog, the patch
> or any comments. Plz as to fix.

Ok. i will add it
