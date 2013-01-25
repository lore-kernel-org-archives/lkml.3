Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3AYImK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:42:10 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:41169 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3AYImI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:42:08 -0500
Message-ID: <510244CF.8050709@huawei.com>
Date: Fri, 25 Jan 2013 16:39:43 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Daniel Wagner <wagi@monom.org>
CC: John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
References: <50FCDB5C.4050608@huawei.com> <50FD0144.1000401@monom.org> <50FD0402.6060400@huawei.com> <50FD09FD.4010804@monom.org> <50FD1113.6010402@huawei.com> <50FD786E.4050108@gmail.com> <20130122100938.GA26820@candlejack.bmw-carit.intra>
In-Reply-To: <20130122100938.GA26820@candlejack.bmw-carit.intra>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> BTW, isn't this a similar to what should happen with the block io cgroup?
>>>> What is the behavior with a fd writing to a file in the scenario you
>>>> describe above?
>>>>
>>>
>>> It forbids task moving in this case:
>>>
>>> /*
>>>   * We cannot support shared io contexts, as we have no mean to support
>>>   * two tasks with the same ioc in two different groups without major rework
>>>   * of the main cic data structures.  For now we allow a task to change
>>>   * its cgroup only if it's the only owner of its ioc.
>>>   */
>>> static int blkcg_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
>>>
>>
>> OK, I guess we should do something similar in the netprio, netcls
>> cgroups and
>> yes document it as you noted in your last comment.
> 
> Here is my attempt to add such a check. I really don't know if this is the
> correct way to do so. To test this I have written a test program, which
> seems to test the right thing. Please have a look and let me know if
> it is correct: http://www.monom.org/misc/scm_rights.c
> 
> And here a dirty first version of the patch:
> 

Adding new can_attach() is discouraged. It's considered bad, because if cgroup
is mounted with multi subsystems binded, and if one of them can forbid task
moving for some reason, this will add burden on users to use cgroup properly.

