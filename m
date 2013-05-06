Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3EFSmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:42:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39388 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab3EFSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:42:37 -0400
Date: Mon, 6 May 2013 11:42:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue: inline trivial wrappers
Message-ID: <20130506184232.GC32173@mtj.dyndns.org>
References: <20130430023146.8F351660923@gitolite.kernel.org>
 <CAB9dFdtwk5MKNmrOQVaV0Zh_ETNJVabeMVd45njnC-AYr0Md6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB9dFdtwk5MKNmrOQVaV0Zh_ETNJVabeMVd45njnC-AYr0Md6g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 06, 2013 at 10:44:58AM -0400, Marc Dionne wrote:
> On Mon, Apr 29, 2013 at 10:31 PM, Linux Kernel Mailing List
> <linux-kernel@vger.kernel.org> wrote:
> > Gitweb:     http://git.kernel.org/linus/;a=commit;h=8425e3d5bdbe8e741d2c73cf3189ed59b4038b84
> > Commit:     8425e3d5bdbe8e741d2c73cf3189ed59b4038b84
> > Parent:     611c92a0203091bb022edec7e2d8b765fe148622
> > Author:     Tejun Heo <tj@kernel.org>
> > AuthorDate: Wed Mar 13 16:51:36 2013 -0700
> > Committer:  Tejun Heo <tj@kernel.org>
> > CommitDate: Wed Mar 13 16:51:36 2013 -0700
> >
> >     workqueue: inline trivial wrappers
> >
> >     There's no reason to make these trivial wrappers full (exported)
> >     functions.  Inline the followings.
> >
> >      queue_work()
> >      queue_delayed_work()
> >      mod_delayed_work()
> >      schedule_work_on()
> >      schedule_work()
> >      schedule_delayed_work_on()
> >      schedule_delayed_work()
> >      keventd_up()
> >
> >     Signed-off-by: Tejun Heo <tj@kernel.org>
> 
> This commit has the side effect of making some functions
> EXPORT_SYMBOL_GPL that had been previously exported with EXPORT_SYMBOL
> for a long time, such as schedule_work().  This is used by OpenAFS and
> probably other out of tree modules.  Past exchanges on this list (ex:
> http://marc.info/?l=linux-fsdevel&m=123550631318910) suggest the
> license requirements for existing interfaces shouldn't change, at
> least without providing an alternate means of getting the same
> functionality.  Any thoughts on whether this can be adjusted within
> the current release cycle?

Hah, so schedule_work() was EXPORT_SYMBOL() and queue_work*() were
EXPORT_SYMBOL_GPL()?  It'd be rather silly to avoid inlining those
wrappers for license reasons.  Can you please send a patch changing
the necessary functions to EXPORT_SYMBOL()?

Thanks.

-- 
tejun
