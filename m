Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaBKP5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:57:11 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBKP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:57:09 -0500
Date: Tue, 11 Feb 2014 10:56:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>, david.vrabel@citrix.com,
        roger.pau@citrix.com, mrushton@amazon.com, msw@amazon.com,
        boris.ostrovsky@oracle.com
Cc: Jens Axboe <axboe@kernel.dk>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.14 : NFO: trying
 to register non-static key. the code is fine but needs lockdep annotation.
Message-ID: <20140211155650.GA23026@phenom.dumpdata.com>
References: <20140210184412.GA18198@phenom.dumpdata.com>
 <20140210195402.GA3924@kernel.dk>
 <771950784.20140211165215@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <771950784.20140211165215@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:52:15PM +0100, Sander Eikelenboom wrote:
> Hi Konrad,
> 
> Today decided to tryout another kernel RC and your pull request to Jens on top of it .. and I encoutered this one:

Thank you for testing!

Could you provide the .config file please?

Did you see this _before_ the pull request with Jens? I presume
not, but just double checking?

And lastly - what were you doing when you triggered this? Just launching
a guest?

CC-ing Roger and other folks who were on the patches.

> 
> 
> [  438.029756] INFO: trying to register non-static key.
> [  438.029759] the code is fine but needs lockdep annotation.
> [  438.029760] turning off the locking correctness validator.
> [  438.029770] CPU: 3 PID: 9593 Comm: blkback.2.xvda Tainted: G        W    3.14.0-rc2-20140211-pcireset-net-btrevert-xenblock+ #1
> [  438.029773] Hardware name: MSI MS-7640/890FXA-GD70 (MS-7640)  , BIOS V1.8B1 09/13/2010
> [  438.029784]  ffff88005224c4f0 ffff88004e5d9b68 ffffffff81b808c4 ffff88004ba2b510
> [  438.029791]  0000000000000002 ffff88004e5d9c38 ffffffff81116eab ffff88004e5d9bf8
> [  438.029798]  ffffffff81117b35 0000000000000000 0000000000000000 ffffffff82cee570
> [  438.029799] Call Trace:
> [  438.029815]  [<ffffffff81b808c4>] dump_stack+0x46/0x58
> [  438.029826]  [<ffffffff81116eab>] __lock_acquire+0x1c2b/0x2220
> [  438.029833]  [<ffffffff81117b35>] ? lock_acquire+0xe5/0x150
> [  438.029841]  [<ffffffff81117b0d>] lock_acquire+0xbd/0x150
> [  438.029847]  [<ffffffff810e5965>] ? flush_work+0x5/0x290
> [  438.029852]  [<ffffffff810e599d>] flush_work+0x3d/0x290
> [  438.029856]  [<ffffffff810e5965>] ? flush_work+0x5/0x290
> [  438.029863]  [<ffffffff81117b35>] ? lock_acquire+0xe5/0x150
> [  438.029872]  [<ffffffff816fef01>] ? xen_blkif_schedule+0x1a1/0x8d0
> [  438.029881]  [<ffffffff81b8ae0d>] ? _raw_spin_unlock_irqrestore+0x6d/0x90
> [  438.029888]  [<ffffffff8111392b>] ? trace_hardirqs_on_caller+0xfb/0x240
> [  438.029894]  [<ffffffff81113a7d>] ? trace_hardirqs_on+0xd/0x10
> [  438.029901]  [<ffffffff816fefe9>] xen_blkif_schedule+0x289/0x8d0
> [  438.029907]  [<ffffffff8110d510>] ? __init_waitqueue_head+0x60/0x60
> [  438.029913]  [<ffffffff81113a7d>] ? trace_hardirqs_on+0xd/0x10
> [  438.029919]  [<ffffffff81b8ae21>] ? _raw_spin_unlock_irqrestore+0x81/0x90
> [  438.029925]  [<ffffffff816fed60>] ? xen_blkif_be_int+0x40/0x40
> [  438.029932]  [<ffffffff810ee374>] kthread+0xe4/0x100
> [  438.029938]  [<ffffffff81b8afe0>] ? _raw_spin_unlock_irq+0x30/0x50
> [  438.029946]  [<ffffffff810ee290>] ? __init_kthread_worker+0x70/0x70
> [  438.029951]  [<ffffffff81b8c1fc>] ret_from_fork+0x7c/0xb0
> [  438.029958]  [<ffffffff810ee290>] ? __init_kthread_worker+0x70/0x70
> 
> Doesn't seem to serious .. but never the less :-)
> 
> --
> 
> Sander
> 
> 
> Monday, February 10, 2014, 8:54:02 PM, you wrote:
> 
> > On Mon, Feb 10 2014, Konrad Rzeszutek Wilk wrote:
> >> Hey Jens,
> >> 
> >> Please git pull the following branch:
> >> 
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-jens-3.14
> >> 
> >> which is based off v3.13-rc6. If you would like me to rebase it on
> >> a different branch/tag I would be more than happy to do so.
> 
> > Older is fine, it's only an issue if you are ahead of the branch you
> > want to go into.
> 
> dd>> 
> >> The patches are all bug-fixes and hopefully can go in 3.14.
> >> 
> >> They deal with xen-blkback shutdown and cause memory leaks
> >> as well as shutdown races. They should go to stable tree and if you
> >> are OK with I will ask them to backport those fixes.
> >> 
> >> There is also a fix to xen-blkfront to deal with unexpected state
> >> transition. And lastly a fix to the header where it was using the
> >> __aligned__ unnecessarily.
> 
> > Pulled!
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
