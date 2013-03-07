Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab3CGC3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:29:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:60999 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab3CGC3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:29:51 -0500
Message-ID: <5137FB81.7040304@huawei.com>
Date: Thu, 7 Mar 2013 10:29:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>,
        Cgroups <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: INFO: suspicious RCU usage. in cgroup_name
References: <5137687E.50701@oracle.com>
In-Reply-To: <5137687E.50701@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/7 0:02, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> I've stumbled on the following:
> 
> [  450.180599] ===============================
> [  450.181392] [ INFO: suspicious RCU usage. ]
> [  450.182101] 3.9.0-rc1-next-20130305-sasha-00048-g35e9ec5-dirty #1032 Tainted: G        W
> [  450.183482] -------------------------------
> [  450.184343] include/linux/cgroup.h:429 suspicious rcu_dereference_check() usage!

My fault. I didn't trigger a OOM to test my patch. I thought the caller
of cpuset_print_task_mems_allowed() already acquired rcu_read_lock()...

Thanks for the report.

