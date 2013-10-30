Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3J3TgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:36:08 -0400
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:53263 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754610Ab3J3TgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:36:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2741:2828:2895:3138:3139:3140:3141:3142:3350:3622:3865:3867:3868:3872:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12740:13019:13069:13141:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: swing60_6ef08f1952450
X-Filterd-Recvd-Size: 1765
Message-ID: <1383161761.9435.35.camel@joe-AO722>
Subject: Re: [PATCH] x86: print microcode revision on PEBs errors
From: Joe Perches <joe@perches.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 12:36:01 -0700
In-Reply-To: <20131030193150.GA7765@redhat.com>
References: <20131030193150.GA7765@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 21:31 +0200, Michael S. Tsirkin wrote:
> On Sandy bridge CPUs with old microcode, PEBs
> fails and suggests a microcode update.
> Print out the required and the actual revision to
> make it easier to figure out what's wrong.
[]
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
[]
> @@ -2105,6 +2105,8 @@ static int intel_snb_pebs_broken(int cpu)
>  		}
>  	}
>  
> +	pr_info("PEBS checking: microcode 0x%x min legal 0x%x\n",
> +		cpu_data(cpu).microcode, rev);

Maybe only emit this with microcode < rev
otherwise it gets emitted once for each online cpu

>  	return (cpu_data(cpu).microcode < rev);
>  }
>  



