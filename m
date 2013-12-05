Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab3LEAlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:41:44 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:54591 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3LEAln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:41:43 -0500
Date: Wed, 4 Dec 2013 16:41:39 -0800 (PST)
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
Subject: Re: [PATCH v2 3/4] oom_kill: has_intersects_mems_allowed() needs
 rcu_read_lock()
In-Reply-To: <20131204130416.GA6014@redhat.com>
Message-ID: <alpine.DEB.2.02.1312041641290.31158@chino.kir.corp.google.com>
References: <20131204130416.GA6014@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Oleg Nesterov wrote:

> At least out_of_memory() calls has_intersects_mems_allowed()
> without even rcu_read_lock(), this is obviously buggy.
> 
> Add the necessary rcu_read_lock(). This means that we can not
> simply return from the loop, we need "bool ret" and "break".
> 
> While at it, swap the names of task_struct's (the argument and
> the local). This cleanups the code a little bit and avoids the
> unnecessary initialization.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>
> Reviewed-by: Sameer Nanda <snanda@chromium.org>

Acked-by: David Rientjes <rientjes@google.com>
