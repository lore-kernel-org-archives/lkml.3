Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3KMRsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:48:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35708 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3KMRsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:48:42 -0500
Date: Wed, 13 Nov 2013 18:48:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        prarit@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched/numa: Fix NULL pointer dereference in
 task_numa_migrate()
Message-ID: <20131113174826.GR21461@twins.programming.kicks-ass.net>
References: <tip-46a73e8a1c1720f7713b5e2df68e9dd272015b5d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-46a73e8a1c1720f7713b5e2df68e9dd272015b5d@git.kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 09:25:22AM -0800, tip-bot for Rik van Riel wrote:
> +	if (unlikely(!sd)) {
> +		p->numa_preferred_nid = cpu_to_node(task_cpu(p));

't is only now I notice, but I added a convenience helper for this:
task_node(p) :-)

No biggie, I'll try and remember when next something near there needs
changing.
