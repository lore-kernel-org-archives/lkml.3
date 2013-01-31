Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3AaXOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:14:48 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39404 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3AaXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:14:45 -0500
Date: Thu, 31 Jan 2013 15:14:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: kbuild test robot <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt'
 undeclared
Message-ID: <20130131231433.GM6824@mtj.dyndns.org>
References: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510aa746.fVU8ZdQ2hys/RwjS%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Fri, Feb 01, 2013 at 01:17:58AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux master
> head:   04c2eee5b9dfcb13f3cd07a5537fb8c785f2751a
> commit: a3201227f803ad7fd43180c5195dbe5a2bf998aa freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE
> date:   1 year, 2 months ago

Heh, this gone goes way back.

> config: make ARCH=tile allyesconfig
> 
> All error/warnings:
> 
>    kernel/cgroup_freezer.c: In function 'freezer_destroy':
> >> kernel/cgroup_freezer.c:151:3: error: 'system_freezing_cnt' undeclared (first use in this function)
>    kernel/cgroup_freezer.c:151:3: note: each undeclared identifier is reported only once for each function it appears in
>    kernel/cgroup_freezer.c: In function 'freezer_fork':
>    kernel/cgroup_freezer.c:209:3: error: implicit declaration of function 'freeze_task'
>    kernel/cgroup_freezer.c: In function 'unfreeze_cgroup':
>    kernel/cgroup_freezer.c:296:3: error: implicit declaration of function '__thaw_task'
>    kernel/cgroup_freezer.c: In function 'freezer_change_state':
> >> kernel/cgroup_freezer.c:315:4: error: 'system_freezing_cnt' undeclared (first use in this function)

So, CONFIG_FREEZER is defbool which is turned on automatically if
CONFIG_CGROUP_FREEZER; however, CONFIG_FREEZER is defined in
Kconfig.freezer which should be included by arch Kconfig file.  tile
doesn't include it (maybe it doesn't want freezer for some reason?).
CONFIG_COGRUP_FREEZER is in init/Kconfig, so allyesconfig enables it
but as CONFIG_FREEZER definition isn't visible, we end up with broken
config CONFIG_CGROUP_FREEZER && !CONFIG_FREEZER.

Maybe we need to move CONFIG_CGROUP_FREEZER to Kconfig.freezer if tile
actually doesn't want freezer?

Thanks.

-- 
tejun
