Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3ANI5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:57:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab3ANI5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:57:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,466,1355068800"; 
   d="scan'208";a="6582531"
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in
 fork/exec/wake
From: li guang <lig.fnst@cn.fujitsu.com>
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
Cc: Alex Shi <alex.shi@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
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
In-Reply-To: <20130111100757.GH2046@e103034-lin>
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>
	 <1357375071-11793-6-git-send-email-alex.shi@intel.com>
	 <20130109182102.GC2046@e103034-lin> <50EF7D07.6080006@intel.com>
	 <20130111100757.GH2046@e103034-lin>
Date: Mon, 14 Jan 2013 16:55:43 +0800
Message-ID: <1358153743.8818.9.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 16:56:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/14 16:57:00,
	Serialize complete at 2013/01/14 16:57:00
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-01-11五的 10:07 +0000，Morten Rasmussen写道：
> On Fri, Jan 11, 2013 at 02:46:31AM +0000, Alex Shi wrote:
> > On 01/10/2013 02:21 AM, Morten Rasmussen wrote:
> > >>  		new_cpu = find_idlest_cpu(group, p, cpu);
> > >> > -
> > >> > -		/* Now try balancing at a lower domain level of new_cpu */
> > >> > -		cpu = new_cpu;
> > >> > -		weight = sd->span_weight;
> > >> > -		sd = NULL;
> > >> > -		for_each_domain(cpu, tmp) {
> > >> > -			if (weight <= tmp->span_weight)
> > >> > -				break;
> > >> > -			if (tmp->flags & sd_flag)
> > >> > -				sd = tmp;
> > >> > -		}
> > >> > -		/* while loop will break here if sd == NULL */
> > > I agree that this should be a major optimization. I just can't figure
> > > out why the existing recursive search for an idle cpu switches to the
> > > new cpu near the end and then starts a search for an idle cpu in the new
> > > cpu's domain. Is this to handle some exotic sched domain configurations?
> > > If so, they probably wouldn't work with your optimizations.
> > 
> > I did not find odd configuration that asking for old logical.
> > 
> > According to Documentation/scheduler/sched-domains.txt, Maybe never.
> > "A domain's span MUST be a superset of it child's span (this restriction
> > could be relaxed if the need arises), and a base domain for CPU i MUST
> > span at least i."  etc. etc.
> 
> The reason for my suspicion is the SD_OVERLAP flag, which has something
> to do overlapping sched domains. I haven't looked into what it does or
> how it works. I'm just wondering if this optimization will affect the
> use of that flag.

seems it did, SD_OVERLAP will not work after this change,
though this flag is maybe scarcely used.
because, this optimization assume all sched-domains span 
is super-set over child domain.
isn't it? Alex.

> 
> Morten
> 
> > 
> > 
> > -- 
> > Thanks Alex
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
regards!
li guang

