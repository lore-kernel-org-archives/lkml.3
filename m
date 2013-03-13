Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab3CMBG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:06:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28561 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3CMBGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:06:55 -0400
Message-ID: <513FD12A.1040105@huawei.com>
Date: Wed, 13 Mar 2013 09:06:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 0/8] cgroup: a bunch of cleanups
References: <513ED010.5060906@huawei.com> <20130312223839.GM25266@htj.dyndns.org>
In-Reply-To: <20130312223839.GM25266@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/13 6:38, Tejun Heo wrote:
> On Tue, Mar 12, 2013 at 02:49:52PM +0800, Li Zefan wrote:
>> Hi Tejun,
>>
>> If you're busy with other stuff, just take your time to go through those
>> patches.
>>
>> 0001-cgroup-remove-cgroup_is_descentant.patch
>> 0002-cgroup-remove-unused-variables-in-cgroup_destroy_loc.patch
>> 0003-cgroup-hold-cgroup_mutex-before-calling-css_offline.patch
>> 0004-cgroup-don-t-bother-to-resize-pid-array.patch
>> 0005-cgroup-remove-useless-code-in-cgroup_write_event_con.patch
>> 0006-cgroup-remove-unneeded-includes-from-cgroup.h.patch
>> 0007-cgroup-fix-an-almost-harmless-off-by-one-bug.patch
>> 0008-cgroup-consolidate-cgroup_attach_task-and-cgroup_att.patch
> 
> 0001-0007 applied to cgroup/for-3.10.  0008 looks fine but in the diff
> cgroup_attach_task_all() is removed completely and added back in
> slightly different form.

At first I thought cgroup_attach_task() was static, so I thought I had
to either move cgroup_attach_task_all() after cgroup_attach_task(),
or add a forward declaration of cgroup_attach_task() in order to pass
compile.

Then I found it was extern, but I forgot to revert this diff.

Will send a v2.

> If you wanna keep the functions ordered like
> you posted, please put a separate patch to move
> cgroup_attach_task_all() before the consolidation.
> 

