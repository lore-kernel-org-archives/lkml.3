Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaENREK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:04:10 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38256 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaENREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:04:08 -0400
Date: Wed, 14 May 2014 13:04:04 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup
 reference counting
Message-ID: <20140514170404.GC15690@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:13:26PM -0400, Tejun Heo wrote:
> Hello,
> 
> Currently, cgroup and css (cgroup_subsys_state) are separately
> reference counted.  cgroup->refcnt is an atomic_t and css->refcnt is a
> percpu_ref.  css is becoming the primary structural block and used
> widely in various operaitons.  cgroup already has a css embedded in it
> (cgroup->dummy_css) to use as its proxy in such operations; however,
> there still are quite a few differences between cgroup and css
> handling limitng how cgroup->dummy_css can be used.
> 
> This patchset makes cgroup use the embedded css's refcnt for reference
> counting.  This closes one of the gaps between an cgroup embedded css,
> which is renamed to cgroup->self early in the patchset, and a normal
> css and will allow more unified handling of cgroups and csses.  In
> addition, this makes cgroup refcnting use percpu_ref too, which is a
> lot more scalable than an atomic_t.
> 
> Ultimately, it'd make things far simpler to assign a proper
> cgroup_subsys to the cgroup embedded csses and handle them the same as
> other csses; however, we can't yet do it thanks to multiple
> hierarchies as we end up with multiple csses of the same subsystem for
> the same task, but in the very long term, if multiple hierarchies can
> be removed, that's where it's headed.
> 
> This patchset contains the following nine patches.
> 
>  0001-cgroup-use-restart_syscall-for-mount-retries.patch
>  0002-cgroup-rename-cgroup-dummy_css-to-self-and-move-it-t.patch
>  0003-cgroup-separate-out-cgroup_has_live_children-from-cg.patch
>  0004-cgroup-move-check_for_release-parent-call-to-the-end.patch
>  0005-cgroup-move-cgroup-sibling-unlinking-to-cgroup_put.patch
>  0006-cgroup-remove-cgroup_destory_css_killed.patch
>  0007-cgroup-bounce-css-release-through-css-destroy_work.patch
>  0008-cgroup-enable-refcnting-for-root-csses.patch
>  0009-cgroup-use-cgroup-self.refcnt-for-cgroup-refcnting.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
