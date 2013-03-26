Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3CZNAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:00:53 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:53923 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712Ab3CZNAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <1364301443.5053.9.camel@laptop>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
	<1364301443.5053.9.camel@laptop>
Date: Tue, 26 Mar 2013 14:00:50 +0100
Message-ID: <CAKfTPtBU40WZU8n-vS=APG4oirBuVR4LB8VNRQ6OT2pr1PhcKQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 13:37, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> +static bool is_light_task(struct task_struct *p)
>> +{
>> +       /* A light task runs less than 20% in average */
>> +       return ((p->se.avg.runnable_avg_sum  * 5) <
>> +                       (p->se.avg.runnable_avg_period));
>> +}
>
> OK, so we have a 'problem' here, we initialize runnable_avg_* to 0, but
> we want to 'assume' a fresh task is fully 'loaded'. IIRC Alex ran into
> this as well.
Hi Peter,

The packing small tasks is only applied at wake up and not during fork
or exec so the runnable_avg_* should have been initialized. As you
mentionned, we assume that a fresh task is fully loaded and let the
default scheduler behavior to select a target CPU

Vincent

>
> PJT, do you have any sane solution for this, I forgot what the result
> of the last discussion was -- was there any?
>
