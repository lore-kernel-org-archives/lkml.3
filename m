Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaIHRkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:40:19 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:45487 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaIHRkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:40:18 -0400
MIME-Version: 1.0
In-Reply-To: <8615268.1yl5ssmHZO@vostro.rjw.lan>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAM_iQpUbGTxrbJZ_ztf+QUvFowsivQ-jvPCSi7kmth7nstPvaA@mail.gmail.com>
	<20140905224554.GD15723@mtj.dyndns.org>
	<8615268.1yl5ssmHZO@vostro.rjw.lan>
Date: Mon, 8 Sep 2014 10:40:17 -0700
Message-ID: <CAM_iQpXUDt1eM-R-Ofr3OzxjB=9K3JZ-XupJ916c7k_NzMK5WQ@mail.gmail.com>
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

On Fri, Sep 5, 2014 at 4:32 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Saturday, September 06, 2014 07:45:54 AM Tejun Heo wrote:
>> Hello,
>>
>> On Fri, Sep 05, 2014 at 11:12:24AM -0700, Cong Wang wrote:
>> > > Rafael, can you please help?
>> >
>> > Rafael is known not responsive at least for this topic. :)
>>
>> :(
>
> Well, am I?
>
> I haven't commented patches in this thread so far, mostly because other
> people have.
>
> How can I help actually?


We asked you to comment on either if this patch is safe for PM freeze
if we don't have the cgroup_freezing() check, or if it is not safe why (so that
I can put it in the comment).

>
>> > > Shouldn't the primary goal of the comment be explaining why we need
>> > > TIF_MEMDIE check there at all anyway?  The deadlock possiblity is not
>> > > very obvious.
>> >
>> > The changelog is not long enough?? ;-) I hate to copy+paste changelog
>> > into comments, changelog is essentially necessary for people to understand
>> > kernel code (at least networking) , so I don't think we have to move it
>> > into comments in this case.
>>
>> It doesn't have to be the same text but the current comment is
>> basically content-less.  e.g. it can just say "OOM killer may get
>> stuck trying to kill a cgroup frozen task" and actualy provide
>> information on what condition the conditional tries to address.
>
> Or something like "We need to check X to prevent Y from happening".
>

OK, maybe just one or two sentences. Let me know if the following
comment is okay for you:

/* OOM killer might decide to kill this process after it is frozen,
  in this case it should thaw and die. */

Thanks.
