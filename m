Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925AbaJPVOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaJPVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:14:52 -0400
Date: Thu, 16 Oct 2014 23:11:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm
	tree
Message-ID: <20141016211136.GA27468@redhat.com>
References: <20141016203954.GA26336@redhat.com> <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Cong Wang wrote:
>
> On Thu, Oct 16, 2014 at 1:39 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> Fix the issue by checking for TIF_MEMDIE thread flag and get away from the
> >> fridge if it is set.  oom_scan_process_thread doesn't have to check for
> >> the frozen task anymore because do_send_sig_info will wake up the thread
> >> and TIF_MEMDIE is already set by that time.
> >
> > I must have missed something... but __refrigerator() sleeps in
> > TASK_UNINTERRUPTIBLE and do_send_sig_info() won't wake it up?
> >
>
> This is exactly what we are trying to fix. Make sure you read the patch
> as well before reply?

I did read the patch, but I can't understand it. I am sorry about that,
and I am asking for your help.

I agree that oom_scan_process_thread()->__thaw_task() doesn't really
help.

But also I can't understand why this patch helps. The changelog says:

	do_send_sig_info will wake up the thread

why?

Oleg.

