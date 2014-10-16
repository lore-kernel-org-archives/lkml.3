Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaJPVwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:52:50 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:53674 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaJPVwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <20141016213512.GA28099@redhat.com>
References: <20141016203954.GA26336@redhat.com>
	<CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
	<20141016211136.GA27468@redhat.com>
	<CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
	<20141016213512.GA28099@redhat.com>
Date: Thu, 16 Oct 2014 14:52:48 -0700
Message-ID: <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
Subject: Re: + freezer-check-oom-kill-while-being-frozen.patch added to -mm tree
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> If a task B is already frozen, it sleeps in D state.
>
> If OOM selects B as a victim after that, it won't be woken by
> SIGKILL, thus it obviously can't call should_thaw_current() and
> notice TIF_MEMDIE.

I see your point now, it would be more clear if you can just quote
the patch instead of changelog.

So are you saying the loop in __refrigerator() is useless? Since
it will always stay in asleep after schedule()?

>
> Btw, I also do not understand the cgroup_freezing() check in
> should_thaw_current(), but this is another story.
>

I hate to repeat the previous discussion. Maybe you can just follow
the link I gave to you? :)

Thanks.
