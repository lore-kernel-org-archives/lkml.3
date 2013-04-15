Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3DODne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:43:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:33997 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3DODnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:43:33 -0400
Message-ID: <516B7753.9060503@huawei.com>
Date: Mon, 15 Apr 2013 11:43:15 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kay@vrfy.org>, <greg@kroah.com>,
        <lennart@poettering.net>, <daniel@zonque.org>
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
References: <1365964619-14762-1-git-send-email-tj@kernel.org> <1365964619-14762-5-git-send-email-tj@kernel.org>
In-Reply-To: <1365964619-14762-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
> +				    char *buf, size_t buflen)
> +{
> +	struct cgroupfs_root *root;
> +	struct cgroup *cgrp = NULL;
> +	int ret = -ENOENT;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
> +	if (root) {
> +		cgrp = task_cgroup_from_root(task, root);

task_cgroup_from_root() will never return NULL, and there's a BUG_ON(!res) in it.

> +		if (cgrp)
> +			ret = cgroup_path(cgrp, buf, buflen);
> +	}
> +
> +	mutex_unlock(&cgroup_mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(task_cgroup_path_from_hierarchy);

