Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509AbaGCLIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:08:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37926 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaGCLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:08:19 -0400
Date: Thu, 3 Jul 2014 07:08:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/5] cgroup: replace cgroup_add_cftypes() with
 cgroup_add_legacy_cftypes()
Message-ID: <20140703110808.GB9748@hmsreliant.think-freely.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404345055-8196-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:50:53PM -0400, Tejun Heo wrote:
> Currently, cftypes added by cgroup_add_cftypes() are used for both the
> unified default hierarchy and legacy ones and subsystems can mark each
> file with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE if it has to
> appear only on one of them.  This is quite hairy and error-prone.
> Also, we may end up exposing interface files to the default hierarchy
> without thinking it through.
> 
> cgroup_subsys will grow two separate cftype addition functions and
> apply each only on the hierarchies of the matching type.  This will
> allow organizing cftypes in a lot clearer way and encourage subsystems
> to scrutinize the interface which is being exposed in the new default
> hierarchy.
> 
> In preparation, this patch adds cgroup_add_legacy_cftypes() which
> currently is a simple wrapper around cgroup_add_cftypes() and replaces
> all cgroup_add_cftypes() usages with it.
> 
> While at it, this patch drops a completely spurious return from
> __hugetlb_cgroup_file_init().
> 
> This patch doesn't introduce any functional differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

