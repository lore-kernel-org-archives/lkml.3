Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaEEQi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 12:38:26 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:62004 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaEEQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 12:38:25 -0400
Date: Mon, 5 May 2014 12:38:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: axboe@kernel.dk, Sasha Levin <sasha.levin@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on
 blkcg_pol_mutex in blkcg_reset_stats()
Message-ID: <20140505163821.GM11231@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
 <20140505163730.GL11231@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505163730.GL11231@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:37:30PM -0400, Tejun Heo wrote:
> During the recent conversion of cgroup to kernfs, cgroup_tree_mutex
> which nests above both the kernfs s_active protection and cgroup_mutex
> is added to synchronize cgroup file type operations as cgroup_mutex
> needed to be grabbed from some file operations and thus can't be put
> above s_active protection.

Ooh, I verified that the patch removes the lockdep warning and am
routing it through cgroup/for-3.15-fixes.  If there's any objection,
please let me know.

Thanks!

-- 
tejun
