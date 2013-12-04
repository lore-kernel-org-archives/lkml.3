Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab3LDM43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:56:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab3LDM42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:56:28 -0500
Date: Wed, 4 Dec 2013 13:57:28 +0100
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
Message-ID: <20131204125728.GA2549@redhat.com>
References: <20131202152423.GA10878@redhat.com> <20131202152440.GA10900@redhat.com> <CANMivWbMmra05sqAgZb7AP+W0qAs8z3jGgsMPPML=3v5TZfFwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANMivWbMmra05sqAgZb7AP+W0qAs8z3jGgsMPPML=3v5TZfFwA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sameer, I didn't notice this part yesterday.

On 12/03, Sameer Nanda wrote:
>
> > @@ -406,7 +409,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  {
> >         struct task_struct *victim = p;
> >         struct task_struct *child;
> > -       struct task_struct *t = p;
> > +       struct task_struct *t;
> >         struct mm_struct *mm;
> >         unsigned int victim_points = 0;
> >         static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> > @@ -437,7 +440,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >          * still freeing memory.
> >          */
> >         read_lock(&tasklist_lock);
> This can be a rcu_read_lock now, I think?

No, we need tasklist for list_for_each_entry(t->children), it
is not rcu-safe.

Oleg.

