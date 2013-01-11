Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab3AKKIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:08:00 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33468 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3AKKH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:07:59 -0500
Date: Fri, 11 Jan 2013 10:07:57 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in
 fork/exec/wake
Message-ID: <20130111100757.GH2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
 <1357375071-11793-6-git-send-email-alex.shi@intel.com>
 <20130109182102.GC2046@e103034-lin>
 <50EF7D07.6080006@intel.com>
MIME-Version: 1.0
In-Reply-To: <50EF7D07.6080006@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 11 Jan 2013 10:07:53.0159 (UTC) FILETIME=[84FFE570:01CDEFE3]
X-MC-Unique: 113011110075415201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 02:46:31AM +0000, Alex Shi wrote:
> On 01/10/2013 02:21 AM, Morten Rasmussen wrote:
> >>  		new_cpu = find_idlest_cpu(group, p, cpu);
> >> > -
> >> > -		/* Now try balancing at a lower domain level of new_cpu */
> >> > -		cpu = new_cpu;
> >> > -		weight = sd->span_weight;
> >> > -		sd = NULL;
> >> > -		for_each_domain(cpu, tmp) {
> >> > -			if (weight <= tmp->span_weight)
> >> > -				break;
> >> > -			if (tmp->flags & sd_flag)
> >> > -				sd = tmp;
> >> > -		}
> >> > -		/* while loop will break here if sd == NULL */
> > I agree that this should be a major optimization. I just can't figure
> > out why the existing recursive search for an idle cpu switches to the
> > new cpu near the end and then starts a search for an idle cpu in the new
> > cpu's domain. Is this to handle some exotic sched domain configurations?
> > If so, they probably wouldn't work with your optimizations.
> 
> I did not find odd configuration that asking for old logical.
> 
> According to Documentation/scheduler/sched-domains.txt, Maybe never.
> "A domain's span MUST be a superset of it child's span (this restriction
> could be relaxed if the need arises), and a base domain for CPU i MUST
> span at least i."  etc. etc.

The reason for my suspicion is the SD_OVERLAP flag, which has something
to do overlapping sched domains. I haven't looked into what it does or
how it works. I'm just wondering if this optimization will affect the
use of that flag.

Morten

> 
> 
> -- 
> Thanks Alex
> 

