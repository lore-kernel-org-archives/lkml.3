Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaAMXLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:11:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaAMXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:11:33 -0500
Date: Mon, 13 Jan 2014 15:11:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 3/5] mm: vmscan: respect NUMA policy mask when shrinking
 slab on direct reclaim
Message-Id: <20140113151132.d07cbc938baf5af70f929120@linux-foundation.org>
In-Reply-To: <a39e4c57c5a8db4d6e5bb8cd070ac807c8c6fce8.1389443272.git.vdavydov@parallels.com>
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
	<a39e4c57c5a8db4d6e5bb8cd070ac807c8c6fce8.1389443272.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 16:36:33 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> When direct reclaim is executed by a process bound to a set of NUMA
> nodes, we should scan only those nodes when possible, but currently we
> will scan kmem from all online nodes even if the kmem shrinker is NUMA
> aware. That said, binding a process to a particular NUMA node won't
> prevent it from shrinking inode/dentry caches from other nodes, which is
> not good. Fix this.

Seems right.  I worry that reducing the amount of shrinking which
node-bound processes perform might affect workloads in unexpected ways.

I think I'll save this one for 3.15-rc1, OK?
