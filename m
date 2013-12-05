Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933385Ab3LEAmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:42:53 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:55971 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab3LEAmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:42:50 -0500
Date: Wed, 4 Dec 2013 16:42:47 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] oom_kill: add rcu_read_lock() into
 find_lock_task_mm()
In-Reply-To: <20131204130420.GA6017@redhat.com>
Message-ID: <alpine.DEB.2.02.1312041642360.31158@chino.kir.corp.google.com>
References: <20131204130420.GA6017@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Oleg Nesterov wrote:

> find_lock_task_mm() expects it is called under rcu or tasklist lock,
> but it seems that at least oom_unkillable_task()->task_in_mem_cgroup()
> and mem_cgroup_out_of_memory()->oom_badness() can call it lockless.
> 
> Perhaps we could fix the callers, but this patch simply adds rcu lock
> into find_lock_task_mm(). This also allows to simplify a bit one of its
> callers, oom_kill_process().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
