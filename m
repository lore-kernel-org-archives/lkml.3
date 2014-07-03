Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaGCLOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 07:14:54 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37967 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGCLOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 07:14:53 -0400
Date: Thu, 3 Jul 2014 07:14:40 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Aristeu Rozanski <aris@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/5] cgroup: distinguish the default and legacy
 hierarchies when handling cftypes
Message-ID: <20140703111440.GC9748@hmsreliant.think-freely.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404345055-8196-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 07:50:54PM -0400, Tejun Heo wrote:
> Until now, cftype arrays carried files for both the default and legacy
> hierarchies and the files which needed to be used on only one of them
> were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
> gets confusing very quickly and we may end up exposing interface files
> to the default hierarchy without thinking it through.
> 
> This patch makes cgroup core provide separate sets of interfaces for
> cftype handling so that the cftypes for the default and legacy
> hierarchies are clearly distinguished.  The previous two patches
> renamed the existing ones so that they clearly indicate that they're
> for the legacy hierarchies.  This patch adds the interface for the
> default hierarchy and apply them selectively depending on the
> hierarchy type.
> 
> * cftypes added through cgroup_subsys->dfl_cftypes and
>   cgroup_add_dfl_cftypes() only show up on the default hierarchy.
> 
> * cftypes added through cgroup_subsys->legacy_cftypes and
>   cgroup_add_legacy_cftypes() only show up on the legacy hierarchies.
> 
> * cgroup_subsys->dfl_cftypes and ->legacy_cftypes can point to the
>   same array for the cases where the interface files are identical on
>   both types of hierarchies.
> 
> * This makes all the existing subsystem interface files legacy-only by
>   default and all subsystems will have no interface file created when
>   enabled on the default hierarchy.  Each subsystem should explicitly
>   review and compose the interface for the default hierarchy.
> 
> * A boot param "cgroup__DEVEL__legacy_files_on_dfl" is added which
>   makes subsystems which haven't decided the interface files for the
>   default hierarchy to present the legacy files on the default
>   hierarchy so that its behavior on the default hierarchy can be
>   tested.  As the awkward name suggests, this is for development only.
> 
> * memcg's CFTYPE_INSANE on "use_hierarchy" is noop now as the whole
>   array isn't used on the default hierarchy.  The flag is removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

