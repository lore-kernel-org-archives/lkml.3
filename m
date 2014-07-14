Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaGNOnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:43:12 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:48406 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbaGNOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:43:01 -0400
Date: Mon, 14 Jul 2014 10:42:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Aristeu Rozanski <aris@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy
 hierarchies when handling cftypes
Message-ID: <20140714144257.GD31610@htj.dyndns.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-5-git-send-email-tj@kernel.org>
 <53C33CC7.3020707@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C33CC7.3020707@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 10:13:27AM +0800, Li Zefan wrote:
> I think we should remove this flag in cgroup_rm_cftypes_locked(). Otherwise
> if we call cgroup_add_dlf_cftypes() and then cgroup_rm_cftypes() and then
> cgroup_add_legacy_cftypes() for the same @cfts, both CFTYPE_ONLY_ON_DFL and
> CFTYPE_INSANE are set.

Heh, that's unlikely to actually happen but yes clearing would be
better.  Will update accordingly.

Thanks.

-- 
tejun
