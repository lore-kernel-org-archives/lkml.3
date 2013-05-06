Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab3EFWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:03:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:33012 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3EFWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:03:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130506184232.GC32173@mtj.dyndns.org>
References: <20130430023146.8F351660923@gitolite.kernel.org>
	<CAB9dFdtwk5MKNmrOQVaV0Zh_ETNJVabeMVd45njnC-AYr0Md6g@mail.gmail.com>
	<20130506184232.GC32173@mtj.dyndns.org>
Date: Mon, 6 May 2013 18:03:05 -0400
Message-ID: <CAB9dFdt_oqQzfeus7+hiyE5czJbTw3+9W_OFVnYbzN=+5hBxcw@mail.gmail.com>
Subject: Re: workqueue: inline trivial wrappers
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 2:42 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, May 06, 2013 at 10:44:58AM -0400, Marc Dionne wrote:
>> On Mon, Apr 29, 2013 at 10:31 PM, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=8425e3d5bdbe8e741d2c73cf3189ed59b4038b84
>> > Commit:     8425e3d5bdbe8e741d2c73cf3189ed59b4038b84
>> > Parent:     611c92a0203091bb022edec7e2d8b765fe148622
>> > Author:     Tejun Heo <tj@kernel.org>
>> > AuthorDate: Wed Mar 13 16:51:36 2013 -0700
>> > Committer:  Tejun Heo <tj@kernel.org>
>> > CommitDate: Wed Mar 13 16:51:36 2013 -0700
>> >
>> >     workqueue: inline trivial wrappers
>> >
>> >     There's no reason to make these trivial wrappers full (exported)
>> >     functions.  Inline the followings.
>> >
>> >      queue_work()
>> >      queue_delayed_work()
>> >      mod_delayed_work()
>> >      schedule_work_on()
>> >      schedule_work()
>> >      schedule_delayed_work_on()
>> >      schedule_delayed_work()
>> >      keventd_up()
>> >
>> >     Signed-off-by: Tejun Heo <tj@kernel.org>
>>
>> This commit has the side effect of making some functions
>> EXPORT_SYMBOL_GPL that had been previously exported with EXPORT_SYMBOL
>> for a long time, such as schedule_work().  This is used by OpenAFS and
>> probably other out of tree modules.  Past exchanges on this list (ex:
>> http://marc.info/?l=linux-fsdevel&m=123550631318910) suggest the
>> license requirements for existing interfaces shouldn't change, at
>> least without providing an alternate means of getting the same
>> functionality.  Any thoughts on whether this can be adjusted within
>> the current release cycle?
>
> Hah, so schedule_work() was EXPORT_SYMBOL() and queue_work*() were
> EXPORT_SYMBOL_GPL()?  It'd be rather silly to avoid inlining those
> wrappers for license reasons.  Can you please send a patch changing
> the necessary functions to EXPORT_SYMBOL()?

As a follow up I sent a patch as you suggested to convert the needed
symbols which are system_wq, queue_work_on and queue_delayed_work_on.
Of course the goal is not to make direct use of those symbols, but
rather to make schedule_work() available again, and that's one way of
accomplishing that.

Thanks,
Marc
