Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763355Ab3DDQxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:53:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54565 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763133Ab3DDQxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:53:16 -0400
Date: Thu, 4 Apr 2013 09:53:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: next-20130325 - INFO: trying to register non-static key.
Message-ID: <20130404165311.GP9425@htj.dyndns.org>
References: <11740.1364321163@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11740.1364321163@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Valdis.

On Tue, Mar 26, 2013 at 02:06:03PM -0400, Valdis Kletnieks wrote:
> Seen in the dmesg for next-20130325, but looks like it's been doing
> it since at least next-20130218.
> 
> [   50.162584] dell_wmi: Received unknown WMI event (0x11)
> [   51.167629] INFO: trying to register non-static key.
> [   51.167636] the code is fine but needs lockdep annotation.
> [   51.167639] turning off the locking correctness validator.
> [   51.167644] Pid: 594, comm: kworker/0:3 Tainted: G        W  O 3.9.0-rc4-next-20130325 #67
> [   51.167646] Call Trace:
> [   51.167656]  [<ffffffff81073847>] register_lock_class+0x108/0x2ba
> [   51.167662]  [<ffffffff81075113>] __lock_acquire+0x126/0xde2
> [   51.167667]  [<ffffffff810755de>] ? __lock_acquire+0x5f1/0xde2
> [   51.167671]  [<ffffffff81076111>] lock_acquire+0xc7/0x14a
> [   51.167677]  [<ffffffff810498dd>] ? process_one_work+0x1fd/0x4ae
> [   51.167681]  [<ffffffff81049949>] process_one_work+0x269/0x4ae
> [   51.167686]  [<ffffffff810498dd>] ? process_one_work+0x1fd/0x4ae
> [   51.167691]  [<ffffffff8104ae2c>] worker_thread+0x2d6/0x3dc
> [   51.167696]  [<ffffffff8104ab56>] ? rescuer_thread+0x343/0x343
> [   51.167701]  [<ffffffff81050394>] kthread+0x9d/0xa5
> [   51.167706]  [<ffffffff810502f7>] ? __kthread_parkme+0x60/0x60
> [   51.167712]  [<ffffffff815fdf6c>] ret_from_fork+0x7c/0xb0
> [   51.167717]  [<ffffffff810502f7>] ? __kthread_parkme+0x60/0x60
> 
> 'git blame' doesn't seem to shout anything.  Commit 112202d90 touched code
> in that area semi-recently, but I don't actually see a problem with it.
> 
> (I admit not being sure how long this has been an issue - discovered I
> had a local config screw-up that meant lockdep wasn't on for quite some
> time).

It's likely caused by the workqueue user not initializing the work
item properly; unfortunately, I can't tell who the offending user is
from the trace.  Can you please reproduce the problem on the following
git branch and report the output?

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-dump

Thanks!

-- 
tejun
