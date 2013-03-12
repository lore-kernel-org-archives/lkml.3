Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3CLPHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:07:14 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45461
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704Ab3CLPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:07:13 -0400
Date: Tue, 12 Mar 2013 16:06:33 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: laijs@cn.fujitsu.com, fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
        jmoyer@redhat.com
Subject: Re: [PATCHSET] writeback: convert writeback to unbound workqueue
Message-ID: <20130312150633.GZ25165@kernel.dk>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362692649-25570-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07 2013, Tejun Heo wrote:
> Hello,
> 
> There's no reason for writeback to implement its own worker pool when
> using workqueue is much simpler and more efficient.  This patchset
> replaces writeback's custom worker pool with unbound workqueue and
> also exports it to userland using WQ_SYSFS so that it can be tuned
> from userland as requested a couple releases ago.
> 
> This patchset contains the following four patches.
> 
>  0001-implement-current_is_workqueue_rescuer.patch
>  0002-writeback-remove-unused-bdi_pending_list.patch
>  0003-writeback-replace-custom-worker-pool-implementation-.patch
>  0004-writeback-expose-the-bdi_wq-workqueue.patch
> 
> 0001-0002 are prep patches.  0003 does the conversion.  0004 makes
> bdi_wq visible to userland.
> 
> This patchset is on top of v3.9-rc1 + "workqueue: implement workqueue
> with custom worker attributes" patchset[1] and available in the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-writeback-conversion

I like it, diffstat looks nice too :-)

Have you done any performance testing, or just functional verification?

-- 
Jens Axboe

