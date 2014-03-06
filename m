Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaCFKMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:12:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaCFKML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:12:11 -0500
Date: Thu, 6 Mar 2014 10:37:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org
Subject: Re: perf: Add support for full Intel event lists
Message-ID: <20140306093755.GA3830@krava.brq.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:30AM -0800, Andi Kleen wrote:

SNIP

> Patches also available from
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/json
> 
> Example output:
> 
> % perf download 
> Downloading models file
> Downloading readme.txt
> 2014-03-05 10:39:33 URL:https://download.01.org/perfmon/readme.txt [10320/10320] -> "readme.txt" [1]
> 2014-03-05 10:39:34 URL:https://download.01.org/perfmon/mapfile.csv [1207/1207] -> "mapfile.csv" [1]
> Downloading events file
> % perf list
> ...
>   br_inst_exec.all_branches                          [Speculative and retired
>                                                       branches]
>   br_inst_exec.all_conditional                       [Speculative and retired
>                                                       macro-conditional
>                                                       branches]
>   br_inst_exec.all_direct_jmp                        [Speculative and retired
>                                                       macro-unconditional
>                                                       branches excluding
>                                                       calls and indirects]
> ... 333 more new events ...
> 
> % perf stat -e br_inst_exec.all_direct_jmp true
> 
>  Performance counter stats for 'true':
> 
>              6,817      cpu/br_inst_exec.all_direct_jmp/                                   
> 
>        0.003503212 seconds time elapsed
> 
> One nice feature is that a pointer to the specification update is now
> included in the description, which will hopefully clear up many problems:
> 
> % perf list
> ...
>   mem_load_uops_l3_hit_retired.xsnp_hit              [Retired load uops which
>                                                       data sources were L3
>                                                       and cross-core snoop
>                                                       hits in on-pkg core
>                                                       cache. Supports address
>                                                       when precise. Spec
>                                                       update: HSM26, HSM30
>                                                       (Precise event)]
> ...

nice! going to review this soon

jirka
