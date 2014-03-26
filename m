Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaCZORR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:17:17 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44308 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaCZORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <5332CAA7.8000901@linux.vnet.ibm.com>
References: <cover.1395832156.git.viresh.kumar@linaro.org>
	<7eb4d1a03031b4d873ce08e8912900d7936a3ca8.1395832156.git.viresh.kumar@linaro.org>
	<5332CAA7.8000901@linux.vnet.ibm.com>
Date: Wed, 26 Mar 2014 19:47:15 +0530
Message-ID: <CAKohpomzsV+HhH9r3s0jJH_NT0bzdDEd+3k8bopPg9vtVHc5Lw@mail.gmail.com>
Subject: Re: [LNG] Re: [PATCH 12/14] hrtimer: don't emulate notifier call to
 initialize timer base
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2014 18:10, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> I don't think this is such a good idea. Open-coding a part of that callback
> in the init routine can lead to loop-holes down the road:

We think that we are open-coding part of that callback here because it is
implemented that way on the first design.

Rather, we should have a common routine which should do all the work
required when a CPU comes up. And any modification should be done
to that code.

> what if someone
> changes or adds something to the CPU_UP_PREPARE switch-case, and forgets to
> do the same in the init-routine?

This is not a driver which only 2-3 people use. This part is so well reviewed
by so many highly smart people that this should never happen. And if it
happens than its nothing but a review mistake.

> It is more comforting to know that there is just one single place where CPU
> hotplug operations are handled (hrtimer_cpu_notify). That, in turn is good
> for reliability because it makes it easier to write bug-free code.

And for me that single place is: init_hrtimers_cpu() :)
