Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbaCSM3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:29:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57933 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaCSM3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140319120122.GK27632@laptop.programming.kicks-ass.net>
References: <1395165409-18055-1-git-send-email-vincent.guittot@linaro.org>
 <1395165409-18055-6-git-send-email-vincent.guittot@linaro.org> <20140319120122.GK27632@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 19 Mar 2014 13:29:00 +0100
Message-ID: <CAKfTPtBBbKGPTuPu_1-rxAv6ADSFzziWk5hgmrz-wB4dupm6eg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
To: Peter Zijlstra <peterz@infradead.org>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 13:01, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 18, 2014 at 06:56:47PM +0100, Vincent Guittot wrote:
>> A new flag SD_SHARE_POWERDOMAIN is created to reflect whether groups of CPUs
>> in a sched_domain level can or not reach different power state. As an example,
>> the flag should be cleared at CPU level if groups of cores can be power gated
>> independently. This information can be used to add load balancing level between
>> group of CPUs than can power gate independantly. The default behavior of the
>> scheduler is to spread tasks across CPUs and groups of CPUs
>
>> so the flag is set into all sched_domains.
>
> I suppose that is the part Preeti stumbled over; as did I. Its not set
> at all.

yes, it's confusing. i'm going to update the commit message

>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
