Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaIHXQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:16:17 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:38479 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaIHXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <1609685.fbsF6EQ3X7@vostro.rjw.lan>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<1899038.KOOHvy2XUu@vostro.rjw.lan>
	<CAM_iQpXWeYtnT8_p4xJROom24u6G=i=0nkALx8tDfOhwA+zNqw@mail.gmail.com>
	<1609685.fbsF6EQ3X7@vostro.rjw.lan>
Date: Mon, 8 Sep 2014 16:16:15 -0700
Message-ID: <CAM_iQpXiJL=q6NFkiPF71dZHKXu=ReJ59Rbadc__+UX-GW2x8A@mail.gmail.com>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> The reason why it matters for the suspend-time freezing is that we freeze tasks
> to take them out of the picture entirely until they are thawed.  Therefore we
> can't allow them to go back to the picture just for a while until they are
> killed.  Frozen tasks are not supposed to get back to the picture at all.
>


Ok, then checking TIF_MEMDIE is unsafe for PM freeze, we should
keep the cgroup_freezing() test to make sure freeze request is from
cgroup not PM. Question got answered. :)

I will put the following as a comment:

/* OOM killer may decide to kill this process after it is frozen,
   in this case SIGKILL can never be handled, so we should check
  TIF_MEMDIE and if it is set, thaw and let SIGKILL kill it.
  But for PM freeze, it is not allowed to get out even for a while,
  so we have to keep it being frozen. */

Let me know if it looks good to you.
