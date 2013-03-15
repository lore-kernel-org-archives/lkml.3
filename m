Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab3COCbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 22:31:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46357 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3COCbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 22:31:15 -0400
X-IronPort-AV: E=Sophos;i="4.84,849,1355068800"; 
   d="scan'208";a="6875487"
Subject: Re: [PATCH 2/2] task_work: check callback if it's NULL
From: li guang <lig.fnst@cn.fujitsu.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Oleg Nesterov <oleg@redhat.com>, viro@zeniv.linux.org.uk,
        edumazet@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <51427CA4.2060803@huawei.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1363247865-3531-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <20130314144307.GB16136@redhat.com>
	 <1363306834.21129.121.camel@liguang.fnst.cn.fujitsu.com>
	 <514272D3.7040901@huawei.com>
	 <1363310769.21129.132.camel@liguang.fnst.cn.fujitsu.com>
	 <51427CA4.2060803@huawei.com>
Date: Fri, 15 Mar 2013 10:29:45 +0800
Message-ID: <1363314585.21129.134.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/15 10:29:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/15 10:29:56,
	Serialize complete at 2013/03/15 10:29:56
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-03-15五的 09:43 +0800，Li Zefan写道：
> On 2013/3/15 9:26, li guang wrote:
> > 在 2013-03-15五的 09:01 +0800，Li Zefan写道：
> >> On 2013/3/15 8:20, li guang wrote:
> >>> 在 2013-03-14四的 15:43 +0100，Oleg Nesterov写道：
> >>>> On 03/14, liguang wrote:
> >>>>>
> >>>>> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> >>>>> ---
> >>>>>  kernel/task_work.c |    3 ++-
> >>>>>  1 files changed, 2 insertions(+), 1 deletions(-)
> >>>>>
> >>>>> diff --git a/kernel/task_work.c b/kernel/task_work.c
> >>>>> index 0bf4258..f458b08 100644
> >>>>> --- a/kernel/task_work.c
> >>>>> +++ b/kernel/task_work.c
> >>>>> @@ -75,7 +75,8 @@ void task_work_run(void)
> >>>>>
> >>>>>  		do {
> >>>>>  			next = work->next;
> >>>>> -			work->func(work);
> >>>>> +			if (unlikely(work->func))
> >>>>> +				work->func(work);
> >>>>
> >>>> Why?
> >>>>
> >>>> Oleg.
> >>>>
> >>>
> >>> can we believe a callback always be call-able?
> >>> can it happened to be 0? e.g. wrong initialized.
> >>> of course, we can complain the caller, be why don't
> >>> we easily make it more safer?
> >>>
> >>
> >> Because you're not making things safer, but your're trying
> >> to cover up bugs...
> >>
> > 
> > Oh, that's a little harsh to a normal programmer like me :-)
> > for it seems you are asking me to be coding without any bug.
> > are you? or it is the theory of kernel coding?
> > 
> 
> And you make a bug, and you want the kernel to cover up the bug
> instead of crash on a null pointer deref so you'll know you've
> made a bug?
> 
> Why we check if a callback is NULL before calling it? Because
> it's allowed to be. Why we don't check if a callback is NULL?
> Because it's not supposed to be.
> 

OK, Thanks for your reminder.


