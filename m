Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab3BRRQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:16:53 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:56428 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab3BRRQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:16:52 -0500
Date: Mon, 18 Feb 2013 09:16:47 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v2] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Message-ID: <20130218171647.GD17414@htj.dyndns.org>
References: <5121C647.7030608@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5121C647.7030608@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 02:12:23PM +0800, Li Zefan wrote:
> commit 205a872bd6f9a9a09ef035ef1e90185a8245cc58 ("cgroup: fix lockdep
> warning for event_control") solved a deadlock by introducing a new
> bug.
> 
> Move cgrp->event_list to a temporary list doesn't mean you can traverse
> this list locklessly, because at the same time cgroup_event_wake() can
> be called and remove the event from the list. The result of this race
> is disastrous.
> 
> We adopt the way how kvm irqfd code implements race-free event removal,
> which is now described in the comments in cgroup_event_wake().
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
