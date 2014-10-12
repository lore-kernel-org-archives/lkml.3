Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaJLNRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 09:17:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:56535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaJLNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 09:17:19 -0400
Date: Sun, 12 Oct 2014 15:17:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 1/5] sched,numa: build table of node hop distance
Message-ID: <20141012131714.GE3015@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412797050-8903-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 03:37:26PM -0400, riel@redhat.com wrote:
> +	sched_domains_numa_hops = kzalloc(sizeof(int) * nr_node_ids * nr_node_ids, GFP_KERNEL);
> +	if (!sched_domains_numa_hops)
> +		return;

That's potentially a _BIG_ table (1M for a 512 node system).
The node_distance has magic allocations and is of u8 size, is there any
way we can re-use node_distance and avoid a second O(n^2) allocation?
