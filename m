Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3LMDU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 22:20:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:47883 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3LMDU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 22:20:57 -0500
Message-ID: <52AA7D12.2070705@huawei.com>
Date: Fri, 13 Dec 2013 11:20:50 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.14] cgroup: fix fail path in cgroup_load_subsys()
References: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/13 3:17, Vladimir Davydov wrote:
> Calling cgroup_unload_subsys() from cgroup_load_subsys() after
> online_css() failure will result in a NULL ptr dereference on attempt to
> offline_css(), because online_css() only assigns css to cgroup on
> success. Let's fix that by skipping calls to offline_css() and
> css_free() in cgroup_unload_subsys() if there is no css, and freeing css
> in cgroup_load_subsys() on online_css() failure.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

I don't have strong preference on which way to go.

Acked-by: Li Zefan <lizefan@huawei.com>

