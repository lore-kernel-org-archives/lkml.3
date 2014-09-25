Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaIYBm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:42:29 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44403 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIYBm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:42:27 -0400
Message-ID: <542372FF.4020808@huawei.com>
Date: Thu, 25 Sep 2014 09:42:23 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, Miao Xie <miaox@cn.fujitsu.com>,
        "Tetsuo Handa" <penguin-kernel@I-love.SAKURA.ne.jp>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH v3 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
References: <542124D3.9000007@huawei.com> <20140924132218.GC16555@htj.dyndns.org> <20140924133513.GD16555@htj.dyndns.org>
In-Reply-To: <20140924133513.GD16555@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/24 21:35, Tejun Heo wrote:
> On Wed, Sep 24, 2014 at 09:22:18AM -0400, Tejun Heo wrote:
>> On Tue, Sep 23, 2014 at 03:44:19PM +0800, Zefan Li wrote:
>>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>
>>> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
>>> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
>>> because it is used as bit number. Redefine it as decimal bit number.
>>>
>>> Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.
>>>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Ingo Molnar <mingo@kernel.org>
>>> Cc: Miao Xie <miaox@cn.fujitsu.com>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>> Acked-by: Kees Cook <keescook@chromium.org>
>>> [ lizf: slightly modified subject and changelog ]
>>> Signed-off-by: Zefan Li <lizefan@huawei.com>
>>
>> Applied 1-3 to cgroup/for-3.17-fixes w/ the typo spotted by davidr
>> fixed.
> 
> Reverted due to build failure.  Will wait for a refreshed version. :(
> 

Didn't notice mm/slab.c uses PF_SPREAD_SLAB without the cpuset wrapper...

