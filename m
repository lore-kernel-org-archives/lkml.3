Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaCCIdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:33:05 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:15200 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbaCCIdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:33:02 -0500
Message-ID: <53143E2E.6010302@huawei.com>
Date: Mon, 3 Mar 2014 16:32:46 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: Add missing rcu read locks
References: <1393510855-8771-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1393510855-8771-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/27 22:20, Sasha Levin wrote:
> We call task_cs() which ends up going into cgroup code without having rcu
> read lock. Fix it by grabbing the lock before retrival of task_cs() and usage
> of the result.
> 

Thanks for the patch.

Fengguang already reported it, and I've made a patch for it, but I was fixing
two bugs for 3.14 and then waiting for them to be applied.

There're other places that rcu_read_lock() should be used, and we need to
remove task_lock().

