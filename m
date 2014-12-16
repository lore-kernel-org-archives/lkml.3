Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaLPQ7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:59:31 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:54912 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaLPQ73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:59:29 -0500
Date: Tue, 16 Dec 2014 11:59:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chintan Pandya <cpandya@codeaurora.org>
Cc: mhocko@suse.cz, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Provide knob for force OOM into the memcg
Message-ID: <20141216165922.GA30984@phnom.home.cmpxchg.org>
References: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418736335-30915-1-git-send-email-cpandya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 06:55:35PM +0530, Chintan Pandya wrote:
> We may want to use memcg to limit the total memory
> footprint of all the processes within the one group.
> This may lead to a situation where any arbitrary
> process cannot get migrated to that one  memcg
> because its limits will be breached. Or, process can
> get migrated but even being most recently used
> process, it can get killed by in-cgroup OOM. To
> avoid such scenarios, provide a convenient knob
> by which we can forcefully trigger OOM and make
> a room for upcoming process.

Why do you move tasks around during runtime?  Rather than scanning
thousands or millions of page table entries to relocate a task and its
private memory to another configuration domain, wouldn't it be easier to
just keep the task in a dedicated cgroup and reconfigure that instead?

There doesn't seem to be a strong usecase for charge migration that
couldn't be solved by doing things slightly differently from userspace.
Certainly not something that justifies the complexity that it adds to
memcg model and it's synchronization requirements from VM hotpaths.
Hence, I'm inclined to not add charge moving to version 2 of memcg.
