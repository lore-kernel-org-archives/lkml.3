Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3B1GyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:54:18 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:22186 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3B1GyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:54:17 -0500
Message-ID: <512EFEDF.8080205@huawei.com>
Date: Thu, 28 Feb 2013 14:53:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com> <512DE4A8.5050303@huawei.com> <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
In-Reply-To: <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/27 21:23, Tejun Heo wrote:
> On Wed, Feb 27, 2013 at 2:49 AM, Li Zefan <lizefan@huawei.com> wrote:
>> Well, cgrp->name is a pointer to struct cgroup_name.
>>
>> At first I tried to declare cgrp->name as char *, and use container_of()
>> to get struct cgroup_name, but it didn't result in simpler code.
> 
> Hmmm?  But then what prevents defining const struct cgroup_name?
> 
> static const struct cgroup_name root_cgroup_name = { .name = "/" };

Can't... That's char name[0] not char *name.

I'll allocate a global struct cgroup_name *root_cgroup_name, and use it
for all root_cgroup->name and dummytop->name.

