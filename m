Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaFYKb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:31:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbaFYKb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:31:58 -0400
Date: Wed, 25 Jun 2014 11:31:49 +0100
From: Mel Gorman <mgorman@suse.de>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, peterz@infradead.com,
        mingo@kernel.org
Subject: Re: [PATCH 1/7] sched,numa: use group's max nid as task's preferred
 nid
Message-ID: <20140625103149.GZ10819@suse.de>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <1403538095-31256-2-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1403538095-31256-2-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 11:41:29AM -0400, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> From task_numa_placement, always try to consolidate the tasks
> in a group on the group's top nid.
> 
> In case this task is part of a group that is interleaved over
> multiple nodes, task_numa_migrate will set the task's preferred
> nid to the best node it could find for the task, so this patch
> will cause at most one run through task_numa_migrate.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

That loop was written prior to pseudo-interleaving as well and in the
context of that change this makes sense and removes a potentially
expensive loop.

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
