Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbaJCSDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:03:40 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:58131 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbaJCSDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <20141003151334.GE4816@dhcp22.suse.cz>
References: <CAM_iQpVf3ga5vVbhKmXySvK9ibh9bGgnGHFBOFtmag9=uh8D=A@mail.gmail.com>
	<20140930081637.GA4456@dhcp22.suse.cz>
	<CAM_iQpXx3ULtPr50ESTZk1+984vSG9-dKegEjawDZ2yJS3CTdw@mail.gmail.com>
	<20141003151334.GE4816@dhcp22.suse.cz>
Date: Fri, 3 Oct 2014 11:03:30 -0700
Message-ID: <CAM_iQpW4t_jKSCbS5J1N15FFChd=-UK3QOXrjjst64Rqe5KBTw@mail.gmail.com>
Subject: Re: Please backport commit 3812c8c8f39 to stable
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 8:13 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> That commit fixes an OOM deadlock. Not a soft lockup. Do you have the
> OOM killer report from the log? This would tell us that the killed task
> was indeed sleeping on the lock which is hold by the charger which
> triggered the OOM. I am little bit surprised that I do not see any OOM
> related functions on the stacks (maybe the code is inlined...).


Oh, did you see __mem_cgroup_try_charge() calls
schedule_timeout_uninterruptible() in stack trace? Yes, they are inlined
and I don't see any other possibilities for calling it.

>
> It would be better to know what exactly is going on before backporting
> this change because it is quite large.
>

I thought the stack trace I showed is obvious. :) I am very happy
to investigate if you see any other path calling
schedule_timeout_uninterruptible()
in __mem_cgroup_try_charge().
