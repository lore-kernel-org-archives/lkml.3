Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3DODq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 23:46:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62834 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3DODqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 23:46:25 -0400
Date: Sun, 14 Apr 2013 20:46:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, kay@vrfy.org, greg@kroah.com,
        lennart@poettering.net, daniel@zonque.org
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Message-ID: <20130415034613.GK3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
 <516B7753.9060503@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516B7753.9060503@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:43:15AM +0800, Li Zefan wrote:
> > +int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
> > +				    char *buf, size_t buflen)
> > +{
> > +	struct cgroupfs_root *root;
> > +	struct cgroup *cgrp = NULL;
> > +	int ret = -ENOENT;
> > +
> > +	mutex_lock(&cgroup_mutex);
> > +
> > +	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
> > +	if (root) {
> > +		cgrp = task_cgroup_from_root(task, root);
> 
> task_cgroup_from_root() will never return NULL, and there's a BUG_ON(!res) in it.

@hierarchy_id may come from userland, so we probably should update
task_cgroup_from_root() to return NULL if the id is invalid.  Will add
a patch.

Thanks.

-- 
tejun
