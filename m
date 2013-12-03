Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3LCUtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:49:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3LCUtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:49:22 -0500
Date: Tue, 3 Dec 2013 21:50:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sameer Nanda <snanda@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] oom_kill: change oom_kill.c to use
	for_each_thread()
Message-ID: <20131203205019.GA25556@redhat.com>
References: <20131202152423.GA10878@redhat.com> <20131202152440.GA10900@redhat.com> <CANMivWbMmra05sqAgZb7AP+W0qAs8z3jGgsMPPML=3v5TZfFwA@mail.gmail.com> <20131203200507.GC19083@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203200507.GC19083@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Oleg Nesterov wrote:
>
> > > -static bool has_intersects_mems_allowed(struct task_struct *tsk,
> > > +static bool has_intersects_mems_allowed(struct task_struct *start,
> > Comment block needs to be fixed up due to variable name change from
> > tsk to start.
>
> thanks again, I'll update the patch.

Yes, I'll redo and resend.

I decided to split it into 2 changes, "add rcu_read_lock() into
has_intersects_mems_allowed()" should come as a separate change.

Because it seems that oom_kill.c needs more rcu_read_lock's, at
least find_lock_task_mm() can be called without rcu lock.

Oleg.

