Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaEHShP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 14:37:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60623 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaEHShN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 14:37:13 -0400
Date: Thu, 8 May 2014 14:36:22 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH cgroup/for-3.16] cgroup: rename css_tryget*() to
 css_tryget_online*()
Message-ID: <20140508183622.GR19914@cmpxchg.org>
References: <20140507160429.GE26540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507160429.GE26540@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 12:04:29PM -0400, Tejun Heo wrote:
> Unlike the more usual refcnting, what css_tryget() provides is the
> distinction between online and offline csses instead of protection
> against upping a refcnt which already reached zero.  cgroup is
> planning to provide actual tryget which fails if the refcnt already
> reached zero.  Let's rename the existing trygets so that they clearly
> indicate that they're onliness.
> 
> I thought about keeping the existing names as-are and introducing new
> names for the planned actual tryget; however, given that each
> controller participates in the synchronization of the online state, it
> seems worthwhile to make it explicit that these functions are about
> on/offline state.
> 
> Rename css_tryget() to css_tryget_online() and css_tryget_from_dir()
> to css_tryget_online_from_dir().  This is pure rename.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
