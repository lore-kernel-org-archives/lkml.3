Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3ICUHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 16:07:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:55977 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3ICUHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 16:07:07 -0400
Date: Tue, 3 Sep 2013 16:06:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] cgroup: fix css leaks on online_css() failure
Message-ID: <20130903200656.GD27092@mtj.dyndns.org>
References: <1377723829-22814-1-git-send-email-tj@kernel.org>
 <1377723829-22814-2-git-send-email-tj@kernel.org>
 <52245DE0.1010701@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52245DE0.1010701@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 02, 2013 at 05:44:00PM +0800, Li Zefan wrote:
> Now cgroup_destroy_locked() is called:
> 
> 	for_each_root_subsys(cgrp->root, ss)
> 		kill_css(cgroup_css(cgrp, ss));

Oops, yes, later in the series, for_each_css() is introduced and
replaces for_each_root_subsys() usages solving the above problem.  I
should have put those patches before this one.  Will re-sequence the
patches.

Thanks.

-- 
tejun
