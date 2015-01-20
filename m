Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbbATDYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:24:12 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:17566 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbATDYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:24:10 -0500
Message-ID: <54BDCA3C.4030804@huawei.com>
Date: Tue, 20 Jan 2015 11:23:40 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <hannes@cmpxchg.org>, <shijie8@gmail.com>, <torvalds@linux-foundation.org>,
        <azurit@pobox.sk>, <hugh.dickins@tiscali.co.uk>, <rientjes@google.com>,
        <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>
Subject: Re: does the semantics of MAP_LOCKED is equal to mlock() function?
References: <54BCA187.6070601@huawei.com> <20150119094656.GA21052@dhcp22.suse.cz> <20150119110116.GB21052@dhcp22.suse.cz>
In-Reply-To: <20150119110116.GB21052@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 19:01, Michal Hocko wrote:
> On Mon 19-01-15 10:46:56, Michal Hocko wrote:
> [...]
>>> testcase 2: mmap without MAP_LOCKED flag and the call mlock (memsize = 8192)
>>>
>>> 185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
>>> 186                          MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
>>> 187                 if (p == MAP_FAILED)
>>> 188                         err(1, "mmap(lock) failed");
>>> 189
>>> 190                 if (mlock(p, memsize) == -1)
>>> 191                         err(1, "mlock failed")
>>>
>>> expect: invoke OOM killer.
>>> result: invoke OOM killer.
> 
> Are you sure about this? memcg OOM killer shouldn't trigger even from
> mlock path. It should just lead to ENOMEM. If you see the OOM killer
> then it is probably coming from a page fault from a different source.
> strace of your test would tell you more.
> 
hi, Michal Hocko

sorry for the wrong description in the email. i run the two testcase in kernel v3.10.63, not
the latest kernel.

in kernel v3.18, the two testcases can not invoke OOM killer.

The problem comes from the LTP tests, because the v3.10.61 lts apply the following patch:

f8a5117916dd2871c056963bf5ee0d1101c10099 mm: memcg: handle non-error OOM situations more gracefully
f79d6a468980516cbfb9e01313c846b82b9d2e7e mm: memcg: do not trap chargers with full callstack on OOM
7a147e0c45a8fa198ade4128bdcbf8592f48843e mm: memcg: rework and document OOM waiting and wakeup
11f34787b50ce71f66b85ad8790beaa5eee3f897 mm: memcg: enable memcg OOM killer only for user faults

as you said in: http://marc.info/?l=linux-api&m=142122902613316&w=2

"
The primary issue is that mmap doesn't report a failure if MAP_LOCKED fails to populate the area. Is
this the correct/expected behavior?
"

There is another problem:

in kernel v3.10.63  testcase 1 can not invoke OOM, but testcase2 can invoke OOM.
in kernel v3.18     both testcase 1 and testcase 2 can not invoke OOM.

in kernel v3.10.63, why testcase2  can invoke OOM killer?

Thanks


Best Regards
Wang Long










