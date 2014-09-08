Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaIHXAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:00:43 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45602 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbaIHXAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:00:42 -0400
MIME-Version: 1.0
In-Reply-To: <1899038.KOOHvy2XUu@vostro.rjw.lan>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<2588099.AI1YmNFQ25@vostro.rjw.lan>
	<20140908225012.GE3806@mtj.dyndns.org>
	<1899038.KOOHvy2XUu@vostro.rjw.lan>
Date: Mon, 8 Sep 2014 16:00:41 -0700
Message-ID: <CAM_iQpXWeYtnT8_p4xJROom24u6G=i=0nkALx8tDfOhwA+zNqw@mail.gmail.com>
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

On Mon, Sep 8, 2014 at 4:15 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, September 09, 2014 07:50:12 AM Tejun Heo wrote:
>> Hello,
>>
>> On Tue, Sep 09, 2014 at 12:48:28AM +0200, Rafael J. Wysocki wrote:
>> > Well, not exactly from anywhere.  Just from where try_to_freeze() is called
>> > I suppose?
>>
>> Yeap, anywhere try_to_freeze() may be called.
>>
>> > Which means that if this is a user space task, it won't to a lot before dying,
>> > will it?
>>
>> Userland tasks aren't likely to a lot of damages before dying but then
>> again there's no guarantee.  As it currently stands, try_to_freeze()
>> can be anywhere.
>
> Well, in that case the TIF_MEMDIE test alone is not sufficient in my opinion,
> because we can't guarantee that the task will not do something it was frozen
> to prevent it from doing.
>
>

That is true, there is a small window between TIF_MEMDIE is set
and SIGKILL is handled (aka process is killed), but this seems to
be a general signal handling issue not related with freezer after all
OOM relies on SIGKILL to function. No?
