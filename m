Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab3EXF4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 01:56:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64020 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3EXF4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 01:56:48 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-d5-519f011f1f3c
Date: Fri, 24 May 2013 07:56:40 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        "Rafael J. Wysocky" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Vicent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>
Subject: Re: [RFC v2 0/3][TESTS] LAB: Support for Legacy Application Booster
 governor - tests results
Message-id: <20130524075640.0a5b80ff@amdc308.digital.local>
In-reply-to: <20130522164453.29cd3a7d@amdc308.digital.local>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <CAKohpokXNUmMbk0KOh58-0=sAs7yzD=cQe24eaoArpRSwM__Gg@mail.gmail.com>
 <20130522122700.104ca5cd@amdc308.digital.local>
 <CAKohpo=9dRXb1jjauvhzuje9rOgH82k-3DeL2zqiwHDHOwSo4g@mail.gmail.com>
 <20130522164453.29cd3a7d@amdc308.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t9jQV15xvmBBpeni1o8bfrBbjHvs6xF
	59knzBZvHnFbvHm4mdHi8q45bBafe48wWtxuXMFm0b+wl8mi48g3ZouNXz0cuD3uXNvD5rFu
	2ltmj74tqxg9Hi1uYfT4vEkugDWKyyYlNSezLLVI3y6BK2P7i0a2gv0yFWv7X7M0ML4W7WLk
	5JAQMJGYMGcmO4QtJnHh3nq2LkYuDiGB6YwSv+bMY4Rw2pkkFrU0s4BUsQioSnw/PYMZxGYT
	0JP4fPcpE4gtIqAjceFjAzNIA7PALyaJJZu/gCWEBdIl/m3rArN5Bawl5l6aAbaOU8BGonX2
	byaIDbuYJM53bwJL8AtISrT/+8EMcZOdxLlPG9ghmgUlfky+B3YFs4CWxOZtTawQtrzE5jVv
	mScwCs5CUjYLSdksJGULGJlXMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgRHyTPpHYyrGiwO
	MQpwMCrx8M7QmRcoxJpYVlyZe4hRgoNZSYT3wTegEG9KYmVValF+fFFpTmrxIUZpDhYlcd6D
	rdaBQgLpiSWp2ampBalFMFkmDk6pBsap3Frxi7WXri8rPPg06eCNr13Zb20e+f35bWj2o0rs
	FE9l9vfK+WwdQoYrt0fU/MjI0MlljbmxJ+jyRbF/P5n5fR99WrFma+2azclr5tyRargiOH2f
	vpTYzoM+2UGXchUUYyp74mZHHZuRsqSJc1tktvX7ZIesgNnzAhjsgt+Xzk57cZXVNEKJpTgj
	0VCLuag4EQAhLF9ijgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> 
> > On 22 May 2013 15:57, Lukasz Majewski <l.majewski@samsung.com>
> > wrote:
> > >> On 3 May 2013 19:37, Jonghwa Lee <jonghwa3.lee@samsung.com>
> > >> wrote:
> > 
> > > I think, that overclocking support is crucial here. As you pointed
> > > out
> > > - ondemand and conservative benefit from it. Therefore, I would
> > > urge for its mainline acceptance.
> > >
> > > (code for reference)
> > > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> > >
> > > In this RFC (patch 1/3), I've decided to put the burden of
> > > overclocking support to platform code (cpufreq/exynos-cpufreq.c
> > > and cpufreq/exynos4x12-cpufreq.c).
> > >
> > > Those changes aren't intrusive for other boards/archs. Moreover
> > > overclocking is closely related to processor clocking/power
> > > dissipation capabilities, so SoC specific code is a good place for
> > > it.
> > >
> > >
> > > What DO need a broad acceptance is the overclocking API proposed
> > > at: include/linux/cpufreq.h
> > >
> > > This introduces interface to which others will be bind. It
> > > shouldn't be difficult to implement overclocking at other SoCs (as
> > > it was proposed for Exynos).
> > >
> > > Feedback is welcome, since I might have overlooked oddities
> > > present at other SoCs.
> > 
> > Hi..
> > 
> > I am not talking about the minute details here... for example I
> > didn't like the way overclocking support is implemented... It has to
> > be a bit more framework oriented then driver...
> > 
> > What I am thinking right now is if it is worth to add both the
> > features you are trying. i.e. overclocking and LAB..
> > 
> > So, requested you to give some figures... of ondemand with and
> > without overclocking... Leave LAB for now...

As you wished, I've provided relevant data for overclocking.

Would you be so kind and comment on them?



> > 
> > Then we can give LAB a try with above...
> 
> Test HW Exynos4412 (4 Cores):
> Kernel 3.8.3
> 
> Ondemand max freq: 1.4 GHz
> Overclock max freq: 1.5 GHz
> 
> 
> Ondemand improvement with and without overclocking (called by us
> TurboBoost - TB):
> 
> Dhrystone has been built according to:
> http://zenit.senecac.on.ca/wiki/index.php/Dhrystone_howto
> It's Makefile is also attached.
> ------------------------------------------------
> 
> Dhrystone	# of Threads			
> 		1	2	3	4
> ondemand	2054794	2061855	2097902	2090592
> ondemand + TB	2290076	2205882	2281368 2290076
> 
> Improvement:	10%	7%	8%	9%
> -------------------------------------------------
> 
> Electric charge [C]
> (Avg) [A] * [second]	# of Threads			
> 		1	2	3	4
> ondemand	1,334	1,837	2,296	3,096
> ondemand + TB	1,401	2,2025	2,907	4,34976
> 								
> Power cost:	5%	17%	21%	29%
> -------------------------------------------------
> 
> Execution time [second]	# of Threads			
> 		1	2	3	4
> ondemand	2,827	2,8	2,787	2,872
> ondemand + TB	2,622	2,694	2,667	2,76
> 				
> 				
> Speedup:	-7%	-4%	-4%	-4%
> 
> -------------------------------------------------
> 
> "Real life" example:
> time tar -czf linux-3.9.1.tar.gz linux-3.9.1/
> 
> 		Avg current[mA]		Time[s]
> Ondemand:	460			153	
> Ondemand + TB:	512			144
> 
> Result:		+10%			-6%
> 
> 
> 
> Conclusion: 
> 
> The main use case for TB is to speed up execution of tasks packed to
> one core. Other cores are then in IDLE state.
> 
> For a single core we can safely overclock, since we will not exceed
> its power consumption and thermal limits.
> 
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Poland (SRPOL) | Linux Platform Group
