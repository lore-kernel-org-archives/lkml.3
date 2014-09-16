Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaIPWzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:55:51 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:38872 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaIPWzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140915093608.GA19976@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<1527959.PBej7RR7ig@vostro.rjw.lan>
	<20140915005657.GA11267@mtj.dyndns.org>
	<4489261.oHB60C5hao@vostro.rjw.lan>
	<20140915093608.GA19976@dhcp22.suse.cz>
Date: Tue, 16 Sep 2014 15:55:48 -0700
Message-ID: <CAM_iQpXLEvxvf7=iyJ=FiviSenCwFB10cyEWHvX6HSs=f7kt8w@mail.gmail.com>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 2:36 AM, Michal Hocko <mhocko@suse.cz> wrote:
> This patch builds on top of Cong Wang's. What do you think?

I think it is should a preliminary of my patch, not a followup. I can carry
this patch for you if you want.

> ---
> From cdf97a20b107ee584352f07274a88d7c3f014ab2 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Mon, 15 Sep 2014 10:52:30 +0200
> Subject: [PATCH] OOM, PM: OOM killed task cannot escape PM suspend
>
> PM freezer relies on having all tasks frozen by the time devices are
> getting frozen so that no task will touch them while they are getting
> frozen. But OOM killer is allowed to kill an already frozen task in
> order to handle OOM situtation. In order to protect from late wake ups
> OOM killer is disabled after all tasks are frozen. This, however, still
> keeps an window open when a killed task didn't manage to die by the time
> freeze_processes finishes. Fix this by checking all tasks after OOM
> killer has been disabled. To prevent from useless check also introduce
> and check oom_kills count which gets incremented when a task is killed
> by OOM killer. All the tasks have to be checked only if the counter
> changes.


Not sure if I understand your patch correctly, seems you are checking if
there is any ongoing OOM killer during PM suspend, since oom_kills
will always increase, maybe a seqlock is more clear?

Or you mean totally forbid PM suspend when an OOM killer is ongoing?
If so, you should call atomic_dec() after OOM is done.

Thanks.
