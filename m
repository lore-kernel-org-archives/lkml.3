Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaIJXU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:20:59 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50549 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaIJXU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:20:57 -0400
MIME-Version: 1.0
In-Reply-To: <2606659.qXoKHWVyLl@vostro.rjw.lan>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAM_iQpXwEEoCTqksFEyJ7UigOJkf6g5UHnddEHcMDjwKz6K-DQ@mail.gmail.com>
	<CAM_iQpUP9kSGMs6Lq9tBLGaJrW6yyBWU5z38WzBiH4x-H_ZdYA@mail.gmail.com>
	<2606659.qXoKHWVyLl@vostro.rjw.lan>
Date: Wed, 10 Sep 2014 16:20:56 -0700
Message-ID: <CAM_iQpW0c=REGz0kG1BqwMWm2UHXVi3PfX8BTdgiRV46uO-Cpw@mail.gmail.com>
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

On Wed, Sep 10, 2014 at 4:38 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Wednesday, September 10, 2014 01:30:25 PM Cong Wang wrote:
>> I am wondering if the folllowing check makes any sense with regarding
>> to rule out PM freeze:
>>
>>         if ((!pm_nosig_freezing && !pm_freezing) &&
>>             cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
>>                 return true;
>>
>> PM will not freeze the process again if it is already frozen by cgroup,
>> so here we just make sure that it will not thaw if PM freeze is in progress.
>>
>> Am I missing anything?
>
> And where exactly would you like to put this check?  Into __refrigerator()?

Yes, still in should_thaw_current() which is called in __refrigerator().
