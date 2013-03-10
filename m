Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3CJMBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:01:19 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44563 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3CJMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:01:17 -0400
Date: Sun, 10 Mar 2013 05:01:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCHSET wq/for-3.10-tmp] workqueue: implement workqueue with
 custom worker attributes
Message-ID: <20130310120113.GC24522@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <513C61B9.5030004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513C61B9.5030004@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Sun, Mar 10, 2013 at 06:34:33PM +0800, Lai Jiangshan wrote:
> > This patchset contains the following 31 patches.
> > 
> >  0001-workqueue-make-sanity-checks-less-punshing-using-WAR.patch
> 
> >  0002-workqueue-make-workqueue_lock-irq-safe.patch
> 
> workqueue_lock protects too many things. We can introduce different locks
> for different purpose later.

I don't know.  My general attitude toward locking is the simpler the
better.  None of the paths protected by workqueue_lock are hot.
There's no actual benefit in making them finer grained.

> >  0023-workqueue-implement-get-put_pwq.patch
> 
> I guess this patch and patch25 may have very deep issue VS RCU.

Hmmm... scary.  I suppose you're gonna elaborate on the review of the
actual patch?

> >  0024-workqueue-prepare-flush_workqueue-for-dynamic-creati.patch
> >  0025-workqueue-perform-non-reentrancy-test-when-queueing-.patch
> >  0026-workqueue-implement-apply_workqueue_attrs.patch
> >  0027-workqueue-make-it-clear-that-WQ_DRAINING-is-an-inter.patch
> >  0028-workqueue-reject-increasing-max_active-for-ordered-w.patch
> >  0029-cpumask-implement-cpumask_parse.patch
> >  0030-driver-base-implement-subsys_virtual_register.patch
> >  0031-workqueue-implement-sysfs-interface-for-workqueues.patch
> 
> 
> for 1~13,15~22,26~28, please add Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Done.

Thanks.

-- 
tejun
