Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269Ab3LTOE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:04:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224Ab3LTOEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:04:55 -0500
Date: Fri, 20 Dec 2013 15:04:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: dietmar.eggemann@arm.com
Cc: mingo@redhat.com, vincent.guittot@linaro.org, morten.rasmussen@arm.com,
        chris.redpath@arm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/8] sched: introduce common topology level init
 function
Message-ID: <20131220140451.GV16438@laptop.programming.kicks-ass.net>
References: <1386936688-29113-1-git-send-email-dietmar.eggemann@arm.com>
 <1386936688-29113-6-git-send-email-dietmar.eggemann@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386936688-29113-6-git-send-email-dietmar.eggemann@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * SD_flags allowed in topology descriptions.
> + *
> + * SD_SHARE_CPUPOWER      - describes SMT topologies
> + * SD_SHARE_PKG_RESOURCES - describes shared caches
> + * SD_NUMA                - describes NUMA topologies
> + *
> + * Odd one out:
> + * SD_ASYM_PACKING        - describes SMT quirks
> + *
> + * SD_PREFER_SIBLING      - describes preference for sibling domain
> + */
> +#define TOPOLOGY_SD_FLAGS         \
> +	(SD_SHARE_CPUPOWER |      \
> +	 SD_SHARE_PKG_RESOURCES | \
> +	 SD_NUMA |                \
> +	 SD_ASYM_PACKING |        \
> +	 SD_PREFER_SIBLING)

See SD_PREFER_SIBLING is behavioural, the exact kinda thing we want to
keep out of this mask,
