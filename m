Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3FQRQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:16:59 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39421 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3FQRQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:16:57 -0400
Date: Mon, 17 Jun 2013 10:16:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, koverstreet@google.com,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Message-ID: <20130617171651.GE32663@mtj.dyndns.org>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
 <20130614132026.GD10084@dhcp22.suse.cz>
 <20130614223125.GD6593@mtj.dyndns.org>
 <20130615053522.GA7017@htj.dyndns.org>
 <20130617132744.GB5018@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617132744.GB5018@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Jun 17, 2013 at 03:27:44PM +0200, Michal Hocko wrote:
> Thanks for your results! Yes the boost can be really high. I will try to
> measure some memcg workloads as soon as I have some spare cycles. I do
> not expect a big win but I also do not think this would regress.

With the just committed RCU-sched conversion, the slowdown even on
single CPU configuration w/ CONFIG_PREEMPT should be in the range of a
few percent points in the worst cases and will mostly be in the noise
in any realistic scenarios.  So, yeah, looks pretty good to me. :)

Thanks.

-- 
tejun
