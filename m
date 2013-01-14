Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185Ab3ANSzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:55:19 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:40322 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab3ANSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:55:17 -0500
Date: Mon, 14 Jan 2013 10:55:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Colin Cross <ccross@google.com>, Mike Galbraith <efault@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cgroup: remove synchronize_rcu() from
 rebind_subsystems()
Message-ID: <20130114185512.GG27942@mtj.dyndns.org>
References: <50F3CE8E.5000402@huawei.com>
 <50F3CEC2.1020909@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3CEC2.1020909@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 05:24:18PM +0800, Li Zefan wrote:
> Nothing's protected by RCU in rebind_subsystems(), and I can't think
> of a reason why it is needed.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.  We probably should synchornize_rcu() from
cgroup_diput() too.  Probably by punting css_free() and cgrp freeing
to a work item from call_rcu() callback.

Thanks.

-- 
tejun
