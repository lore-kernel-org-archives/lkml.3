Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaLHLAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:00:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaLHLAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:00:12 -0500
Date: Mon, 8 Dec 2014 11:59:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 1/4] tools/perf: support parsing parameterized events
Message-ID: <20141208105907.GB4796@krava.redhat.com>
References: <1417572578-9051-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1417572578-9051-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141204124422.GA4195@krava.brq.redhat.com>
 <20141207073724.GA32721@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207073724.GA32721@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 11:37:24PM -0800, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> 
> | anyway we could assign directly to the param term name as you do,
> | but I think we just need to mark the term as parametrized, like:
> | 
> | in /sys/bus/event_source/devices/pmu/events/event_name you have:
> |   param2=?,bar=1,param1=?
> 
> I like the idea of just using a single ? for required parameters, but
> the problem I had with this approach can be seen with these two sysfs
> entries:
> 
>         $ cat HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE
>         domain=0x2,offset=0xe0,starting_index=core,lpar=0x0
> 
>         $ cat HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CORE
>         domain=0x3,offset=0xe0,starting_index=vcpu,lpar=sibling_guest_id
> 
> The parameter 'starting_index' refers to a core in one event and vcpu in
> another event. We were trying to give a hint as to what it refers to.
> 
> Given that, 'starting_index' is not very intuitive, how about discarding
> starting_index and replacing with what it really means for the event and,
> use a simple '?' to indicate required parameter).
> 
>         $ cat HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE
>         domain=0x2,offset=0xe0,core=?,lpar=0x0
> 
>         $ cat HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CORE
>         domain=0x3,offset=0xe0,vcpu=?,lpar=?
> 
> perf list shows these as:
> 
> 	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,core=?/ 
> 	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CHIP,vcpu=?,lpar=?/
> 
> command line would be
> 
> 	-e hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,core=2/ 
> 
> 	or
> 
> 	-e hv_24x7/HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CHIP,vcpu=2,lpar=7/
> 
> and would fail if a required parameter is missing.

that sounds good to me

jirka
