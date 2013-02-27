Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3B0Kui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:50:38 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:11145 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab3B0Kuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:50:37 -0500
Message-ID: <512DE4A8.5050303@huawei.com>
Date: Wed, 27 Feb 2013 18:49:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
In-Reply-To: <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/26 21:26, Tejun Heo wrote:
> Hello,
> 
> On Tue, Feb 26, 2013 at 2:25 AM, Li Zefan <lizefan@huawei.com> wrote:
>> Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
>> cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
>> the current version is a bit simpler.
> 
> Can't we just set it to constant "/"?  Root cgroup init is a separate
> path anyway.
> 

Well, cgrp->name is a pointer to struct cgroup_name.

At first I tried to declare cgrp->name as char *, and use container_of()
to get struct cgroup_name, but it didn't result in simpler code.

So seems there's no way that is a pure win over another.

