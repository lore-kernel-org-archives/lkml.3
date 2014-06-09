Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbaFIVWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:22:48 -0400
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:33246 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754332AbaFIVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:22:46 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: body80_8c4311fd19623
X-Filterd-Recvd-Size: 2023
Message-ID: <1402348962.3142.32.camel@joe-AO725>
Subject: Re: [PATCH 6/7] cpufreq: intel_pstate: Trivial code cleanup
From: Joe Perches <joe@perches.com>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 09 Jun 2014 14:22:42 -0700
In-Reply-To: <5396208F.6070400@semaphore.gr>
References: <5396208F.6070400@semaphore.gr>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 00:01 +0300, Stratos Karafotis wrote:
> Remove unnecessary braces.

[]

> @@ -204,20 +203,16 @@ static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)

>  static inline void intel_pstate_reset_all_pid(void)
>  {
>  	unsigned int cpu;
> -	for_each_online_cpu(cpu) {
> +
> +	for_each_online_cpu(cpu)
>  		if (all_cpu_data[cpu])
>  			intel_pstate_busy_pid_reset(all_cpu_data[cpu]);
> -	}

It's pretty traditional to keep the braces here
as it generally makes it clearer for the reader.

	for (...) {
		if (foo)
			bar();
	}

is generally used over

	for (...)
		if (foo)
			bar();

Just like using

	if (foo) {
		/* commment */
		bar();
	}

> @@ -748,15 +744,14 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
[]
> -	pr_info("Intel pstate controlling: cpu %d\n", cpunum);
> +	pr_info("Intel pstate controlling: CPU %d\n", cpunum);

cpu is very slightly preferred lower case.

$ git grep -E -i '^[^"]*"[^"]*\bcpu\b'|grep -w -i -o cpu | sort |uniq -c | sort -rn
   2705 cpu
   2084 CPU
     17 Cpu


