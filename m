Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaHMJ1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:27:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaHMJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:27:02 -0400
Date: Wed, 13 Aug 2014 11:26:59 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v2] freezer: check OOM kill while being frozen
Message-ID: <20140813092659.GA2775@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140812114430.GA7049@dhcp22.suse.cz>
 <CAM_iQpUtvqnaSuzO9d+HSDhEwtwjP9J5JaZwYusdW157zCdhRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUtvqnaSuzO9d+HSDhEwtwjP9J5JaZwYusdW157zCdhRw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12-08-14 17:53:33, Cong Wang wrote:
> On Tue, Aug 12, 2014 at 4:44 AM, Michal Hocko <mhocko@suse.cz> wrote:
[...]
> >> @@ -147,12 +156,6 @@ void __thaw_task(struct task_struct *p)
> >>  {
> >>       unsigned long flags;
> >>
> >> -     /*
> >> -      * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
> >> -      * be visible to @p as waking up implies wmb.  Waking up inside
> >> -      * freezer_lock also prevents wakeups from leaking outside
> >> -      * refrigerator.
> >> -      */
> >
> > This is an unrelated change.
> >
> 
> It is, because as I explained, __thaw_task() doesn't do what this comment
> says therefore needs this patch. Or you prefer to make it a separated patch?

It is outdated since a3201227f803. I would do it in a separate patch but
maybe just mention that the above commit has changed the implementation.

-- 
Michal Hocko
SUSE Labs
