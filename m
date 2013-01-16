Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab3APBvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:51:11 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55734 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3APBvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:51:10 -0500
X-AuditID: 9c930179-b7b0cae0000065b4-bc-50f6078a9d7b
From: Namhyung Kim <namhyung@kernel.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, peterz@infradead.org, Morten.Rasmussen@arm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: reduce sched_domain_topology space
References: <1358241318-20168-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Wed, 16 Jan 2013 10:51:06 +0900
In-Reply-To: <1358241318-20168-1-git-send-email-lig.fnst@cn.fujitsu.com>
	(liguang's message of "Tue, 15 Jan 2013 17:15:18 +0800")
Message-ID: <87r4llnbed.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, liguang

On Tue, 15 Jan 2013 17:15:18 +0800, liguang wrote:
> sched_domain_topology space was allocated by the size
> ARRAY_SIZE(default_topology) + sched_domains_numa_levels,
> suppose CONFIG_SCHED_SMT, CONFIG_SCHED_MC were y,
> "static struct sched_domain_topology_level default_topology[] = {
>          { sd_init_SIBLING, cpu_smt_mask, },
>          { sd_init_MC, cpu_coregroup_mask, },
>          { sd_init_CPU, cpu_cpu_mask, },
>          { NULL, },
> };"
> then, ARRAY_SIZE(default_topology) equals to 4,
> default_topology's NULL entry was accounted,
> but, the following allocation for other sched_domains_numa_levels
> entries was startd at 3(for default_topology[3].init is NULL),
> so, 1 entry was forgot.

I don't think it's forgotten.

The sched_domain_topology still needs NULL entry at the end.  So what
the current code does is to set up following sched_domain_topology:

{ default_topology (without last NULL entry), numa topology, NULL }

Thanks,
Namhyung
