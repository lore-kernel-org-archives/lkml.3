Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3DPLT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:19:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51593 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3DPLTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:19:25 -0400
Message-ID: <516D333D.4040703@huawei.com>
Date: Tue, 16 Apr 2013 19:17:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <bsingharora@gmail.com>, <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, <jpoimboe@redhat.com>,
        <berrange@redhat.com>, <lpoetter@redhat.com>,
        <workman-devel@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: cgroup: status-quo and userland efforts
References: <20130406012159.GA17159@mtj.dyndns.org>
In-Reply-To: <20130406012159.GA17159@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/6 9:21, Tejun Heo wrote:
> Hello, guys.
> 
>  Status-quo
>  ==========
> 
> It's been about a year since I wrote up a summary on cgroup status quo
> and future plans.  We're not there yet but much closer than we were
> before.  At least the locking and object life-time management aren't
> crazy anymore and most controllers now support proper hierarchy
> although not all of them agree on how to treat inheritance.
> 
> IIRC, the yet-to-be-converted ones are blk-throttle and perf.  cpu
> needs to be updated so that it at least supports a similar mechanism
> as cfq-iosched for configuring ratio between tasks on an internal
> cgroup and its children.  Also, we really should update how cpuset
> handles a cgroup becoming empty (no cpus or memory node left due to
> hot-unplug).  It currently transfers all its tasks to the nearest
> ancestor with executing resources, which is an irreversible process
> which would affect all other co-mounted controllers.  We probably want
> it to just take on the masks of the ancestor until its own executing
> resources become online again, and the new behavior should be gated
> behind a switch (Li, can you please look into this?).
> 

Sure, I'll be working on sane hierarchy behavior for cpuset.

