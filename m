Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3BRRSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:18:03 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50817 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3BRRSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:18:00 -0500
Date: Mon, 18 Feb 2013 09:17:56 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3] cgroup: fix cgroup_rmdir() vs close(eventfd) race
Message-ID: <20130218171756.GE17414@htj.dyndns.org>
References: <512208CE.8000003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512208CE.8000003@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 06:56:14PM +0800, Li Zefan wrote:
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
> v3:
> - call eventfd_signal() no matter it's eventfd close or cgroup removal
> that removes the cgroup event.
> 
> Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Dropped v2 and applied this one to cgroup/for-3.9.

Thanks.

-- 
tejun
