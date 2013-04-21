Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3DUBlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 21:41:44 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:35273 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3DUBlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 21:41:42 -0400
Date: Sat, 20 Apr 2013 18:41:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 09/10] cpuset: allow to keep tasks in empty cpusets
Message-ID: <20130421014136.GB19097@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <517138A4.3070209@huawei.com>
 <20130419205821.GA15543@mtj.dyndns.org>
 <5171EDC1.4070805@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5171EDC1.4070805@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sat, Apr 20, 2013 at 09:22:09AM +0800, Li Zefan wrote:
> > migration is being done.  Another approach would be converting cgroup
> > to use SRCU instead, which would lessen pain on other places too.  The
> > only problem there would be that srcu_read_lock() is a bit more
> > expensive than rcu_read_lock().  I'm not sure whether that'd show up
> > in some hot path or not.  Ideas?
> 
> I guess we can live with rcu_read_lock() for now, and see if we can
> change it to srcu when other significant changes are done in all
> cgroup controllers. (hierarchy support in blkcg, etc..)

Ooh, I'm almost done with converting blk-throttle to support hierarchy
as cfq is already ready, blkcg will be ready very soon.  The only
thing left to do in terms of hierarchy support would be internal
weight for cpu.  :)

Thanks.

-- 
tejun
