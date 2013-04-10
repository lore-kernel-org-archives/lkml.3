Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935572Ab3DJHcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:32:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52059
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab3DJHcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:32:42 -0400
Message-ID: <1365579146.30071.24.camel@laptop>
Subject: Re: [PATCHSET] perf, cgroup: implement hierarchy support for
 perf_event controller
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@kernel.org, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Apr 2013 09:32:26 +0200
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 19:23 -0700, Tejun Heo wrote:
> perf_event cgroup controller is one of the remaining few with broken
> hierarchy support.  It turns out it's pretty easy to implement - the
> only thing necessary is making perf_cgroup_match() return %true also
> when the cgroup of the current task is a descendant of the event's
> cgroup.  This patchset implements cgroup_is_descendant() and uses it
> to implement hierarchy support in perf_event controller.
> 
> This patchset contains the following three patches.
> 
>  0001-cgroup-make-sure-parent-won-t-be-destroyed-before-it.patch
>  0002-cgroup-implement-cgroup_is_descendant.patch
>  0003-perf-make-perf_event-cgroup-hierarchical.patch

Thanks, looks simple and straight fwd. 

> Ingo, how should these be routed?
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git perf_event-hierarchy-support

Ingo typically likes multi-maintainer sets to be pulled from a common
tree into all relevant maintainer trees so that git merges afterwards
just-work (tm). But I'll let him expand.

