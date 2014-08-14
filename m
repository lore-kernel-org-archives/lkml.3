Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaHNAQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:16:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37047 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaHNAQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140813092659.GA2775@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
	<20140812114430.GA7049@dhcp22.suse.cz>
	<CAM_iQpUtvqnaSuzO9d+HSDhEwtwjP9J5JaZwYusdW157zCdhRw@mail.gmail.com>
	<20140813092659.GA2775@dhcp22.suse.cz>
Date: Wed, 13 Aug 2014 17:16:35 -0700
Message-ID: <CAM_iQpUUD5v9LHDjpjR0tM4NkQehDYqoZ7UGDSmXvqf3uiEHjQ@mail.gmail.com>
Subject: Re: [Patch v2] freezer: check OOM kill while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 2:26 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Tue 12-08-14 17:53:33, Cong Wang wrote:
>> On Tue, Aug 12, 2014 at 4:44 AM, Michal Hocko <mhocko@suse.cz> wrote:
> [...]
>> >> @@ -147,12 +156,6 @@ void __thaw_task(struct task_struct *p)
>> >>  {
>> >>       unsigned long flags;
>> >>
>> >> -     /*
>> >> -      * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
>> >> -      * be visible to @p as waking up implies wmb.  Waking up inside
>> >> -      * freezer_lock also prevents wakeups from leaking outside
>> >> -      * refrigerator.
>> >> -      */
>> >
>> > This is an unrelated change.
>> >
>>
>> It is, because as I explained, __thaw_task() doesn't do what this comment
>> says therefore needs this patch. Or you prefer to make it a separated patch?
>
> It is outdated since a3201227f803. I would do it in a separate patch but
> maybe just mention that the above commit has changed the implementation.
>

OK, I will split this patch.
