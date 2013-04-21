Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3DUBmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 21:42:47 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41605 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3DUBmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 21:42:45 -0400
Date: Sat, 20 Apr 2013 18:42:41 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 05/10] cpuset: don't update tasks' cpumask and nodemask
 in an empty cpuset
Message-ID: <20130421014241.GC19097@mtj.dyndns.org>
References: <517137A7.4020605@huawei.com>
 <51713819.8050708@huawei.com>
 <20130419183618.GC13811@mtj.dyndns.org>
 <5171EA24.3070001@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5171EA24.3070001@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Apr 20, 2013 at 09:06:44AM +0800, Li Zefan wrote:
> I was trying to fix a bug: before moving tasks out of empty cpusets,
> update_tasks_nodemask() is called, which calls do_migrate_pages(xx, from, to)
> finally, from == node_to_be_offlined, to == empty_nodeamsk, so I guess
> no pages will be migrated.
> 
> Then when those tasks are moving to an ancestor, do_migrate_pages(xx, from, to)
> is called again, from == empty_nodemask, to == ancestor's nodemask,
> so I guess again no pages will be migrated.

Oh, I see.  I was a bit confused by the description.  Maybe include
the above?

Thanks.

-- 
tejun
