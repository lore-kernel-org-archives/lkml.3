Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3DODug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:50:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52335 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3DODue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:50:34 -0400
Message-ID: <516B78E5.6000109@huawei.com>
Date: Mon, 15 Apr 2013 11:49:57 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kay@vrfy.org>, <greg@kroah.com>,
        <lennart@poettering.net>, <daniel@zonque.org>
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
References: <1365964619-14762-1-git-send-email-tj@kernel.org> <1365964619-14762-5-git-send-email-tj@kernel.org> <516B7753.9060503@huawei.com> <20130415034613.GK3050@htj.dyndns.org>
In-Reply-To: <20130415034613.GK3050@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/15 11:46, Tejun Heo wrote:
> On Mon, Apr 15, 2013 at 11:43:15AM +0800, Li Zefan wrote:
>>> +int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
>>> +				    char *buf, size_t buflen)
>>> +{
>>> +	struct cgroupfs_root *root;
>>> +	struct cgroup *cgrp = NULL;
>>> +	int ret = -ENOENT;
>>> +
>>> +	mutex_lock(&cgroup_mutex);
>>> +
>>> +	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
>>> +	if (root) {
>>> +		cgrp = task_cgroup_from_root(task, root);
>>
>> task_cgroup_from_root() will never return NULL, and there's a BUG_ON(!res) in it.
> 
> @hierarchy_id may come from userland, so we probably should update
> task_cgroup_from_root() to return NULL if the id is invalid.  Will add
> a patch.
> 

But if id is invalid, idr_find() will return NULL. As long as root is not NULL,
task_cgroup_from_root() will always return a valid cgroup.

