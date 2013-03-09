Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3CIUCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:02:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab3CIUCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:02:37 -0500
Date: Sat, 9 Mar 2013 21:00:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, cgroups@vger.kernel.org
Subject: [PATCH 0/1] do not abuse ->cred_guard_mutex in threadgroup_lock()
Message-ID: <20130309200046.GA8149@redhat.com>
References: <20130306223657.GA7392@redhat.com> <20130307172545.GA10353@redhat.com> <20130307180139.GD29601@htj.dyndns.org> <20130307180332.GE29601@htj.dyndns.org> <20130307191242.GA18265@redhat.com> <20130307193820.GB3209@htj.dyndns.org> <513A9A67.60909@huawei.com> <20130309032936.GT14556@mtj.dyndns.org> <513AE918.7020704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513AE918.7020704@huawei.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Li Zefan wrote:
>
> We don't need both patches for 3.9, so we'll queue Oleg's fix for 3.9 and
> yours for 3.10?

Well. OK, please see 1/1 (compile tested only).

But I still like the patch from Tejun more... Except _perhaps_ my
patch is better for 3.9 just because it is simpler.

And. I still think that probably we can avoid thread_group_leader()
recheck-and-restart logic in attach_task_by_pid(). But even if this
is true (and thus we can revert the changes in de_thread), we should
do this on top of Tejun's patch.

Oleg.

